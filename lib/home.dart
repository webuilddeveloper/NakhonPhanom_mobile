import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_mobile/component/carousel_rotation.dart';
import 'package:marine_mobile/pages/coming_soon.dart';
import 'package:marine_mobile/pages/otop_product_list.dart';
import 'package:marine_mobile/pages/welfare_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'component/carousel_banner.dart';
import 'component/carousel_form.dart';
import 'component/link_url_in.dart';
import 'login.dart';
import 'pages/blank_page/blank_loading.dart';
import 'pages/blank_page/toast_fail.dart';
import 'pages/main_popup/dialog_main_popup.dart';
import 'pages/news/news_form.dart';
import 'pages/news/news_list.dart';
import 'shared/api_provider.dart';
import 'package:intl/intl.dart';
// import 'package:marine_mobile/pages/about_us/about_us_form.dart';
// import 'package:marine_mobile/pages/complain/complain.dart';
// import 'package:marine_mobile/pages/license/check_license_list_category.dart';
// import 'package:marine_mobile/pages/my_qr_code.dart';
// import 'package:marine_mobile/pages/question/question_list.dart';
// import 'package:marine_mobile/pages/training_course/training_course_list_category.dart';

// import 'package:marine_mobile/component/material/check_avatar.dart';
// import 'package:marine_mobile/pages/license/renew_license.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'pages/knowledge/knowledge_list.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key, this.changePage});

  Function? changePage;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  DateTime? currentBackPressTime;

  Future<dynamic>? _futureBanner = Future.value();
  Future<dynamic>? _futureNews = Future.value();
  Future<dynamic>? _futureRotation = Future.value();

  Future<dynamic>? _futureProfile;

  Future<dynamic>? _futureMainPopUp;

  String profileCode = '';
  String currentLocation = '-';
  final seen = <String>{};
  List unique = [];
  List imageLv0 = [];

  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;
  bool checkDirection = false;

  final RefreshController _refreshController = RefreshController(
      initialRefresh: false,
      initialRefreshStatus: RefreshStatus.idle,
      initialLoadStatus: LoadStatus.idle);

  LatLng latLng = const LatLng(13.743989326935178, 100.53754006134743);

  int _currentNewsPage = 0;
  final int _newsLimit = 4;
  List<dynamic> _newsList = [];
  bool _hasMoreNews = true;

  @override
  void initState() {
    _newsList = [];
    _read();
    currentBackPressTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        child: _buildBackground(),
        onWillPop: confirmExit,
      ),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context,
        text: 'กดอีกครั้งเพื่อออก',
        color: Colors.black,
        fontColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _buildBackground() {
    return Container(
      // decoration: BoxDecoration(
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        // overScroll.disallowGlow();
        overScroll.disallowIndicator();
        return false;
      },
      child: _buildSmartRefresher(),
    );
  }

  _buildSmartRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const ClassicHeader(),
      footer: const ClassicFooter(),
      physics: const BouncingScrollPhysics(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
        padding: EdgeInsets.zero, // ลบ padding ที่อาจทำให้เกิดช่องว่าง
        children: [
          _buildHeader(),
          _buildbody(),
          const SizedBox(height: 20),
          _buildRotation(),
          const SizedBox(height: 20),
          _buildNews(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  _buildHeader() {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: screenHeight * 0.45,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: _buildBanner(),
            ),
          ),
          Positioned(
            top: screenHeight * 0.45 - 40,
            left: 12,
            right: 12,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComingSoon(),
                  ),
                );
              },
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFe7b014), Color(0xFFfad84c)],
                      stops: [0.0, 0.9]),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.white,
                      size: 42,
                    ),
                    // SizedBox(width: 10),
                    Text(
                      'แหล่งท่องเที่ยว',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildbody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ComingSoon(),
                //   ),
                // );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtopProductListPage(),
                  ),
                );
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF9e6e19), Color(0xFFe7b014)],
                      stops: [0.0, 0.9]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      'สินค้า OTOP',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ComingSoon(),
                //   ),
                // );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelfareListPage(),
                  ),
                );
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF9e6e19), Color(0xFFe7b014)],
                      stops: [0.0, 0.9]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wallet_giftcard_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      'สวัสดิการ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBanner() {
    return CarouselRotation(
      model: _futureBanner,
      nav: (String path, String action, dynamic model, String code) {
        if (action == 'out') {
          // launchInWebViewWithJavaScript(path);
          // launchURL(path);
          launchUrl(Uri.parse(path));
        } else if (action == 'in') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarouselForm(
                code: code,
                model: model,
                url: mainBannerApi,
                urlGallery: bannerGalleryApi,
              ),
            ),
          );
        }
      },
    );
  }

  _buildRotation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CarouselBanner(
        model: _futureRotation,
        nav: (String path, String action, dynamic model, String code,
            String urlGallery) {
          if (action == 'out') {
            launchInWebViewWithJavaScript(path);
          } else if (action == 'in') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarouselForm(
                  code: code,
                  model: model,
                  url: mainBannerApi,
                  urlGallery: bannerGalleryApi,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _buildNews() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ข่าวประกาศ',
                style: TextStyle(
                  color: Color(0xFFbf9000),
                  fontSize: 20.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsList(
                        title: 'ข่าวประชาสัมพันธ์',
                      ),
                    ),
                  );
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ดูทั้งหมด',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF27544F),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 17,
                      color: Color(0XFF27544F),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          FutureBuilder<dynamic>(
            future: _futureNews,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data.length > 0) {
                  if (_currentNewsPage == 0) {
                    _newsList = snapshot.data; // หน้าแรก - แทนที่
                  }
                }
                print('=============futureNews===============');
                print(snapshot.data);
                return Center(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemCount: _newsList.length,
                    itemBuilder: (context, index) {
                      var data = _newsList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsForm(
                                url: data['url'] ?? '',
                                code: data['code'] ?? '',
                                model: data ?? '',
                                urlComment: newsApi,
                                urlGallery: newsGalleryApi,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.transparent,
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(14),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(14),
                                      ),
                                      child: data['imageUrl'] != null &&
                                              data['imageUrl']
                                                  .toString()
                                                  .isNotEmpty
                                          ? Image.network(
                                              data['imageUrl'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : BlankLoading(
                                              height: double.infinity,
                                              width: double.infinity,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(14),
                                      bottomRight: Radius.circular(14),
                                    ),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${data['title']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Sarabun',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return BlankLoading(
                  width: null,
                  height: null,
                );
              } else {
                return const Center(
                  child: Text(
                    'ไม่พบข้อมูล',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  _read() async {
    _getLocation();

    _futureBanner = postDio('${mainBannerApi}read', {
      'skip': 0,
      'limit': 10,
    });
    _futureNews = postDio('${newsApi}read', {
      'skip': _currentNewsPage * _newsLimit,
      'limit': _newsLimit,
    });
    _futureRotation = postDio('${rotationApi}read', {
      'skip': 0,
      'limit': 10,
    });
    //  Future<dynamic>? _futureRotation = Future.value();

    _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});

    //read profile
    profileCode = (await storage.read(key: 'profileCode2'))!;
    if (profileCode != '') {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _onLoading() async {
    if (!_hasMoreNews) {
      _refreshController.loadComplete();
      return;
    }
    _currentNewsPage++;
    final moreNews = await postDio('${newsApi}read', {
      'skip': _currentNewsPage * _newsLimit,
      'limit': _newsLimit,
    });
    if (moreNews != null && moreNews.length < _newsLimit) {
      _hasMoreNews = false;
    }
    if (moreNews == null || moreNews.isEmpty) {
      _hasMoreNews = false;
      _refreshController.loadNoData();
      return;
    }
    setState(() {
      if (_newsList.isEmpty) {
        _newsList = moreNews;
      } else {
        _newsList.addAll(moreNews);
      }
    });
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    _currentNewsPage = 0;
    _hasMoreNews = true; // รีเซ็ตค่านี้เพื่อให้สามารถโหลดเพิ่มได้

    try {
      var newsData = await postDio('${newsApi}read', {
        'skip': 0,
        'limit': _newsLimit,
        'app': 'marine',
      });

      setState(() {
        _newsList = newsData ?? []; // ป้องกันกรณี null
        print("รีเฟรชข้อมูลเสร็จสิ้น: ${_newsList.length} รายการ");
      });

      // ตรวจสอบว่ายังมีข้อมูลเพิ่มเติมหรือไม่
      if (newsData == null || newsData.length < _newsLimit) {
        _hasMoreNews = false;
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการรีเฟรช: $e");
    }

    _refreshController.refreshCompleted();
  }

  getMainPopUp() async {
    var result =
        await post('${mainPopupHomeApi}read', {'skip': 0, 'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupDDPM');
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
              // c['username'] == userData.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          this.setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false, // close outside
            context: context,
            builder: (_) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: MainPopupDialog(
                  model: _futureMainPopUp!,
                  type: 'mainPopup',
                ),
              );
            },
          );
        } else {
          this.setState(() {
            hiddenMainPopUp = true;
          });
        }
      } else {
        this.setState(() {
          hiddenMainPopUp = false;
        });
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureMainPopUp!,
                type: 'mainPopup',
              ),
            );
          },
        );
      }
    }
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      currentLocation = placemarks.first.administrativeArea!;
    });
  }
}
