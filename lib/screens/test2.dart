import 'package:flutter/material.dart';
import 'package:mushafmuscat/widgets/audioplayer.dart';
import 'package:mushafmuscat/widgets/test3.dart';

import '../localization/app_localizations.dart';


class ScrollableFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
               Text(AppLocalizations.of(context)!
                                  .translate('tafsir_text')
                                  .toString()),
                                    Text(AppLocalizations.of(context)!
                                  .translate('tafsir_text')
                                  .toString()),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AudioPlayerWidget(),
          ),
        ],
      ),
    );
  }
}
