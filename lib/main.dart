import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_timer_movie/app_component.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MovieApp());

  // 设置状态栏颜色
  if (Platform.isAndroid) {
    var style = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
