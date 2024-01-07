import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funbook/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import '../firebase_services/upload_video.dart';
class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({Key? key, required this.videoFile, required this.videoPath}) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  bool isLoading = false;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  UploadVideoController uploadVideoController = Get.put(UploadVideoController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  void nowuploadVideo(String songName, String caption, String videoPath) async{
    setState(() {
      isLoading = true;
    });
    String res = await uploadVideoController.uploadVideo(songName, caption, videoPath);
    if (res == "Success") {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Successfully Posted");
      Navigator.pop(context);
      Navigator.pop(context);

    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(height: 30,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width-20,
                    child: TextFormField(
                      controller: _songController,
                      decoration: InputDecoration(
                        hintText: "Song Name",
                        icon: Icon(Icons.music_note),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width-20,
                    child: TextFormField(
                      controller: _captionController,
                      decoration: InputDecoration(
                        hintText: "Caption",
                        icon: Icon(Icons.closed_caption),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  isLoading
                      ? const CircularProgressIndicator() :
                  ElevatedButton(
                      onPressed: () {
                        nowuploadVideo(
                        _songController.text,
                        _captionController.text,
                        widget.videoPath);
                      },
                      child:
                      Text('Share!',style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
