import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String name;
  String ID;
  Map<String, dynamic> location;
  dynamic rating;
  String address;

  Restaurant(
    this.name,
    this.ID,
    this.location,
    this.rating,
    this.address,
  );

  //This is for API json
  factory Restaurant.fromMap(Map<String, dynamic> json) {
    return Restaurant(
      json['name'],
      json['place_id'],
      json['geometry']['location'],
      json['rating'],
      json['formatted_address'],
    );
  }

   Restaurant fromFirebase(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Restaurant(
      snapshot['name'],
      snapshot['ID'],
      snapshot['location'],
      snapshot['rating'],
      snapshot['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "ID": ID,
      "location": location,
      "rating": rating,
      "address": address,
    };
  }

}