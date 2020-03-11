import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  final String UserId;

  ImageCapture({Key key, this.UserId}) : super(key: key);

  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        statusBarColor: Colors.blue,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Ajustar');

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.blue,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Container(
                padding: EdgeInsets.all(25), child: Image.file(_imageFile)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  //color: Colors.black,
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Uploader(
                file: _imageFile,
              ),
            )
          ]
        ],
      ),
    );
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://siriustrackeragente.appspot.com/');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  StorageUploadTask _uploadTask;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    user = await _auth.currentUser();
  }

  _startUpload() {
    String filePath = 'usersCNH/${user?.uid}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            if (_uploadTask.isComplete) {
              Navigator.pop(context);
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    value: progressPercent,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black38),
                  ),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontFamily: 'Raleway'),
                  ),
                ]);
          });
    } else {
      return FlatButton.icon(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)),
          label: Text(
            'Enviar foto',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'Raleway'),
          ),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload);
    }
  }
}
