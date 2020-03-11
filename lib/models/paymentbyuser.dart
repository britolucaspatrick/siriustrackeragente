import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentsByUser {
  //String service;
  int status;
  String ds_banco;
  String agencia;
  String cd_Banco;
  String conta;
  String destinatario;
  String cpf;
  Timestamp dt_abertura;
  Timestamp dt_finalizado;

  String get Status_desc {
    if (status == 0)
      return "Solicitado";
    else if (status == 1)
      return "Processamento";
    else if (status == 2)
      return "Realizado";
    else if (status == 3)
      return "Reportado";
    else if (status == 4)
      return "Report solucionado com sucesso";
    else if (status == 5) return "Report solucionado com erro";
  }

  PaymentsByUser(
      {
      //this.service,
      this.status,
      this.ds_banco,
      this.agencia,
      this.cd_Banco,
      this.conta,
      this.destinatario,
      this.cpf,
      this.dt_abertura,
      this.dt_finalizado});

  Map<String, Object> toJson() {
    return {
      //'service': service,
      'status': status,
      'ds_banco': ds_banco,
      'agencia': agencia,
      'cd_Banco': cd_Banco,
      'conta': conta,
      'destinatario': destinatario,
      'cpf': cpf,
      'dt_abertura': dt_abertura,
      'dt_finalizado': dt_finalizado,
    };
  }

  factory PaymentsByUser.fromJson(Map<Object, Object> doc) {
    PaymentsByUser service = new PaymentsByUser(
      //service: doc['service'],
      status: doc['status'],
      ds_banco: doc['ds_banco'],
      agencia: doc['agencia'],
      cd_Banco: doc['cd_Banco'],
      conta: doc['conta'],
      destinatario: doc['destinatario'],
      cpf: doc['cpf'],
      dt_abertura: doc['dt_abertura'],
      dt_finalizado: doc['dt_finalizado'],
    );
    return service;
  }

  factory PaymentsByUser.fromDocument(DocumentSnapshot doc) {
    return PaymentsByUser.fromJson(doc.data);
  }
}
