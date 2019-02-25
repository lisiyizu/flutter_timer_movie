class CommentEntity {
  String code;
  String msg;
  String showMsg;
  CommentBean data;

  static CommentEntity fromMap(Map<String, dynamic> map) {
    CommentEntity temp = new CommentEntity();
    temp.code = map['code'];
    temp.msg = map['msg'];
    temp.showMsg = map['showMsg'];
    temp.data = CommentBean.fromMap(map['data']);
    return temp;
  }

  static List<CommentEntity> fromMapList(dynamic mapList) {
    List<CommentEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class CommentBean {
  MiniComment mini;
  PlusComment plus;

  static CommentBean fromMap(Map<String, dynamic> map) {
    CommentBean dataBean = new CommentBean();
    dataBean.mini = MiniComment.fromMap(map['mini']);
    dataBean.plus = PlusComment.fromMap(map['plus']);
    return dataBean;
  }

  static List<CommentBean> fromMapList(dynamic mapList) {
    List<CommentBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class MiniComment {
  int total;
  List<MiniDetail> list;

  static MiniComment fromMap(Map<String, dynamic> map) {
    MiniComment miniBean = new MiniComment();
    miniBean.total = map['total'];
    miniBean.list = MiniDetail.fromMapList(map['list']);
    return miniBean;
  }

  static List<MiniComment> fromMapList(dynamic mapList) {
    List<MiniComment> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class PlusComment {
  int total;
  List<PlusDetail> list;

  static PlusComment fromMap(Map<String, dynamic> map) {
    PlusComment plusBean = new PlusComment();
    plusBean.total = map['total'];
    plusBean.list = PlusDetail.fromMapList(map['list']);
    return plusBean;
  }

  static List<PlusComment> fromMapList(dynamic mapList) {
    List<PlusComment> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class MiniDetail {
  String content;
  String headImg;
  String img;
  String locationName;
  String nickname;
  bool isHot;
  bool isPraise;
  int commentDate;
  int commentId;
  int praiseCount;
  double rating;
  int replyCount;

  static MiniDetail fromMap(Map<String, dynamic> map) {
    MiniDetail temp = new MiniDetail();
    temp.content = map['content'];
    temp.headImg = map['headImg'];
    temp.img = map['img'];
    temp.locationName = map['locationName'];
    temp.nickname = map['nickname'];
    temp.isHot = map['isHot'];
    temp.isPraise = map['isPraise'];
    temp.commentDate = map['commentDate'];
    temp.commentId = map['commentId'];
    temp.praiseCount = map['praiseCount'];
    temp.rating = map['rating'] + 0.0;
    temp.replyCount = map['replyCount'];
    return temp;
  }

  static List<MiniDetail> fromMapList(dynamic mapList) {
    List<MiniDetail> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class PlusDetail {
  String content;
  String headImg;
  String locationName;
  String nickname;
  String title;
  bool isWantSee;
  int commentDate;
  int commentId;
  double rating;
  int replyCount;

  static PlusDetail fromMap(Map<String, dynamic> map) {
    PlusDetail temp = new PlusDetail();
    temp.content = map['content'];
    temp.headImg = map['headImg'];
    temp.locationName = map['locationName'];
    temp.nickname = map['nickname'];
    temp.title = map['title'];
    temp.isWantSee = map['isWantSee'];
    temp.commentDate = map['commentDate'];
    temp.commentId = map['commentId'];
    temp.rating = map['rating'] + 0.0;
    temp.replyCount = map['replyCount'];
    return temp;
  }

  static List<PlusDetail> fromMapList(dynamic mapList) {
    List<PlusDetail> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
