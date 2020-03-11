import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siriustrackeragente/animation/move.dart';
import 'package:siriustrackeragente/business/auth.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';
import 'package:siriustrackeragente/screens/cracha.dart';
import 'package:siriustrackeragente/screens/payment.dart';
import 'package:siriustrackeragente/widgets/chat.dart';
import 'package:siriustrackeragente/widgets/nodata.dart';
import 'package:siriustrackeragente/widgets/servicesseleted.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => new _ServicesState();
}

class _ServicesState extends State<Services> {
  bool validate = false;
  bool enableService = false;
  List<ServicesByUser> listServicesByUser = new List();
  BuildContext context;

  @override
  void initState() {
    super.initState();
    _getServices();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
          elevation: 0,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Serviços",
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.blue,
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
                      image: AssetImage("assets/images/conversation.png"),
                      height: 90,
                      width: 90,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              if (listServicesByUser.length > 0)
                Expanded(
                  child: ListView.builder(
                    itemBuilder: _buildServicesByUser,
                    itemCount: listServicesByUser.length,
                    scrollDirection: Axis.vertical,
                  ),
                )
              else
                NoData(
                  labelText: 'Nenhum serviço!',
                )
            ],
          ),
        ));
  }

  void _showServiceSelected(ServicesByUser value) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ServicesSeleted(service: value, visibleAceitar: false);
      },
    );
  }

//info, status, valor, dt_abertura, dt_inicioatendimento
  Widget _buildServicesByUser(BuildContext context, int index) {
    return MoveAnimation(
        duration: Duration(seconds: 3),
        child: GestureDetector(
          onTap: (){
            _showServiceSelected(listServicesByUser[index]);
          },
          child: Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Card(
                  elevation: 3.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              listServicesByUser[index].InfoWindow,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Dt. Abertura: ${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_abertura?.millisecondsSinceEpoch).day}/"
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_abertura?.millisecondsSinceEpoch).month}/"
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_abertura?.millisecondsSinceEpoch).year} "
                                  "\u00B7 "
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_abertura?.millisecondsSinceEpoch).hour}:"
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_abertura?.millisecondsSinceEpoch).minute}",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Dt. Inicio Atendimento: ${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_inicioatendimento?.millisecondsSinceEpoch).day}/"
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_inicioatendimento?.millisecondsSinceEpoch).month}/"
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_inicioatendimento?.millisecondsSinceEpoch).year} "
                                  "\u00B7 "
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_inicioatendimento?.millisecondsSinceEpoch).hour}:"
                                  "${DateTime.fromMillisecondsSinceEpoch(listServicesByUser[index].Dt_inicioatendimento?.millisecondsSinceEpoch).minute}",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '',
                              //"Valor: R\u0024 ${Functions.formatDoubleToMoney(listServicesByUser[index].Valor)}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "Status: ${(listServicesByUser[index].Status_desc)}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          children: <Widget>[
                            if (listServicesByUser[index].Status == 1)
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    _callChat(listServicesByUser[index]);
                                  },
                                  icon: Icon(Icons.chat),
                                  color: Colors.white,
                                  label: Text("Chat"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.black54)),
                                ),
                              ),
                            if (listServicesByUser[index].Status ==
                                1) //Chacha para o serviço corrente
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    _callCracha(listServicesByUser[index]);
                                  },
                                  icon: Icon(
                                    Icons.perm_identity,
                                    color: Colors.purple,
                                  ),
                                  color: Colors.white,
                                  label: Text(
                                    "Crachá",
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.purple)),
                                ),
                              ),
                            if (listServicesByUser[index].Status ==
                                1) //2 - Em pagamento
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    _callPayment(listServicesByUser[index]);
                                  },
                                  icon: Icon(
                                    Icons.payment,
                                    color: Colors.green,
                                  ),
                                  color: Colors.white,
                                  label: Text(
                                    "Pagamento",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
              )
          ),
        )
    );
  }

  void _getServices() async {
    try {
      setState(() {
        listServicesByUser.clear();
      });
      Auth.getCurrentFirebaseUser().then((userID) {
        Firestore.instance
            .collection("servicesByUser")
            .where("userID", isEqualTo: userID.uid)
            .getDocuments()
            .then((querySnapshot) {
          querySnapshot.documents.forEach((f) {
            setState(() {
              f.data["documentID"] = f.documentID;
              listServicesByUser.add(ServicesByUser.fromJson(f.data));
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void _callChat(ServicesByUser servicesByUser) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Chat(service: servicesByUser)));
  }

  void _callCracha(ServicesByUser servicesByUser) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Cracha(service: servicesByUser)));
  }

  void _callPayment(ServicesByUser servicesByUser) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Payment(service: servicesByUser)));
  }
}
