import 'dart:async';

import 'package:ghuraghuri/ModelLocation.dart';
import 'package:ghuraghuri/auth_methods.dart';
import 'package:ghuraghuri/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'addplace.dart';

class LocationDetails extends StatefulWidget {
  LocationDetails({Key? key, required this.name, String? this.desc, String? this.url, required this.latitude, required this.longitude, String? this.rating, String? this.type}) : super(key: key);
  final String? desc,url,rating,type;
  final String latitude, longitude, name;
  @override
  _LocationDetailsState createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {

  Completer<GoogleMapController> _controller = Completer();
  bool isPressed = false;
   List<Marker> markers = [];

   initialize(){
     setState(() {
        Marker marker1 = Marker(
           markerId: MarkerId(widget.name),
           infoWindow: InfoWindow(title: widget.name),
           icon: BitmapDescriptor.defaultMarker,
           position: LatLng(double.parse(widget.latitude), double.parse(widget.longitude))
       );

       markers.add(marker1);
     });
   }

  @override
  initState()  {
    // TODO: implement initState
    initialize();
    super.initState();
  }

  Widget _getMap() {
    return Container(
      height: 400,
      child: GoogleMap(
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        markers: markers.map((e) => e).toSet(),
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        // onLongPress: _createMarker,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text("Location Details"),
        ),
        body:
        SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(widget.url ?? "No images",
                        fit: BoxFit.cover,),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.black12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Name: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  Text(widget.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  /*GestureDetector(
                                        onTap: (){},
                                        child: Icon(Icons.arrow_right)),*/
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text("Description: ",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 320,
                                    child: Text(widget.desc ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                  /*GestureDetector(
                                        onTap: (){},
                                        child: Icon(Icons.arrow_right)),*/
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Rating: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  Text(widget.rating ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Type: ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  Text(widget.type ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  /*GestureDetector(
                                        onTap: (){},
                                        child: Icon(Icons.arrow_right)),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    isPressed? _getMap(): Container()],

                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          setState(() {
            if(isPressed) isPressed=false;
            else isPressed=true;
          });
        },
        // tooltip: 'Increment',
        child: isPressed? const Icon(Icons.backspace_outlined): const Icon(Icons.location_searching),
      )
    );
  }
}