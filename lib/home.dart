
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghuraghuri/ModelArticle.dart';
import 'package:ghuraghuri/addplace.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'auth_methods.dart';
import 'background.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController description = TextEditingController();
  final TextEditingController title = TextEditingController();
  var dir = Directory.current.path;
  late File _image;
  bool load=false;
  Future<String>? imgurl;
  final ImagePicker _picker = ImagePicker();
  List<ModelArticle> articleList = [];

  fetchArticleList() async {
    String title, desc, url;
    int like, dislike;

    FirebaseFirestore.instance.collection('Article').get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((products) {
        title=products["Title"];
        desc=products["Description"];
        url=products["Url"];
        like=products["Like"];
        dislike=products["Dislike"];
        setState(() {
          articleList.add(ModelArticle(title,  desc, like, dislike, url));
        });
      });
    });
  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    fetchArticleList();

  }


  Future getimage() async{
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery
    );
    setState(() {
      _image=File(pickedFile!.path);
      load=true;
    });

  }

  Future uploadImageToFirebase(BuildContext context) async {
    String url;
    String fileName = _image.toString();
    firebase_storage.Reference firebaseStorageRef =
    firebase_storage.FirebaseStorage.instance.ref().child('ArticleImage/$fileName');
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    uploadTask.whenComplete(() async {
      url = await firebaseStorageRef.getDownloadURL();
      storeArticle(title.text, description.text, 0, 0, url);
    }).catchError((onError) {
      print(onError);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
    mainAxisAlignment: MainAxisAlignment.start,

    children: <Widget>[
           Column(
             children: [
               Container(
                   margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                   child: const Text("Post an Article!",
                     style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, ),)),
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
               Container(
                 margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                 child: load==true? Image.file(_image):const Text(""),
               ),
               const SizedBox(height: 10,),
               Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     margin: const EdgeInsets.fromLTRB(50, 0, 5, 0),
                     child: GestureDetector(
                       onTap:  () {
                         getimage();
                       },
                       child: const Icon(Icons.add_a_photo),
                           ),
                   ),
                   GestureDetector(
                     onTap:  () {
                       getimage();
                     },
                     child: const Text("Add Photo"),),

                   Container(
                     margin: const EdgeInsets.fromLTRB(80, 0, 5, 0),
                     child: GestureDetector(
                       onTap:  () {},
                       child: const Icon(Icons.done, color:Colors.deepPurpleAccent ,),
                     ),
                   ),
                   GestureDetector(
                     onTap:  () {
                       if(load==true){
                         uploadImageToFirebase(context);
                         setState(() {
                           Fluttertoast.showToast(
                               msg: 'Article added',
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
                           MaterialPageRoute(builder: (context) =>  const BackGroundPage()),
                         );
                       }
                     },
                     child: const Text('Post',
                     style: TextStyle(
                         color: Colors.deepPurpleAccent,
                         fontWeight: FontWeight.bold,
                         fontSize: 18
                     ),),)
                 ],
               ),
             ],
           ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 35, 20, 0),
            child: const Text("Top Articles!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),)),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          height: 300,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Container(
                height: 350,
                width: 300,
                child: GestureDetector(
                  onTap: (){
                    String title= articleList[i].title;
                   /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ProductDetails(name: name, quantity: q, desc: des, url: u, price: pr)));*/},
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 230,
                            child: Image.network(articleList[i].url ?? "No images",
                              fit: BoxFit.cover,),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            color: Colors.black12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                        text: articleList[i].title ?? ""),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      String title= articleList[i].title;
                                     /* Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  ProductDetails(name: name, quantity: q, desc: des, url: u, price: pr)));*/},
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
    ]
          ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPlace()));
        },
        // tooltip: 'Increment',
        child: const Icon(Icons.add_location),
      ),
    );
  }
}