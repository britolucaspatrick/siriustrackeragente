
//stateless, sem estado, não possui variação, especifico para widgets
import 'package:flutter/material.dart';
import 'package:siriustrackeragente/business/servicesbyuser.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';
import 'package:siriustrackeragente/utils/functions.dart';
import 'package:siriustrackeragente/widgets/customflatbutton.dart';

class ServicesSeleted extends StatelessWidget {
  final ServicesByUser service;
  final VoidCallback onPressed;
  final bool visibleAceitar;
  ServicesSeleted({this.service, this.onPressed, this.visibleAceitar = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        title: Text(
          "Detalhes do serviço",
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "OpenSans",
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                    height: 150,
                    width: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: _buildImagens,
                      itemCount: service.UrlImagemVeiculo.length,
                    )
                ),
                SizedBox(height: 5,),
                Row(
                  children: <Widget>[
                    Text(
                      'Título: ${service.InfoWindow}',
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Text(
                  'Descrição: ${service.Description}',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontFamily: "OpenSans",
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  children: <Widget>[
                    Text(
                      "Valor: R\u0024 ${Functions.formatDoubleToMoney(service.Valor)}",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: <Widget>[
                    Text(
                      "Status: ${service.Status_desc}",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0,),
                        child: CustomFlatButton(
                          title: "Voltar",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          borderColor: Colors.red,
                          borderWidth: 2,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    visibleAceitar ?
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CustomFlatButton(
                          title: "Aceitar",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.green,
                          onPressed: () {
                            ServicesByUserBusiness.updateByEmAtendimento(service);
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.greenAccent,
                          borderColor: Colors.green,
                          borderWidth: 2,
                        ),
                      ),
                    )
                        :
                    SizedBox(width: 5.0,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagens(BuildContext context, int index) {
    return FittedBox(
      child: Material(
          color: Colors.white,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: Colors.black26,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(service.UrlImagemVeiculo[index],
                      ),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}