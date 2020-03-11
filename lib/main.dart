import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siriustrackeragente/screens/homepage.dart';
import 'package:siriustrackeragente/screens/signinscreen.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SiriusTracker - Agente',
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((pref) {
      String userID = pref.getString('userID');
      if (userID == null || userID.isEmpty) {
        Future.delayed(Duration(seconds: 5)).then((v) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SignInScreen()));
        });
      } else {
        Future.delayed(Duration(seconds: 5)).then((v) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Image(
                          image: AssetImage("assets/icon/app.gif"),
                          height: 200.0,
                          width: 200.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Center(
                          child: Text(
                        "Sirius Tracker p/ Agentes",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
