import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logintemplate/env/routes.dart';
import 'package:logintemplate/env/transition_utils.dart';
import 'package:logintemplate/pages/firststart_page.dart';
import 'package:logintemplate/pages/loading_page.dart';
import 'package:logintemplate/pages/login_page.dart';
import 'package:logintemplate/pages/login_success_page.dart';
import 'package:logintemplate/pages/signup_page.dart';

// Storage data
final storage = new FlutterSecureStorage();

void main() async{
  // Setup Locale
  var delegate = await LocalizationDelegate.create(
      basePath: 'assets/i18n',
      fallbackLocale: 'en_US',
      supportedLocales: ['en_US', 'it_IT']);

  runApp(LocalizedApp(delegate, MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Flutter Translate Demo',
        localizationsDelegates: [
          // TODO - check https://github.com/bratan/flutter_translate/wiki/1.-Installation,-Configuration-&-Usage
//          GlobalMaterialLocalizations.delegate,
//          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        // TODO - add theme
//        theme: ThemeData(),
        initialRoute: LOADING_ROUTE,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case LOADING_ROUTE:
              return PageTransition(child: LoadingPage(), type: PageTransitionType.fade);
              break;
            case MAIN_ROUTE:
              return PageTransition(child: FirstStartPage(), type: PageTransitionType.fade);
              break;
            case LOGIN_ROUTE:
              return PageTransition(child: LoginPage(), type: PageTransitionType.rightToLeft);
              break;
            case SIGN_UP_ROUTE:
              return PageTransition(child: SignUpPage(), type: PageTransitionType.rightToLeft);
              break;
            case LOGIN_SUCCESS_ROUTE:
              return PageTransition(child: LoginSuccessPage(), type: PageTransitionType.rightToLeft);
              break;
            default:
              return null;
          }
        }
      ),
    );
  }
}