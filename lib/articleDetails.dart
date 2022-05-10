import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleDetails extends StatefulWidget {
  const ArticleDetails({Key? key, String? this.title, String? this.description, int? this.like, int? this.dislike, String? this.url, String? this.uid, String? this.id}) : super(key: key);
  final String? title,description,url,uid,id;
  final int? like,dislike;

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  late String name="";
  late int like = 0;
  late int dislike = 0;


  fetchUserById() async {
    String nam;

    FirebaseFirestore.instance.collection('Users')
        .where('Uid', isEqualTo: widget.uid).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((products) {
        nam=products["Name"];
        setState(() {
          name=nam;
        });
      });
    });
  }

  fetchArticleInfo() async{
    int lik, dislik;
    FirebaseFirestore.instance.collection('Article')
        .where('Title', isEqualTo: widget.title).get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((products) {
        lik=products["Like"];
        dislik= products["Dislike"];
        setState(() {
          like=lik;
          dislike=dislik;
        });
      });
    });
  }

  increaseLike() async{
    int lik = like+1;
    FirebaseFirestore.instance
        .collection('Article')
        .doc(widget.id)
        .update({'Like': lik})
        .then((value) => print("Article Updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }

  increaseDislike() async{
    int dislik = dislike+1;
    FirebaseFirestore.instance
        .collection('Article')
        .doc(widget.id)
        .update({'Dislike': dislik})
        .then((value) => print("Article Updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    fetchUserById();
    fetchArticleInfo();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Details"),
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
                            Text(name ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),),
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                   onTap:  () {
                                     increaseLike();
                                    /* Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) =>  ArticleDetails(title: widget.title, description: widget.description, like: like, dislike: dislike, url: widget.url, uid: widget.uid, id: widget.id)));*/
                                   },
                                   child: const Icon(Icons.thumb_up_alt_rounded, color:Colors.white ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(like.toString() ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  const SizedBox(width: 30,),
                                  GestureDetector(
                                    onTap:  () {
                                      increaseDislike();
                                    },
                                    child: const Icon(Icons.thumb_down_alt_rounded, color:Colors.white ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(dislike.toString() ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                ],
                              ),
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