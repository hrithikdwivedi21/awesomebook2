import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final String title;
  const RoundButton({Key? key , required this.title}) : super(key: key);

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  String get title => '';


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(title),
      ),
    );
  }
}
