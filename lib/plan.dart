import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Plan"),
        ),
        body:
        SingleChildScrollView(
          child: Column(
            children: [
            ],
          ),
        )
    );
  }
}