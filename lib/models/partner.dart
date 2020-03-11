import 'package:cloud_firestore/cloud_firestore.dart';

class Partner {
  final String cep;
  final String cnpj;
  final String email;
  final String logradouro;
  final String nome;
  final String numero;
  final String st_registro;
  final String telefone_adm;
  final String telefone_sac;
  final String url_logo;

  Partner(
      {this.cep,
      this.cnpj,
      this.email,
      this.logradouro,
      this.nome,
      this.numero,
      this.st_registro,
      this.telefone_adm,
      this.telefone_sac,
      this.url_logo});

  Map<String, Object> toJson() {
    return {
      'cep': cep,
      'cnpj': cnpj,
      'email': email,
      'logradouro': logradouro,
      'nome': nome,
      'numero': numero,
      'st_registro': st_registro,
      'telefone_adm': telefone_adm,
      'telefone_sac': telefone_sac,
      'url_logo': url_logo
    };
  }

  factory Partner.fromJson(Map<String, Object> doc) {
    Partner partner = new Partner(
      cep: doc['cep'],
      cnpj: doc['cnpj'],
      email: doc['email'],
      logradouro: doc['logradouro'],
      nome: doc['nome'],
      numero: doc['numero'],
      st_registro: doc['st_registro'],
      telefone_adm: doc['telefone_adm'],
      telefone_sac: doc['telefone_sac'],
      url_logo: doc['url_logo'],
    );
    return partner;
  }

  factory Partner.fromDocument(DocumentSnapshot doc) {
    return Partner.fromJson(doc.data);
  }
}
