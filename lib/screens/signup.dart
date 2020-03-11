import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siriustrackeragente/business/auth.dart';
import 'package:siriustrackeragente/models/user.dart';
import 'package:siriustrackeragente/widgets/customalertdialog.dart';

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullname = new TextEditingController();
  final TextEditingController _number = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _passwordConf = new TextEditingController();
  bool _blackVisible = false;
  VoidCallback onBackPress;
  bool passwordVisible;
  bool passwordVisibleConf;
  bool isLoading;

  @override
  void initState() {
    super.initState();

    onBackPress = () {
      Navigator.of(context).pop();
    };

    passwordVisible = false;
    passwordVisibleConf = false;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 70.0, bottom: 10.0, left: 10.0, right: 10.0),
                        child: Text(
                          "Criar nova conta",
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(212, 20, 15, 1.0),
                            decoration: TextDecoration.none,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            labelText: "Nome Completo",
                          ),
                          controller: _fullname,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Informe nome completo';
                            } else if (value.length < 3) {
                              return 'Deve conter pelo menos 3 caracteres';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            labelText: "Telefone",
                          ),
                          controller: _number,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Informe telefone';
                            } else if (value.length < 8) {
                              return 'Deve conter pelo menos 8 caracteres';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            labelText: "E-mail",
                          ),
                          controller: _email,
                          validator: (value) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (value == null || value.isEmpty)
                              return 'Informe e-mail';
                            else if (!regex.hasMatch(value))
                              return 'E-mail inválido';
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onTap: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                              border: UnderlineInputBorder(),
                              filled: true,
                              labelText: "Senha"),
                          controller: _password,
                          obscureText: passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Informe senha';
                            else if (value.length < 6)
                              return 'Deve conter mínimo de 6 caracteres';
                            else if (_password.text != _passwordConf.text)
                              return 'As senhas devem coincidir';
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(passwordVisibleConf
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onTap: () {
                                  setState(() {
                                    passwordVisibleConf = !passwordVisibleConf;
                                  });
                                },
                              ),
                              border: UnderlineInputBorder(),
                              filled: true,
                              labelText: "Confirmar senha"),
                          controller: _passwordConf,
                          obscureText: passwordVisibleConf,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Informe senha';
                            else if (value.length < 6)
                              return 'Deve conter mínimo de 6 caracteres';
                            else if (_password.text != _passwordConf.text)
                              return 'As senhas devem coincidir';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 40.0),
                        child: OutlineButton(
                          child: isLoading
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : Text('Cadastrar'),
                          onPressed: () {
                            _signUp(
                                fullname: _fullname.text,
                                email: _email.text,
                                number: _number.text,
                                password: _password.text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: onBackPress,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signUp(
      {String fullname,
      String number,
      String email,
      String password,
      BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await Auth.signUp(email, password).then((uID) {
          Auth.addUser(new User(
              userID: uID,
              email: email,
              firstName: fullname,
              number: number,
              profilePictureURL: '',
              bairro: '',
              cep: '',
              cidade: '',
              complement: '',
              cpf: '',
              logradouro: '',
              numero: '',
              st_cnh: '0'));
          onBackPress();
        });
        setState(() => isLoading = false);
      } catch (e) {
        print("Error in sign up: $e");
        String exception = Auth.getExceptionText(e);
        _showErrorAlert(
          title: "Erro ao cadastrar",
          content: exception,
        );
        setState(() => isLoading = false);
      }
    }
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }
}
