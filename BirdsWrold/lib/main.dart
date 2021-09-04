import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api/API.dart';
import 'route_generator.dart';

void main() {
  runApp(
      ChangeNotifierProvider(create: (_) => API(),child:MyApp(),

      ));
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birds World',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RouteNames.SPLASH_SCREEN,
    );
  }
}
