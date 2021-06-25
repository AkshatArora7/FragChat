import 'package:flutter/material.dart';
import 'package:fragchat/helper/authenticate.dart';
import 'package:fragchat/helper/helperfunction.dart';
import 'package:fragchat/screens/dms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
    setState(() {
      userIsLoggedIn = value;
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFFFF7043),
          scaffoldBackgroundColor: Color(0xFF37474F),
        ),
        debugShowCheckedModeBanner: false,
        home: userIsLoggedIn != null
            ? userIsLoggedIn ? ChatRoom() : Authenticate()
            : Container(
                child: Center(
                  child: Authenticate(),
                ),
              ));
  }
}
