import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:funbook/firebase_services/firebase_methods.dart';
import 'package:funbook/screens/image_post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';
import 'confirm_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedValue='Entertainment';

  void postImage(String uid, String username, String profImage) async{
      setState(() {
        isLoading = true;
      });
      try {
        String res = await FirestoreMethods().uploadPost(_descriptionController.text, _file!, uid, username, profImage,selectedValue!);
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          showSnackBar(
            context,
            'Posted!',
          );
          clearImage();
        } else {
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, res);
        }
      }catch(e){
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          e.toString(),
        );
      }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }


  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
              videoFile: File(video.path), videoPath: video.path,
          ),
        ),
      );
    }
  }
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  _selectvideo(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Post a video'),
          children: <Widget>[
            // SimpleDialogOption(
            //     padding: const EdgeInsets.all(20),
            //     child: const Text('Camera'),
            //     onPressed: () => pickVideo(ImageSource.gallery, context),
            // ),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () => pickVideo(ImageSource.gallery, context),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {

                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back),
              //   onPressed: () {},
              // ),
              automaticallyImplyLeading: false,
              title: Text("Add Post"),
              // centerTitle: false,
            ),
            body: Container(
              padding: EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _selectImage(context);
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(30.0),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.add_a_photo),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text('Post An Image')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectvideo(context);
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(30.0),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.video_camera_back),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text('Add a video')
                                    ],
                                  ),
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
            )
        )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  clearImage();
                },
              ),
              title: Text("Post"),
              centerTitle: false,
              // actions: [
              //   TextButton(
              //     onPressed: ()=> postImage(user.uid,user.username,user.photoUrl),
              //     child: const Text(
              //       'Post',
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18),
              //     ),
              //   )
              // ],
            ),
            body: ListView(
              children:[
                Column(
                children: [
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),

                      // CircleAvatar(
                      //   backgroundImage: NetworkImage(
                      //     user.photoUrl
                      //   ),
                      // ),



                  Stack(
                    children: [
                      _file!=null?Image(
                          image: MemoryImage(_file!)
                      ):const CircularProgressIndicator(),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: IconButton(
                          onPressed: (){
                            clearImage();
                          },
                          icon: Icon(Icons.close,color: Colors.black,),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: DropdownButtonFormField(

                      value: selectedValue,
                      onChanged: (newValue){
                        setState(() {
                          selectedValue=newValue as String;
                        });
                      },
                      items: ['Entertainment', 'Gaming', 'Bollywood','Tollywood','Politics','Food'].map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Write caption here...',
                          ),
                      maxLines: 3,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  isLoading ? const CircularProgressIndicator() :
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width * .90,
                      height: MediaQuery.of(context).size.width * .14,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                          child: TextButton(
                            onPressed: ()=> postImage(user!.uid,user.username,user.photoUrl),
                            child: Text(
                              'Post Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      ),
                    ),
                  )

                ],
              ),
                  ]
            ),
          );
  }
}
