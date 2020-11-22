import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget todoWaiting(String content, BuildContext context) {
  return Center(
    child: Shimmer.fromColors(
        child: Text(content),
        baseColor: Colors.white,
        highlightColor: Theme.of(context).backgroundColor),
  );
}
