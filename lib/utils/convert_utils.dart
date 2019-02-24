import 'dart:convert';

class ConvertUtils {
  /// fluro 传递中文参数前，先转换，fluro 不支持中文传递
  static String cnEncode(String cn) => jsonEncode(Utf8Encoder().convert(cn));

  /// fluro 传递后取出参数，解析
  static String cnDecode(String encodedCn) {
    var decodedCn = jsonDecode(encodedCn);

    if (decodedCn is List<int>) {
      return Utf8Decoder().convert(decodedCn);
    } else {
      return 'Fail';
    }
  }
}
