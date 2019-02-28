class MovieStillsEntity {
  List<ImageTypesListBean> imageTypes;
  List<MovieStills> images;

  static MovieStillsEntity fromMap(Map<String, dynamic> map) {
    MovieStillsEntity entity = new MovieStillsEntity();
    entity.imageTypes = ImageTypesListBean.fromMapList(map['imageTypes']);
    entity.images = MovieStills.fromMapList(map['images']);
    return entity;
  }

  static List<MovieStillsEntity> fromMapList(dynamic mapList) {
    List<MovieStillsEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class ImageTypesListBean {
  String typeName;
  int type;

  static ImageTypesListBean fromMap(Map<String, dynamic> map) {
    ImageTypesListBean imageTypesListBean = new ImageTypesListBean();
    imageTypesListBean.typeName = map['typeName'];
    imageTypesListBean.type = map['type'];
    return imageTypesListBean;
  }

  static List<ImageTypesListBean> fromMapList(dynamic mapList) {
    List<ImageTypesListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class MovieStills {
  String image;
  String imageSubtypeDes;
  int id;
  int type;
  int approveStatus;
  int imageSubtype;

  static MovieStills fromMap(Map<String, dynamic> map) {
    MovieStills imagesListBean = new MovieStills();
    imagesListBean.image = map['image'];
    imagesListBean.imageSubtypeDes = map['imageSubtypeDes'];
    imagesListBean.id = map['id'];
    imagesListBean.type = map['type'];
    imagesListBean.approveStatus = map['approveStatus'];
    imagesListBean.imageSubtype = map['imageSubtype'];
    return imagesListBean;
  }

  static List<MovieStills> fromMapList(dynamic mapList) {
    List<MovieStills> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
