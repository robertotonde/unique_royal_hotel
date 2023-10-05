import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/sign_in_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class QuestionDetail extends StatefulWidget {
  QuestionDetail({Key? key, this.documentId, this.name, this.photoProfile})
      : super(key: key);

  final String? documentId;
  String? name, _question, photoProfile;
  final TextEditingController nama = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController question = new TextEditingController();
  @override
  _QuestionDetailState createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  @override
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  var uuid = Uuid();
  var imagePicUrl;

  String? data;
  String? filename;
  bool imageUpload = true;

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataIn = prefs.getString("clockin") ?? 'default';
    return dataIn;
  }

  callme() async {
    await Future.delayed(Duration(seconds: 20));
    getData().then((value) => {
          setState(() {
            data = value;
            data = "test";
          })
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String? fileName;

  File? imageFile;

  @override
  void initState() {
    callme();
    // TODO: implement initState
    super.initState();
  }

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });

      uploadImage();
    } else {
      print('No image selected!');
    }
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(imageFile!.path);
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(imageFile!);
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
    setState(() {
      print("Profile Picture uploaded");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });

    setState(() {
      print("Profile Picture uploaded");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  Future selectPhoto() async {
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });

      uploadImage();
    } else {
      print('No image selected!');
    }
  }

  Future uploadImage() async {
    String fileName = basename(imageFile!.path);
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(imageFile!);
    await uploadTask.whenComplete(() async {
      var _url = await ref.getDownloadURL();
      var _imageUrl = _url.toString();
      setState(() {
        imagePicUrl = _imageUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = context.read<SignInBloc>();
    var v4 = uuid.v4();
    void addData() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("Q&A")
            .doc(widget.documentId)
            .collection("question")
            .add({
          "Name": sb.name,
          "Photo Profile": sb.photoProfile,
          "Detail question": widget._question,
          "Answer": " ",
          "Date": DateTime.now()
        });
      });
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          ('Add Question'),
          style: TextStyle(
              fontFamily: "RedHat",
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 12.0, left: 12.0, top: 15.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(('Add Question'),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          fontFamily: "RedHat")),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: TextFormField(
                      // ignore: missing_return
                      validator: (input) {
                        if (input!.isEmpty) {
                          return ('Please add your question');
                        }
                      },
                      maxLines: 6,
                      onSaved: (input) => widget._question = input,
                      controller: widget.question,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          fontFamily: "RedHat",
                          fontSize: 16.0,
                          color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black12.withOpacity(0.01))),
                        contentPadding: EdgeInsets.all(13.0),
                        hintText: ('Add Your Question'),
                        hintStyle:
                            TextStyle(fontFamily: "RedHat", fontSize: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.1,
                  ),
                  InkWell(
                    onTap: () {
                      final formState = _form.currentState;

                      if (formState!.validate()) {
                        formState.save();

                        addData();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(('Error')),
                                content: Text(('Please add your question')),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      primary: Colors.transparent,
                                    ),
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Container(
                      height: 52.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                      child: Center(
                        child: Text(
                          ('Send'),
                          style: TextStyle(
                              fontFamily: "RedHat",
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
