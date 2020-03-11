import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siriustrackeragente/business/auth.dart';
import 'package:siriustrackeragente/helper/uihelper.dart';
import 'package:siriustrackeragente/screens/about.dart';
import 'package:siriustrackeragente/screens/configuration.dart';
import 'package:siriustrackeragente/screens/contact.dart';
import 'package:siriustrackeragente/screens/myaccount.dart';
import 'package:siriustrackeragente/screens/services.dart';
import 'package:siriustrackeragente/screens/signinscreen.dart';

class MenuWidget extends StatelessWidget {
  final menuItems = [
    'Início',
    'Serviços',
    'Dados pessoais',
    'Configuração',
    'Sobre',
    'Contato',
    'Sair'
  ];
  final num currentMenuPercent;
  final Function(bool) animateMenu;
  final String nome_;
  final String email_;
  final String url_;

  MenuWidget(
      {Key key,
      this.currentMenuPercent,
      this.animateMenu,
      this.nome_,
      this.email_,
      this.url_})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentMenuPercent != 0
        ? Positioned(
            left: realW(-358 + 358 * currentMenuPercent),
            width: realW(358),
            height: screenHeight,
            child: Opacity(
              opacity: currentMenuPercent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(realW(50))),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        blurRadius: realW(20)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (notification) {
                        notification.disallowGlow();
                      },
                      child: CustomScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              height: realH(236),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(realW(50))),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      colors: [
                                        Color(0xFF59C2FF),
                                        Color(0xFF1270E3),
                                      ])),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                      left: realW(10),
                                      bottom: realH(27),
                                      height: 100,
                                      width: 100,
                                      child: CircleAvatar(
                                        backgroundImage: url_ != null
                                            ? NetworkImage(url_)
                                            : AssetImage(
                                                "assets/images/default.png"),
                                      )),
                                  Positioned(
                                    left: realW(135),
                                    top: realH(110),
                                    child: DefaultTextStyle(
                                      style: TextStyle(color: Colors.white),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: realH(5.0)),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text.rich(
                                                TextSpan(
                                                  text: nome_ == null
                                                      ? ''
                                                      : nome_,
                                                  style: TextStyle(
                                                      fontSize: realW(14),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: realH(5.0)),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text.rich(
                                                TextSpan(
                                                  text: email_,
                                                  style: TextStyle(
                                                      fontSize: realW(14),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(
                                top: realH(34),
                                bottom: realH(50),
                                right: realW(37)),
                            sliver: SliverFixedExtentList(
                              itemExtent: realH(56),
                              delegate: new SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Container(
                                    width: realW(320),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: realW(20)),
                                    decoration: index == 0
                                        ? BoxDecoration(
                                            color: Color(0xFF379BF2)
                                                .withOpacity(0.2),
                                            borderRadius: BorderRadius.only(
                                                topRight:
                                                    Radius.circular(realW(50)),
                                                bottomRight:
                                                    Radius.circular(realW(50))))
                                        : null,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (index == 0)
                                          animateMenu(false);
                                        else if (index == 1)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => Services()));
                                        else if (index == 2)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => MyAccount()));
                                        else if (index == 3)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      Configuration()));
                                        else if (index == 4)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => AboutApp()));
                                        else if (index == 5)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => Contact()));
                                        else if (index == 6) _logOut(context);
                                      },
                                      child: Text(
                                        menuItems[index].trim(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: index == 0
                                              ? Colors.blue
                                              : Colors.black,
                                          fontSize: realW(20),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ));
                              }, childCount: menuItems.length),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // close button
                    Positioned(
                      bottom: realH(53),
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          animateMenu(false);
                        },
                        child: Container(
                          width: realH(71),
                          height: realH(71),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: realW(17)),
                          child: Icon(
                            Icons.close,
                            color: Color(0xFFE96977),
                            size: realW(34),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFB5E74).withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(realW(36)),
                                topLeft: Radius.circular(realW(36))),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : const Padding(padding: EdgeInsets.all(0));
  }

  void _logOut(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      Auth.signOut();
      Auth.signOutGoogle();
      prefs.setString('userID', "");
      prefs.setString('email', "");
      prefs.setString('nome', "");
      prefs.setString('url', "");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => SignInScreen()));
    });
  }
}
