import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:siriustrackeragente/animation/move.dart';
import 'package:siriustrackeragente/business/auth.dart';
import 'package:siriustrackeragente/models/user.dart';
import 'package:siriustrackeragente/widgets/alert.dart';
import 'package:siriustrackeragente/widgets/imagecapture.dart';

class MyAccount extends StatefulWidget {
  _MyAccountState createState() => new _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  TextEditingController _name = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _cep = new MaskedTextController(mask: '00.000-000');
  TextEditingController _logradouro = new TextEditingController();
  TextEditingController _bairro = new TextEditingController();
  TextEditingController _numero = new TextEditingController();
  TextEditingController _cidade = new TextEditingController();
  TextEditingController _complemento = new TextEditingController();
  TextEditingController _cpf = new MaskedTextController(mask: '000.000.000-00');
  FirebaseUser user;
  User _userEmail;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  String _password;
  var _scaffoldKey;
  TextEditingController cardNumber =
      new MaskedTextController(mask: '0000 0000 0000 0000');
  TextEditingController expiryDate = new MaskedTextController(mask: '00/00');
  TextEditingController cardHolderName = new TextEditingController();
  TextEditingController cvvCode = new TextEditingController();
  bool isCvvFocused = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
    Auth.getCurrentFirebaseUser().then((v) {
      Stream<User> userEmail = Auth.getUser(v.uid);
      if (userEmail.isEmpty != null) {
        _name.text = v?.displayName;
        _email.text = v?.email;
      }
      userEmail.forEach((userEmail) {
        _userEmail = userEmail;
        setState(() {
          user = v;
          _name.text = userEmail?.firstName;
          _email.text = userEmail?.email;
          _number.text = userEmail?.number;
          _cpf.text = userEmail?.cpf;
          _logradouro.text = userEmail?.logradouro;
          _bairro.text = userEmail?.bairro;
          _cidade.text = userEmail?.cidade;
          _complemento.text = userEmail?.complement;
          _numero.text = userEmail?.numero;
          _cep.text = userEmail?.cep;

          cardNumber.text = userEmail?.cardNumber;
          expiryDate.text = userEmail?.expiryDate;
          cardHolderName.text = userEmail?.cardHolderName;
          cvvCode.text = userEmail?.cvvCode;

          isLoading = false;

        });
      });

    }).timeout(Duration(seconds: 5), onTimeout: (){
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purple),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.only(left: 10, right: 10),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Minha Conta",
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.purple,
                            decoration: TextDecoration.none,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Image(
                          image: AssetImage("assets/images/profile.png"),
                          height: 100,
                          width: 100,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.person),
                        labelText: "Nome"),
                    controller: _name,
                    enabled: user?.providerId == 'google.com',
                  ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.email),
                        labelText: "E-mail"),
                    controller: _email,
                    enabled: false,
                  ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.phone),
                        labelText: "Telefone",
                        prefixText: "+55"),
                    keyboardType: TextInputType.phone,
                    controller: _number,
                  ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.call_to_action),
                        labelText: "CPF"),
                    controller: _cpf,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 30),
                    child: Text(
                      "CNH",
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(120, 193, 190, 1),
                        decoration: TextDecoration.none,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          child: Text(
                            "Foto segurando CNH. Deve aparecer nitidamente seu rosto físico, foto do documento, cpf, rg e número registro.",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                              color: Colors.black45,
                              decoration: TextDecoration.none,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          padding: EdgeInsets.only(left: 10),
                        ),
                      ),
                      _userEmail?.st_cnh == null || _userEmail?.st_cnh != 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ImageCapture()));
                                setState(() {
                                  _userEmail.st_cnh = '1';
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Image(
                                  image: AssetImage("assets/images/cnh.png"),
                                  fit: BoxFit.contain,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            )
                          : _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              duration: new Duration(seconds: 4),
                              content: new Row(
                                children: <Widget>[
                                  new CircularProgressIndicator(),
                                  new Text("Foto em análise...")
                                ],
                              ),
                            ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 30),
                    child: Text(
                      "Cartão crédito",
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(28, 70, 125, 1),
                        decoration: TextDecoration.none,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  CreditCardWidget(
                    cardNumber: cardNumber.text,
                    expiryDate: expiryDate.text,
                    cardHolderName: cardHolderName.text,
                    cvvCode: cvvCode.text,
                    showBackView:
                        isCvvFocused, //true when you want to show cvv(back) view
                    height: 175,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: true,
                          labelText: "Número"),
                      controller: cardNumber,
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if (value == null || value.isEmpty)
                          return "Necessário informar número";
                        else if (value.length != 19)
                          return "Deve conter 16 caracteres.";
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                labelText: "Dt. Vencimento"),
                            controller: expiryDate,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if (value == null || value.isEmpty)
                                return "Necessário informar dt. vencimento";
                              else if (value.length != 5)
                                return "Deve conter 5 caracteres";
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              labelText: "Cód. segurança",
                            ),
                            controller: cvvCode,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            validator: (value){
                              if (value == null || value.isEmpty)
                                return "Necessário informar cód. segurança";
                              else if (value.length != 3)
                                return "Deve conter 3 caracteres";
                            },
                            onChanged: (v) {
                              setState(() {
                                v.length != 3
                                    ? isCvvFocused = true
                                    : isCvvFocused = false;
                              });
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: true,
                          labelText: "Nome"),
                      controller: cardHolderName,
                      validator: (value){
                        if (value == null || value.isEmpty)
                          return "Necessário informar nome";
                        else if (value.length < 3)
                          return "Deve conter mínimo de 3 caracteres";
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate() && validarCNH(_userEmail)) {
                          Auth.addUser(new User(
                              userID: user?.uid,
                              firstName: user?.providerId == 'google.com'
                                  ? user?.displayName
                                  : _name.text,
                              email: user?.email,
                              number: _number.text,
                              cpf: _cpf.text,
                              logradouro: _logradouro.text,
                              bairro: _bairro.text,
                              cidade: _cidade.text,
                              complement: _complemento.text,
                              numero: _numero.text,
                              cep: _cep.text,
                              st_cnh: _userEmail.st_cnh == null
                                  ? '0'
                                  : _userEmail.st_cnh == '1'
                                      ? '1'
                                      : _userEmail.st_cnh == '2'
                                          ? '2'
                                          : _userEmail.st_cnh == '3'
                                              ? '3'
                                              : '0',
                              cardNumber: cardNumber.text,
                              expiryDate: expiryDate.text,
                              cardHolderName: cardHolderName.text,
                              cvvCode: cvvCode.text));
                          Alert.showAlertDialog(context, "Salvo com sucesso.");
                        }
                      },
                      child: Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildScreen(BuildContext context) {
    return new Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Column(children: <Widget>[
                MoveAnimation(
                  duration: Duration(seconds: 3),
                  //child: CardMyAccountList(),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  /*_saveMyAccount(BuildContext context){
    if (_key.currentState.validate()){
      new Alert().showAlertDialog(context, "Salvo com sucesso.");
    }
  }*/

  String validateField(String value) {
    if (value.length == 0) {
      return "Informe campo!";
    }
    return "";
  }

  bool validarCNH(User email) {
    if (email == null || email.st_cnh == null || email.st_cnh.isEmpty){
        Alert.showAlertDialog(context, 'Obrigatório informar CNH');
      return false;
    }

    return true;
  }
}
