import 'package:flutter/material.dart';
class StoryWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 67,
        height: 67,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9B2282),Color(0xFFEEA863)]
          )
        ),
        child: Container(

        ),
      ),
    );
  }

}