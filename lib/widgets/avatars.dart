import 'package:flutter/material.dart';
import 'package:funbook/screens/storyimage.dart';
import 'package:funbook/widgets/storyview.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class Avatars extends StatefulWidget {
  const Avatars({Key? key}) : super(key: key);

  @override
  State<Avatars> createState() => _AvatarsState();
}

class _AvatarsState extends State<Avatars> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => StoryImage()));
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        // backgroundColor: Colors.deepOrange,
                        backgroundImage: NetworkImage(user!.photoUrl),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          child: Icon(Icons.add_circle_outline_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Your Story"),
              ],
            ),
          ),

          for(int i=1;i<10;i++)avatar(user!.uid,user!.username),
        ],
      ),
    );
  }

  Padding avatar(String uid,String username) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoryPageView(uid:uid)));
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80'),
            ),
            SizedBox(
              height: 5,
            ),
            Text(username),
          ],
        ),
      ),
    );
  }
}
