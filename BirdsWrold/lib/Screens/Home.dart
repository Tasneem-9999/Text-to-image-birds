import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project2/CustomWidgets/StoryCard.dart';
import 'package:project2/api/API.dart';
import 'package:project2/model/UserModel.dart';
import 'package:project2/CustomWidgets/CustomDialog.dart';
import 'package:project2/route_generator.dart';
import 'package:project2/utils/styles.dart';
import 'package:provider/provider.dart';

import 'ProfileScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formkey = GlobalKey<FormState>();

  String? text;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
          child: ListView(
        // Important: Remove any padding from the ListView.
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Welcome ${User.childName}',
              style: TextStyle(
                fontFamily: "ink free",
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: CustomColors.primaryColor,
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                Text(
                  "Home",
                  style: TextStyle(
                      fontFamily: "ink free",
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                      fontFamily: "ink free",
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                )
              ],
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              // Update the state of the app.
              // ...
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: Text(
          "Birds World",
          style: CustomTextStyles.appBarText,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Consumer<API>(builder: (context, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.story.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteNames.DETAILS_SCREEN);
                          model.setIndexElement(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.15,
                              left: MediaQuery.of(context).size.width * 0.10,
                              right: MediaQuery.of(context).size.width * 0.10),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: StoryCard(
                              title: model.title(index),
                              imagePath: "${API.url}down?path=" +
                                  model.getStory(index).image1,
                            ),
                          ),
                        ),
                      );
                    })),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.primaryColor,
        onPressed: () {
          CustomDialog.showAlertDialog(
              context,
              "Add a story ",
              Form(
                key: _formkey,
                child: TextFormField(
                    validator: (test) {
                      if (test!.isEmpty)
                        return "Please enter bird Specifications";
                      else
                        text = test;
                    },
                    style: TextStyle(fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.primaryColor, width: 1.0),
                        ),
                        hintText: 'add Bird specification',
                        hintStyle: TextStyle(fontWeight: FontWeight.w200),
                        labelText: 'New Story',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black))),
              ),
              TextButton(
                child: Text("Submit"),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    CustomDialog.showIndicator(
                        context,
                        "Generating story..",
                        CircularProgressIndicator(
                          color: CustomColors.primaryColor,
                        ),
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                        ));
                    int s = await API.textClassifier(text!);
                    if (s == 1) {
                      await API.getStories();

                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    } else if (s == -1) {
                      CustomDialog.showAlertDialog(
                          context,
                          "Text is awful",
                          Text("the text you enter is awful.\n"),
                          TextButton(
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ));
                    }
                  }
                },
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
