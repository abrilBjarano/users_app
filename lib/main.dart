import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/infoHandler/app_info.dart';
import 'package:users_app/users/en/splashScreen/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  AppLocalizationDelegate _localeOverrideDelegate =
  const AppLocalizationDelegate(Locale('en', 'US'));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(
      child: ChangeNotifierProvider(
        create: (context) => AppInfo(),

        child: MaterialApp(
          title: 'Ship Driver',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            _localeOverrideDelegate
          ],
          supportedLocales: const[
            Locale('en', ''), // English, no country code
            Locale('es', ''),//Spanish, no country code
            Locale('de', ''),// German, no country code
          ],
          home: const MySplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context){
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp(){
    setState(() {
      key = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key:key,
        child: widget.child!);
  }
}
