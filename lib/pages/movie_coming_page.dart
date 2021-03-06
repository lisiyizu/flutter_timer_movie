import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application.dart';
import '../entities/movie_coming_entity.dart';
import '../networks/http_utils.dart';
import '../networks/network_configs.dart';
import '../resource.dart';
import '../routers/routers.dart';
import '../utils/convert_utils.dart';
import '../utils/logger.dart';

class MovieComingPage extends StatefulWidget {
  @override
  _MovieComingPageState createState() => _MovieComingPageState();
}

class _MovieComingPageState extends State<MovieComingPage> with AutomaticKeepAliveClientMixin {
  final _logger = Logger('MovieComingPage');
  var _allInfo = [];
  var _attentions = <MovieInfo>[];
  var _comings = <MovieInfo>[];
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

  _request({bool isRefresh = false}) async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      var movieData = await _requestMovies(290);

      setState(() {
        _allInfo.clear();

        if (isRefresh) {
          _attentions.clear();
          _comings.clear();
        }

        _attentions.addAll(movieData.attentions);
        _comings.addAll(movieData.comings);

        _allInfo
          ..add('最受关注')
          ..addAll(_attentions)
          ..add('即将上映')
          ..addAll(_comings);

        _isLoading = false;
      });
    }
  }

  Future<MovieComingsEntity> _requestMovies(int locationId) async {
    Response response = await HttpUtils.instance.get(NetworkConfigs.movieComing, params: {'locationId': locationId});
    return response == null
        ? null
        : MovieComingsEntity.fromMap((response.data is String) ? json.decode(response.data) : response.data) ?? null;
  }

  Widget _buildMovieItem(BuildContext context, int index, Color color) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: !(_allInfo[index] is MovieInfo)
                ? Text(
                    '${_allInfo[index]}',
                    style: TextStyle(fontSize: 20.0, color: color),
                  )
                : InkWell(
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _movieWidget(index, color),
                      ),
                    ),
                    onTap: () {
                      MovieInfo movie = _allInfo[index] as MovieInfo;

                      /// fluro 不支持直接传递中文，需要先编码再传递，获取后再解码
                      Application.router.navigateTo(
                          context, Routers.generateDetailPath(movie.id, ConvertUtils.fluroCnParamsEncode(movie.title)),
                          transition: TransitionType.fadeIn);
                    },
                  )));
  }

  Widget _movieWidget(int index, Color color) {
    var movie = _allInfo[index] as MovieInfo;
    var act = movie.actor1.isEmpty && movie.actor2.isEmpty
        ? '暂无'
        : movie.actor1.isEmpty ? movie.actor2 : movie.actor2.isEmpty ? movie.actor1 : '${movie.actor1}/${movie.actor2}';
    return ComingMovieWidget(movie: movie, act: act, color: color);
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
                  child: _attentions.isEmpty && _comings.isEmpty
                      ? CupertinoActivityIndicator()
                      : RefreshIndicator(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              controller: _scrollController,
                              itemCount: _allInfo.length,
                              itemBuilder: (context, index) {
                                return _buildMovieItem(context, index, color);
                              }),
                          onRefresh: () async {
                            _request(isRefresh: true);
                            return null;
                          })),
              floatingActionButton: !_showBackTop
                  ? null
                  : FloatingActionButton(
                      mini: true,
                      child: Icon(MovieIcons.back_top),
                      onPressed: () {
                        _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                      }),
            )));
  }
}

class ComingMovieWidget extends StatelessWidget {
  final MovieInfo movie;
  final String act;
  final Color color;

  ComingMovieWidget({Key key, @required this.movie, @required this.act, @required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        movie.image.isEmpty
            ? Image.asset(Resource.imageFail, width: 70.0, height: 90.0, fit: BoxFit.contain)
            : CachedNetworkImage(
                imageUrl: movie.image,
                width: 70.0,
                height: 90.0,
                fit: BoxFit.contain,
                placeholder: (context, string) => Container(
                    height: 90.0, width: 70.0, alignment: Alignment.center, child: CupertinoActivityIndicator()),
                errorWidget: (context, string, e) => Container(
                    height: 90.0, width: 70.0, alignment: Alignment.center, child: Image.asset(Resource.imageFail)),
              ),
        MovieIntroduce(movie: movie, act: act),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${movie.wantedCount}人想看',
                style: TextStyle(fontSize: 10.0, color: color), overflow: TextOverflow.ellipsis),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(width: 1.0, color: color)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                      child: Text('查看\n详情', style: TextStyle(fontSize: 12.0, color: color))),
                ))
          ],
        )
      ],
    );
  }
}

class MovieIntroduce extends StatelessWidget {
  final MovieInfo movie;
  final String act;

  MovieIntroduce({Key key, @required this.movie, @required this.act}) : super(key: key);

  Widget _buildIntroduceContent(String content) {
    return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(content, style: TextStyle(fontSize: 10.0), overflow: TextOverflow.ellipsis));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(movie.title,
              style: TextStyle(fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
          _buildIntroduceContent('导演: ${movie.director.isEmpty ? '暂无' : movie.director}'),
          _buildIntroduceContent('主演: $act'),
          _buildIntroduceContent('分类: ${movie.type}'),
          _buildIntroduceContent('${movie.releaseDate}')
        ],
      ),
    ));
  }
}
