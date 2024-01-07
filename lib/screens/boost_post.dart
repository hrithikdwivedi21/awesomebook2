import 'package:flutter/material.dart';

class BoostPost extends StatefulWidget {
  const BoostPost({Key? key}) : super(key: key);

  @override
  State<BoostPost> createState() => _BoostPostState();
}

class _BoostPostState extends State<BoostPost> {
  double sval = 0;
  double dval = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Boost Post"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(children: [
        Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "₹ $sval over $dval days",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            )),
        Slider(
          value: sval,
          min: 0,
          max: 10000,
          divisions: 100,
          label: "Price: $sval",
          onChanged: (double value) {
            //by default value will be range from 0-1
            setState(() {
              sval = value;
            });
          },
        ),
        Slider(
          value: dval,
          min: 0,
          max: 10,
          divisions: 10,
          label: "Days: $dval",
          onChanged: (double value) {
            //by default value will be range from 0-1
            setState(() {
              dval = value;
            });
          },
        ),
        Container(
          margin: EdgeInsets.all(25),
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Center(
              child: const Text(
                'Pay now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
          ),
        ),
      ]
      ),
    );
  }
}
