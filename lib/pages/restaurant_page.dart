import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:travend/models/restaurant.dart';
import 'package:travend/models/user.dart' as model;
import 'package:travend/pages/main.dart';
import 'package:travend/pages/messaging_page.dart';
import 'package:uuid/uuid.dart';

class RestaurantPage extends StatefulWidget {
  RestaurantPage({Key? key, required this.restaurant}) : super(key: key);

  Restaurant restaurant;

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  var name = "";
  var address = "";
  dynamic rating = 3.0;
  late Restaurant current;
  var username = "";
  var userPhoto = "";
  var restaurantID = "1123043424";
  var userID = "";
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    current = widget.restaurant;
    super.initState();
    getRestaurantInfo();
    getUserName();
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }
  // get it from firestore
  void getRestaurantInfo() async {
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection('restaurants')
        .doc(current.ID)
        .get();

    setState(() {
    var restaurant = current.fromFirebase(snap);
      name = restaurant.name;
      rating = restaurant.rating + .0;
      address = restaurant.address;
      restaurantID = restaurant.ID;
    });
  }

  getUserName() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection('users').doc(userID).get();

    var user = model.User.fromMap(snap);

    this.userID = userID;
    setState(() {
      username = user.username;
      userPhoto = user.photoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blueAccent,),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
            },
          )
        ],
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder (
        stream: FirebaseFirestore.instance.collection('restaurants').doc(restaurantID).
        collection('comments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                      'https://www.baridahotels.com/gallery/images/restoranlar02.jpg',
                      height: 150, fit: BoxFit.fill),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Text(
                                "Details: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 16,
                                    color: Colors.deepOrangeAccent),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Rating: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              RatingStars(
                                value: rating + .0,
                                starBuilder: (index, color) =>
                                    Icon(
                                      Icons.star_rate,
                                      color: color,
                                    ),
                                starCount: 5,
                                starSize: 16,
                                maxValue: 5,
                                starSpacing: 2,
                                maxValueVisibility: true,
                                valueLabelVisibility: false,
                                animationDuration: const Duration(
                                    milliseconds: 1000),
                                starOffColor: const Color(0xffaaaaaa),
                                starColor: Colors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Adress: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ])),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(4),
                                itemCount: (snapshot.data! as dynamic).docs.length,
                                itemBuilder: (context, index) {
                                  return CommentCard(
                                    snap: (snapshot.data! as dynamic).docs[index],
                                    currUser: username,);
                                }),

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userPhoto),
                radius: 24,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as $username',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await postComment(restaurantID, commentController.text, userID, username, userPhoto);
                  setState(() {
                    commentController.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: const Text('Comment', style: TextStyle(color: Colors.deepOrangeAccent),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key, required this.snap, required this.currUser}) : super(key: key);

  final snap;
  final currUser;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              15.0),
        ),
        elevation: 2,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 24, // Image radius
                    backgroundImage: NetworkImage(widget.snap['profilePic']),
                    backgroundColor: Colors.transparent,
                  ),
                  Bubble(
                      margin:
                      const BubbleEdges.only(
                          top: 0),
                      nip: BubbleNip.leftTop,
                      color: const Color.fromRGBO(
                          212, 234, 244, 1.0),
                      child:
                      Column(children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: widget.snap['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          Text(
                            widget.snap['text'],
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w900,
                                color: Colors.grey),
                          ),
                        ]
                        ),
                      ])
                  ),
                  const Spacer(),
                  widget.snap['name'] != widget.currUser ?
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MessagingPage()
                      ));
                    },
                    icon: const Icon(Icons.send),color: Colors.indigo,
                  ): const Text(""),
                ]
            ),
          ),
        ]
        )
    );
  }
}
Future<void> postComment(String restaurantID, String text, String uid,
    String name, String profilePic) async {

  try {
    if(text.isNotEmpty) {
      String commentID = const Uuid().v1();
      await FirebaseFirestore.instance.collection('restaurants').doc(restaurantID).
      collection('comments').doc(commentID).set({
        'profilePic': profilePic,
        'name': name,
        'text': text,
        'commentID': commentID
      });
    } else {
      print("Text is empty");
    }
  } catch(e) {
    print(e.toString());
  }
}
