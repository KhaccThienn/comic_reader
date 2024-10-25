import 'dart:io';

import 'package:anim_search/providers/data_provider.dart';
import 'package:anim_search/screens/anime_details_screen.dart';
import 'package:anim_search/screens/home_screen.dart';
import 'package:anim_search/screens/login_screen.dart';
import 'package:anim_search/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  String? emailPref;
  String? avatarPref;
  String? displayNamePref;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        title: 'AnimSearch',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
          primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
        ),
        home: LoginPage(),
        routes: {
          AnimeDetailScreen.routeName: (context) => AnimeDetailScreen(),
        },
      ),
    );
  }
}
