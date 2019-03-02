import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../application.dart';
import '../resource.dart';
import '../routers/routers.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 倒计时进入主页，必要的延时做初始化工作
    Future.delayed(Duration(seconds: 3)).then((val) => Application.router.navigateTo(
        context, Routers.generateHomePath('Timer'),
        replace: true, transition: TransitionType.fadeIn, transitionDuration: Duration(milliseconds: 500)));

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(Resource.imageAppLogo, width: 250, height: 250),
      ),
    );
  }
}
