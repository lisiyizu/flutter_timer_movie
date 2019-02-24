import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_movie/application.dart';
import 'package:flutter_timer_movie/utils/logger.dart';

class MovieDetail extends StatefulWidget {
  final int movieId;
  final String movieName;

  MovieDetail({Key key, @required this.movieId, @required this.movieName}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final _logger = Logger('MovieDetail');

  @override
  void initState() {
    super.initState();
    _logger.log('${widget.movieId}-${widget.movieName}');
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, color) => Theme(
            data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.movieName),
              ),
              body: Container(),
            )));
  }
}
