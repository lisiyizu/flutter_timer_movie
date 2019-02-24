import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_movie/utils/logger.dart';
import 'router_handlers.dart';

class Routers {
  static var root = '/'; // 首页的 path 必须为 '/' 其他随意
  static var home = '/home';
  static var appTheme = '/app_theme';
  static var movieDetails = '/movie_details';
  static var _logger = Logger('Routers');

  static void configureRouters(Router router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      _logger.log('Page Not Found');
    });

    // splash
    router.define(root, handler: rootHandler);
    // home
    router.define(home, handler: homeHandler);
    // theme page
    router.define(appTheme, handler: appThemeHandler);
  }
}
