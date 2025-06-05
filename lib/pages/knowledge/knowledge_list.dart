import 'package:flutter/material.dart';
import 'package:marine_mobile/component/header.dart';
import 'package:marine_mobile/shared/api_provider.dart' as service;

import 'knowledge_list_vertical.dart' as grid;

import 'package:pull_to_refresh/pull_to_refresh.dart';

class KnowledgeList extends StatefulWidget {
  const KnowledgeList({super.key, this.title});
  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgeList createState() => _KnowledgeList();
}

class _KnowledgeList extends State<KnowledgeList> {
  grid.KnowledgeListVertical? gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String? keySearch;
  String? category;
  int _limit = 10;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    gridView = grid.KnowledgeListVertical(
      site: 'DDPM',
      model: service
          .post('${service.knowledgeApi}read', {'skip': 0, 'limit': _limit}),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      gridView = new grid.KnowledgeListVertical(
        site: 'DDPM',
        model: service.post('${service.knowledgeApi}read', {
          'skip': 0,
          'limit': _limit,
          'category': category,
          "keySearch": keySearch
        }),
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(
        context,
        goBack,
        title: 'คลังความรู้',
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: const ClassicFooter(
            loadingText: ' ',
            canLoadingText: ' ',
            idleText: ' ',
            idleIcon: Icon(
              Icons.arrow_upward,
              color: Colors.transparent,
            ),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 10.0),
              gridView!,
            ],
          ),
        ),
      ),
    );
  }
}
