import 'package:fluro/fluro.dart';

import '../utils/logger.dart';
import 'router_handlers.dart';

class Routers {
  static var root = '/'; // 首页的 path 必须为 '/' 其他随意
  static var home = '/home';
  static var appTheme = '/app_theme';
  static var movieDetails = '/movie_details';
  static var _logger = Logger('Routers');

  static void configureRouters(Router router) {
    router.notFoundHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
      _logger.log('Page Not Found');
      _logger.log(params);
    });

    // splash
    router.define(root, handler: rootHandler);
    // home
    router.define(home, handler: homeHandler);
    // theme
    router.define(appTheme, handler: appThemeHandler);
    // movie detail
    router.define(movieDetails, handler: movieDetailHandler);
  }

  static String generateHomePath(String title) => '$home?title=$title';

  static String generateDetailPath(int id, String name) => '$movieDetails?movieId=$id&movieName=$name';
}
