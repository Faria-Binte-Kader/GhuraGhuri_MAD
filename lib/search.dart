import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'LocationDeatils.dart';
import 'ModelLocation.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
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
    return Container(
      child: Column(
        children: <Widget>[
          Text("All Locations", style: TextStyle(fontSize: 20)),
          Padding(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: _resultsList.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(
                          _resultsList[index]['Imageurl'] ?? "No images",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.black12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    String name = _resultsList[index]['Name'];
                                    String des =
                                        _resultsList[index]['Description'];
                                    String u = _resultsList[index]['Imageurl'];
                                    String lat =
                                        _resultsList[index]['Latitude'];
                                    String lng =
                                        _resultsList[index]['Longitude'];
                                    String rat = _resultsList[index]['Rating'];
                                    String typ = _resultsList[index]['Type'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LocationDetails(
                                                    name: name,
                                                    desc: des,
                                                    url: u,
                                                    latitude: lat,
                                                    longitude: lng,
                                                    rating: rat,
                                                    type: typ)));
                                  },
                                  child: Icon(Icons.arrow_right)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  String name = _resultsList[index]['Name'];
                  String des = _resultsList[index]['Description'];
                  String u = _resultsList[index]['Imageurl'];
                  String lat = _resultsList[index]['Latitude'];
                  String lng = _resultsList[index]['Longitude'];
                  String rat = _resultsList[index]['Rating'];
                  String typ = _resultsList[index]['Type'];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationDetails(
                              name: name,
                              desc: des,
                              url: u,
                              latitude: lat,
                              longitude: lng,
                              rating: rat,
                              type: typ)));
                }),
          )),
        ],
      ),
    );
  }
}
