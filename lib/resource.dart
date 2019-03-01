import 'package:flutter/material.dart';

class Resource {
  // Root
  static var _imageRoot = 'assets/images/';

  // Fonts
  static var fontFamilyDancingScript = 'DancingScript';

  // Images
  static var imageAppIcon = '${_imageRoot}app_icon.png';
  static var imageAppLogo = '${_imageRoot}app_logo.png';
  static var imageFail = '${_imageRoot}fail.png';
  static var imageAvaDefault = '${_imageRoot}ava_default.png';
}

/// 三方图标
class MovieIcons {
  static const IconData back_top = MovieIconData(0xe653);
  static const IconData login_out = MovieIconData(0xe65f);
  static const IconData gender = MovieIconData(0xe6d2);
  static const IconData movie = MovieIconData(0xe60d);
  static const IconData theme = MovieIconData(0xe688);
  static const IconData person_settings = MovieIconData(0xe63d);
  static const IconData change_pass = MovieIconData(0xe51d);
  static const IconData register = MovieIconData(0xe6b3);
}

class MovieIconData extends IconData {
  const MovieIconData(int codePoint) : super(codePoint, fontFamily: 'IconFonts');
}
