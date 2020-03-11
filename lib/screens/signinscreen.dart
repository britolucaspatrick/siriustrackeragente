import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siriustrackeragente/business/auth.dart';
import 'package:siriustrackeragente/screens/homepage.dart';
import 'package:siriustrackeragente/screens/signup.dart';
import 'package:siriustrackeragente/widgets/customalertdialog.dart';

class SignInScreen extends StatefulWidget {
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool passwordVisible;
  bool isLoading;
  var loader;

  @override
  void initState() {
    super.initState();

    passwordVisible = true;
    isLoading = false;
  }

  Widget _signInButton() {
    return OutlineButton(
      onPressed: () {
        signInWithGoogle().then((value) {
          if (value != null) {
            SharedPreferences.getInstance().then((pref) {
              pref.setString('userID', value.uid);
              pref.setString('email', value.email);
              pref.setString('nome', value.displayName);
              pref.setString('url', value.photoUrl);
            });
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
          }
        }).catchError((er) {
          _showErrorAlert(title: 'Erro', content: er.toString());
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/google_logo.png"),
            height: 25.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'Google',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Image(
                      image: AssetImage("assets/icon/app.gif"),
                      height: 200.0,
                      width: 200.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 10.0, left: 15.0, right: 15.0),
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
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 20.0, left: 15.0, right: 15.0),
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
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          OutlineButton(
                            child: isLoading
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator())
                                : Text('Entrar'),
                            onPressed: () {
                              _emailLogin(
                                  email: _email.text,
                                  password: _password.text,
                                  context: context);
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 10.0, left: 15.0, right: 15.0),
                      ),
                      Column(
                        children: <Widget>[
                          OutlineButton(
                            child: Text('Cadastrar'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignUpScreen()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _signInButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult retur = await _auth.signInWithCredential(credential);
    final FirebaseUser user = retur.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  _emailLogin({String email, String password, BuildContext context}) {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Auth.signIn(email, password).then((value) {
          Auth.getUser(value.uid).first.then((user) {
            SharedPreferences.getInstance().then((pref) {
              pref.setString('userID', value.uid);
              pref.setString('email', value.email);
              pref.setString(
                  'nome',
                  value.displayName == null || value.displayName == ''
                      ? user.firstName
                      : value.displayName);
              pref.setString('url', value.photoUrl);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => HomePage()));
            });
          });
          setState(() => isLoading = false);
        }).catchError((err) {
          print(err);
          setState(() => isLoading = false);
        });
      } catch (e) {
        String exception = Auth.getExceptionText(e);
        print(exception);
        _showErrorAlert(
          title: "Login falhou",
          content: exception,
          onPressed: () {},
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
