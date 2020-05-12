import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logintemplate/env/keys/keys.dart';
import 'package:logintemplate/env/routes.dart';
import 'package:logintemplate/widgets/container_with_logo.dart';
import 'package:logintemplate/widgets/delayed_animation.dart';

class FirstStartPage extends StatefulWidget {
  @override
  _FirstStartPageState createState() => _FirstStartPageState();
}

class _FirstStartPageState extends State<FirstStartPage> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;

  @override
  void initState() {

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;

    return MaterialApp(
      home: Scaffold(
          body: ContainerWithLogo(
            children: [
              DelayedAnimation(
                child:
                Text(
                  translate(Keys.First_Page_Welcome_To),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: color),
                ),
                delay: delayedAmount + 1000,
              ),
              DelayedAnimation(
                child:
                Text(
                  translate(Keys.App_Bar_Title),
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: color),
                ),
                delay: delayedAmount + 2000,
              ),
              SizedBox(
                height: 30.0,
              ),
              DelayedAnimation(
                child:
                Column(
                  children: <Widget>[
                    Text(
                      translate(Keys.First_Page_Text1),
                      style: TextStyle(fontSize: 20.0, color: color),
                    ),
                    Text(
                      translate(Keys.First_Page_Text2),
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0, color: color),
                    ),
                  ],
                ),
                delay: delayedAmount + 3000,
              ),
              SizedBox(
                height: 40.0,
              ),
              DelayedAnimation(
                child:
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      child: Transform.scale(
                        scale: _scale,
                        child: _animatedButtonUI,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    loginButton(context),
                  ],
                ),
                delay: delayedAmount + 4000,
              ),
            ],
          )

      ),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  final loginButton = (context) => FlatButton(
    onPressed: () {
      Navigator.pushNamed(context, LOGIN_ROUTE);
    },
    child: Text(
      translate(Keys.Button_Login),
      style: TextStyle(
          fontSize: 22.0,
          decoration: TextDecoration.underline,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    ),
  );

  Widget get _animatedButtonUI => Container(
    height: 60,
    width: 270,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: Colors.white,
    ),
    child: Center(
      child: Text(
        translate(Keys.Button_Sign_Up),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8185E2),
        ),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    Navigator.pushNamed(context, SIGN_UP_ROUTE);
  }
}