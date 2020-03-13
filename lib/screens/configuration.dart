import 'package:flutter/material.dart';
import 'package:siriustrackeragente/business/auth.dart';
import 'package:siriustrackeragente/widgets/alert.dart';

class Configuration extends StatefulWidget {
  @override
  _ConfigurationState createState() => new _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool validate = false;
  bool notifEnableServiceAppOff = false;
  bool notifPagamentEfet = false;
  bool loginAuto = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Color.fromRGBO(39, 85, 128, 1.0)),
          backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Configurações",
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(39, 85, 128, 1.0),
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
                    image: AssetImage("assets/images/configuration.png"),
                    height: 90,
                    width: 90,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: notifEnableServiceAppOff,
                  onChanged: (bool value) {
                    setState(() {
                      notifEnableServiceAppOff = value;
                    });
                  },
                ),
                Expanded(
                  child: Text("Notificação de serviços com app em \n"
                      "segundo plano ou fechado"),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: notifPagamentEfet,
                  onChanged: (bool value) {
                    setState(() {
                      notifPagamentEfet = value;
                    });
                  },
                ),
                Expanded(
                  child: Text("Notificação de pagamento efetuado"),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: loginAuto,
                  onChanged: (bool value) {
                    setState(() {
                      loginAuto = value;
                    });
                  },
                ),
                Expanded(
                  child: Text("Logar automaticamente no aplicativo"),
                ),
              ],
            ),

            Divider(height: 15, indent: 15, endIndent: 15,),

            GestureDetector(
              child: Text("Solicitar alteração da senha",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onTap: (){
                Alert.showAlertDialog(context, "Enviamos um e-mail para realizar a alteração.");
                Auth.resetPassword();
              },
            )

          ],
        )
    );
  }
}
