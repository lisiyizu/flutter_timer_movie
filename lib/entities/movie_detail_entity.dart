class MovieDetailEntity {
  String code;
  String msg;
  String showMsg;
  DetailBean data;

  static MovieDetailEntity fromMap(Map<String, dynamic> map) {
    MovieDetailEntity temp = new MovieDetailEntity();
    temp.code = map['code'];
    temp.msg = map['msg'];
    temp.showMsg = map['showMsg'];
    temp.data = DetailBean.fromMap(map['data']);
    return temp;
  }

  static List<MovieDetailEntity> fromMapList(dynamic mapList) {
    List<MovieDetailEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class DetailBean {
  String playState;
  AdvertisementBean advertisement;
  BasicBean basic;
  BoxOfficeBean boxOffice;
  LiveBean live;
  RelatedBean related;

  static DetailBean fromMap(Map<String, dynamic> map) {
    DetailBean dataBean = new DetailBean();
    dataBean.playState = map['playState'];
    dataBean.advertisement = AdvertisementBean.fromMap(map['advertisement']);
    dataBean.basic = BasicBean.fromMap(map['basic']);
    dataBean.boxOffice = BoxOfficeBean.fromMap(map['boxOffice']);
    dataBean.live = LiveBean.fromMap(map['live']);
    dataBean.related = RelatedBean.fromMap(map['related']);
    return dataBean;
  }

  static List<DetailBean> fromMapList(dynamic mapList) {
    List<DetailBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class AdvertisementBean {
  String error;
  bool success;
  int count;
  List<AdvListListBean> advList;

  static AdvertisementBean fromMap(Map<String, dynamic> map) {
    AdvertisementBean advertisementBean = new AdvertisementBean();
    advertisementBean.error = map['error'];
    advertisementBean.success = map['success'];
    advertisementBean.count = map['count'];
    advertisementBean.advList = AdvListListBean.fromMapList(map['advList']);
    return advertisementBean;
  }

  static List<AdvertisementBean> fromMapList(dynamic mapList) {
    List<AdvertisementBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class BasicBean {
  String bigImage;
  String commentSpecial;
  String img;
  String message;
  String mins;
  String name;
  String nameEn;
  String releaseArea;
  String releaseDate;
  String story;
  String url;
  bool is3D;
  bool isDMAX;
  bool isEggHunt;
  bool isFilter;
  bool isIMAX;
  bool isIMAX3D;
  bool isTicket;
  bool sensitiveStatus;
  double overallRating;
  int hotRanking;
  int movieId;
  int movieStatus;
  int personCount;
  int showCinemaCount;
  int showDay;
  int showtimeCount;
  int totalNominateAward;
  int totalWinAward;
  AwardBean award;
  CommunityBean community;
  DirectorBean director;
  QuizGameBean quizGame;
  StageImgBean stageImg;
  StyleBean style;
  VideoBean video;
  List<String> type;
  List<ActorsListBean> actors;

  static BasicBean fromMap(Map<String, dynamic> map) {
    BasicBean basicBean = new BasicBean();
    basicBean.bigImage = map['bigImage'];
    basicBean.commentSpecial = map['commentSpecial'];
    basicBean.img = map['img'];
    basicBean.message = map['message'];
    basicBean.mins = map['mins'];
    basicBean.name = map['name'];
    basicBean.nameEn = map['nameEn'];
    basicBean.releaseArea = map['releaseArea'];
    basicBean.releaseDate = map['releaseDate'];
    basicBean.story = map['story'];
    basicBean.url = map['url'];
    basicBean.is3D = map['is3D'];
    basicBean.isDMAX = map['isDMAX'];
    basicBean.isEggHunt = map['isEggHunt'];
    basicBean.isFilter = map['isFilter'];
    basicBean.isIMAX = map['isIMAX'];
    basicBean.isIMAX3D = map['isIMAX3D'];
    basicBean.isTicket = map['isTicket'];
    basicBean.sensitiveStatus = map['sensitiveStatus'];
    basicBean.overallRating = map['overallRating'] + 0.0;
    basicBean.hotRanking = map['hotRanking'];
    basicBean.movieId = map['movieId'];
    basicBean.movieStatus = map['movieStatus'];
    basicBean.personCount = map['personCount'];
    basicBean.showCinemaCount = map['showCinemaCount'];
    basicBean.showDay = map['showDay'];
    basicBean.showtimeCount = map['showtimeCount'];
    basicBean.totalNominateAward = map['totalNominateAward'];
    basicBean.totalWinAward = map['totalWinAward'];
    basicBean.award = AwardBean.fromMap(map['award']);
    basicBean.community = CommunityBean.fromMap(map['community']);
    basicBean.director = DirectorBean.fromMap(map['director']);
    basicBean.quizGame = QuizGameBean.fromMap(map['quizGame']);
    basicBean.stageImg = StageImgBean.fromMap(map['stageImg']);
    basicBean.style = StyleBean.fromMap(map['style']);
    basicBean.video = VideoBean.fromMap(map['video']);
    basicBean.actors = ActorsListBean.fromMapList(map['actors']);

    List<dynamic> dynamicList0 = map['type'];
    basicBean.type = new List();
    basicBean.type.addAll(dynamicList0.map((o) => o.toString()));

    return basicBean;
  }

  static List<BasicBean> fromMapList(dynamic mapList) {
    List<BasicBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class BoxOfficeBean {
  String todayBoxDes;
  String todayBoxDesUnit;
  String totalBoxDes;
  String totalBoxUnit;
  int movieId;
  int ranking;
  int todayBox;
  int totalBox;

  static BoxOfficeBean fromMap(Map<String, dynamic> map) {
    BoxOfficeBean boxOfficeBean = new BoxOfficeBean();
    boxOfficeBean.todayBoxDes = map['todayBoxDes'];
    boxOfficeBean.todayBoxDesUnit = map['todayBoxDesUnit'];
    boxOfficeBean.totalBoxDes = map['totalBoxDes'];
    boxOfficeBean.totalBoxUnit = map['totalBoxUnit'];
    boxOfficeBean.movieId = map['movieId'];
    boxOfficeBean.ranking = map['ranking'];
    boxOfficeBean.todayBox = map['todayBox'];
    boxOfficeBean.totalBox = map['totalBox'];
    return boxOfficeBean;
  }

  static List<BoxOfficeBean> fromMapList(dynamic mapList) {
    List<BoxOfficeBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class LiveBean {
  String img;
  String playNumTag;
  String playTag;
  String title;
  int count;
  int liveId;
  int status;

  static LiveBean fromMap(Map<String, dynamic> map) {
    LiveBean liveBean = new LiveBean();
    liveBean.img = map['img'];
    liveBean.playNumTag = map['playNumTag'];
    liveBean.playTag = map['playTag'];
    liveBean.title = map['title'];
    liveBean.count = map['count'];
    liveBean.liveId = map['liveId'];
    liveBean.status = map['status'];
    return liveBean;
  }

  static List<LiveBean> fromMapList(dynamic mapList) {
    List<LiveBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class RelatedBean {
  String relatedUrl;
  int goodsCount;
  int relateId;
  int type;

  static RelatedBean fromMap(Map<String, dynamic> map) {
    RelatedBean relatedBean = new RelatedBean();
    relatedBean.relatedUrl = map['relatedUrl'];
    relatedBean.goodsCount = map['goodsCount'];
    relatedBean.relateId = map['relateId'];
    relatedBean.type = map['type'];
    return relatedBean;
  }

  static List<RelatedBean> fromMapList(dynamic mapList) {
    List<RelatedBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class AdvListListBean {
  String advTag;
  String tag;
  String type;
  String typeName;
  String url;
  bool isHorizontalScreen;
  bool isOpenH5;
  int endDate;
  int startDate;

  static AdvListListBean fromMap(Map<String, dynamic> map) {
    AdvListListBean advListListBean = new AdvListListBean();
    advListListBean.advTag = map['advTag'];
    advListListBean.tag = map['tag'];
    advListListBean.type = map['type'];
    advListListBean.typeName = map['typeName'];
    advListListBean.url = map['url'];
    advListListBean.isHorizontalScreen = map['isHorizontalScreen'];
    advListListBean.isOpenH5 = map['isOpenH5'];
    advListListBean.endDate = map['endDate'];
    advListListBean.startDate = map['startDate'];
    return advListListBean;
  }

  static List<AdvListListBean> fromMapList(dynamic mapList) {
    List<AdvListListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class AwardBean {
  int totalNominateAward;
  int totalWinAward;

  static AwardBean fromMap(Map<String, dynamic> map) {
    AwardBean awardBean = new AwardBean();
    awardBean.totalNominateAward = map['totalNominateAward'];
    awardBean.totalWinAward = map['totalWinAward'];
    return awardBean;
  }

  static List<AwardBean> fromMapList(dynamic mapList) {
    List<AwardBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class CommunityBean {
  static CommunityBean fromMap(Map<String, dynamic> map) {
    CommunityBean communityBean = new CommunityBean();
    return communityBean;
  }

  static List<CommunityBean> fromMapList(dynamic mapList) {
    List<CommunityBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class DirectorBean {
  String img;
  String name;
  String nameEn;
  int directorId;

  static DirectorBean fromMap(Map<String, dynamic> map) {
    DirectorBean directorBean = new DirectorBean();
    directorBean.img = map['img'];
    directorBean.name = map['name'];
    directorBean.nameEn = map['nameEn'];
    directorBean.directorId = map['directorId'];
    return directorBean;
  }

  static List<DirectorBean> fromMapList(dynamic mapList) {
    List<DirectorBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class QuizGameBean {
  static QuizGameBean fromMap(Map<String, dynamic> map) {
    QuizGameBean quizGameBean = new QuizGameBean();
    return quizGameBean;
  }

  static List<QuizGameBean> fromMapList(dynamic mapList) {
    List<QuizGameBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class StageImgBean {
  int count;
  List<ListListBean> list;

  static StageImgBean fromMap(Map<String, dynamic> map) {
    StageImgBean stageImgBean = new StageImgBean();
    stageImgBean.count = map['count'];
    stageImgBean.list = ListListBean.fromMapList(map['list']);
    return stageImgBean;
  }

  static List<StageImgBean> fromMapList(dynamic mapList) {
    List<StageImgBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class StyleBean {
  String leadImg;
  String leadUrl;
  int isLeadPage;

  static StyleBean fromMap(Map<String, dynamic> map) {
    StyleBean styleBean = new StyleBean();
    styleBean.leadImg = map['leadImg'];
    styleBean.leadUrl = map['leadUrl'];
    styleBean.isLeadPage = map['isLeadPage'];
    return styleBean;
  }

  static List<StyleBean> fromMapList(dynamic mapList) {
    List<StyleBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class VideoBean {
  String hightUrl;
  String img;
  String title;
  String url;
  int count;
  int videoId;
  int videoSourceType;

  static VideoBean fromMap(Map<String, dynamic> map) {
    VideoBean videoBean = new VideoBean();
    videoBean.hightUrl = map['hightUrl'];
    videoBean.img = map['img'];
    videoBean.title = map['title'];
    videoBean.url = map['url'];
    videoBean.count = map['count'];
    videoBean.videoId = map['videoId'];
    videoBean.videoSourceType = map['videoSourceType'];
    return videoBean;
  }

  static List<VideoBean> fromMapList(dynamic mapList) {
    List<VideoBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class ActorsListBean {
  String img;
  String name;
  String nameEn;
  String roleImg;
  String roleName;
  int actorId;

  static ActorsListBean fromMap(Map<String, dynamic> map) {
    ActorsListBean actorsListBean = new ActorsListBean();
    actorsListBean.img = map['img'];
    actorsListBean.name = map['name'];
    actorsListBean.nameEn = map['nameEn'];
    actorsListBean.roleImg = map['roleImg'];
    actorsListBean.roleName = map['roleName'];
    actorsListBean.actorId = map['actorId'];
    return actorsListBean;
  }

  static List<ActorsListBean> fromMapList(dynamic mapList) {
    List<ActorsListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class ListListBean {
  String imgUrl;
  int imgId;

  static ListListBean fromMap(Map<String, dynamic> map) {
    ListListBean listListBean = new ListListBean();
    listListBean.imgUrl = map['imgUrl'];
    listListBean.imgId = map['imgId'];
    return listListBean;
  }

  static List<ListListBean> fromMapList(dynamic mapList) {
    List<ListListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
