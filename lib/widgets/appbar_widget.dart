import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Icon(
        Icons.camera_alt_outlined,
        size: 34.0,
      ),
      title: Text(
        "Funbook",
        style: TextStyle(
            fontFamily: GoogleFonts.dangrek().fontFamily,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            size: 34.0,
          ),
          onPressed: () => debugPrint("search"),
        ),
        IconButton(
          icon: Icon(
            Icons.message_rounded,
            size: 34.0,
          ),
          onPressed: () => debugPrint("Chats"),
        ),
      ],
    );
  }

}