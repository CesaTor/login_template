import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class ContainerWithLogo extends StatelessWidget {

  final Widget child;

  final List<Widget> children;

  ContainerWithLogo({this.child, this.children = const []});

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AvatarGlow(
                      endRadius: 90,
                      duration: Duration(seconds: 2),
                      glowColor: Colors.white24,
                      repeat: true,
                      repeatPauseDuration: Duration(seconds: 2),
                      startDelay: Duration(seconds: 1),
                      child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/images/logo.jpg"),
                            radius: 50.0,
                          )),
                    ),
                    if(child != null) child,
                    ...children,
                  ],
                )
            ))
    );
  }

}
