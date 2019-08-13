import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();

    /* Contact c = Contact();
    c.name = "Lucas";
    c.email = "lucas@gmail.com";
    c.phone = "9966332211";
    c.img = "Teste img!";

    helper.saveContact(c).then((data) {
      helper.getAllContacts().then((list) {
        print(list);
      });
    }); */
    
    helper.getAllContacts().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de contatos"),
      ),
      body: Container(),
    );
  }
}
