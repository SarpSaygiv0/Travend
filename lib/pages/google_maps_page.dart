import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travend/models/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:travend/pages/restaurant_page.dart';


class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  // We use this url because google maps API did not function correctly even
  // though we gave the latitude and longitude information provided by geoLocator
  // So we had to give this URL with hardcoded query. But we wanted to make it
  // clear for you that we have tried the dynamic version which uses the latitude
  // and longitude values.
  String baseUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=izmir+yali+mahallesi+restoranlar/@38.4715827,27.0908244,17z&key=AIzaSyC8OZkoWb3ucJrhyFAfiTOxw8at36CmA20';

  List<Restaurant> restaurants = [];
  late Future <Position> _currentUserLocation;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _currentUserLocation = Geolocator.getCurrentPosition();
    fetchRestaurants();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: _currentUserLocation,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // The user location returned from the snapshot
                Position snapshotData = snapshot.data as Position;
                LatLng _userLocation = LatLng(snapshotData.latitude, snapshotData.longitude);
                return Scaffold(
                  body: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _userLocation,
                      zoom: 14,
                    ),
                    markers: addMarkers(_userLocation),
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Text("Show"),
                    onPressed: () {
                      setState(() {
                        uploadRestaurantsToFirestore();
                      });
                    },
                  ),
                );
              } else {
                return const Center(child: Text("Failed to get user location."));
              }
            }
            // While the connection is not in the done state yet
            return const Center(child: CircularProgressIndicator());
          });
  }

  //get restaurants from google maps API
  fetchRestaurants() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      restaurants = <Restaurant>[];
      List resMaps = json['results'];
      var counter = 0;
      for (final resMap in resMaps) {
        if (counter == 25) {
          break;
        }
        restaurants.add(Restaurant.fromMap(resMap));
        counter++;
      }
    } else {
      throw Exception("Fetching restaurants is not successful ${response.statusCode}");
    }
  }

  uploadRestaurantsToFirestore() async {
     var firestore = FirebaseFirestore.instance.collection('restaurants');
      for (final restaurant in restaurants) {
        Restaurant data = Restaurant(
            restaurant.name,
            restaurant.ID,
            restaurant.location,
            restaurant.rating,
            restaurant.address
        );

        await firestore.doc(restaurant.ID).set(data.toJson());
      }
  }

  Set<Marker> addMarkers(userLocation) {
    _markers.add(Marker(
      markerId: const MarkerId("User Location"),
      infoWindow: const InfoWindow(title: "User Location"),
      position: userLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    ));

    addRestaurantMarkers().then((value) => _markers);
    return _markers;
  }

  Future<void> addRestaurantMarkers() async {
    Map<String, dynamic> currLocation;
    LatLng restaurantLocation;
    for (final restaurant in restaurants) {
        currLocation = restaurant.location;
        restaurantLocation = LatLng(currLocation['lat'], currLocation['lng']);
        _markers.add(Marker(
            markerId: MarkerId(restaurant.ID),
            infoWindow: InfoWindow(title: restaurant.name),
            position: restaurantLocation,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RestaurantPage(restaurant: restaurant)));
            }));
    }
  }
}