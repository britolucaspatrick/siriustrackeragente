import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siriustrackeragente/models/partner.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';
import 'package:siriustrackeragente/models/user.dart';

class Cracha extends StatefulWidget {
  final ServicesByUser service;

  Cracha({Key key, @required this.service}) : super(key: key);

  @override
  _CrachaState createState() => new _CrachaState();
}

class _CrachaState extends State<Cracha> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool validate = false;
  bool enableService = false;
  List<Partner> _list = new List();
  List<User> _user = new List();
  FirebaseUser user;
  var documentID;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        user = value;
      });
    });

    _getPartnerByService();
    _getOperadorById();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.purple),
        title: new Text('Crachá', style: TextStyle(color: Colors.purple),),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        centerTitle: true,
      ),
      body: _list == null ||
              _list.length == 0 ||
              user == null ||
              _user == null ||
              _user.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                _list[0].url_logo != null && _list[0].url_logo.isNotEmpty
                    ? Row(
                        children: <Widget>[
                          Container(
                            child: Image(
                              image: NetworkImage(_list[0].url_logo),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                          ),
                          SizedBox(height: 20.0),
                        ],
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                            "${_list[0].nome} \n"
                            "CPNJ: ${_list[0].cnpj} \n"
                            "Endereço: ${_list[0].logradouro} \n"
                            "CEP: ${_list[0].cep} \n"
                            "Contatos: ${_list[0].telefone_sac}/ "
                            "${_list[0].telefone_adm} \n"
                            "E-mail: ${_list[0].email}",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: "OpenSans",
                                color: Colors.black38)),
                        padding: EdgeInsets.only(left: 10),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Divider(
                  height: 2.0,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.person_pin,
                      size: 120,
                      color: Colors.black26,
                    ),
                    Container(
                      child: Expanded(
                        child: Text(
                            "Agente: ${_user[0].firstName} \n"
                            "CPF: ${_user[0].cpf} \n"
                            /*"Logradouro: ${_user[0].logradouro} \n"
                            "Número: ${_user[0].numero} \n"
                            "Complemento: ${_user[0].complement} \n"
                            "Cidade: ${_user[0].cidade} \n"
                            "CEP: ${_user[0].cep} \n"*/
                            "Service ID: ${widget.service.documentID}",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: "OpenSans",
                                color: Colors.black38)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  _getOperadorById() async {
    setState(() {
      _list.clear();
    });

    await Firestore.instance
        .collection("users")
        //.where("Service", isEqualTo: "/servicesByUser/${documentID}")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((f) {
        setState(() {
          _user.add(User.fromJson(f.data));
          print(_list);
        });
      });
    });
  }

  _getPartnerByService() async {
    setState(() {
      _list.clear();
    });

    await Firestore.instance
        .collection("partner")
        //.where("Service", isEqualTo: "/servicesByUser/${documentID}")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((f) {
        setState(() {
          _list.add(Partner.fromJson(f.data));
          print(_list);
        });
      });
    });
  }
}
