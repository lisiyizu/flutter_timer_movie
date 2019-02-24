import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_movie/application.dart';
import 'package:flutter_timer_movie/entities/movie_on_entity.dart';
import 'package:flutter_timer_movie/networks/http_utils.dart';
import 'package:flutter_timer_movie/networks/network_configs.dart';
import 'package:flutter_timer_movie/resource.dart';
import 'package:flutter_timer_movie/utils/logger.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MovieOnPage extends StatefulWidget {
  @override
  _MovieOnPageState createState() => _MovieOnPageState();
}

class _MovieOnPageState extends State<MovieOnPage> with AutomaticKeepAliveClientMixin {
  final _logger = Logger('MovieOnPage');
  var _movies = <MsListBean>[];
  var _isLoading = false;
  var _showBackTop = false;
  ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _request();

    _scrollController.addListener(() {
      setState(() => _showBackTop = _scrollController.position.pixels >= window.physicalSize.height * 0.3);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MovieOnPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _request({bool isRefresh = false}) async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      var movieData = await _requestMovies(290);

      setState(() {
        _isLoading = false;
        if (isRefresh) _movies.clear();
        _movies.addAll(movieData.ms);
      });
    }
  }

  Future<MovieOnEntity> _requestMovies(int locationId) async {
    Response response = await HttpUtils.instance.get(NetworkConfigs.movieOn, params: {'locationId': locationId});
    return response == null ? null : MovieOnEntity.fromMap(response.data);
  }

  Widget _buildMovieItem(BuildContext context, int index, Color color) {
    MsListBean movie = _movies[index];

    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: InkWell(
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: _movieWidget(movie, color),
              ),
            ),
            onTap: () {},
          )),
    );
  }

  Widget _movieWidget(MsListBean movie, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// 剧照
        CachedNetworkImage(
          imageUrl: movie.img,
          width: 70.0,
          height: 110.0,
          fit: BoxFit.contain,
          placeholder: (context, string) =>
              Container(height: 110.0, width: 70.0, alignment: Alignment.center, child: CupertinoActivityIndicator()),
          errorWidget: (context, string, e) =>
              Container(height: 110.0, width: 70.0, alignment: Alignment.center, child: Image.asset(Resource.imageFail)),
        ),

        /// 影片信息
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(movie.tCn,
                  style: TextStyle(fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(children: <Widget>[
                    SmoothStarRating(
                        starCount: 5,
                        rating: movie.r / 2,
                        color: Colors.deepOrange,
                        size: 12.0,
                        borderColor: Colors.deepOrange),
                    Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(movie.r == -1.0 ? '暂无评分' : '${movie.r}分', style: TextStyle(fontSize: 10.0)))
                  ])),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('导演: ${movie.dN}', style: TextStyle(fontSize: 10.0), overflow: TextOverflow.ellipsis)),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child:
                      Text('主演: ${movie.actors}', style: TextStyle(fontSize: 10.0), overflow: TextOverflow.ellipsis)),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('简介: ${movie.commonSpecial.isEmpty ? '暂无' : movie.commonSpecial}',
                      style: TextStyle(fontSize: 10.0), overflow: TextOverflow.ellipsis)),
              Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child:
                      Text('分类: ${movie.movieType}', style: TextStyle(fontSize: 10.0), overflow: TextOverflow.ellipsis))
            ],
          ),
        )),

        /// 查看详情
        DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)), border: Border.all(width: 1.0, color: color)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              child: Text('查看\n详情', style: TextStyle(fontSize: 12.0, color: color))),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, color) => Theme(
            data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
            child: Scaffold(
              body: Container(
                alignment: Alignment.center,
                child: _movies.isEmpty
                    ? CupertinoActivityIndicator(
                        radius: 12.0,
                      )
                    : RefreshIndicator(
                        child: ListView.builder(
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => _buildMovieItem(context, index, color),
                            itemCount: _movies.length),
                        onRefresh: () async {
                          await _request(isRefresh: true);
                          return null;
                        }),
              ),
              floatingActionButton: !_showBackTop
                  ? null
                  : FloatingActionButton(
                      mini: true,
                      child: Icon(Icons.vertical_align_top),
                      onPressed: () {
                        _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                      }),
            )));
  }
}
