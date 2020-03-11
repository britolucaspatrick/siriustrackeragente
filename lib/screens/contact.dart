import 'package:flutter/material.dart';
import 'package:siriustrackeragente/widgets/alert.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => new _ContactState();
}

class _ContactState extends State<Contact> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromRGBO(78, 186, 11, 1.0)),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Contato",
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(78, 186, 11, 1.0),
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
                      image: AssetImage("assets/images/contact.png"),
                      height: 90,
                      width: 90,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 300,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                child: TextField(
                  controller: this._controller,
                  maxLength: 299,
                  maxLines: 30,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Motivo',
                    hintText: 'Digite algo...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.black26)),
                  ),
                  onChanged: (text) => setState(() {}),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(
                            color: Colors.black12,
                            width: 100,
                          ),
                        ),
                        elevation: 5,
                        onPressed: () {
                          this._controller.text = '';
                          Alert.showAlertDialog(context, 'Agradecemos o contato. \n'
                              'Estaremos respondendo, os mais breve possível, por e-mail.');
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30,
                        ),
                        label: Text(
                          'Enviar',
                        )
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
