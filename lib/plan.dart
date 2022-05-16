import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ModelPlan.dart';
import 'PlanDetails.dart';
import 'auth_methods.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  List<ModelPlan> planList = [];

  fetchPlanList() async {
    String title, desc, uid, id, start, end;

    FirebaseFirestore.instance
        .collection('Plans')
        .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((plan) {
        title = plan["Title"];
        desc = plan["Description"];
        uid = plan["Uid"];
        id = plan["ID"];
        start = plan["StartDate"];
        end = plan["EndDate"];
        setState(() {
          planList.add(ModelPlan(title, desc, uid, id, start, end));
        });
      });
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    fetchPlanList();
  }

  Future addPlan(BuildContext context) async {
    storePlan(title.text, description.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Plan"),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: const Text(
                          "Add a Plan!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      margin: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                      child: TextField(
                        controller: description,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 20,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.edit),
                          hintText: 'Type details',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                            addPlan(context);
                            setState(() {
                              Fluttertoast.showToast(
                                  msg: 'Plan added',
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
                                  builder: (context) => const Plan()),
                            );
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 35, 20, 0),
                    child: const Text(
                      "My Plans!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: 400,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return Container(
                        height: 70,
                        width: 300,
                        child: GestureDetector(
                          onTap: () {
                            String title = planList[i].title;
                            String description = planList[i].description;
                            String uid = planList[i].uid;
                            String id = planList[i].id;
                            String s = planList[i].startdate;
                            String e = planList[i].enddate;
                            log('pid: $id');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlanDetails(
                                        title: title,
                                        description: description,
                                        uid: uid,
                                        id: id,
                                        start: s,
                                        end: e)));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    color: Colors.black12,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                                text: planList[i].title ?? ""),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              String title = planList[i].title;
                                              /* Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  ProductDetails(name: name, quantity: q, desc: des, url: u, price: pr)));*/
                                            },
                                            child: Icon(Icons.arrow_right)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: planList.length,
                  ),
                ),
              ]),
        ));
  }
}
