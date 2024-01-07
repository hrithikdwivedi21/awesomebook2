import 'package:flutter/material.dart';
import 'package:funbook/utils/colors.dart';

class BottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BottomAppBar(
      child: BottomNavigationBar(
        backgroundColor: Colors.blue,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30.0,
                // color: (_page == 0) ? primaryColor : secondaryColor,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30.0,

              ),
              label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: 30.0,
              ),
              label: "Add Post"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border_outlined,
                size: 30.0,
              ),
              label: "Likes"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30.0,
              ),
              label: "Profile"),
        ],

      ),
    );
  }
}
