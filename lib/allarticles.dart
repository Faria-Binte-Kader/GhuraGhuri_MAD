import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ModelArticle.dart';
import 'articleDetails.dart';

class AllArticles extends StatefulWidget {
  const AllArticles({Key? key}) : super(key: key);

  @override
  _AllArticlesState createState() => _AllArticlesState();
}

class _AllArticlesState extends State<AllArticles> {
  List<ModelArticle> articleList = [];

  fetchArticleList() async {
    String title, desc, url, uid, id;
    int like, dislike;

    FirebaseFirestore.instance
        .collection('Article')
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
    fetchArticleList();
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
                    "All Articles",
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
                                            String title = articleList[i].title;
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
                  itemCount: articleList.length,
                ),
              ),
            ]),
      ),
    );
  }

}