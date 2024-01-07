import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:funbook/providers/user_provider.dart';
import 'package:funbook/screens/MainScreen.dart';
import 'package:funbook/screens/splash_screen.dart';
import 'package:funbook/utils/colors.dart';
import 'package:funbook/utils/routes.dart';
import 'package:provider/provider.dart';
import './screens/homescreen.dart';
import './screens/login.dart';
import 'models/auth_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    await Firebase.initializeApp();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Awesome Book",
        themeMode: ThemeMode.light,
        darkTheme: ThemeData(brightness: Brightness.dark),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            color: Colors.blue,
            elevation: 0.0,
          ),
        ),
        home: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        )
            : Splash_screen(),
      ),
    );
  }
}
