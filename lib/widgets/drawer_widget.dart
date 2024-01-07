import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class DrawerWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final profileUrl="https://pbs.twimg.com/media/Dq-xHcgUwAAAqRQ?format=jpg&name=large";
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountEmail: Text("hrdtech.in@gmail.com"),
                accountName: Text("Hrdtech"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(profileUrl),
                ),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.home,color: Colors.black,),
            title: Text("Home"),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.search,color: Colors.black,),
            title: Text("Search User"),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.person,color: Colors.black,),
            title: Text("Members"),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.creditcard,color: Colors.black,),
            title: Text("Payments"),
          ),
        ],
      ),
    );

  }

}