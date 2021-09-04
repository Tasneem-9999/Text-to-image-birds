import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project2/api/API.dart';
import 'package:project2/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../route_generator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () => {checkFirstSeen()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.width * 0.40,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Birds World",
                        style: TextStyle(
                          fontFamily: "ink free",
                          fontSize: MediaQuery.of(context).size.height * 0.050,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.18),
              child: new CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future checkFirstSeen() async {
    await API.getStories();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    bool _isLogged = (prefs.getBool('isLogged') ?? false);

    if (_seen) {
      if (_isLogged) {
        User.email = prefs.getString("email")!;
        User.userName = prefs.getString("username")!;
        User.childName = prefs.getString("childName")!;
        Navigator.of(context).pushReplacementNamed(RouteNames.MAIN_SCREEN);
      } else
        Navigator.of(context).pushReplacementNamed(RouteNames.SIGN_UP);
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacementNamed(RouteNames.ON_BOARDING_SCREEN);
    }
  }
}
