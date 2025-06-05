import 'package:flutter/material.dart';
import 'package:marine_mobile/component/header.dart' show header;
import 'package:marine_mobile/shared/api_provider.dart';

import '../../component/key_search.dart';
import '../../component/tab_category.dart';
import '../../shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'news_list_vertical.dart';

class NewsList extends StatefulWidget {
  NewsList({super.key, this.title});

  final String? title;

  @override
  _NewsList createState() => _NewsList();
}

class _NewsList extends State<NewsList> {
  NewsListVertical? news;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    news = new NewsListVertical(
      site: "DDPM",
      model: postDio('${newsApi}read', {
        'skip': 0,
        'limit': _limit,
      }),
      url: '${service.newsApi}read',
      urlComment: '${service.newsCommentApi}read',
      urlGallery: '${service.newsGalleryApi}',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      news = new NewsListVertical(
        site: 'DDPM',
        model: postDio('${newsApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
        }),
        url: '${service.newsApi}read',
        urlGallery: '${service.newsGalleryApi}',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, goBack, title: 'ข่าวประกาศ'),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: const ClassicFooter(
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
            children: [
              SizedBox(height: 30),
              CategorySelector(
                model: service.postCategory(
                  '${service.newsCategoryApi}read',
                  {'skip': 0, 'limit': 100, 'code': '20241028102515-482-400'},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: postDio('${newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch
                        }),
                        url: '${service.newsApi}read',
                        urlGallery: '${service.newsGalleryApi}',
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 5),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: postDio('${newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                        }),
                        url: '${service.newsApi}read',
                        urlGallery: '${service.newsGalleryApi}',
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              news!,
            ],
          ),
        ),
      ),
    );
  }
}
