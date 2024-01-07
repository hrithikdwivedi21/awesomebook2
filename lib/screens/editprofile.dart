import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funbook/screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../firebase_services/auth_methods.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';
import 'MainScreen.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}



class _EditProfileState extends State<EditProfile> {
  final  _usernameController = TextEditingController();
  final  _emailController = TextEditingController();
  final  _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;


  // var userData = {};

  @override
  void initState() {
    super.initState();
    // getData();
  }
  //
  // getData() async {
  //
  //     var userSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.uid)
  //         .get();
  //
  //     userData = userSnap.data()!;
  //     _usernameController.text=userData['username'];
  //     _emailController.text=userData['email'];
  //     _bioController.text=userData['bio'];
  //     // print(userData['username']);
  // }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  bool buttonClicked = false;

  void updateuser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res;
    if(_image!=null) {
      // signup user using our authmethodds
       res = await AuthMethods().updateUser(
          username: _usernameController.text.trim(),
          bio: _bioController.text.trim(),
          file: _image!
      );
    }else{
      // signup user using our authmethodds
       res = await AuthMethods().updateUserdata(
          username: _usernameController.text.trim(),
          bio: _bioController.text.trim(),
      );
    }

      // if string returned is success, user has been created
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

      showSnackBar(context, "Profile updated successfully");


  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    _usernameController.text=user!.username;
    _emailController.text=user.email;
    _bioController.text=user.bio;
    double deviseWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Edit profile'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen( uid: FirebaseAuth.instance.currentUser!.uid)));
        },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),

                  // Image.asset(
                  //     'assets/logo.png',
                  //     width: 100.0,
                  //     height: 100.0
                  // ),
                  Stack(
                    children: [
                      _image!=null?
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_image!)):
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.photoUrl),
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
                          readOnly:true,
                          controller: _emailController,

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

                  InkWell(
                    onTap: () {
                      updateuser();
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
                          'Update',
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

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
