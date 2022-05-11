import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghuraghuri/ModelLocation.dart';

import 'PlanLocations.dart';

class PlanDetails extends StatefulWidget {
  const PlanDetails(
      {Key? key,
      String? this.title,
      String? this.description,
      String? this.uid,
      String? this.id})
      : super(key: key);
  final String? title, description, uid, id;

  @override
  _PlanDetailsState createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  List<Modellocation> _resultsList = [];

  fetchPlanLocationList() async {
    String title, desc, uid, id;

    FirebaseFirestore.instance
        .collection('PlanLocation')
        .where("Planid", isEqualTo: widget.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((planlocation) {
        title = planlocation["Title"];
        desc = planlocation["Description"];
        uid = planlocation["Uid"];
        id = planlocation["ID"];
        setState(() {
          _resultsList.add(Modellocation(title, desc, "", "", "", "", ""));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Plan Details"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                  Container(
                                    width: 330,
                                    child: Text(
                                      widget.title ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              width: 320,
                              child: Text(
                                widget.description ?? "",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.add,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //String? id = widget.id;
                      log('planid: ${widget.id}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlanLocations(
                                  title: widget.title,
                                  description: widget.description,
                                  uid: widget.uid,
                                  id: widget.id)));
                    },
                    child: const Text(
                      'Add Location',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      itemCount: _resultsList.length,
                      itemBuilder: (context, index) => Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15),
                                        text: _resultsList[index].locationName ?? ""),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15),
                                        text: _resultsList[index].description ?? ""),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
