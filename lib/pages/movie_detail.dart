import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_movie/entities/movie_stills_entity.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../application.dart';
import '../entities/comment_entity.dart';
import '../entities/movie_detail_entity.dart';
import '../networks/http_utils.dart';
import '../networks/network_configs.dart';
import '../resource.dart';
import '../utils/logger.dart';

typedef void CategoryGuideAction();

class MovieDetail extends StatefulWidget {
  final int movieId;
  final String movieName;

  MovieDetail({Key key, @required this.movieId, @required this.movieName}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final _logger = Logger('MovieDetail');
  DetailBean _detail;
  var _miniComments = <MiniDetail>[];
  var _plusComments = <PlusDetail>[];
  var _stillsList = <MovieStills>[];

  @override
  void initState() {
    super.initState();
    _requestDetail();
    _requestCommentDetail();
    _requestStillsDetail();
    _logger.log('movieId => ${widget.movieId}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(MovieDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _requestDetail() async {
    var movieDetail = await _requestMovie(290);
    setState(() => _detail = movieDetail.data);
  }

  _requestCommentDetail() async {
    var comments = await _requestComments();
    setState(() {
      _miniComments.clear();
      _plusComments.clear();
      _miniComments.addAll(comments.data.mini.list);
      _plusComments.addAll(comments.data.plus.list);
    });
  }

  _requestStillsDetail() async {
    var stills = await _requestStills();
    setState(() {
      _stillsList.clear();
      _stillsList.addAll(stills.images);
    });
  }

  Future<MovieDetailEntity> _requestMovie(int locationId) async {
    Response response = await HttpUtils.instance
        .get(NetworkConfigs.movieDetail, params: {'locationId': locationId, 'movieId': widget.movieId});
    return response == null
        ? null
        : MovieDetailEntity.fromMap((response.data is String) ? json.decode(response.data) : response.data) ?? null;
  }

  Future<CommentEntity> _requestComments() async {
    Response response = await HttpUtils.instance.get(NetworkConfigs.movieComment, params: {'movieId': widget.movieId});
    return response == null
        ? null
        : CommentEntity.fromMap((response.data is String) ? json.decode(response.data) : response.data) ?? null;
  }

  Future<MovieStillsEntity> _requestStills() async {
    Response response = await HttpUtils.instance.get(NetworkConfigs.movieStills, params: {'movieId': widget.movieId});

    /// 后台返回数据的问题，解析前先通过 json.decode 解码
    return response == null
        ? null
        : MovieStillsEntity.fromMap((response.data is String) ? json.decode(response.data) : response.data) ?? null;
  }

  /// 演员
  Widget _buildActorItems(int index, Color color) {
    var actor = index != 0 ? _detail.basic.actors[index - 1] : null;
    return Container(
        child: index == 0
            ? Text('演\n员', style: TextStyle(color: color, fontSize: 14.0))
            : Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: PersonIntroduce(
                    image: actor.img,
                    name: actor.name.isNotEmpty ? actor.name : actor.nameEn,
                    desc: actor.roleName.isNotEmpty ? '饰${actor.roleName}' : null),
              ));
  }

  /// 短评
  Widget _buildMiniCommentItems(BuildContext context, int index) {
    var detail = _miniComments[index];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: CommentWidget(
            nick: detail.nickname,
            ava: detail.headImg,
            date: detail.commentDate,
            rate: detail.rating,
            content: detail.content));
  }

  /// 精选
  Widget _buildPlusCommentItems(BuildContext context, int index) {
    var detail = _plusComments[index];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: CommentWidget(
            nick: detail.nickname,
            ava: detail.headImg,
            date: detail.commentDate,
            rate: detail.rating,
            content: detail.content));
  }

  @override
  Widget build(BuildContext context) {
    if (_stillsList.length > 10) _stillsList.removeRange(10, _stillsList.length);

    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, color) => Theme(
            data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
            child: Scaffold(
              appBar: _detail == null ? AppBar(title: Text(widget.movieName)) : null,
              body: Container(
                alignment: Alignment.center,
                child: _detail == null
                    ? CupertinoActivityIndicator(radius: 12.0)
                    : CustomScrollView(
                        slivers: <Widget>[
                          /// 影片背景图片
                          SliverAppBar(
                              title: Text(_detail.basic.name),
                              expandedHeight: 350.0,
                              backgroundColor: color,
                              flexibleSpace: FlexibleSpaceBar(
                                  background: CachedNetworkImage(
                                      imageUrl: _detail.basic.img,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width)),
                              pinned: true),

                          ///
                          MovieCategoryGuide(category: '演职员一览', color: color, guideAction: () {}),

                          SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              sliver: SliverToBoxAdapter(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('导\n演', style: TextStyle(color: color, fontSize: 14.0)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: PersonIntroduce(
                                            image: _detail.basic.director.img, name: _detail.basic.director.name))
                                  ],
                                ),
                              )),

                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            sliver: SliverToBoxAdapter(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      _detail.basic.actors.length + 1, (index) => _buildActorItems(index, color)),
                                ),
                              ),
                            ),
                          ),

                          ///
                          MovieCategoryGuide(category: '剧情简介', color: color, guideAction: () {}),
                          SliverPadding(
                              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
                              sliver: SliverToBoxAdapter(
                                  child: Text(_detail.basic.story, maxLines: 3, overflow: TextOverflow.ellipsis))),

                          ///
                          MovieCategoryGuide(category: '剧照', color: color, guideAction: () {}),
                          MovieStillsWidget(stillsList: _stillsList),

                          ///
                          MovieCategoryGuide(category: '精选短评', color: color, guideAction: () {}),
                          SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => _buildMiniCommentItems(context, index),
                                      childCount: _miniComments.length))),

                          ///
                          MovieCategoryGuide(category: '精选影评', color: color, guideAction: () {}),
                          SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => _buildPlusCommentItems(context, index),
                                      childCount: _plusComments.length)))
                        ],
                      ),
              ),
            )));
  }
}

/// 顶部分类导航
class MovieCategoryGuide extends StatelessWidget {
  final String category;
  final String actionText;
  final CategoryGuideAction guideAction;
  final Color color;

  MovieCategoryGuide({Key key, this.category, this.guideAction, this.color, this.actionText = '查看全部'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0, bottom: 4.0),
      sliver: SliverToBoxAdapter(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(category, style: TextStyle(color: color, fontSize: 16.0)),
          InkWell(
              onTap: guideAction,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(actionText, style: TextStyle(color: color, fontSize: 16.0)),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ))
        ],
      )),
    );
  }
}

/// 人物简介
class PersonIntroduce extends StatelessWidget {
  final String image;
  final String name;
  final String desc;

  PersonIntroduce({Key key, this.image, this.name, this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: image,
            width: 60.0,
            height: 80.0,
            fit: BoxFit.cover,
            placeholder: (context, string) =>
                Container(height: 80.0, width: 60.0, alignment: Alignment.center, child: CupertinoActivityIndicator()),
            errorWidget: (context, string, e) => Container(
                height: 80.0, width: 60.0, alignment: Alignment.center, child: Image.asset(Resource.imageFail)),
          ),
          Container(
              alignment: Alignment.center,
              width: 60.0,
              child:
                  Text(name, style: TextStyle(color: Colors.black87, fontSize: 10.0), overflow: TextOverflow.ellipsis)),
          desc == null || desc.isEmpty
              ? Container(width: 0, height: 0)
              : Container(
                  alignment: Alignment.center,
                  width: 60.0,
                  child:
                      Text(desc, style: TextStyle(color: Colors.grey, fontSize: 10.0), overflow: TextOverflow.ellipsis))
        ]);
  }
}

/// 剧照
class MovieStillsWidget extends StatelessWidget {
  final List<MovieStills> stillsList;

  MovieStillsWidget({Key key, this.stillsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      sliver: SliverToBoxAdapter(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                stillsList.length,
                (index) => GestureDetector(
                    child: Container(
                        height: 80.0,
                        width: 60.0,
                        child: CachedNetworkImage(
                          imageUrl: stillsList[index].image,
                          fit: BoxFit.scaleDown,
                          placeholder: (context, string) => CupertinoActivityIndicator(),
                          errorWidget: (context, string, e) => Image.asset(Resource.imageFail),
                        )),
                    onTap: () {})),
          ),
        ),
      ),
    );
  }
}

/// 评论
class CommentWidget extends StatelessWidget {
  final String nick;
  final String ava;
  final int date;
  final double rate;
  final String content;

  CommentWidget({Key key, this.nick, this.ava, this.date, this.rate, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(
          width: 30.0,
          height: 30.0,
          child: ClipOval(
            child: CachedNetworkImage(imageUrl: ava),
          )),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Row(children: <Widget>[
                  Text(nick),
                  Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: SmoothStarRating(
                          rating: rate / 2, color: Colors.deepOrange, borderColor: Colors.deepOrange, size: 10.0))
                ]),
                Text(content)
              ])))
    ]);
  }
}
