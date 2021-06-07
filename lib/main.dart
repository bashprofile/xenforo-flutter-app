import 'package:flutter/material.dart';
import 'helpers/color.dart';
import 'screens/home.dart';
import 'package:provider/provider.dart';
import 'providers/user.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (_) => new UserModel(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XenForo',
      theme: ThemeData(
        splashColor: Colors.white.withOpacity(0.25),
        fontFamily: 'Gilroy',
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color(0xff1281dd),
      ),
      home: MyHomePage(title: 'Xenforo Forum'),
    );
  }
}
