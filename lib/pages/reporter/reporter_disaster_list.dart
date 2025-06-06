import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import 'reporter_disaster_list_vertical.dart';

class ReporterDisasterList extends StatefulWidget {
  ReporterDisasterList({super.key, this.title, this.username, this.category});

  final String? title;
  final String? username;
  final String? category;

  @override
  _ReporterDisasterList createState() => _ReporterDisasterList();
}

class _ReporterDisasterList extends State<ReporterDisasterList> {
  ReporterDisasterListVertical? reporterHistory;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);
    super.initState();
    reporterHistory = new ReporterDisasterListVertical(
      site: "DDPM",
      model: post('${reporterApi}read',
          {'skip': 0, 'limit': _limit, 'category': widget.category}),
      url: '${reporterApi}read',
      urlGallery: '${reporterGalleryApi}read',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      reporterHistory = new ReporterDisasterListVertical(
        site: 'DDPM',
        model: post('${reporterApi}read',
            {'skip': 0, 'limit': _limit, 'category': widget.category}),
        url: '${reporterApi}read',
        urlGallery: '${reporterGalleryApi}read',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, goBack, title: widget.title),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: ClassicFooter(
            loadingText: ' ',
            canLoadingText: ' ',
            idleText: ' ',
            idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // controller: _controller,
            children: [
              reporterHistory!,
            ],
          ),
        ),
      ),
    );
  }
}
