import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ghuraghuri/sign_up.dart';
import 'auth_methods.dart';
import 'background.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GhuraGhuri',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primaryColor: Colors.grey,
        fontFamily: 'Montserrat',
        colorScheme: const ColorScheme.dark(),
      ),
      home: FirebaseAuth.instance.currentUser!=null? const BackGroundPage(): const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading? Center(
        child: Container(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
      ) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30,100,30,0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Text("Welcome",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50),),
                    Text("!",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 50),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Travelling made easy with Ghura Ghuri!",
                    style: TextStyle(fontSize: 18),)),
              Container(
                //height: 40,
                margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  focusNode: FocusNode(),
                  controller: mail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              Container(
                //height: 40,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  focusNode: FocusNode(),
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60,),
              Container(
                height: 50,
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.deepPurpleAccent,
                  color: Colors.deepPurple,
                  elevation: 8.0,
                  child: GestureDetector(
                    onTap:(){
                      if(mail.text.isNotEmpty && password.text.isNotEmpty)
                      {
                        setState(() {
                          isLoading = true;
                        });
                        logIn(mail.text, password.text).then((user){
                          if(user!=null)
                          {
                            setState(() {
                              isLoading=false;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  const BackGroundPage()),
                              );
                            });
                            print("Login Successful");
                          }
                          else {
                            print("Login failed");
                            setState(() {
                              isLoading=false;
                            });
                          }
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('LOGIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New here?  "),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SignUp()),
                    ),
                    child: Center(
                      child: Text('Sign Up!',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                        ),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
