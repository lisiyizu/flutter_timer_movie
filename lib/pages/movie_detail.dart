import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../application.dart';
import '../entities/comment_entity.dart';
import '../entities/movie_detail_entity.dart';
import '../networks/http_utils.dart';
import '../networks/network_configs.dart';
import '../resource.dart';
import '../utils/logger.dart';

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

  @override
  void initState() {
    super.initState();
    _requestDetail();
    _requestCommentDetail();
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

  Future<MovieDetailEntity> _requestMovie(int locationId) async {
    Response response = await HttpUtils.instance
        .get(NetworkConfigs.movieDetail, params: {'locationId': locationId, 'movieId': widget.movieId});
    return response == null ? null : MovieDetailEntity.fromMap(response.data) ?? null;
  }

  Future<CommentEntity> _requestComments() async {
    Response response = await HttpUtils.instance.get(NetworkConfigs.movieComment, params: {'movieId': widget.movieId});
    return response == null ? null : CommentEntity.fromMap(response.data) ?? null;
  }

  Widget _buildPersonItem(String image, String name, String desc) {
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

  Widget _buildActorItems(int index, Color color) {
    var actor = index != 0 ? _detail.basic.actors[index - 1] : null;
    return Container(
        child: index == 0
            ? Text('演\n员', style: TextStyle(color: color, fontSize: 14.0))
            : Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildPersonItem(actor.img, actor.name.isNotEmpty ? actor.name : actor.nameEn,
                    actor.roleName.isNotEmpty ? '饰${actor.roleName}' : null),
              ));
  }

  Widget _buildComment(String nick, String ava, int date, double rate, String content) {
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

  Widget _buildMiniCommentItems(BuildContext context, int index) {
    var detail = _miniComments[index];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: _buildComment(detail.nickname, detail.headImg, detail.commentDate, detail.rating, detail.content));
  }

  Widget _buildPlusCommentItems(BuildContext context, int index) {
    var detail = _plusComments[index];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: _buildComment(detail.nickname, detail.headImg, detail.commentDate, detail.rating, detail.content));
  }

  @override
  Widget build(BuildContext context) {
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
                          ///
                          SliverAppBar(
                              title: Text(_detail.basic.name),
                              expandedHeight: 350.0,
                              backgroundColor: color,
                              flexibleSpace: FlexibleSpaceBar(
                                  background: CachedNetworkImage(imageUrl: _detail.basic.img, fit: BoxFit.cover)),
                              pinned: true),

                          ///
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 12.0, right: 12.0),
                            sliver: SliverToBoxAdapter(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('演职员一览', style: TextStyle(color: color, fontSize: 16.0)),
                                InkWell(
                                    onTap: () {},
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('查看全部', style: TextStyle(color: color, fontSize: 16.0)),
                                        Icon(Icons.keyboard_arrow_right)
                                      ],
                                    ))
                              ],
                            )),
                          ),

                          ///
                          SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              sliver: SliverToBoxAdapter(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('导\n演', style: TextStyle(color: color, fontSize: 14.0)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: _buildPersonItem(
                                            _detail.basic.director.img, _detail.basic.director.name, null))
                                  ],
                                ),
                              )),

                          ///
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
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('剧情简介', style: TextStyle(color: color, fontSize: 16.0)),
                                  Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(_detail.basic.story))
                                ],
                              ),
                            ),
                          ),

                          ///
                          SliverPadding(
                            padding: const EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0, bottom: 4.0),
                            sliver: SliverToBoxAdapter(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('精选短评', style: TextStyle(color: color, fontSize: 16.0)),
                                InkWell(
                                    onTap: () {},
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('查看全部', style: TextStyle(color: color, fontSize: 16.0)),
                                        Icon(Icons.keyboard_arrow_right)
                                      ],
                                    ))
                              ],
                            )),
                          ),

                          SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => _buildMiniCommentItems(context, index),
                                      childCount: _miniComments.length))),

                          ///
                          SliverPadding(
                            padding: const EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0, bottom: 4.0),
                            sliver: SliverToBoxAdapter(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('精选影评', style: TextStyle(color: color, fontSize: 16.0)),
                                InkWell(
                                    onTap: () {},
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('查看全部', style: TextStyle(color: color, fontSize: 16.0)),
                                        Icon(Icons.keyboard_arrow_right)
                                      ],
                                    ))
                              ],
                            )),
                          ),

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
