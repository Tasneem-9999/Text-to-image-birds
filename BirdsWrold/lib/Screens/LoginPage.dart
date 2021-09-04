import 'package:flutter/material.dart';
import 'package:project2/api/API.dart';
import 'package:project2/model/UserModel.dart';
import 'package:project2/CustomWidgets/CustomDialog.dart';
import 'package:project2/utils/styles.dart';
import '../route_generator.dart';
import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  String? _password;
  String? _username;

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
                      bottom: MediaQuery.of(context).size.height * 0.05),
                  child: Text(
                    'Log In',
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
                            else
                              _username = test;
                          },
                          cursorColor: CustomColors.primaryColor,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.primaryColor,
                                    width: 1.0),
                              ),
                              hintText: 'Your Username',
                              labelText: 'Your Username',
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
                              _password = test;
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
                        int state = await API.logIn(_username!, _password!);
                        if (state == 1)
                          Navigator.of(context)
                              .pushReplacementNamed(RouteNames.MAIN_SCREEN);
                        //Username or password incorrect
                        else if (state == -2)
                          CustomDialog.showAlertDialog(
                              context,
                              "Sing-In Error",
                              Text("Username or password incorrect"),
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Log In',
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
                        'Or Log in with Social account',
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
                        'Don\'t have an account ?',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, RouteNames.SIGN_UP);
                        },
                        child: Text(
                          'Sign Up',
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
              ],
            ),
          ),
        ),
      )),
    );
  }
}
