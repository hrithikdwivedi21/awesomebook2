import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funbook/models/chatroommodel.dart';
import 'package:funbook/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../models/messagemodel.dart';

class ChatRoom extends StatefulWidget {
  final targetUser;
  final ChatRoomModel? chatroom;
  const ChatRoom({Key? key,required this.targetUser, required this.chatroom}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: Uuid().v1(),
          sender: widget.targetUser['uid'],
          createdon: DateTime.now(),
          text: msg,
          seen: false,
          url : '', islocation: '0',
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom?.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());


      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom?.chatroomid).update({'lastmessage':msg});

      // showSnackBar(context,"Message Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.targetUser['photoUrl']),

            ),
            SizedBox(width: 10,),
            Text(widget.targetUser['username']),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom?.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.active) {
                        if(snapshot.hasData) {
                          QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: (currentMessage.sender == widget.targetUser['uid']) ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender == widget.targetUser['uid']) ? Colors.grey : Theme.of(context).colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else if(snapshot.hasError) {
                          return Center(
                            child: Text("An error occured! Please check your internet connection."),
                          );
                        }
                        else {
                          return Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      }
                      else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5
                ),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter message"

                          ),
                        )
                    ),
                    IconButton(onPressed: (){
                      sendMessage();
                    },
                        icon: Icon(Icons.send,color: Colors.blue,))
                  ],
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
