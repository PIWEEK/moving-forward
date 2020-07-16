import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'layout.dart';
import 'resource.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Persons Moving Forward',
        // home: LayoutPage(),
        theme: ThemeData(
          textTheme: GoogleFonts.madaTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          "/": (BuildContext context) => AppLayout(),
          "/resource": (BuildContext context) => Resource(),
        },
        debugShowCheckedModeBanner: false);
  }
}
