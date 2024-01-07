import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:funbook/firebase_services/firebase_methods.dart';
import 'package:funbook/screens/MainScreen.dart';
import 'package:funbook/screens/chatroom.dart';
import 'package:funbook/screens/editprofile.dart';
import 'package:funbook/screens/login.dart';
import 'package:funbook/screens/post_view.dart';

import 'package:uuid/uuid.dart';
import '../firebase_services/auth_methods.dart';
import '../models/chatroommodel.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo:widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );

      setState(() {
        isLoading = false;
      });
    }

  }

  String currentuser = FirebaseAuth.instance.currentUser!.uid;
  Future<ChatRoomModel?> getChatroomModel(targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${currentuser}", isEqualTo: true).where("participants.${targetUser}", isEqualTo: true).get();

    if(snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;

      // showSnackBar(context,"Chatroom already exists!");
    }
    else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: Uuid().v1(),
        lastMessage: "",
        participants: {
          widget.uid.toString(): true,
          currentuser.toString(): true,
        },
      );

      await FirebaseFirestore.instance.collection("chatrooms").doc(newChatroom.chatroomid).set(newChatroom.toMap());

      chatRoom = newChatroom;

      // showSnackBar(context,"New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {

    return isLoading == false ?
    Center(
      child: CircularProgressIndicator(), // Show indicator
    ) :Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainScreen()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(userData['username']),
            userData['is_subscribed']?
            Column(
              children: [
                SizedBox(width: 5),
                Icon(Icons.verified, color: Colors.white,size: 20,),
              ],
            ):SizedBox(width: 5)
          ],
        ),
        centerTitle: false,

      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        userData['photoUrl'],
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, "posts"),
                              buildStatColumn(followers, "followers"),
                              buildStatColumn(following, "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? Row(
                                    children: [
                                      FollowButton(
                                          text: 'Sign Out',
                                          textColor: Colors.white,
                                          borderColor: Colors.grey,
                                          function: () async {
                                            await AuthMethods().signOut();
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                     LoginInsta(),
                                              ),
                                            );
                                          }, backgroundColor: Colors.blue,
                                        ),
                                      FollowButton(
                                        text: 'Edit Profile',
                                        textColor: Colors.white,
                                        borderColor: Colors.grey,
                                        function: ()  {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfile(uid: widget.uid),
                                            ),
                                          );
                                        }, backgroundColor: Colors.blue,
                                      )
                                    ],
                                  )

                                  : isFollowing
                                      ? Row(
                                        children: [
                                          FollowButton(
                                              text: 'Unfollow',
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                await FirestoreMethods().followUser(
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid,
                                                  userData['uid'],

                                                );

                                                setState(() {
                                                  isFollowing = false;
                                                  followers--;
                                                });
                                              },
                                            ),
                                          FollowButton(
                                            text: 'Message',
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            borderColor: Colors.black,

                                            function: ()  async{
                                              // getChatroomModel(widget.uid);
                                              ChatRoomModel? chatroomModel = await getChatroomModel(widget.uid);
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatRoom(targetUser: userData, chatroom: chatroomModel,)));
                                            },
                                          ),
                                        ],
                                      )
                                      : Row(
                                        children: [
                                          FollowButton(
                                              text: 'Follow',
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              borderColor: Colors.blue,
                                              function: () async {
                                                await FirestoreMethods().followUser(
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid,
                                                  userData['uid'],


                                                );

                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              },
                                            ),
                                          FollowButton(
                                            text: 'Message',
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            borderColor: Colors.black,
                                            function: ()  async{
                                              // getChatroomModel(widget.uid);
                                              ChatRoomModel? chatroomModel = await getChatroomModel(widget.uid);
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatRoom(targetUser: userData, chatroom: chatroomModel,)));
                                            },
                                          ),
                                        ],
                                      )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Row(
                    children: [
                      Text(userData['username'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      userData['is_subscribed']?
                      Column(
                        children: [
                          SizedBox(width: 5),
                          Icon(Icons.verified, color: Colors.blueAccent,size: 15,),
                        ],
                      ):SizedBox(width: 5)
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 1,
                  ),
                  child: Text(
                    userData['bio'],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: widget.uid)
                .orderBy("datePublished",descending:true)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                  return Container(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>PostView(snap: snap,)));
                      },
                      child: Image(
                        image: NetworkImage(snap['postUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}
