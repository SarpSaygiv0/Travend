# Travend

**About** <br/>

Travend is an application that provides users with nearby restaurants information and allows them to get
interact with each other by commenting on the restaurants. Users have to sign up first in order to use the
app. After they give the required information they are now able to use Travend’s features such as uploading
a profile picture, seeing the nearby restaurants, and commenting on them. The messaging part stayed as a
view, in order for you to see how would it look like even though it does not function. 

**How to use it**

1. Open travend app
2. Run main.dart
3. As the poject starts , the first page you'll see is starting page.This page requires you to sign in with google or sign up to the app.
4. App might require you to give permission to see get your location after you log in, allow it.
5. After you login, you are in profile page. You can upload your profile picture from your device.
6. You can switch to map section from the tab to see your location on the screen.
7. Click show button to see restaurants. 
  (We used a specific url because google maps API did not function correctly even
  though we gave the latitude and longitude information provided by geoLocator
  So we had to give this URL with hardcoded query. But we wanted to make it
  clear for you that we have tried the dynamic version which uses the latitude
  and longitude values. Therefore, you will see restaurants in given query in the link)
8. Click the markers to go to the restaurant's page.
9. You can add comment and see other's comments about the restaurant here.
10. Click message icon button to go to messaging page



**Software Versions**
  
  flutter version: 2.10.3
  dart version: 2.16.1
  
  cupertino_icons: ^1.0.2 
  
  http: ^0.13.4 <br/>
  cloud_firestore: ^3.1.17 <br/>
  firebase_core: ^1.7.0 <br/>
  firebase_auth: ^3.3.19 <br/>
  google_sign_in: ^5.2.0 <br/>
  flutter_signin_button: ^2.0.0 <br/>
  horizontal_card_pager: ^1.1.1 <br/>
  flutter_titled_container: ^1.0.7 <br/>
  flutter_rating_stars: ^1.0.3+4 <br/>
  bubble: ^1.2.1 <br/>
  image_picker: ^0.8.5+3 <br/>
  provider: ^6.0.3 <br/>
  firebase_storage: ^10.2.18 <br/>
  google_maps_flutter: ^2.1.8 <br/>
  geolocator: ^8.2.1 <br/>
  google_place: ^0.4.7 <br/>
  uuid: ^3.0.6 


**Firebase is used as a backend service**

[Video about the project](https://www.youtube.com/watch?v=rGlZkBkFjis&t=335s)
