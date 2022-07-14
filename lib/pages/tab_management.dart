import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travend/pages/google_maps_page.dart';
import 'package:travend/pages/main.dart';
import 'package:travend/pages/profile_page.dart';
import 'package:travend/models/user.dart' as model;
import 'messaging_page.dart';

class TabManagement extends StatefulWidget {
  const TabManagement({Key? key}) : super(key: key);

  @override
  State<TabManagement> createState() => _TabManagementState();

  Future<model.User> getUserInfo() async {
    User currentUser = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users')
        .doc(currentUser.uid).get();

    return model.User.fromMap(snap);
  }
}

class _TabManagementState extends State<TabManagement> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // getUserData();
  }

  // getUserData() async {
  //   UserProvider _userProvider = Provider.of(context, listen: false);
  //   await _userProvider.refreshUser();
  // }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const HomePage();
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
              },
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          title: const Text("TRAVEND"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white70,
            tabs: [
              Tab(text: 'Profile', icon: Icon(Icons.person),),
              Tab(text: 'Map', icon: Icon(Icons.map),),
              Tab(text: 'Messages', icon: Icon(Icons.message),),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ProfilePage(),
            MapSample(),
            MessagingPage(),
          ],
        ),
      ),
    );
  }
}
