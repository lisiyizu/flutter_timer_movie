import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_movie/locale/app_localizations.dart';

import '../application.dart';
import '../locale/app_localizations.dart';
import '../pages/movie_coming_page.dart';
import '../pages/movie_on_page.dart';
import '../resource.dart';
import '../utils/logger.dart';

class MoviePage extends StatefulWidget {
  final title;

  MoviePage({Key key, @required this.title}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> with SingleTickerProviderStateMixin {
  final _logger = Logger('MoviePage');

//  var _tabTitle = ['正在热播', '即将上映'];
  var _moviePages = <Widget>[];
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _moviePages..add(MovieOnPage())..add(MovieComingPage());
    _tabController = TabController(length: _moviePages.length, vsync: this);
    _pageController = PageController(initialPage: 0);

    _tabController.addListener(() {
      //绑定 tabView 和 pageView 一起滚动
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(_tabController.index,
            duration: Duration(milliseconds: 300), curve: Curves.decelerate);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _tabTitle = [
      AppLocalizations.of(context).text('hot_casting'),
      AppLocalizations.of(context).text('coming_soon')
    ];
    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, color) => Theme(
              data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
              child: Scaffold(
                appBar: AppBar(
                  actions: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                            child: Row(children: <Widget>[
                              Icon(Icons.location_on, size: 20.0),
                              Text('北京', style: TextStyle(fontSize: 12.0))
                            ]),
                            onTap: () {}))
                  ],
                  title: Text(AppLocalizations.of(context).text('home_title'),
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: Resource.fontFamilyDancingScript,
                      )),
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: color,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: List.generate(_tabTitle.length, (index) => Tab(text: _tabTitle[index])),
                  ),
                ),
                body: Container(
                  child: PageView(
                    controller: _pageController,
                    children: _moviePages,
                    onPageChanged: (value) => _tabController.animateTo(value,
                        duration: Duration(milliseconds: 300), curve: Curves.decelerate),
                  ),
                ),
              ),
            ));
  }
}
