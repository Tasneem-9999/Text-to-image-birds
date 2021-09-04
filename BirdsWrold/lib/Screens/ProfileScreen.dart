import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project2/model/UserModel.dart';
import 'package:project2/route_generator.dart';
import 'package:project2/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.white,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(RouteNames.MAIN_SCREEN);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Log-out",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: Colors.black),
                            onPressed: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              bool usernameDeleted =
                                  await pref.remove('username');
                              bool childNameDeleted =
                                  await pref.remove('childName');
                              bool emailDeleted = await pref.remove('email');
                              bool isLoggedDeleted =
                                  await pref.remove('isLogged');

                              if (usernameDeleted &
                                  childNameDeleted &
                                  emailDeleted &
                                  isLoggedDeleted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: CustomColors.primaryColor,
                                  content: Text("You have logged out"),
                                  duration: Duration(seconds: 3),
                                ));

                                Navigator.of(context)
                                    .pushReplacementNamed(RouteNames.LOG_IN);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'My Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontFamily: 'ink free',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: height * 0.60,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
top: 120,                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.02,
                                    left: MediaQuery.of(context).size.width *
                                        0.02),
                                child: Container(
                                  height: innerHeight * 0.75,
                                  width: innerWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CustomColors.primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Child name ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ink free',
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "${User.childName}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'ink free',
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Parent name',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'ink free',
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${User.userName}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'ink free',
                                              fontSize: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Email ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'ink free',
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${User.email}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'ink free',
                                              fontSize: 25,

                                            ),
                                        ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  child: Image.asset(
                                    'assets/ProfileScreen.png',
                                    width: innerWidth * 0.45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
