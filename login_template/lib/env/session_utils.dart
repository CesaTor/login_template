import 'package:flutter/material.dart';
import 'package:logintemplate/env/routes.dart';
import 'package:logintemplate/main.dart';

Future<bool> isLogged() async {
  String token = await storage.read(key: "jwt");
  return !(token == null || token.isEmpty);
}

Future<void> sessionLogout(BuildContext context) async {
  await storage.deleteAll();
  // Clear all, go to main, remove old routes
  Navigator.pushNamedAndRemoveUntil(context, MAIN_ROUTE, (Route<dynamic> route) => false);
}