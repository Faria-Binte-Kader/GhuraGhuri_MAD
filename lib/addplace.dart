import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghuraghuri/auth_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ghuraghuri/ModelLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';


class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  Completer<GoogleMapController> _controller = Completer();
  final TextEditingController description = TextEditingController();
  final TextEditingController title = TextEditingController();
  var dir = Directory.current.path;
  late File _image;
  bool load=false;
  Future<String>? imgurl;
  final ImagePicker _picker = ImagePicker();

  List<Modellocation> locationList = [];
  List<Marker> MarkerList = [];
  List<Marker> markerss = [];
  late Marker _newMarker;

  late String  latitude='', longitude='';
  late String newlat='',newlng='';

  String dropdownvalue = '1';
  var items = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  Future getimage() async{
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery
    );
    setState(() {
      _image=File(pickedFile!.path);
      load=true;
    });
  }

  Future uploadLocationToFirebase(BuildContext context) async {
    String url;
    String fileName = _image.toString();
    firebase_storage.Reference firebaseStorageRef =
    firebase_storage.FirebaseStorage.instance.ref().child('LocationImage/$fileName');
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    uploadTask.whenComplete(() async {
      url = await firebaseStorageRef.getDownloadURL();
      storeLocation(title.text, description.text, newlat, newlng, url, dropdownvalue);
    }).catchError((onError) {
      print(onError);
    });

  }

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
      });
    });
  }


  @override
  initState()  {
    // TODO: implement initState
    fetchLocationList();
    super.initState();
  }

  static const CameraPosition _kLake = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(23.875854, 90.379547),
      // tilt: 59.440717697143555,
      zoom: 16);

  Widget _buildPopupDialog(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {return new AlertDialog(
      title: const Text('Add location'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: TextField(
              controller: title,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
            child: TextField(
              controller: description,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.edit),
                hintText: 'Type details',
              ),
            ),
          ),
          Row(
            children: [
              const Text("Rating"),
              const SizedBox(width: 20,),
              DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
            ],
          ),
          Container(
            child: load==true? Container(height:130,child: Image.file(_image)):const Text(""),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: GestureDetector(
                  onTap:  () {
                    setState((){
                      getimage();
                    });
                  },
                  child: const Icon(Icons.add_a_photo),
                ),
              ),
              GestureDetector(
                onTap:  () {
                  setState((){
                    getimage();
                  });
                },
                child: const Text("Add Photo"),),],),
        ],
      ),
      actions: <Widget>[
        new GestureDetector(
          onTap:  () {
            if(load==true){
              uploadLocationToFirebase(context);
              setState(() {
                Fluttertoast.showToast(
                    msg: 'Location added',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    fontSize: 16.0
                );
              });
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const AddPlace()),
                    );
            }
          },
          child: const Text('Post',
            style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),),),
        const SizedBox(width: 120,),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close',style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18
          )),
        ),
      ],
    );});
  }

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
              onLongPress: _createMarker,
            ),
          ),
        ],
      ),
    );
  }


  void _createMarker(LatLng pos){
    setState(() {
      newlat= pos.latitude.toString();
      newlng=pos.longitude.toString();
      _newMarker = Marker(
        markerId: const MarkerId('newMarker'),
        infoWindow: const InfoWindow(title: 'this is the new marker'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: pos,
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        }
      );
      MarkerList.add(_newMarker);
    });
  }

}