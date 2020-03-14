import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentsByService {
  String serviceID;
  int status;
  String ds_banco;
  String agencia;
  String cd_Banco;
  String conta;
  String destinatario;
  String cpf;
  String msg;
  Timestamp dt_abertura;
  Timestamp dt_finalizado;

  String get Status_desc {
    if (status == 0)
      return "Solicitado";
    else if (status == 1)
      return "Processamento";
    else if (status == 2)
      return "Pagamento Realizado";
    else if (status == 3)
      return "Reportado";
    else if (status == 4)
      return "Report solucionado com sucesso";
    else if (status == 5)
      return "Report solucionado com erro";
    else if (status == 6)
      return "Usuário solicitou pagamento";
  }

  PaymentsByService(
      {
      this.serviceID,
      this.status,
      this.ds_banco,
      this.agencia,
      this.cd_Banco,
      this.conta,
      this.destinatario,
      this.cpf,
      this.dt_abertura,
      this.dt_finalizado,
      this.msg});

  Map<String, Object> toJson() {
    return {
      'serviceID': serviceID,
      'status': status,
      'ds_banco': ds_banco,
      'agencia': agencia,
      'cd_Banco': cd_Banco,
      'conta': conta,
      'destinatario': destinatario,
      'cpf': cpf,
      'dt_abertura': dt_abertura,
      'dt_finalizado': dt_finalizado,
      'msg': msg,
    };
  }

  factory PaymentsByService.fromJson(Map<Object, Object> doc) {
    PaymentsByService service = new PaymentsByService(
      serviceID: doc['serviceID'],
      status: doc['status'],
      ds_banco: doc['ds_banco'],
      agencia: doc['agencia'],
      cd_Banco: doc['cd_Banco'],
      conta: doc['conta'],
      destinatario: doc['destinatario'],
      cpf: doc['cpf'],
      dt_abertura: doc['dt_abertura'],
      dt_finalizado: doc['dt_finalizado'],
      msg: doc['msg'],
    );
    return service;
  }

  factory PaymentsByService.fromDocument(DocumentSnapshot doc) {
    return PaymentsByService.fromJson(doc.data);
  }
}
