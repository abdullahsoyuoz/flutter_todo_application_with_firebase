import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_app/Util/TodoLogoWidget.dart';
import 'package:todo_app/Util/utility.dart';

class TodoAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
            padding: EdgeInsets.only(
              top: getSize(context).size.height * 0.04,
            ),
            height: getSize(context).size.height * 0.15,
            width: getSize(context).size.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: getSize(context).size.height * 0.03,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Hero(tag: "textLogo", child: TodoTextLogoWidget()),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Hero(tag: "logo", child: todoActionButton(context)),
                  ),
                )
              ],
            )),
      ),
    );
  }

  todoActionButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: getSize(context).size.height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            child: TodoLogoWidget(),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            onLongPress: () {},
          ),
        ],
      ),
    );
  }
}
