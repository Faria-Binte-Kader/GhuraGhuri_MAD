import 'package:cloud_firestore/cloud_firestore.dart';

class Modellocation{
  String locationName;
  String description;
  String url;
  String latitude;
  String longitude;
  String rating;
  String type;

  Modellocation(this.locationName, this.description, this.url, this.latitude, this.longitude, this.rating, this.type);

  Modellocation.fromSnapshot(DocumentSnapshot snapshot) :
        locationName = snapshot['Name'],
        description = snapshot['Description'],
        url = snapshot['Imageurl'],
        latitude = snapshot['Latitude'],
        longitude = snapshot['Longitude'],
        rating = snapshot['Rating'],
        type = snapshot['Type'];
}