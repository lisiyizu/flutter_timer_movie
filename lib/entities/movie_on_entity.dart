class MovieOnEntity {
  String bImg;
  String date;
  String voucherMsg;
  bool hasPromo;
  int lid;
  int newActivitiesTime;
  int totalComingMovie;
  PromoBean promo;
  List<MsListBean> ms;

  static MovieOnEntity fromMap(Map<String, dynamic> map) {
    MovieOnEntity temp = new MovieOnEntity();
    temp.bImg = map['bImg'];
    temp.date = map['date'];
    temp.voucherMsg = map['voucherMsg'];
    temp.hasPromo = map['hasPromo'];
    temp.lid = map['lid'];
    temp.newActivitiesTime = map['newActivitiesTime'];
    temp.totalComingMovie = map['totalComingMovie'];
    temp.promo = PromoBean.fromMap(map['promo']);
    temp.ms = MsListBean.fromMapList(map['ms']);
    return temp;
  }

  static List<MovieOnEntity> fromMapList(dynamic mapList) {
    List<MovieOnEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class PromoBean {
  static PromoBean fromMap(Map<String, dynamic> map) {
    PromoBean promoBean = new PromoBean();
    return promoBean;
  }

  static List<PromoBean> fromMapList(dynamic mapList) {
    List<PromoBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class MsListBean {
  String aN1;
  String aN2;
  String actors;
  String commonSpecial;
  String d;
  String dN;
  String img;
  String m;
  String movieType;
  String rd;
  String t;
  String tCn;
  String tEn;
  String year;
  bool is3D;
  bool isDMAX;
  bool isFilter;
  bool isHasTrailer;
  bool isHot;
  bool isIMAX;
  bool isIMAX3D;
  bool isNew;
  bool isTicket;
  bool preferentialFlag;
  double r;
  int nearestCinemaCount;
  int nearestDay;
  int nearestShowtimeCount;
  int cC;
  int def;
  int id;
  int movieId;
  int rc;
  int rsC;
  int sC;
  int ua;
  int wantedCount;
  List<String> p;
  List<VersionsListBean> versions;

  static MsListBean fromMap(Map<String, dynamic> map) {
    MsListBean msListBean = new MsListBean();
    msListBean.aN1 = map['aN1'];
    msListBean.aN2 = map['aN2'];
    msListBean.actors = map['actors'];
    msListBean.commonSpecial = map['commonSpecial'];
    msListBean.d = map['d'];
    msListBean.dN = map['dN'];
    msListBean.img = map['img'];
    msListBean.m = map['m'];
    msListBean.movieType = map['movieType'];
    msListBean.rd = map['rd'];
    msListBean.t = map['t'];
    msListBean.tCn = map['tCn'];
    msListBean.tEn = map['tEn'];
    msListBean.year = map['year'];
    msListBean.is3D = map['is3D'];
    msListBean.isDMAX = map['isDMAX'];
    msListBean.isFilter = map['isFilter'];
    msListBean.isHasTrailer = map['isHasTrailer'];
    msListBean.isHot = map['isHot'];
    msListBean.isIMAX = map['isIMAX'];
    msListBean.isIMAX3D = map['isIMAX3D'];
    msListBean.isNew = map['isNew'];
    msListBean.isTicket = map['isTicket'];
    msListBean.preferentialFlag = map['preferentialFlag'];
    msListBean.r = map['r'] + 0.0;
    msListBean.nearestCinemaCount = map['NearestCinemaCount'];
    msListBean.nearestDay = map['NearestDay'];
    msListBean.nearestShowtimeCount = map['NearestShowtimeCount'];
    msListBean.cC = map['cC'];
    msListBean.def = map['def'];
    msListBean.id = map['id'];
    msListBean.movieId = map['movieId'];
    msListBean.rc = map['rc'];
    msListBean.rsC = map['rsC'];
    msListBean.sC = map['sC'];
    msListBean.ua = map['ua'];
    msListBean.wantedCount = map['wantedCount'];
    msListBean.versions = VersionsListBean.fromMapList(map['versions']);

    List<dynamic> dynamicList0 = map['p'];
    msListBean.p = new List();
    msListBean.p.addAll(dynamicList0.map((o) => o.toString()));

    return msListBean;
  }

  static List<MsListBean> fromMapList(dynamic mapList) {
    List<MsListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class VersionsListBean {
  String version;
  int movieEnum;

  static VersionsListBean fromMap(Map<String, dynamic> map) {
    VersionsListBean versionsListBean = new VersionsListBean();
    versionsListBean.version = map['version'];
    versionsListBean.movieEnum = map['enum'];
    return versionsListBean;
  }

  static List<VersionsListBean> fromMapList(dynamic mapList) {
    List<VersionsListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
