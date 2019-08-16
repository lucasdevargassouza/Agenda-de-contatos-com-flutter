import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contactList = List();

  @override
  void initState() {
    super.initState();

    /* Contact contact = Contact();
    contact.name = "Paulinho";
    contact.email = "Paulinho@gmail.com";
    contact.phone = "998652365";


    helper.saveContact(contact).then((contato) {
      print(contato);
    }); */

    helper.getAllContacts().then((list) {
      setState(() {
        contactList = list;
      });
    });
  }

  void _callContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    );

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
        _getAllContacts();
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() async {
    await helper.getAllContacts().then((list) {
      setState(() {
        contactList = list;
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        launch("tel:${contactList[index].phone}");
                      },
                      child: Text(
                        "Ligar",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _callContactPage(contact: contactList[index]);
                      },
                      child: Text(
                        "Editar",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        helper.deleteContact(contactList[index].id);

                        helper.getAllContacts().then((list) {
                          setState(() {
                            contactList = list;
                          });
                        });
                      },
                      child: Text(
                        "Excluir",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _sortList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contactList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contactList.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
      default:
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contatos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(
                child: Text("Order A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem(
                child: Text("Order Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _sortList,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contactList.length,
        itemBuilder: (context, index) => _contactCard(context, index),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () => _callContactPage(),
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _callContactPage(contact: contactList[index]),
      onLongPress: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image(contactList[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contactList[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contactList[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contactList[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _image(Contact contato) {
    if (contato.img != null && contato.img != "") {
      return FileImage(File(contato.img));
    } else {
      return AssetImage("lib/assets/imgs/person.png");
    }
  }
}
