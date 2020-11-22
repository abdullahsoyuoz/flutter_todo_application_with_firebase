import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Util/utility.dart';

class TodoLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(getSize(context).size.height * 0.005),
              color: Theme.of(context).primaryColor),
          height: getSize(context).size.height * 0.02,
          width: getSize(context).size.height * 0.032,
        ),
        SizedBox(
          height: getSize(context).size.height * 0.005,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(getSize(context).size.height * 0.005),
              color: Theme.of(context).primaryColor),
          height: getSize(context).size.height * 0.032,
          width: getSize(context).size.height * 0.0512,
        )
      ],
    );
  }
}

class TodoTextLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("todo",
        style: GoogleFonts.catamaran(
            decoration: TextDecoration.none,
            fontSize: getSize(context).size.height * 0.07,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).primaryColor));
  }
}
