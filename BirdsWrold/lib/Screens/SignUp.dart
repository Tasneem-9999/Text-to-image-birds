import 'package:flutter/material.dart';
import 'package:project2/api/API.dart';
import 'package:project2/model/UserModel.dart';
import 'package:project2/route_generator.dart';
import 'package:project2/CustomWidgets/CustomDialog.dart';
import 'package:project2/utils/styles.dart';
import 'LoginPage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  final regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            validator: (test) {
                              if (test!.isEmpty)
                                return "Please enter Email";
                              else {
                                if (regExp.hasMatch(test) == false)
                                  return "Please enter valid Email";

                                User.email = test;
                              }
                              setState(() {});
                            },
                            style: TextStyle(fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.0),
                                ),
                                hintText: 'Your Email',
                                labelText: 'Your Email',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            validator: (test) {
                              if (test!.isEmpty)
                                return "Please enter UserName";
                              else
                                User.userName = test;
                            },
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.0),
                                ),
                                hintText: 'User Name',
                                labelText: 'User Name',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            validator: (test) {
                              if (test!.isEmpty)
                                return "Please enter Child name";
                              else
                                User.childName = test;
                            },
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.0),
                                ),
                                hintText: 'Child Name',
                                labelText: 'Child Name',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            validator: (test) {
                              if (test!.isEmpty)
                                return "Please enter Password";
                              else
                                User.password = test;
                            },
                            obscureText: true,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.0),
                                ),
                                hintText: 'Password',
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: RawMaterialButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          int state = await API.register();
                          //Done
                          if (state == 1) {
                            Navigator.of(context)
                                .pushReplacementNamed(RouteNames.MAIN_SCREEN);
                            print("done");
                          }
                          //email already taken
                          else if (state == -1) {
                            CustomDialog.showAlertDialog(
                                context,
                                "Sign-UP Error",
                                Text("Email already taken"),
                                TextButton(
                                  child: Text("Ok"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ));
                          }
                          //username already taken
                          else if (state == -2) {
                            CustomDialog.showAlertDialog(
                                context,
                                "Sign-UP Error",
                                Text(
                                  "Username already taken",
                                ),
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ));
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                      elevation: 6.0,
                      fillColor: CustomColors.primaryColor,
                      shape: StadiumBorder(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Or sign up with Social account',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 155.0,
                        child: MaterialButton(
                          color: CustomColors.primaryColor,
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.facebook,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'FACEBOOK',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          shape: StadiumBorder(),
                        ),
                      ),
                      Container(
                        width: 155,
                        child: MaterialButton(
                          color: CustomColors.primaryColor,
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.android,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Google',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          shape: StadiumBorder(),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Do you have an account ?',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, RouteNames.LOG_IN);
                          },
                          child: Text(
                            'Log in',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: CustomColors.primaryColor,
                                color: CustomColors.primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'By signing up you agree to our ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Terms of Use',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: CustomColors.primaryColor,
                                color: CustomColors.primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'and ',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: CustomColors.primaryColor,
                              color: CustomColors.primaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
