import 'dart:async';

import 'package:flutter/material.dart';
class DemoStory extends StatefulWidget {
  const DemoStory({Key? key}) : super(key: key);

  @override
  State<DemoStory> createState() => _DemoStoryState();
}

class _DemoStoryState extends State<DemoStory> {

  late Timer _timer;
  int _start = 3;
  bool loading = true;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            setState(() {
              loading = false;
            });
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }


  @override
  void initState() {
    startTimer();
    super.initState();
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: loading==false?Text("Hey"):CircularProgressIndicator(),
      ),
    );
  }
}
