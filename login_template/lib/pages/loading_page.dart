import 'package:flutter/material.dart';
import 'package:logintemplate/env/routes.dart';
import 'package:logintemplate/env/session_utils.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  bool loaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    precacheImage(AssetImage("assets/images/logo.jpg"), context);
    precacheImage(AssetImage("assets/images/background.jpg"), context).then((val) {
      setState(() {
        loaded = true;
      });
    });

    if(loaded) {
      isLogged().then((val) {
        if(val)
          Navigator.pushNamedAndRemoveUntil(context, LOGIN_SUCCESS_ROUTE, (Route<dynamic> route) => false);
        else
          Navigator.pushNamedAndRemoveUntil(context, MAIN_ROUTE, (Route<dynamic> route) => false);
      });
    }

    return Container(
        decoration: BoxDecoration(
//          color: Color(0xdd0872),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green,Colors.white,Color(0xffe20a6f)])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator()
          ],
        )
    );
  }
}