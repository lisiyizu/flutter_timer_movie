import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_movie/application.dart';
import 'package:flutter_timer_movie/pages/movie_coming_page.dart';
import 'package:flutter_timer_movie/pages/movie_on_page.dart';
import 'package:flutter_timer_movie/resource.dart';
import 'package:flutter_timer_movie/utils/logger.dart';

class MoviePage extends StatefulWidget {
  final title;

  MoviePage({Key key, @required this.title}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> with SingleTickerProviderStateMixin {
  final _logger = Logger('MoviePage');
  var _tabTitle = ['正在热播', '即将上映'];
  var _moviePages = <Widget>[];
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitle.length, vsync: this);
    _pageController = PageController(initialPage: 0);
    _moviePages..add(MovieOnPage())..add(MovieComingPage());

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
  void didUpdateWidget(MoviePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                  title: Text(widget.title,
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
