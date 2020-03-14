import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siriustrackeragente/animation/move.dart';
import 'package:siriustrackeragente/business/auth.dart';
import 'package:siriustrackeragente/business/payment.dart';
import 'package:siriustrackeragente/models/paymentbyservice.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';
import 'package:siriustrackeragente/screens/myaccount.dart';
import 'package:siriustrackeragente/widgets/alert.dart';
import 'package:siriustrackeragente/widgets/chat.dart';
import 'package:siriustrackeragente/widgets/nodata.dart';

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
  List<PaymentsByService> listPaymentsByService = new List<PaymentsByService>();
  FirebaseUser user;
  var documentID;
  String banco = '', conta = '', agencia = '';

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((value) {
      user = value;
    });

    _getPayments();
    print(user?.uid);
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
        alignment: AlignmentDirectional.center,
        child: Column(
          children: <Widget>[
            listPaymentsByService.length == 0 ?
            NoData(labelText: "Nenhum pagamento",) :
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
          showDialog(context: context,
              builder: (BuildContext context){
                return optionsPaymentReport();
              });
        },
      ),
    );
  }

  bool existStatus(List<PaymentsByService> listPaymentsByService, int status){
    bool exist = false;
    listPaymentsByService.forEach((f){
      if (f.status == status)
        exist = true;
    });

    return exist;
  }

  Widget callBank(){
    Auth.getUser(widget.service.userID).forEach((f){
      setState(() {
        conta = f.conta;
        agencia = f.agencia;
        banco = f.banco;
      });
    });

    return Container(
      padding: EdgeInsets.only(top: 130, bottom: 130, right: 50, left: 50),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text('Confirma o banco, agência e conta abaixo?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text('Caso esteja incorreto altere no seu cadastro, em minha conta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              title: Text('Banco'),
              subtitle: Text(banco),
            ),
            ListTile(
              title: Text('Agência'),
              subtitle: Text(agencia),
            ),
            ListTile(
              title: Text('Conta'),
              subtitle: Text(conta),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text('Errado', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.red),),
                  onPressed: (){

                  },
                ),
                FlatButton(
                  child: Text('Correto', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.blue),),
                  onPressed: (){

                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget optionsPaymentReport(){
    return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              onTap: (){
                Navigator.pop(context);
                if (existStatus(listPaymentsByService, 0))
                  Alert.showAlertDialog(context, 'Já existe solicitação de pagamento');
                else if (existStatus(listPaymentsByService, 2))
                  Alert.showAlertDialog(context, 'Já existe pagamento realizado');
                else if (existStatus(listPaymentsByService, 6))
                  Alert.showAlertDialog(context, 'Já foi solicitado pagamento');
                else if (listPaymentsByService.length == 0){
                  PaymentBusiness.createUserRepostNoPayment(widget.service.documentID);
                  _getPayments();
                }
                else Alert.showAlertDialog(context, 'Não foi possível solicitar o pagamento, selecione outra opção');
              },
              title: Text('Solicitar pagamento'),
              subtitle: Text('Caso o contratante não disponibilizar o pagamento no término do serviço'),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                if (existStatus(listPaymentsByService, 2))
                  Alert.showAlertDialog(context, 'Pagamento realizado');
                else
                  showDialog(context: context, builder: (BuildContext context) {
                    return callBank();
                  });

              },
              title: Text('Banco incorreto'),
              subtitle: Text('Para alterar conta para recebimento'),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
              },
              title: Text('Atraso para recebimento'),
              subtitle: Text('O pagamento pode demorar até dois dias úteis'),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
              },
              title: Text('Valor incorreto'),
              subtitle: Text('Recebi um valor incorreto do serviço contratado'),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
              },
              title: Text('Nenhuma das opções'),
              subtitle: Text('Selecione está opção, informe o motivo, estaremos entrando em contato'),
            ),
          ],
        ),
      ),
      padding: EdgeInsets.only(top: 130, bottom: 130, right: 50, left: 50),
    );
  }

  //info, status, valor, dt_abertura, dt_inicioatendimento
  Widget _buildPaymentsByUser(BuildContext context, int index) {
    return MoveAnimation(
      duration: Duration(seconds: 3),
      child: Container(
          height: 120,
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
                  /*Padding(
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
                  ),*/
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(listPaymentsByService[index].msg,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          flex: 1,
                        ),

                      ],
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }

  Future<void> _getPayments() async {
    setState(() {
      listPaymentsByService.clear();
    });

    await Firestore.instance
        .collection("paymentsByService")
        .where("serviceID", isEqualTo: "${widget.service.documentID}")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((f) {
        setState(() {
          f.data["documentID"] = f.documentID;
          listPaymentsByService.add(PaymentsByService.fromJson(f.data));
          print(listPaymentsByService);
        });
      });
    });
  }

  void _callChat(ServicesByUser servicesByUser) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Chat(service: servicesByUser)));
  }
}

