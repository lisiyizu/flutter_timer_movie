import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application.dart';
import '../bloc/theme_bloc.dart';
import '../locale/app_localizations.dart';
import '../utils/preference_utils.dart';

class ThemePage extends StatelessWidget {
  Widget _buildGridItem(context, index) => InkWell(
        child: Container(color: Application.themeColors[index]),
        onTap: () {
          Application.themeBloc.dispatch(ThemeEvent(Application.themeColors[index]));
          PreferencesUtil.saveInteger(Application.themeIndexKey, index);
        },
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (_, color) => Theme(
            data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).text('theme')),
              ),
              body: Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    ///
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(AppLocalizations.of(context).text('current_theme'),
                                  style: TextStyle(fontSize: 20.0, color: color))),
                          Container(color: color, width: 40.0, height: 40.0)
                        ],
                      ),
                    )),

                    ///
                    SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        sliver: SliverGrid(
                            delegate:
                                SliverChildBuilderDelegate(_buildGridItem, childCount: Application.themeColors.length),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, mainAxisSpacing: 20.0, crossAxisSpacing: 20.0)))
                  ],
                ),
              ),
            )));
  }
}
