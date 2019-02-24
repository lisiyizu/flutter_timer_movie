import 'package:fluro/fluro.dart';
import 'package:flutter_timer_movie/pages/home_page.dart';
import 'package:flutter_timer_movie/pages/movie_detail.dart';
import 'package:flutter_timer_movie/pages/splash_page.dart';
import 'package:flutter_timer_movie/pages/theme_page.dart';
import 'package:flutter_timer_movie/utils/convert_utils.dart';

var rootHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
  return SplashPage();
});

var homeHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
  // 用于传递参数，在路径后面拼接参数 key 以及参数
  // 例如在 router.navigatorTo 传递路径带上参数，${Routers.home}?title=Timer 在页面打开后获取到 Timer 值
  String title = params['title']?.first;
  return HomePage(title: title);
});

var appThemeHandler = Handler(handlerFunc: (_, Map<String, dynamic> params) {
  return ThemePage();
});

var movieDetailHandler = Handler(handlerFunc: (_, Map<String, List<String>> params) {
  String id = params['movieId']?.first;
  String movieName = params['movieName']?.first;
  return MovieDetail(movieId: int.parse(id), movieName: ConvertUtils.cnDecode(movieName));
});
