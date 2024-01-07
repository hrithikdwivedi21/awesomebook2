import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funbook/screens/MainScreen.dart';
import 'package:funbook/screens/register.dart';
import 'package:funbook/utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_services/auth_methods.dart';
import '../utils/utils.dart';

class LoginInsta extends StatefulWidget {
  @override
  _LoginInstaState createState() => _LoginInstaState();
}

class _LoginInstaState extends State<LoginInsta> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  bool buttonClicked = false;
  int buttonColor = 0xff26A9FF;
  final _formkey = GlobalKey<FormState>();
  bool inputTextNotNull = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text.trim(), password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

 void googleLogin() async{
   String res = await AuthMethods().googleLogin();
   if (res == 'success') {
     Navigator.of(context).pushAndRemoveUntil(
         MaterialPageRoute(
           builder: (context) => MainScreen(),
         ),
             (route) => false);

   } else {
     showSnackBar(context, res);
   }
 }

  // moveToHome(BuildContext context) async {
  //   if (_formkey.currentState!.validate()) {
  //     setState(() {
  //       buttonClicked = true;
  //     });
  //     await Future.delayed(Duration(seconds: 1));
  //     await Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
  //     setState(() {
  //       buttonClicked = false;
  //     });
  //   }
  // }

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
                        height: 50.0,
                      ),
                      // Text(
                      //   "Awesome Book",
                      //   style: TextStyle(
                      //       fontSize: 45.0,
                      //       color: Colors.blue,
                      //       fontFamily: GoogleFonts.dangrek().fontFamily,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      Image.asset(
                        'assets/a.png',
                        width: 100.0,
                        height: 100.0
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
                              decoration: InputDecoration(
                                hintText: 'Email address',
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                border: InputBorder.none,
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
                              controller: _passwordController,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "This field cannot be empty";
                                } else if (value.length < 9) {
                                  return "Please enter a valid password of min length 8";
                                }
                                return null;
                              },
                              obscureText: true,
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                border: InputBorder.none,
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
                          // if (_formkey.currentState!.validate()) {
                          loginUser();
                          // }
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
                            child: !_isLoading
                                ? const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Forgot your login details? ',
                            style: TextStyle(
                              fontSize: deviseWidth * .035,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('Get help');
                            },
                            child: Text(
                              'Get help',
                              style: TextStyle(
                                fontSize: deviseWidth * .035,
                                color: Color(0xff002588),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: deviseWidth * .040,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: deviseWidth * .40,
                            color: Color(0xffA2A2A2),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                              fontSize: deviseWidth * .040,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 1,
                            width: deviseWidth * .40,
                            color: Color(0xffA2A2A2),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: deviseWidth * .040,
                      ),
                      InkWell(
                        onTap: () {
                          // if (_formkey.currentState!.validate()) {
                          googleLogin();
                          // }
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: deviseWidth * .90,
                          height: deviseWidth * .14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: !_isLoading
                                ?  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png",width: 30,),
                                    SizedBox(width: 10,),
                                    Text(
                              'Continue with Google',
                              style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                              ),
                            ),
                                  ],
                                )
                                : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              },
                              child: Text(
                                'Register',
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
