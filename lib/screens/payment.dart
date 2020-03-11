import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siriustrackeragente/animation/move.dart';
import 'package:siriustrackeragente/models/paymentbyuser.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';
import 'package:siriustrackeragente/widgets/chat.dart';

class Payment extends StatefulWidget {
  final ServicesByUser service;

  Payment({Key key, @required this.service}) : super(key: key);

  @override
  _PaymentState createState() => new _PaymentState();
}

class _PaymentState extends State<Payment> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool validate = false;
  bool enableService = false;
  List<PaymentsByUser> listPaymentsByService = new List();
  FirebaseUser user;
  var documentID;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((value) {
      user = value;
    });

    _getPayments();
    print(user?.uid);
  }

  _getPayments() async {
    setState(() {
      listPaymentsByService.clear();
    });

    await Firestore.instance
        .collection("paymentsByService")
        //.where("Service", isEqualTo: "/servicesByUser/${documentID}")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((f) {
        setState(() {
          f.data["documentID"] = f.documentID;
          listPaymentsByService.add(PaymentsByUser.fromJson(f.data));
          print(listPaymentsByService);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        title: new Text('Pagamento', style: TextStyle(color: Colors.green),),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/card.png',
                    fit: BoxFit.scaleDown,
                  ),
                  width: 70,
                  height: 70,
                ),
                Container(
                  child: Text(
                      "Banco 260 - NU Pagamentos S.A.\n"
                      "Agência 0001\n"
                      "Conta 4027291-01",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: "OpenSans",
                      )),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(
                      "Destinatário: Patrick Brito\n"
                      "CPF: 098.384.559-01",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: "OpenSans",
                      )),
                ),
                Icon(
                  Icons.person_pin,
                  size: 70,
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Divider(
              height: 2.0,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(height: 5.0),
            Expanded(
              child: ListView.builder(
                itemBuilder: _buildPaymentsByUser,
                itemCount: listPaymentsByService.length,
                scrollDirection: Axis.vertical,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.report_problem,
          color: Colors.white,
        ),
        onPressed: () {
          true;
        },
      ),
    );
  }

//info, status, valor, dt_abertura, dt_inicioatendimento
  Widget _buildPaymentsByUser(BuildContext context, int index) {
    return MoveAnimation(
      duration: Duration(seconds: 3),
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
                          listPaymentsByService[index].Status_desc,
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
                          "Dt. Abertura: ${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_abertura?.millisecondsSinceEpoch).day}/"
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_abertura?.millisecondsSinceEpoch).month}/"
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_abertura?.millisecondsSinceEpoch).year} "
                          "\u00B7 "
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_abertura?.millisecondsSinceEpoch).hour}:"
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_abertura?.millisecondsSinceEpoch).minute}",
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
                          "Dt. Finalizado: ${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_finalizado?.millisecondsSinceEpoch).day}/"
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_finalizado?.millisecondsSinceEpoch).month}/"
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_finalizado?.millisecondsSinceEpoch).year} "
                          "\u00B7 "
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_finalizado?.millisecondsSinceEpoch).hour}:"
                          "${DateTime.fromMillisecondsSinceEpoch(listPaymentsByService[index].dt_finalizado?.millisecondsSinceEpoch).minute}",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  void _callChat(ServicesByUser servicesByUser) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Chat(service: servicesByUser)));
  }
}
