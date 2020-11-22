import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Services/firestoreAuthService.dart';
import 'package:todo_app/Util/utility.dart';

todoSetting(BuildContext context) {
  return ClipRect(
    child: Container(
      color: Theme.of(context).backgroundColor.withOpacity(0.9),
      height: getSize(context).size.height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          settingsTitle(context),
          //switchTheme(context),
          logoutButton(context)
        ],
      ),
    ),
  );
}

switchTheme(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    mainAxisSize: MainAxisSize.max,
    children: [
      Padding(
        padding: EdgeInsets.only(bottom: getSize(context).size.height * 0.03),
        child: Text("Dark Mode"),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: getSize(context).size.height * 0.03),
        child: CupertinoSwitch(
          value: todoThemeMode.currentTheme() == ThemeMode.dark ? true : false,
          onChanged: (value) {
            Provider.of<TodoThemeMode>(context).switchTheme();
          },
        ),
      ),
    ],
  );
}

settingsTitle(BuildContext context) {
  return Container(
    padding:
        EdgeInsets.symmetric(vertical: getSize(context).size.height * 0.04),
    child: Text(
      "Ayarlar",
      style: GoogleFonts.catamaran(
        textStyle: TextStyle(color: Theme.of(context).primaryColor),
        fontWeight: FontWeight.w900,
        decoration: TextDecoration.none,
        fontSize: getSize(context).size.height * 0.07,
      ),
    ),
  );
}

logoutButton(BuildContext context) {
  return Padding(
      padding: EdgeInsets.only(bottom: getSize(context).size.height * 0.03),
      child: CupertinoButton(
        child: Text(
          "Logout",
          style: TextStyle(color: Theme.of(context).colorScheme.red),
        ),
        onPressed: () {
          FirebaseAuthService.signOut().whenComplete(() {
            Navigator.pushNamed(context, "/auth");
          });
        },
      ));
}
