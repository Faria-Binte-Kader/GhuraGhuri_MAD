import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghuraghuri/auth_methods.dart';
import 'package:ghuraghuri/profile.dart';

import 'ModelArticle.dart';
import 'articleDetails.dart';

class MyArticles extends StatefulWidget {
  const MyArticles({Key? key}) : super(key: key);

  @override
  _MyArticlesState createState() => _MyArticlesState();
}

class _MyArticlesState extends State<MyArticles> {
  List<ModelArticle> articleList = [];

  fetchMyArticleList() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String uid = firebaseAuth.currentUser!.uid.toString();
    String title, desc, url, id;
    int like, dislike;

    FirebaseFirestore.instance
        .collection('Article')
        .where("Uid", isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((products) {
        title = products["Title"];
        desc = products["Description"];
        url = products["Url"];
        like = products["Like"];
        dislike = products["Dislike"];
        uid = products["Uid"];
        id = products["ID"];
        setState(() {
          articleList
              .add(ModelArticle(title, desc, like, dislike, url, uid, id));
        });
      });
    });
  }

  @override
  initState() {
    // TODO: implement initState
    fetchMyArticleList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GhuraGhuri"),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: const Text(
                    "My Articles",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          String title = articleList[i].title;
                          String description = articleList[i].description;
                          String uid = articleList[i].uid;
                          String url = articleList[i].url;
                          int like = articleList[i].like;
                          int dislike = articleList[i].dislike;
                          String id = articleList[i].id;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticleDetails(
                                      title: title,
                                      description: description,
                                      like: like,
                                      dislike: dislike,
                                      url: url,
                                      uid: uid,
                                      id: id)));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 230,
                                  child: Image.network(
                                    articleList[i].url ?? "No images",
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                                              text: articleList[i].title ?? ""),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            String aid = articleList[i].id;
                                            deleteArticle(aid);
                                            Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  Profile()));
                                          },
                                          child: Icon(Icons.delete)),
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
                  itemCount: articleList.length,
                ),
              ),
            ]),
      ),
    );
  }

}