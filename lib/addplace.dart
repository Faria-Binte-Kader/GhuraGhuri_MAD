import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ghuraghuri/ModelMarker';
import 'package:ghuraghuri/ModelLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;


class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  Completer<GoogleMapController> _controller = Completer();

  List<Modellocation> locationList = [];
  List<Marker> MarkerList = [];
  List<Marker> markerss = [];

  late String  latitude='', longitude='';

  fetchLocationList() async {
    String locationName, description, url, rating, type;

    FirebaseFirestore.instance.collection('Locations').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((products) {
        locationName=products["Name"];
        description=products["Description"];
        url=products["Imageurl"];
        latitude=products["Latitude"];
        longitude=products["Longitude"];
        rating=products["Rating"];
        type=products["Type"];
        setState(() {
          LatLng pos = new LatLng(double.parse(latitude), double.parse(longitude));
          locationList.add(Modellocation(locationName,  description, url, latitude, longitude, rating, type));
          MarkerList.add(Marker(
              markerId: MarkerId(locationName),
              infoWindow: InfoWindow(title: locationName,
              ),
              position: pos,
              icon: BitmapDescriptor.defaultMarker
          ));

        });
        dev.log('$LatLng',
          name: 'latlang'
        );
      });
    });
  }

  initialize(){
    setState(() {
      const Marker marker1 = Marker(
        markerId: MarkerId('_kGooglePLex'),
        infoWindow: InfoWindow(title: 'Google Plex'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(23.875854, 90.379547)
      );

      markerss.add(marker1);
     });
  }

  @override
  initState()  {
    // TODO: implement initState
    initialize();
    fetchLocationList();
    super.initState();
  }

  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746);

  /*static const Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId('_kGooglePLex'),
    infoWindow: InfoWindow(title: 'Google Plex'),
    // icon: BitmapDescriptor.defaultMarker,
    position: LatLng(23.8711, 90.3732)
  );
*/
  static const CameraPosition _kLake = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(23.875854, 90.379547),
      // tilt: 59.440717697143555,
      zoom: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: MarkerList.map((e) => e).toSet(),
              initialCameraPosition: _kLake,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              // onLongPress: _createMarker,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goTo,
        label: Text('Uttara!!'),
        icon: Icon(Icons.directions_car),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _goTo() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}