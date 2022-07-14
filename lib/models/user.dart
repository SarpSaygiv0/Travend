import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String uid;
  String email;
  String about;
  int age;
  String gender;
  String photoUrl;
  List followers;
  List following;

  User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.about,
      required this.age,
      required this.gender,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "uid": uid,
      "email": email,
      "about": about,
      "age": age,
      "gender": gender,
      "photoUrl": photoUrl,
      "followers": followers,
      "following": following
    };
  }

  static User fromMap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      about: snapshot['about'],
      age: snapshot['age'],
      gender: snapshot['gender'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
