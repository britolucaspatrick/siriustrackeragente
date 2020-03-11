import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';

class ChatScreen extends StatefulWidget {
  final ServicesByUser serv;

  ChatScreen({Key key, @required this.serv}) : super(key: key);

  @override
  State createState() => new ChatScreenState(service: serv);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.service});
  final ServicesByUser service;
  String id;
  var listMessage;
  String groupChatId;
  SharedPreferences prefs;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    groupChatId = service.documentID;
    isLoading = false;
    isShowSticker = false;
    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        user = value;
      });
    });
    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    print(user.uid);

    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),
              // Input content
              buildInput(),
            ],
          ),
          // Loading
          buildLoading()
        ],
      ),
      //onWillPop: true,
    );
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    Firestore.instance
        .collection('users')
        .document(groupChatId)
        .updateData({'chattingWith': service.clientUserID});
    setState(() {});
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      //Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': service.userID,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      //Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    print('documento ${document['idFrom']}');
    print(user.uid);
    if (document['idFrom'] != user.uid) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: Icon(Icons.person),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                if (document['type'] == 0)
                  Container(
                    child: Text(
                      document['content'],
                      style: TextStyle(color: Colors.black),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
                if (document['type'] == 1)
                  Container(
                    child: FlatButton(
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black26),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              'images/img_not_available.jpeg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: document['content'],
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        /* Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));*/
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
              ],
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    } else {
      //Usuário logado
      return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                if (document['type'] == 0) //Text
                  Container(
                    child: Text(
                      document['content'],
                      style: TextStyle(color: Colors.black),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                if (document['type'] == 1) //Image
                  Container(
                    child: FlatButton(
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black26),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              'images/img_not_available.jpeg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: document['content'],
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        /*Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));*/
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                Material(
                  child: user.photoUrl == null || user.photoUrl.isEmpty
                      ? Image(
                          image: AssetImage("assets/images/default.png"),
                          width: 35,
                          height: 35,
                        )
                      : CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black26),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: user.photoUrl,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(document['timestamp']))),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                  margin: EdgeInsets.only(top: 5.0, right: 55.0),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Digite sua mensagem...',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.black, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black26)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
