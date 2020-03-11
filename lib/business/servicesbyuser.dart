import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';

class ServicesByUserBusiness {

/*  static Future<QuerySnapshot> getServicesByStatus(int vStatus) async {
    await Firestore.instance
        .collection("servicesByUser")
        .where("Status", isEqualTo: vStatus)
        .getDocuments();
  }*/

  static void updateByEmAtendimento(ServicesByUser service){
    service.Status = 1;
    service.Dt_inicioatendimento = new Timestamp.now();
    FirebaseAuth.instance.currentUser().then((value){
      service.userID = value.uid;
      Firestore.instance.collection("servicesByUser").document(service.documentID).updateData(service.toJson());
    });
  }
}