import 'dart:typed_data';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart' as model;
import '../utils/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var username = "";
  var gender = "";
  var age = 0;
  var about = "";
  var value = 3.0;
  Uint8List? image;
  var photoURL = "";

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<Uint8List> selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
    return img;
  }

  Future<void> uploadPPtoFirestore(Uint8List? image) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final user = FirebaseFirestore.instance.collection('users').doc(userID);

    Reference ref = FirebaseStorage.instance.ref().child("profilePictures").child(userID);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    user.update({
      'photoUrl' : downloadUrl
    });
  }

  void getUserInfo() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
      .collection('users').doc(userID).get();

    var user = model.User.fromMap(snap);
    setState(() {
      username = user.username;
      gender = user.gender;
      age = user.age;
      about = user.about;
      photoURL = user.photoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {

    // var user = Provider.of<UserProvider>(context).getUser as model.User;

    List<CardItem> items = [
      ImageCarditem(
        image: Image.network('https://picsum.photos/200',
            height: 72, fit: BoxFit.fill),
      ),
      ImageCarditem(
        image: Image.network(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
            height: 72,
            fit: BoxFit.fill),
      ),
      ImageCarditem(
        image: Image.network('https://picsum.photos/200',
            height: 72, fit: BoxFit.fill),
      ),
      ImageCarditem(
        image: Image.network(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
            height: 72,
            fit: BoxFit.fill),
      ),
      ImageCarditem(
        image: Image.network(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
            height: 72,
            fit: BoxFit.fill),
      ),
      ImageCarditem(
        image: Image.network(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
            height: 72,
            fit: BoxFit.fill),
      ),
      ImageCarditem(
        image: Image.network(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
            height: 72,
            fit: BoxFit.fill),
      ),
      ImageCarditem(
        image: Image.network(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
            height: 72,
            fit: BoxFit.fill),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(children: [
                      photoURL != ""
                          ? CircleAvatar(
                              radius: 48, // Image radius
                              backgroundImage: NetworkImage(photoURL),
                              backgroundColor: Colors.transparent,
                            )
                          : const CircleAvatar(
                              radius: 48, // Image radius
                              backgroundImage: NetworkImage(
                                  'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                              backgroundColor: Colors.transparent,
                            ),
                      Positioned(
                        bottom: -8,
                        left: 60,
                        child: IconButton(
                          onPressed: () {
                            selectImage().then((value) => uploadPPtoFirestore(image)).then((value) => getUserInfo());
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ]),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                username,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey[700]),
                              ),
                              MaterialButton(
                                minWidth: 100,
                                height: 40,
                                onPressed: () {
                                  //Poke Activity

                                },
                                color: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                            ]))
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 2,
                child: Padding(padding: const EdgeInsets.all(8), child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        "Gender: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18,),
                      ),
                      Text(
                        gender,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18, color: Colors.teal),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Age: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        age.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18, color: Colors.teal),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "About: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        about,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.teal),
                      ),
                    ],
                  ),
                ])),),
              const Spacer(),
              TitledContainer(
                  titleColor: Colors.grey,
                  title: 'Favorite Places',
                  textAlign: TextAlignTitledContainer.Left,
                  fontSize: 14.0,
                  backgroundColor: Colors.white,
                  child: Container(
                      width: double.infinity,
                      height: 120.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Center(
                          child: HorizontalCardPager(
                            onPageChanged: (page) => print("page : $page"),
                            onSelectedItem: (page) => print("selected : $page"),
                            items: items,
                          )))),
              Spacer(),
              TitledContainer(
                titleColor: Colors.grey,
                title: 'John\'s Opinion',
                textAlign: TextAlignTitledContainer.Left,
                fontSize: 14.0,
                backgroundColor: Colors.white,
                child: new Container(),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Color.fromRGBO(240, 240, 244, 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(4),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2,
                                child: Column(children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          child: Image.network(
                                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                                              height: 100,
                                              width: 150,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const Text(
                                                  "X Restaurant",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.grey),
                                                ),
                                                RatingStars(
                                                  value: value,
                                                  onValueChanged: (v) {
                                                    //
                                                    setState(() {
                                                      value = v;
                                                    });
                                                  },
                                                  starBuilder: (index, color) =>
                                                      Icon(
                                                        Icons.star_rate,
                                                        color: color,
                                                      ),
                                                  starCount: 5,
                                                  starSize: 20,
                                                  maxValue: 5,
                                                  starSpacing: 2,
                                                  maxValueVisibility: true,
                                                  valueLabelVisibility: false,
                                                  animationDuration:
                                                  Duration(milliseconds: 1000),
                                                  starOffColor:
                                                  const Color(0xffe7e8ea),
                                                  starColor: Colors.yellow,
                                                ),
                                                //Here will be rate bar
                                              ]))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Bubble(
                                      margin: BubbleEdges.only(top: 10),
                                      nip: BubbleNip.leftTop,
                                      color: Color.fromRGBO(212, 234, 244, 1.0),
                                      child: Row(children: const <Widget>[
                                        CircleAvatar(
                                          radius: 24, // Image radius
                                          backgroundImage: NetworkImage(
                                              'https://picsum.photos/200'),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Bla Bla Bla Bla Bla Bla Bla Bla Bl\nBla Bla Bla Bla Bla Bla Bla Bla Bl\nBla Bla Bla Bla Bla Bla Bla Bla Bl',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.grey),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                ]));
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

