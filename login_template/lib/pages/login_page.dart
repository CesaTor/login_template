import 'dart:convert';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logintemplate/env/api_data.dart';
import 'package:logintemplate/env/keys/keys.dart';
import 'package:logintemplate/env/routes.dart';
import 'package:logintemplate/env/variables.dart';
import 'package:logintemplate/main.dart';
import 'package:logintemplate/widgets/container_with_logo.dart';
import 'package:logintemplate/widgets/text_field_base_form.dart';
//-----------------------------------------------------------------------------
// Login
//-----------------------------------------------------------------------------

class LoginPage extends StatefulWidget {
  final String title;
  LoginPage({Key key, this.title}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  JwtData resData;
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String> postLogin() async {
    // Populate Body Request
    LoginJsonData reqBody = new LoginJsonData();
    reqBody.identifier = emailController.text;
    reqBody.password = passwordController.text;

    // Request Call
    try{
      var response = await http.post(
          Uri.encodeFull(SERVER_IP + LOGIN_PATH),
          headers: {"Accept": "application/json"},
          body: reqBody.toJson()
      );

      Map<String, dynamic> data = json.decode(response.body);

      if(data.containsKey("error")) {
        StrapiError err = StrapiError.fromMap(data);
        print("postLogin() Error: " + response.body);
        // TODO
        return "TODO - Strapi Errors Interface";
//        return err.message[0].messages[0].message;
      }else if(response.statusCode == 200 && data.containsKey("jwt")) {
        // save data
        resData = JwtData.fromMap(data);
        return translate(Keys.Request_Status_Success);
      }
      print("postLogin() Unexpected Response :" +response.body);
      return translate(Keys.Request_Status_Unexpected_Error);

    } catch (error) {
      print("ERROR! " + error.toString());
      print("postLogin() Check what happened");
      return translate(Keys.Request_Status_Connectivity_Issue);
    }
  }

  Future<void> successRoute(BuildContext context) async {
    await storage.write(key: "jwt", value: resData.jwt);
    await storage.write(key: "username", value: resData.user.username);
    await storage.write(key: "email", value: resData.user.email);
    Navigator.pushNamedAndRemoveUntil(context, LOGIN_SUCCESS_ROUTE, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFieldBaseForm(controller: emailController, hintText: translate(Keys.Form_Identifier), validator: (value) {
      if (value.isEmpty) {
        return translate(Keys.Errors_Empty_Field, args: {'fieldName': translate(Keys.Form_Identifier)});

        return "Campo Nickname/Email vuoto!";
      }
      return null;
    });
    final passwordField = TextFieldBaseForm(controller: passwordController, hintText: translate(Keys.Form_Password), obscure: true, validator: (value) {
      if (value.isEmpty) {
        return translate(Keys.Errors_Empty_Field, args: {'fieldName': translate(Keys.Form_Password)});
      }
      return null;
    });

    final loginButton =(context) => Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            postLogin().then((val) {
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text(val)));

              if(val == translate(Keys.Request_Status_Success))
                successRoute(context);
            });
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Builder(
          builder: (context) => ContainerWithLogo(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child:Column(
                      children: <Widget>[
                        emailField,
                        SizedBox(height: 25.0),
                        passwordField,
                        SizedBox(
                          height: 35.0,
                        ),
                        loginButton(context),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  )
              )
          )
      ),
    );
  }
}
