import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funbook/screens/add_post.dart';
import 'package:funbook/screens/feedscreen.dart';
import 'package:funbook/screens/image_post.dart';
import 'package:funbook/screens/profile_screen.dart';
import 'package:funbook/screens/search_screen.dart';
import 'package:funbook/screens/video_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'notifications_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _page = 0;
  late PageController pageController; // for tabs animation


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUsername();
    addData();
    pageController = PageController();
  }

  addData() async {
    UserProvider _userProvider =
    Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  // Future<Object?> getUsername() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   return snap.data();
  // }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    // String data = getUsername().toString();
    return Scaffold(
      // drawer: DrawerWidget(),

      body:PageView(
       children: [
         FeedScreen(),
         SearchScreen(),
         AddPostScreen(),
         VideoScreen(),
         Notifications(),
         ProfileScreen(uid: user.uid),
       ],
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30.0,
                color: (_page == 0) ? Colors.yellow : Colors.white,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30.0,
                color: (_page == 1) ? Colors.yellow : Colors.white,
              ),
              label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: 30.0,
                color: (_page == 2) ? Colors.yellow : Colors.white,
              ),
              label: "Add Post"),

          BottomNavigationBarItem(

              icon:

              (_page == 3) ?
              Image.asset("assets/5.png",width: 30,)
              :Image.asset("assets/8.png",width: 30,),
              label: "Videos"),
          BottomNavigationBarItem(
              icon: (_page == 4) ?
              Image.asset("assets/4.png",width: 30,)
                  :Image.asset("assets/1.png",width: 30,),
              label: "Likes"
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30.0,
                color: (_page == 5) ? Colors.yellow : Colors.white,
              ),
              label: "Profile"),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
