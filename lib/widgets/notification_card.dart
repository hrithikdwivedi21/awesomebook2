import 'package:flutter/material.dart';
import 'package:funbook/screens/profile_screen.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatefulWidget {
  final snap;
  const NotificationCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: widget.snap['uid'])));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profilePic']),
              radius: 18,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
                        ),
                        TextSpan(
                            text: widget.snap['type']=='like'?' liked your photo':' commented on your photo',
                            style: TextStyle(
                                color: Colors.black
                            )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['timestamp'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400,),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Image.network(widget.snap['postUrl'],width: 40.0,),
          )
        ],
      ),
    );
  }
}