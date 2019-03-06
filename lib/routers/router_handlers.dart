import 'package:fluro/fluro.dart';
import 'package:flutter_timer_movie/pages/register_page.dart';

import '../pages/home_page.dart';
import '../pages/info_settings_page.dart';
import '../pages/login_page.dart';
import '../pages/movie_detail.dart';
import '../pages/rename_page.dart';
import '../pages/splash_page.dart';
import '../pages/theme_page.dart';
import '../utils/convert_utils.dart';

var rootHandler = Handler(handlerFunc: (_, __) => SplashPage());

var homeHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
  // 用于传递参数，在路径后面拼接参数 key 以及参数
  // 例如在 router.navigatorTo 传递路径带上参数，${Routers.home}?title=Timer 在页面打开后获取到 Timer 值
  String title = params['title']?.first;
  return HomePage(title: title);
});

var appThemeHandler = Handler(handlerFunc: (_, __) => ThemePage());

var movieDetailHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
  String id = params['movieId']?.first;
  String movieName = params['movieName']?.first;
  return MovieDetail(movieId: int.parse(id), movieName: ConvertUtils.fluroCnParamsDecode(movieName));
});

var loginHandler = Handler(handlerFunc: (_, __) => LoginPage());

var registerHandler = Handler(handlerFunc: (_, __) => RegisterPage());

var infoSettingsHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
  String id = params['user_id']?.first;
  return InfoSettingsPage(userId: int.parse(id));
});

var renameHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
  String id = params['user_id']?.first;
  return RenamePage(userId: int.parse(id));
});
