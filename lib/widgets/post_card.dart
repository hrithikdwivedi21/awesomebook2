import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funbook/firebase_services/firebase_methods.dart';
import 'package:funbook/screens/comments_screen.dart';
import 'package:funbook/screens/post_view.dart';
import 'package:funbook/screens/video_player.dart';
import 'package:funbook/screens/video_screen.dart';
import 'package:funbook/widgets/like_animations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/boost_post.dart';
import '../screens/profile_screen.dart';
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;

    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    if (mounted) setState((){});
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
      showSnackBar(context, "Deleted");
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['photoUrl']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: widget.snap['uid'])));
                          },
                          child:
                          Row(
                            children: [
                              Text(widget.snap['username'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                           widget.snap['is_subscribed']==true?
                              Column(
                                children: [
                                  SizedBox(width: 5),
                                  Icon(Icons.verified, color: Colors.blueAccent,size: 15,),
                                ],
                              ):SizedBox(width: 5)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
               (widget.snap['uid']==user?.uid)?
                IconButton(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          deletePost(
                                            widget.snap['postId']
                                                .toString(),
                                          );
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                                  )
                                  .toList()),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ):Container(),
              ],
            ),
          ),
         GestureDetector(
              onTap: (){
                (widget.snap['postType']=='Image')?
                Navigator.push(context,MaterialPageRoute(builder: (context)=>PostView(snap: widget.snap,)))
                :
                Navigator.push(context,MaterialPageRoute(builder: (context)=>VideoPlayer(snap: widget.snap,)));
              },
              onDoubleTap: () {
                FirestoreMethods().likePost(
                    widget.snap['postId'].toString(),
                    user!.uid,
                    widget.snap['likes'],
                    user!.username,
                    widget.snap['postUrl'],
                    user!.photoUrl,
                    widget.snap['uid'],
                  widget.snap['postType']
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children : [
                  SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      child: Image.asset("assets/1.png",width: 100,),
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                    ),
                  ),
                ]
              ),
            ),


          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user!.uid),
                child: IconButton(
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Image.asset("assets/3.png")
                        :Image.asset("assets/2.png"),
                  onPressed: () => FirestoreMethods().likePost(
                    widget.snap['postId'].toString(),
                    user.uid,
                    widget.snap['likes'],
                    user.username,
                    widget.snap['postUrl'],
                    user.photoUrl,
                      widget.snap['uid'],
                    widget.snap['postType']
                  ),
                ),
              ),
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(
                  snap: widget.snap,
                )));
              }, icon: Icon(Icons.comment_outlined)),

              IconButton(onPressed: () async{
                final uri = Uri.parse(widget.snap['postUrl']);
                final response = await http.get(uri);
                final bytes = response.bodyBytes;
                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/image.jpg';
                File(path).writeAsBytesSync(bytes);

                await Share.shareFiles([path], text: widget.snap['description'],subject: "Awesome Book ");
              }, icon: Icon(Icons.share_outlined)),
              Spacer(),
              // if(widget.snap['uid']==user.uid)
              //   GestureDetector(
              //     onTap: (){
              //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BoostPost()));
              //     },
              //     child: Container(
              //       color: Colors.blueAccent,
              //       padding: EdgeInsets.all(10),
              //       margin: EdgeInsets.only(right: 10),
              //       child: Text("Boost Post",style: TextStyle(color: Colors.white),),
              //     ),
              //   )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 3),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // Text(
                    //   '${widget.snap['username']} ',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    Expanded(
                      child: Text(
                          // widget.snap['description'].toString().length>40?widget.snap['description'].toString().substring(0,40)+'...':widget.snap['description'],
                        widget.snap['description'],
                      ),
                    ),
                  ],
                ),
                InkWell(
                    child: Container(
                      child: Text(
                        'View all $commentLen comments',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(
                        snap: widget.snap,
                      )));
                    }),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 25,
            thickness: 0.1,
            indent: 2,
            endIndent: 2,
          ),
        ],
      ),
    );
  }
}
