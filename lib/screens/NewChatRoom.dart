import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funbook/screens/profile_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../models/UserModel.dart';
import '../models/chatroommodel.dart';
import '../models/messagemodel.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;

  const ChatRoomPage({Key? key, required this.targetUser, required this.chatroom}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController messageController = TextEditingController();

  static void navigateTo(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: Uuid().v1(),
          sender: widget.targetUser.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false,
           url : '', islocation: '0',
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());


    }
  }

  void sendLocation() async {
    String msg = "Live location";
    String url = "https://www.google.com/maps/search/?api=1&query=23.047023,80.208123&mode=d";
    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: Uuid().v1(),
          sender: widget.targetUser.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false,
          url : url, islocation: '1',
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());


    }
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);

      String msg = "Live location";
      String url = "https://www.google.com/maps/search/?api=1&query=${_currentPosition?.latitude},${_currentPosition?.longitude}&mode=d";
      if(msg != "") {
        // Send Message
        MessageModel newMessage = MessageModel(
          messageid: Uuid().v1(),
          sender: widget.targetUser.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false,
          url : url, islocation: '1',
        );

        FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

        widget.chatroom.lastMessage = msg;
        FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());


      }

    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: widget.targetUser.uid.toString())));

          },
          child: Row(
            children: [

              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(widget.targetUser.photoUrl.toString()),
              ),

              SizedBox(width: 10,),
              Text(widget.targetUser.username.toString()),

            ],
          ),
        ),

        actions: [
          IconButton(
            icon: Image.asset('assets/location.png'),
            onPressed: () {
              // sendLocation();
              _getCurrentPosition();
              // navigateTo(23.047023, 80.208123);
            },
          ),
        ],
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // This is where the chats will go
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
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
                                mainAxisAlignment: (currentMessage.sender == widget.targetUser.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                                        color: (currentMessage.sender == widget.targetUser.uid) ? Colors.grey : Theme.of(context).colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child:
                                      currentMessage.islocation!='1'?
                                      Text(
                                        currentMessage.text.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ):
                                          GestureDetector(
                                            onTap: (){
                                              navigateTo(currentMessage.url.toString());
                                            },
                                            child: Text(
                                              currentMessage.text.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary,),
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