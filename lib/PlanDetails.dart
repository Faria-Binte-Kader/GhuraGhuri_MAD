import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanDetails extends StatefulWidget {
  const PlanDetails({Key? key, String? this.title, String? this.description, this.uid,}) : super(key: key);
  final String? title,description,uid;

  @override
  _PlanDetailsState createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Plan Details"),
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
                                    child: Text(widget.title ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              width: 320,
                              child: Text(widget.description ?? "",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                ),),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}