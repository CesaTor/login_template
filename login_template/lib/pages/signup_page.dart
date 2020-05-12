import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:logintemplate/env/api_data.dart';
import 'package:logintemplate/env/keys/keys.dart';
import 'package:logintemplate/env/routes.dart';
import 'package:logintemplate/env/variables.dart';
import 'package:logintemplate/main.dart';
import 'package:logintemplate/widgets/container_with_logo.dart';
import 'package:logintemplate/widgets/text_field_base_form.dart';
//-----------------------------------------------------------------------------
// Signup
//-----------------------------------------------------------------------------

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  JwtData resData;

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final nickController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  Future<String> postSignUp() async {

    // TODO - email/password validation

    // Populate Body Request
    SignUpJsonData reqBody = new SignUpJsonData();
    reqBody.username = nickController.text;
    reqBody.email = emailController.text;
    reqBody.password = passwordController.text;

    // Request Call
    try{
      var response = await http.post(
          Uri.encodeFull(SERVER_IP+SIGN_UP_PATH),
          headers: {"Accept": "application/json"},
          body: reqBody.toJson()
      );

      Map<String, dynamic> data = json.decode(response.body);

      if(data.containsKey("error")) {
        StrapiError err = StrapiError.fromMap(data);
        // TODO - manage all errors
        print("postSignUp() Error: " + response.body);
        return "TODO - Strapi Errors Interface";
//        return err.message[0].messages[0].message;

      }else if(data.containsKey("jwt")) {
        resData = JwtData.fromMap(data);
        return translate(Keys.Request_Status_Success);
      }
      return translate(Keys.Request_Status_Unexpected_Error);

    } catch (error) {
      print("ERROR! " + error.toString());
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

    final signUpButton = (context) => Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            postSignUp().then((val) {
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text(val)));

              print("[$val] - [$translate(Keys.Request_Status_Success)]");
              if(val == translate(Keys.Request_Status_Success))
                successRoute(context);
            });
          }
        },
        child: Text(translate(Keys.Button_Sign_Up),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final nicknameField = TextFieldBaseForm(controller: nickController, hintText: translate(Keys.Form_Username), validator: (value) {
      if (value.isEmpty) {
        return translate(Keys.Errors_Empty_Field, args: {'fieldName': translate(Keys.Form_Username)});
      }
      return null;
    });
    final emailField = TextFieldBaseForm(controller: emailController, hintText: translate(Keys.Form_Email), validator: (value) {
      if (value.isEmpty) {
        return translate(Keys.Errors_Empty_Field, args: {'fieldName': translate(Keys.Form_Email)});
      }
      return null;
    });
    final passwordField = TextFieldBaseForm(controller: passwordController, hintText: translate(Keys.Form_Password), obscure: true, validator: (value) {
      if (value.isEmpty) {
        return translate(Keys.Errors_Empty_Field, args: {'fieldName': translate(Keys.Form_Password)});
      }
      return null;
    });
    final confirmPasswordField = TextFieldBaseForm(controller: confirmController, hintText: translate(Keys.Form_Confirm_Password), obscure: true, validator: (value) {
      if (value.isEmpty)
        return translate(Keys.Errors_Empty_Field, args: {'fieldName': translate(Keys.Form_Confirm_Password)});

      if(value.isNotEmpty && (value != passwordController.text))
        return translate(Keys.Errors_Pass_Not_Same);

      return null;
    });

    return
      Scaffold(
          body: Builder(
              builder: (context) => ContainerWithLogo(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              nicknameField,
                              SizedBox(height: 25.0),
                              emailField,
                              SizedBox(height: 25.0),
                              passwordField,
                              SizedBox(height: 25.0),
                              confirmPasswordField,
                              SizedBox(
                                height: 35.0,
                              ),
                              signUpButton(context),
                            ],
                          )
                      )
                  )
              )
          )
      );
  }

  @override
  void dispose() {
    nickController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}
