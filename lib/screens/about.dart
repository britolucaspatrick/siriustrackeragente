import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => new _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool validate = false;
  bool notifEnableServiceAppOff = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(39, 185, 154, 1.0)),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15),
          child: new Form(
            key: _key,
            autovalidate: validate,
            child: buildScreen(context),
          ),
        ),
      ),
    );
  }

  Widget buildScreen(BuildContext context) {
    return new Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Sobre",
                softWrap: true,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(39, 185, 154, 1.0),
                  decoration: TextDecoration.none,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: "OpenSans",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image(
                image: AssetImage("assets/images/information.png"),
                height: 90,
                width: 90,
              ),
            )
          ],
        ),
        ListTile(
          title: Text('Sirius Tracker - Agente'),
          subtitle: Text('v. 1.0.0.0'),
        ),
        Divider(
          height: 5,
          endIndent: 10,
          indent: 10,
        ),
        ListTile(
          title: Text('Avalie-nos no Google Play'),
          onTap: () => _launchURL(
              'https://play.google.com/store/apps/details?id=com.britoptrck.helptracker'),
        ),
        ListTile(
          title: Text('Linkedin'),
          onTap: () => _launchURL(
              'https://www.linkedin.com/in/sirius-tracker-6736a7195/'),
        ),
        ListTile(
          title: Text('Youtube'),
        ),
        ListTile(
          title: Text('Facebook'),
          onTap: () => _launchURL(
              'https://www.facebook.com/Sirius-Tracker-103697484378957/'),
        ),
        ListTile(
          title: Text('Twitter'),
        ),
        ListTile(
          title: Text('Visite nosso site'),
          onTap: () => _launchURL('http://siriustracker.com/'),
        ),
        ListTile(),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Erro ao iniciar: $url';
    }
  }

  String validateField(String value) {
    if (value.length == 0) {
      return "Informe campo!";
    }
    return "";
  }
}
