import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logintemplate/env/keys/keys.dart';
import 'package:logintemplate/env/session_utils.dart';
import 'package:logintemplate/main.dart';
import 'package:logintemplate/widgets/container_with_logo.dart';
import 'package:logintemplate/widgets/delayed_animation.dart';

class LoginSuccessPage extends StatefulWidget {
  @override
  _LoginSuccessPageState createState() => _LoginSuccessPageState();
}

Future<String> getUsername() async {
  return await storage.read(key: "username");
}

class _LoginSuccessPageState extends State<LoginSuccessPage> with SingleTickerProviderStateMixin {
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
  void dispose() {
//    log.checkLog(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;


    return FutureBuilder<String>(
      future: getUsername(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  Center(child: CircularProgressIndicator());
        }else{
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body:ContainerWithLogo(
                      children: <Widget>[
                        DelayedAnimation(
                          child: Text(
                            translate(Keys.First_Page_Welcome_On_Board),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35.0,
                                color: color),
                          ),
                          delay: delayedAmount + 1000,
                        ),

                        DelayedAnimation(
                          child: Text(
                            "${snapshot.data}",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 35.0,
                                color: color),
                          ),
                          delay: delayedAmount + 1000,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        DelayedAnimation(
                          child: GestureDetector(
//                                onTapDown: _onTapDown,
                            onTapUp: _onTapUp,
                            child: Transform.scale(
                              scale: _scale,
                              child: _animatedButtonUI,
                            ),
                          ),
                          delay: delayedAmount + 2000,
                        ),
                      ],
                  )
              ),
            );

        }
      },
    );
  }

  Widget get _animatedButtonUI => Container(
    height: 60,
    width: 270,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: Colors.white,
    ),
    child: Center(
      child: Text(
        translate(Keys.Button_Logout),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8185E2),
        ),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) {
//    print("tapped");
//    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) async {
    await sessionLogout(context);
//    log.addMessage("Successfully LoggedOut");
//    print("tapped-R");
//    _controller.reverse();
  }
}