import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Page/TodoAuth.dart';
import 'package:todo_app/Services/firestoreTodoService.dart';
import 'package:todo_app/Util/utility.dart';
import 'Page/TodoHome.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => todoService,
      ),
      ChangeNotifierProvider(
        create: (context) => todoThemeMode,
      )
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => HomePage(),
          "/auth": (context) => AuthPage(),
        },
        initialRoute: "/auth",
        themeMode: todoThemeMode.currentTheme(),
        theme: themeLight,
        darkTheme: themeDark),
  ));
}
