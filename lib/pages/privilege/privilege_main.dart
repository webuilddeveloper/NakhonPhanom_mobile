import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:marine_mobile/component/link_url_out.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../component/header.dart';
import '../../home_v2.dart';
import '../../component/key_search.dart';
import '../../shared/api_provider.dart';

import '../main_popup/dialog_main_popup.dart';
import 'list_content_horizontal_privilege.dart';
import 'list_content_horizontal_privlege_suggested.dart';
import 'privilege_form.dart';
import 'privilege_list.dart';
import 'privilege_list_vertical.dart';

class PrivilegeMain extends StatefulWidget {
  PrivilegeMain({super.key, this.title, this.fromPolicy});
  final String? title;
  final bool? fromPolicy;

  @override
  _PrivilegeMain createState() => _PrivilegeMain();
}

class _PrivilegeMain extends State<PrivilegeMain> {
  final storage = new FlutterSecureStorage();

  PrivilegeList? privilegeList;
  PrivilegeListVertical? gridView;
  bool hideSearch = true;
  Future<dynamic>? _futurePromotion;
  // Future<dynamic> _futurePrivilegeCategory;
  Future<dynamic>? _futureForceAds;

  List<dynamic> listData = [];
  List<dynamic> category = [];
  bool isMain = true;
  String categorySelected = '';
  String keySearch = '';
  bool isHighlight = false;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _futurePromotion = post(
        '${privilegeApi}read', {'skip': 0, 'limit': 10, 'isHighlight': true});

    _futureForceAds = post('${forceAdsApi}read', {'skip': 0, 'limit': 10});
    categoryRead();
    getForceAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, goBack, title: widget.title!),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
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
              children: [
                SizedBox(
                  height: 5.0,
                ),
                tabCategory(),
                SizedBox(
                  height: 10.0,
                ),
                KeySearch(
                  show: hideSearch,
                  onKeySearchChange: (String val) {
                    setState(() {
                      keySearch = val;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                keySearch == ''
                    ? isMain
                        ? ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(), // 2nd
                            children: [
                              ListContentHorizontalPrivilegeSuggested(
                                title: 'แนะนำ',
                                url: knowledgeApi,
                                model: _futurePromotion,
                                urlComment: '',
                                navigationList: () {
                                  setState(() {
                                    keySearch = '';
                                    isMain = false;
                                    categorySelected = '';
                                  });
                                },
                                navigationForm: (
                                  String code,
                                  dynamic model,
                                ) {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => PrivilegeForm(
                                  //       code: code,
                                  //       model: model,
                                  //     ),
                                  //   ),
                                  // );
                                  launchURL('${model['linkUrl']}');
                                },
                              ),
                              for (int i = 0; i < listData.length; i++)
                                ListContentHorizontalPrivilege(
                                  code: category[i]['code'],
                                  title: category[i]['title'],
                                  model: listData[i],
                                  navigationList: () {
                                    setState(() {
                                      keySearch = '';
                                      isMain = false;
                                      categorySelected = category[i]['code'];
                                    });
                                  },
                                  navigationForm: (
                                    String code,
                                    dynamic model,
                                  ) {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => PrivilegeForm(
                                    //       code: code,
                                    //       model: model,
                                    //     ),
                                    //   ),
                                    // );
                                    launchURL('${model['linkUrl']}');
                                  },
                                ),
                            ],
                          )
                        : reloadList()
                    : reloadList(),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showForceAds() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);

    var valueStorage = await storage.read(key: 'privilegeDDPM');
    var dataValue;
    if (valueStorage != null) {
      dataValue = json.decode(valueStorage);
    } else {
      dataValue = null;
    }

    var now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    if (dataValue != null) {
      var index = dataValue.indexWhere(
        (c) =>
            c['username'] == user['username'] &&
            c['date'] == DateFormat("ddMMyyyy").format(date).toString() &&
            c['boolean'] == "true",
      );

      if (index == -1) {
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return MainPopupDialog(
              model: _futureForceAds,
              type: 'privilege',
              username: user['username'],
            );
          },
        );
      }
    } else {
      return showDialog(
        barrierDismissible: false, // close outside
        context: context,
        builder: (_) {
          return MainPopupDialog(
            model: _futureForceAds,
            type: 'privilege',
            username: user['username'],
          );
        },
      );
    }
  }

  getForceAds() async {
    var result = await post('${forceAdsApi}read', {'skip': 0, 'limit': 100});
    if (result.length > 0) {
      showForceAds();
    }
  }

  Future<dynamic> categoryRead() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 999 // integer value type
    });
    var response = await http.post(Uri.parse(privilegeCategoryApi + 'read'),
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });

    var data = json.decode(response.body);
    setState(() {
      category = data['objectData'];
    });

    if (category.length > 0) {
      for (int i = 0; i <= category.length - 1; i++) {
        var res = post('${privilegeApi}read',
            {'skip': 0, 'limit': 10, 'category': category[i]['code']});
        listData.add(res);
      }
    }
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      gridView = new PrivilegeListVertical(
        site: 'CIO',
        model: post('${privilegeApi}read', {
          'skip': 0,
          'limit': _limit,
        }),
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  reloadList() {
    return gridView = new PrivilegeListVertical(
      site: 'DDPM',
      model: post('${privilegeApi}read', {
        'skip': 0,
        'limit': _limit,
        'keySearch': keySearch != null ? keySearch : '',
        'isHighlight': isHighlight != null ? isHighlight : false,
        'category': categorySelected != null ? categorySelected : ''
      }),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  tabCategory() {
    return FutureBuilder<dynamic>(
      future: postCategory(
        '${privilegeCategoryApi}read',
        {'skip': 0, 'limit': 100},
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (snapshot.data[index]['code'] != '') {
                      setState(() {
                        keySearch = '';
                        isMain = false;
                        isHighlight = false;
                        categorySelected = snapshot.data[index]['code'];
                      });
                    } else {
                      setState(() {
                        isHighlight = true;
                        categorySelected = '';
                        isMain = true;
                      });
                    }
                    setState(() {
                      categorySelected = snapshot.data[index]['code'];
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: TextStyle(
                        color: categorySelected == snapshot.data[index]['code']
                            ? Colors.black
                            : Colors.grey,
                        decoration:
                            categorySelected == snapshot.data[index]['code']
                                ? TextDecoration.underline
                                : null,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
