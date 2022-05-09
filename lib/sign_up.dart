
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth_methods.dart';
import 'background.dart';
import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController conpass= TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        body: isLoading? Center(
          child: Container(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        ) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30,80,30,0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child:
                  const Text("Make an account to join us!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),),
                ),
                const SizedBox(height: 20,),
                Container(
                  //height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: name,
                    focusNode: FocusNode(),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  //height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: FocusNode(),
                    controller: mail,
                    decoration: const InputDecoration(
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
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                Container(
                  //height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    controller: conpass,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    focusNode: FocusNode(),
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
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
                    controller: phone,
                    keyboardType: TextInputType.number,
                    focusNode: FocusNode(),
                    decoration: const InputDecoration(
                      labelText: "Mobile Number",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60,),
                Container(
                  height: 50,
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Colors.deepPurpleAccent,
                    color: Colors.deepPurple,
                    elevation: 8.0,
                    child: GestureDetector(
                      onTap: (){
                        if(name.text.isNotEmpty && mail.text.isNotEmpty && password.text.isNotEmpty
                            && conpass.text.isNotEmpty && phone.text.isNotEmpty)
                        {
                          if(conpass.text.toString()==password.text.toString())
                          { setState(() {
                            isLoading = true;
                          });
                          createAccount(name.text, mail.text, password.text, phone.text).then((user){
                            if(user!=null)
                            {
                              setState(() {
                                isLoading=false;
                                Fluttertoast.showToast(
                                    msg: 'Sign up succeful!',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black87,
                                    fontSize: 16.0
                                );
                              });
                              print("Sign Up Successful");
                              storeUserData(name.text, mail.text, password.text, phone.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  const BackGroundPage()),
                              );
                            }
                            else {
                              print("Login failed");
                              setState(() {
                                isLoading=false;
                                Fluttertoast.showToast(
                                    msg: 'Sign Up failed',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black87,
                                    fontSize: 16.0
                                );
                              });
                            }
                          });
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text('SIGN UP',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?  "),
                    GestureDetector(
                      onTap:  () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const MyHomePage(title: 'Login')),
                      ),
                      child: const Center(
                        child: Text('Log In!',
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
        ));
  }
}