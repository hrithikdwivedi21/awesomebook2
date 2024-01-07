import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:funbook/firebase_services/auth_methods.dart';
import 'package:funbook/screens/MainScreen.dart';
import 'package:funbook/screens/homescreen.dart';
import 'package:funbook/screens/login.dart';
import 'package:funbook/utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


import '../utils/utils.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final  _usernameController = TextEditingController();
  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();
  final  _bioController = TextEditingController();
  bool _isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Uint8List? _image;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }



  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  bool buttonClicked = false;
  final _formkey = GlobalKey<FormState>();
  bool inputTextNotNull = false;

  moveToHome(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        buttonClicked = true;
      });
      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRout);
      setState(() {
        buttonClicked = false;
      });
    }
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    if(_image!=null) {
      // signup user using our authmethodds
      String res = await AuthMethods().signUpUser(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          bio: _bioController.text.trim(),
          file: _image!);
      // if string returned is sucess, user has been created

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });

        // navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        showSnackBar(context, res);
      }
    }else{
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, "Please choose profile picture");
    }

  }

  @override
  Widget build(BuildContext context) {
    double deviseWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 90,
            ),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Register Now",
                        style: TextStyle(
                            fontSize: 35.0,
                            color: Colors.blue,
                            fontFamily: GoogleFonts.dangrek().fontFamily,
                            fontWeight: FontWeight.bold),
                      ),
                      // Image.asset(
                      //     'assets/logo.png',
                      //     width: 100.0,
                      //     height: 100.0
                      // ),
                      Stack(
                        children: [
                          _image!=null?CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!)
                          ):const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png"),
                          ),
                          Positioned(
                            bottom: -10,
                            left: 60,
                            child: IconButton(
                              onPressed: ()=>selectImage(),
                              icon: Icon(Icons.add_a_photo,color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: deviseWidth * .90,
                        height: deviseWidth * .14,
                        decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              controller: _usernameController,
                              onChanged: (text) {
                                setState(() {});
                              },
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Username',
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "This field cannot be empty";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviseWidth * .05,
                      ),
                      Container(
                        width: deviseWidth * .90,
                        height: deviseWidth * .14,
                        decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              controller: _emailController,
                              onChanged: (text) {
                                setState(() {});
                              },
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Email Address',
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "This field cannot be empty";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviseWidth * .04,
                      ),
                      Container(
                        width: deviseWidth * .90,
                        height: deviseWidth * .14,
                        decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              maxLines: 2,
                              controller: _bioController,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "This field cannot be empty";
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Your Bio',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviseWidth * .04,
                      ),
                      Container(

                        width: deviseWidth * .90,
                        height: deviseWidth * .14,
                        decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              controller: _passwordController,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "This field cannot be empty";
                                } else if (value.length < 8) {
                                  return "Please enter a valid password of min length 8";
                                }
                                return null;
                              },
                              obscureText: true,
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviseWidth * .04,
                      ),
                      InkWell(
                        onTap: () {
                          if(_formkey.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: deviseWidth * .90,
                          height: deviseWidth * .14,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: buttonClicked
                                ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )
                                : !_isLoading
                                    ? const
                                        Text(
                                          'Register',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    : const CircularProgressIndicator(
                                  color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviseWidth * .035,
                      ),
                    ],
                  ),
                  Container(
                    width: deviseWidth,
                    margin: EdgeInsets.only(bottom: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: deviseWidth,
                          height: 1,
                          color: Color(0xffA2A2A2),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginInsta()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xff00258B),
                                  fontSize: deviseWidth * .040,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
