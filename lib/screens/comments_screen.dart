import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase_services/firebase_methods.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final TextEditingController commentEditingController =
  TextEditingController();

  // void postComment(String uid, String name, String profilePic) async {
  //   try {
  //     String res = await FirestoreMethods().postComment(
  //       widget.snap['postId'],
  //       commentEditingController.text,
  //       uid,
  //       name,
  //       profilePic,
  //     );
  //
  //     if (res != 'success') {
  //       showSnackBar(context, res);
  //     }
  //     setState(() {
  //       commentEditingController.text = "";
  //     });
  //   } catch (err) {
  //     showSnackBar(
  //       context,
  //       err.toString(),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished',descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),

      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  await FirestoreMethods().postComment(widget.snap['postId'], commentEditingController.text, user.uid, user.username, user.photoUrl,widget.snap['postUrl'],widget.snap['uid']);
                  setState(() {
                    commentEditingController.text="";
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
