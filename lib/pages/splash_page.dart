import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_movie/application.dart';
import 'package:flutter_timer_movie/r.dart';
import 'package:flutter_timer_movie/routers/routers.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 倒计时进入主页，必要的延时做初始化工作
    Future.delayed(Duration(seconds: 3)).then((val) => Application.router.navigateTo(
        context, '${Routers.home}?title=Timer',
        replace: true, transition: TransitionType.fadeIn, transitionDuration: Duration(milliseconds: 500)));

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(R.imageAppLogo, width: 250, height: 250),
      ),
    );
  }
}
