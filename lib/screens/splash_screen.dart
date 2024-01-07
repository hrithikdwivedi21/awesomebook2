import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase_services/splash_services.dart';
class Splash_screen extends StatefulWidget {
  const Splash_screen({Key? key}) : super(key: key);

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  SplashService splashService = SplashService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        // Text(
        //   "Awesome Book",
        //   style: TextStyle(
        //     color: Colors.blue,
        //     fontFamily: GoogleFonts.dangrek().fontFamily,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 40.0,
        //   ),
        // ),
        Image.asset(
            'assets/logo.png',
            width: 100.0,
            height: 100.0
        ),
      ),
    );
  }
}
