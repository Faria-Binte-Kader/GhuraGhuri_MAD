import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:ghuraghuri/auth_methods.dart';
import 'package:ghuraghuri/plan.dart';
import 'LocationDeatils.dart';
import 'ModelLocation.dart';
import 'PlanDetails.dart';

class PlanLocations extends StatefulWidget {
  const PlanLocations({Key? key, String? this.title, String? this.description, String? this.uid, String? this.id}) : super(key: key);
  final String? title,description,uid,id;

  @override
  _PlanLocationsState createState() => _PlanLocationsState();
}

class _PlanLocationsState extends State<PlanLocations> {
  TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  String? name, des, planid;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  Future addPlanLocation(BuildContext context) async {
    storePlanLocation(name, des, planid);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getLocationsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var locationSnapshot in _allResults) {
        var title = Modellocation.fromSnapshot(locationSnapshot)
            .locationName
            .toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(locationSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getLocationsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('Locations').get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("All Locations"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 30.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
                ),
              ),
              Container(
                  child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _resultsList.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  _resultsList[index]['Imageurl'] ??
                                      "No images",
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  color: Colors.black12,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _resultsList[index]['Name'] ?? "",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            name = _resultsList[index]['Name'];
                                            des = _resultsList[index]['Description'];
                                            planid = widget.id;
                                            addPlanLocation(context);
                                            setState(() {
                                              Fluttertoast.showToast(
                                                  msg: 'Location added',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.black87,
                                                  fontSize: 16.0);
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => PlanDetails(
                                                        title: widget.title,
                                                        description: widget.description,
                                                        uid: widget.uid,
                                                        id: widget.id)));
                                          },
                                          child: Icon(Icons.add)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          name = _resultsList[index]['Name'];
                          des = _resultsList[index]['Description'];
                          planid = widget.id;
                          addPlanLocation(context);
                          setState(() {
                            Fluttertoast.showToast(
                                msg: 'Location added',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black87,
                                fontSize: 16.0);
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Plan()));
                        }),
              )),
            ],
          ),
        ));
  }
}
