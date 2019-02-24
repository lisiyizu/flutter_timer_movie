class MovieComingsEntity {
  List<MovieInfo> attentions;
  List<MovieInfo> comings;

  static MovieComingsEntity fromMap(Map<String, dynamic> map) {
    MovieComingsEntity temp = new MovieComingsEntity();
    temp.attentions = MovieInfo.fromMapList(map['attention']);
    temp.comings = MovieInfo.fromMapList(map['moviecomings']);
    return temp;
  }

  static List<MovieComingsEntity> fromMapList(dynamic mapList) {
    List<MovieComingsEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class MovieInfo {
  String actor1;
  String actor2;
  String director;
  String image;
  String locationName;
  String releaseDate;
  String title;
  String type;
  bool isFilter;
  bool isTicket;
  bool isVideo;
  int id;
  int rDay;
  int rMonth;
  int rYear;
  int videoCount;
  int wantedCount;
  List<VideosListBean> videos;

  static MovieInfo fromMap(Map<String, dynamic> map) {
    MovieInfo attentionListBean = new MovieInfo();
    attentionListBean.actor1 = map['actor1'];
    attentionListBean.actor2 = map['actor2'];
    attentionListBean.director = map['director'];
    attentionListBean.image = map['image'];
    attentionListBean.locationName = map['locationName'];
    attentionListBean.releaseDate = map['releaseDate'];
    attentionListBean.title = map['title'];
    attentionListBean.type = map['type'];
    attentionListBean.isFilter = map['isFilter'];
    attentionListBean.isTicket = map['isTicket'];
    attentionListBean.isVideo = map['isVideo'];
    attentionListBean.id = map['id'];
    attentionListBean.rDay = map['rDay'];
    attentionListBean.rMonth = map['rMonth'];
    attentionListBean.rYear = map['rYear'];
    attentionListBean.videoCount = map['videoCount'];
    attentionListBean.wantedCount = map['wantedCount'];
    attentionListBean.videos = VideosListBean.fromMapList(map['videos']);
    return attentionListBean;
  }

  static List<MovieInfo> fromMapList(dynamic mapList) {
    List<MovieInfo> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class VideosListBean {
  String hightUrl;
  String image;
  String title;
  String url;
  int length;
  int videoId;

  static VideosListBean fromMap(Map<String, dynamic> map) {
    VideosListBean videosListBean = new VideosListBean();
    videosListBean.hightUrl = map['hightUrl'];
    videosListBean.image = map['image'];
    videosListBean.title = map['title'];
    videosListBean.url = map['url'];
    videosListBean.length = map['length'];
    videosListBean.videoId = map['videoId'];
    return videosListBean;
  }

  static List<VideosListBean> fromMapList(dynamic mapList) {
    List<VideosListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
