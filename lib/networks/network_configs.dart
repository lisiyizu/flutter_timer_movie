/// movie api from github: https://github.com/jokermonn/-Api/blob/master/Time.md#movie_detail
/// thanks jokermonn: https://github.com/jokermonn

class NetworkConfigs {
  /// method: get, param: locationId
  static var movieOn = 'https://api-m.mtime.cn/Showtime/LocationMovies.api';

  /// method: get, param: locationId
  static var movieComing = 'https://api-m.mtime.cn/Movie/MovieComingNew.api';

  /// method: get, param: locationId, movieId
  static var movieDetail = 'https://ticket-api-m.mtime.cn/movie/detail.api';

  /// method: get, param: movieId
  static var movieAct = 'https://api-m.mtime.cn/Movie/MovieCreditsWithTypes.api';

  /// method: get, param: movieId
  static var movieComment = 'https://ticket-api-m.mtime.cn/movie/hotComment.api';

  /// method: get, param: pageIndex, movieId
  static var movieTricks = 'https://api-m.mtime.cn/Movie/Video.api';

  /// method: get, param: movieId
  static var movieStills = 'https://api-m.mtime.cn/Movie/ImageAll.api';
}
