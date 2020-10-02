import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:garderieeu/Pages/Home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//  statusBarColor: Colors.transparent,
////    statusBarIconBrightness:
//  ));
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

//       supportedLocales: [
//         Locale('en',''),
//         Locale('ar','')
//       ],
//       localizationsDelegates: [
//         AppLocalizations.delegate,
// //        GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate
//       ],

      // localeResolutionCallback: (locale,supportedLocales){
      //   var supportedLocale;
      //   for( supportedLocale in supportedLocales){
      //     if(supportedLocale.languageCode== locale.languageCode)
      //     {
      //       return supportedLocale;
      //     }
      //   }
      //   return supportedLocales.first;
      // }
      // ,

    debugShowCheckedModeBanner: false,
      title: 'Garderieeu',
      home: SplashScreen(
        'assets/Splash.flr',
        HomePage(),
        startAnimation: 'intro',
        backgroundColor: Color(0xffFFFFFF),
      ),
    );
  }
}
