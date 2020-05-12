import 'package:flutter/material.dart';

class TextFieldBaseForm extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final FormFieldValidator<String> validator;

  TextFieldBaseForm({@required this.controller, @required this.hintText, this.obscure = false, this.validator});

  InputDecoration dec({String hintText}) {
    return InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.white)),
        filled: true,
        fillColor: Colors.white54
    );
  }

  @override
  Widget build(BuildContext context) {

    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return TextFormField(
        validator: validator,
        controller: controller,
        obscureText: this.obscure,
        style: style,
        decoration: dec(hintText: hintText)
    );
  }
}
