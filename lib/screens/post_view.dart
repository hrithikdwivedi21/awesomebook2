import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funbook/screens/MainScreen.dart';
import 'package:funbook/screens/boost_post.dart';
import 'package:funbook/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import '../firebase_services/firebase_methods.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';
import '../widgets/comment_card.dart';
import '../widgets/like_animations.dart';
import '../widgets/post_card.dart';
import 'comments_screen.dart';

class PostView extends StatefulWidget {
  final snap;
  const PostView({Key? key, this.snap}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final TextEditingController commentEditingController =
      TextEditingController();

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
    setState(() {});
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentEditingController.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => MainScreen()));
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                          backgroundImage: NetworkImage(widget.snap['profImage']),
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
                                  child: Text(
                                    widget.snap['username'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        (widget.snap['uid']==user!.uid)?
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
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>PostView(snap: widget.snap,)));
                    },
                    onDoubleTap: () {
                      FirestoreMethods().likePost(
                          widget.snap['postId'].toString(),
                          user.uid,
                          widget.snap['likes'],
                          user.username,
                          widget.snap['postUrl'],
                          user.photoUrl,
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
                        isAnimating: widget.snap['likes'].contains(user.uid),
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
                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BoostPost()));
                      //   },
                      //   child: Container(
                      //     color: Colors.blueAccent,
                      //       padding: EdgeInsets.all(10),
                      //       margin: EdgeInsets.only(right: 10),
                      //       child: Text("Boost Post",style: TextStyle(color: Colors.white),),
                      //   ),
                      // )
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
            ),
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('category', isEqualTo: widget.snap["category"])
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              if (snapshot.data!.docs[index].data()['postId'] == widget.snap["postId"]) {
                return SizedBox(height: 0);
              } else {
                Map<String, dynamic> postData = snapshot.data!.docs[index].data();
                String uid = postData['uid'];

                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    Map<String, dynamic>? userData = userSnapshot.data?.data();
                    if (userData == null) {
                      // Handle the case where user data is null
                      return SizedBox(height: 0);
                    }

                    Map<String, dynamic> mergedData = {...postData, ...userData};

                    return PostCard(snap: mergedData);
                  },
                );
              }
            },
          );
        },
      ),
      ],
        ),
      ),
    );
  }
}
