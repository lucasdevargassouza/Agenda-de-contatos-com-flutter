import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

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
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contactList.length,
        itemBuilder: (context, index) => _contactCard(context, index),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {},
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
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
