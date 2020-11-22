import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:todo_app/Page/TodoSetting.dart';
import 'package:todo_app/Services/firestoreAuthService.dart';
import 'package:todo_app/Widgets/TodoAppBar.dart';
import 'package:todo_app/Widgets/TodoBody.dart';
import 'package:todo_app/Util/TodoWaiting.dart';
import 'package:todo_app/Util/utility.dart';

class HomePage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarManager.setColor(Colors.transparent);
    FlutterStatusbarManager.setNavigationBarColor(
        Theme.of(context).backgroundColor);
    FlutterStatusbarManager.setTranslucent(true);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Padding(
        padding: EdgeInsets.only(
          top: getSize(context).padding.top,
        ),
        child: FutureBuilder(
          future: _initialization,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return todoWaiting("Error: ${snapshot.error}", context);
            }
            if (snapshot.connectionState == ConnectionState.none) {
              return todoWaiting("Bağlantı Yok", context);
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                fit: StackFit.loose,
                children: [
                  TodoBody(),
                  TodoAppBar(),
                ],
              );
            } else {
              return todoWaiting("Hazırlanıyor...", context);
            }
          },
        ),
      ),
      endDrawer: todoSetting(context),
    );
  }
}
