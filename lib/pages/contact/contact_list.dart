import 'package:flutter/material.dart';
import 'package:marine_mobile/component/header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../component/key_search.dart';
import '../../shared/api_provider.dart';

import 'contact_list_vertical.dart';

class ContactList extends StatefulWidget {
  ContactList({
    super.key,
    this.title,
    this.code,
  });

  final String? title;
  final String? code;

  @override
  _ContactList createState() => _ContactList();
}

class _ContactList extends State<ContactList> {
  ContactListVertical? contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<dynamic>? _futureContact;

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

    _futureContact = post('${contactApi}read', {
      'skip': 0,
      'limit': _limit,
    });

    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _futureContact = post('${contactApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': widget.code,
        'keySearch': keySearch
      });

      contact = new ContactListVertical(
        site: "DDPM",
        model: _futureContact,
        title: "",
        url: '${contactApi}read',
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
      appBar: header(context, goBack, title: widget.title ?? ''),
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
            idleIcon: Icon(
              Icons.arrow_upward,
              color: Colors.transparent,
            ),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(height: 10),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                      _futureContact = post('${contactApi}read', {
                        'skip': 0,
                        'limit': _limit,
                        'category': widget.code,
                        'keySearch': keySearch
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              ContactListVertical(
                site: "DDPM",
                model: _futureContact,
                title: "",
                url: '${contactApi}read',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
