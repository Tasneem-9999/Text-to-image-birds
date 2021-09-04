import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:project2/model/UserModel.dart';
import 'package:project2/model/story.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class API extends ChangeNotifier {
  static SharedPreferences? _sharedPreferences;
  Map<String, Map<String, String>>? messages;
  static List<stroy> stories = [];

  int? index;

    static String _url = "http://192.168.43.17:5000/API/";

  static String get url => _url;

  static set url(String value) {
    _url = value;
  }

  static final API storry = new API._internal();

  API._internal();

  factory API() {
    return storry;
  }

  static Future<int> register() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var encodeBody = jsonEncode({
      "username": User.userName,
      "childName": User.childName,
      "password": User.password,
      "email": User.email
    });
    var response =
        await http.post(Uri.parse(_url + "register"), body: encodeBody);
    print(response.body);
    var decodeResponse = jsonDecode(response.body);
    if (decodeResponse["status"]["type"] == "success") {
      _sharedPreferences!.setString("username", User.userName);
      _sharedPreferences!.setString("childName", User.childName);
      _sharedPreferences!.setString("email", User.email);
      _sharedPreferences!.setBool("isLogged", true);

      return 1;
    } else if (decodeResponse["status"]["message"] == "username already taken")
      return -2;
    else if (decodeResponse["status"]["message"] == "email already taken")
      return -1;
    else
      return 0;
  }

  static Future<int> logIn(String username, String password) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var encodeBody = jsonEncode({
      "username": username,
      "password": password,
    });
    var response = await http.post(Uri.parse(_url + "login"), body: encodeBody);
    print(response.body);
    var decodeResponse = jsonDecode(response.body);
    if (decodeResponse["status"]["type"] == "success") {
      User.email = decodeResponse["data"]["user"]["email"];
      User.userName = decodeResponse["data"]["user"]["username"];
      User.childName = decodeResponse["data"]["user"]["childName"];

      _sharedPreferences!
          .setString("username", decodeResponse["data"]["user"]["username"]);
      _sharedPreferences!
          .setString("childName", decodeResponse["data"]["user"]["childName"]);
      _sharedPreferences!
          .setString("email", decodeResponse["data"]["user"]["email"]);
      _sharedPreferences!.setBool("isLogged", true);

      return 1;
    } else if (decodeResponse["status"]["message"] ==
        "Username or password incorrect")
      return -2;
    else
      return 0;
  }

  static Future<int> textClassifier(String text) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String? username = _sharedPreferences!.getString("username");

    var encodeBody = jsonEncode({
      "text": text,
      "username": username,
    });
    var response =
        await http.post(Uri.parse(_url + "textClassifier"), body: encodeBody);
    print(response.body);
    var decodeResponse = jsonDecode(response.body);
    //the word is clean
    print("****");
    if (decodeResponse["status"]["message"] == "Positive") {
      return 1;
    } else {
      return -1;
    }

    return 0;
  }

//http://192.168.1.102:5000/API/getstory?user=abdo
  static Future getStories() async {
    stories.clear();

    _sharedPreferences = await SharedPreferences.getInstance();
    String? username = _sharedPreferences!.getString("username");
    print(username);
    var response =
        await http.get(Uri.parse(_url + "getstory?user=${username}"));
    var decodeResponse = jsonDecode(response.body);
    if(!(username==null))
    for (var story in decodeResponse["status"]['data']) {
      stroy temp = new stroy();
      temp.title = story["title"];
      temp.image1 = story['array'][0]['image'];
      temp.text1 = story['array'][0]['text'];
      temp.image2 = story['array'][1]['image'];
      temp.text2 = story['array'][1]['text'];
      stories.add(temp);
    }

    return 0;
  }




  void setIndexElement(int i) {
    index = i;
  }

  String title(int i) => stories[i].title;

  String text1(int i) => stories[i].text1;

  String text2(int i) => stories[i].text2;

  String image1(int i) => stories[i].image1;

  String image2(int i) => stories[i].image2;

  int getIndexElement() => index!;
  stroy getStory(int i) => stories[i];

  List get story => stories;
}
