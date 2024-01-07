import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funbook/screens/video_comment_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../firebase_services/video_controller.dart';
import '../widgets/circle_animation.dart';
import '../widgets/video_player_item.dart';

class VideoPlayer extends StatefulWidget {
  final snap;
  const VideoPlayer({Key? key,required this.snap}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();

}

class _VideoPlayerState extends State<VideoPlayer> {

  final VideoController videoController = Get.put(VideoController());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text("Video"),
      ),
      body: Stack(
        children: [
          VideoPlayerItem(
            videoUrl: widget.snap['videoUrl'],
          ),
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.snap['username'],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.snap['description'],
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.music_note,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  widget.snap['songName'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(top: size.height / 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildProfile(
                            widget.snap['profImage'],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () =>
                                    videoController.likeVideo(widget.snap['postId']),
                                child:
                                // Icon(
                                //   Icons.thumb_up,
                                //   size: 40,
                                //   color: widget.snap['likes'].contains(
                                //       _auth.currentUser!.uid)
                                //       ? Colors.red
                                //       : Colors.white,
                                // ),
                                widget.snap['likes'].contains(
                                        _auth.currentUser!.uid)
                                        ? Image.asset("assets/3.png",width: 40,)
                                        : Image.asset("assets/1.png",width: 40,),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                widget.snap['likes'].length.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VideoCommentScreen(
                                            videoid: widget.snap['postId'],
                                          )));
                                },
                                child: const Icon(
                                  Icons.comment,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                widget.snap['commentCount'].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.reply,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                widget.snap['shareCount'].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          CircleAnimation(
                            child: buildMusicAlbum( widget.snap['profImage']),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
