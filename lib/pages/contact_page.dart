import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum OrderOptions { orderaz, orderza }

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController _nameEditController = new TextEditingController();
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _phoneEditController = new TextEditingController();

  FocusNode _nome = new FocusNode();

  Contact _editedContact;
  bool _contactEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = new Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameEditController.text = _editedContact.name;
      _emailEditController.text = _editedContact.email;
      _phoneEditController.text = _editedContact.phone;
    }
  }

  Future<bool> _requestPop() {
    if (_contactEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Sair"),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name != null && _editedContact.name != ""
              ? _editedContact.name
              : "Novo contato"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _image(_editedContact),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              TextField(
                focusNode: _nome,
                controller: _nameEditController,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  setState(() {
                    _contactEdited = true;
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailEditController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _contactEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneEditController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _contactEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(_editedContact.name);
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nome);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
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
