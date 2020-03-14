
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siriustrackeragente/models/partner.dart';
import 'package:siriustrackeragente/models/paymentbyservice.dart';

class PaymentBusiness{

  static Future<void> createUserRepostNoPayment(String serviceID){
    PaymentsByService paymentsByService = new PaymentsByService();
    paymentsByService.msg = 'Usuário informou que o contratante não disponibilizou o pagamento no término do serviço';
    paymentsByService.dt_abertura = Timestamp.now();
    paymentsByService.status = 6;
    paymentsByService.serviceID = serviceID;
    /*Firestore.instance.collection('paymentbyservice').add(paymentsByService.toJson()).then((value){
      paymentsByService.
      Firestore.instance.collection('paymentbyservice').document(value.documentID).updateData(paymentsByService.toJson());
    });*/
    return Firestore.instance.collection('paymentsByService').add(paymentsByService.toJson());
  }

}