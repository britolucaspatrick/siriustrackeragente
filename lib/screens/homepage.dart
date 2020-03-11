import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siriustrackeragente/helper/uihelper.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';
import 'package:siriustrackeragente/utils/functions.dart';
import 'package:siriustrackeragente/widgets/menu.dart';
import 'package:siriustrackeragente/widgets/servicesseleted.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationControllerMenu;

  /// get currentOffset percent
  get currentExplorePercent =>
      max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  get currentSearchPercent => max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
  get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));

  var offsetExplore = 0.0;
  var offsetSearch = 0.0;
  var offsetMenu = 0.0;

  bool isExploreOpen = false;
  bool isSearchOpen = false;
  bool isMenuOpen = false;
  Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser user;
  double zoomVal = 5.0;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  List<ServicesByUser> services = new List();
  bool possuiServico = false;
  CurvedAnimation curve;
  Animation<double> animation;
  Animation<double> animationW;
  Animation<double> animationR;
  bool _loading = false;
  String uid;
  String email;
  String nome;
  String url;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((pref) {
      uid = pref.get('userID');
      email = pref.get('email');
      nome = pref.get('nome');
      url = pref.get('url');
      setState(() {
        email;
        nome;
        uid;
        url;
      });
    });
    _getLocation();
    Timer.periodic(Duration(seconds: 10), (value) {
      getServicesByUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              _buildGoogleMap(context),
              _buildContainer(),
              //_floatingButton(),
              Positioned(
                bottom: 30,
                //left: realW(-71 * (currentExplorePercent + currentSearchPercent)),
                child: GestureDetector(
                  onTap: () {
                    animateMenu(true);
                  },
                  child: Opacity(
                    opacity: 1 - (currentSearchPercent + currentExplorePercent),
                    child: Container(
                      width: realW(71),
                      height: realH(71),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: realW(17)),
                      child: Icon(
                        Icons.menu,
                        size: realW(34),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(realW(36)),
                              topRight: Radius.circular(realW(36))),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26, blurRadius: realW(36)),
                          ]),
                    ),
                  ),
                ),
              ),
              MenuWidget(
                currentMenuPercent: currentMenuPercent,
                animateMenu: animateMenu,
                nome_: nome,
                email_: email,
                url_: url,
              ),
            ],
          ),
        ));
  }

  getServicesByUser() async {
    try {
      services.clear();
      possuiServico = false;
      await Firestore.instance
          .collection("servicesByUser")
          .where("Status", isEqualTo: 0)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((f) {
          setState(() {
            f.data["documentID"] = f.documentID;
            services.add(ServicesByUser.fromJson(f.data));
            possuiServico = true;
          });
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
    }
  }

  void animateMenu(bool open) {
    animationControllerMenu =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
    animation =
        Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
          ..addListener(() {
            setState(() {
              offsetMenu = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isMenuOpen = open;
            }
          });
    animationControllerMenu.forward();
  }

  Future<void> _getLocation() async {
    var currentLocation;
    Location location = new Location();
    try {
      await location.getLocation().then((value) {
        currentLocation = value;
        _gotoLocation((currentLocation as LocationData).latitude,
            (currentLocation as LocationData).longitude, 18);
        //Marker Localização do usuário atual
        //_add((currentLocation as LocationData).latitude, (currentLocation as LocationData).longitude);
      }).catchError((error) {});
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      currentLocation = null;
    }
  }

  /*Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }*/

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 60.0),
          height: 140.0,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            scrollDirection: Axis.horizontal,
            itemBuilder: _buildServiceItem,
            itemCount: services?.length,
          )),
    );
  }

  Widget _buildServiceItem(BuildContext context, int index) {
    return _boxes(this.services[index]);
  }

  Widget _boxes(ServicesByUser servicesByUser) {
    return GestureDetector(
      onTap: () {
        _createMarketByService(double.parse(servicesByUser.Latitude),
            double.parse(servicesByUser.Longitude), servicesByUser.InfoWindow);
        _gotoLocation(double.parse(servicesByUser.Latitude),
            double.parse(servicesByUser.Longitude), 18);
      },
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Colors.black26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(servicesByUser.UrlImagemVeiculo[0]),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer(servicesByUser),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer(ServicesByUser servicesByUser) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            servicesByUser.InfoWindow,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "R\u0024 ${Functions.formatDoubleToMoney(servicesByUser.Valor)}",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "${DateTime.fromMillisecondsSinceEpoch(servicesByUser.Dt_abertura?.millisecondsSinceEpoch).day}/"
          "${DateTime.fromMillisecondsSinceEpoch(servicesByUser.Dt_abertura?.millisecondsSinceEpoch).month}/"
          "${DateTime.fromMillisecondsSinceEpoch(servicesByUser.Dt_abertura?.millisecondsSinceEpoch).year} "
          "\u00B7 "
          "${DateTime.fromMillisecondsSinceEpoch(servicesByUser.Dt_abertura?.millisecondsSinceEpoch).hour}:"
          "${DateTime.fromMillisecondsSinceEpoch(servicesByUser.Dt_abertura?.millisecondsSinceEpoch).minute}",
          style: TextStyle(
              color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.bold),
        )),
        SizedBox(height: 5.0),
        RaisedButton(
          child: Text("Detalhes"),
          onPressed: () {
            _showServiceSelected(servicesByUser);
            setState(() {
              services.clear();
            });
          },
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(
              color: Colors.black12,
              width: 60,
            ),
          ),
        ),
      ],
    );
  }

  /*String _distanceBetweenPoint(double startLatitude, double startLongitude, double endLatitude, double endLongitude)  {
    Geolocator().distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude)
        .then((value){
      print(value / 1000);

      return (value / 1000).toString();
    });
    return "";
  }*/

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 30),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  /*void _add(double latitude, double longitude) {
    final Marker marker = Marker(
        markerId: MarkerId('user'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: 'Localização Atual'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen
        )
    );

    setState(() {
      markers[MarkerId('user')] = marker;
    });
  }*/

  Future<void> _gotoLocation(double lat, double long, double zoomValue) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: zoomValue,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  void _createMarketByService(double lat, double long, String infoWindow) {
    final Marker marker = Marker(
        markerId: MarkerId("${lat}${long}"),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: infoWindow),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    setState(() {
      markers[MarkerId('${lat}${long}')] = marker;
    });
  }

  void _showServiceSelected(ServicesByUser value) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ServicesSeleted(service: value,);
      },
    );
  }
}
