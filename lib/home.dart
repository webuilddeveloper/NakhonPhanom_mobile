// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_mobile/component/carousel_new.dart';
import 'package:marine_mobile/component/carousel_rotation.dart';
import 'package:marine_mobile/pages/complain/complain_detail.dart';
import 'package:marine_mobile/pages/contact/contact_list.dart';
import 'package:marine_mobile/pages/event_calendar/calendar.dart';
import 'package:marine_mobile/pages/event_calendar/event_calendar_list.dart';
import 'package:marine_mobile/pages/knowledge/knowledge_list.dart';
import 'package:marine_mobile/pages/news/news_form.dart';

import 'package:marine_mobile/pages/otop_product_list.dart';
import 'package:marine_mobile/pages/poi/poi_list.dart';
import 'package:marine_mobile/pages/privilege/privilege_main.dart';
import 'package:marine_mobile/pages/travel_list.dart';

import 'package:marine_mobile/pages/welfare_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'component/carousel_banner.dart';
import 'component/carousel_form.dart';
import 'component/link_url_in.dart';
import 'login.dart';

import 'pages/blank_page/toast_fail.dart';
import 'pages/main_popup/dialog_main_popup.dart';

import 'pages/news/news_list.dart';
import 'shared/api_provider.dart';
import 'package:intl/intl.dart';

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
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
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
      physics:
          const ClampingScrollPhysics(), // เปลี่ยนจาก BouncingScrollPhysics
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            _buildQuickAccess(),
            const SizedBox(height: 20),
            _buildRotation(),
            const SizedBox(height: 20),
            _buildService(),
            const SizedBox(height: 20),
            _buildNews(),
            const SizedBox(height: 20),
            _buildTravel(context),
            const SizedBox(height: 20),
            _buildEmergencySection(),
            const SizedBox(height: 50),
          ],
        ),
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
            top: screenHeight * 0.45 - 45,
            left: 12,
            right: 12,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoiList(
                        title: '',
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFf59e0b),
                        Color(0xFFfbbf24),
                        Color(0xFFfcd34d),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFf59e0b).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.white,
                        size: 35,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'แหล่งท่องเที่ยว',
                        style: const TextStyle(
                          fontFamily: 'Charmonman',
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtopProductListPage(),
                  ),
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF9e6e19), Color(0xFFe7b014)],
                      stops: [0.0, 0.8]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'สินค้า OTOP',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelfareListPage(),
                  ),
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF9e6e19), Color(0xFFe7b014)],
                      stops: [0.0, 0.8]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wallet_giftcard_sharp,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'สวัสดิการ',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 16,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            child: FutureBuilder(
              future: _futureNews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return const Center(
                    child: Text('ไม่มีข่าวประกาศ'),
                  );
                } else {
                  final newsList = snapshot.data;
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(), // เพิ่ม physics
                    scrollDirection: Axis.horizontal,
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final newsItem = newsList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsForm(
                                url: newsItem['url'] ?? '',
                                code: newsItem['code'] ?? '',
                                model: newsItem,
                                urlComment: newsApi,
                                urlGallery: newsGalleryApi,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: Offset(4, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    width: double.infinity,
                                    child: Image.network(
                                      newsItem['imageUrl'],
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                              strokeWidth: 2,
                                              color: const Color(0xFFbf9000),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'ไม่สามารถโหลดรูปภาพ',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontFamily: 'Kanit',
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      newsItem['title'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _buildService() {
    final List<Map<String, dynamic>> serviceItems = [
      {
        'path': 'assets/icons/icon_menu3.png',
        'title': 'สิทธิประโยชน์',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivilegeMain(
                title: 'สิทธิประโยชน์',
              ),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/calendar_icon.png',
        'title': 'ปฏิทินกิจกรรมจังหวัด ',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCalendarList(
                title: 'ปฏิทินกิจกรรมจังหวัด',
              ),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu5.png',
        'title': 'คลังความรู้',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeList(
                title: 'คลังความรู้',
              ),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu8.png',
        'title': 'เบอร์ฉุกเฉิน',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactList(
                title: 'เบอร์ฉุกเฉิน',
                code: 'emergency',
              ),
            ),
          );
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: const Text(
            'บริการสมาชิก',
            style: TextStyle(
              color: Color(0xFFbf9000),
              fontSize: 20.0,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: (serviceItems.length / 4).ceil() * 130,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1 / 1.4,
            ),
            itemCount: serviceItems.length,
            itemBuilder: (context, index) {
              return _buildServiceIcon(
                path: serviceItems[index]['path'],
                title: serviceItems[index]['title'],
                callBack: serviceItems[index]['callBack'],
              );
            },
          ),
        ),
      ],
    );
  }

  _buildServiceIcon({path, title, callBack}) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: callBack,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFbf9000),
                      Color(0xFFffd700),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Image.asset(
                  path,
                  height: 40,
                  fit: BoxFit.contain,
                  width: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            width: 90,
            alignment: Alignment.topCenter,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400,
                color: Color(0xFFbf9000),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEmergencySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'เบอร์ฉุกเฉิน',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFFbf9000),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('tel:191'));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFf44336), Color(0xFFef5350)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFf44336).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_police,
                              color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'ตำรวจ 191',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('tel:199'));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFff5722), Color(0xFFff7043)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFff5722).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'ดับเพลิง 199',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('tel:1669'));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services,
                              color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'แพทย์ฉุกเฉิน 1669',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComplainDetail()),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF607D8B), Color(0xFF78909C)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF607D8B).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.report_problem,
                              color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'แจ้งปัญหา',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> nakhonPhanomTravelPlaces = [
    {
      'name': 'วัดพระธาตุพนมวรมหาวิหาร',
      'location': 'อำเภอธาตุพนม จังหวัดนครพนม',
      'review': '⭐ 4.7 (มากกว่า 100,000 คนเคารพสักการะ)',
      'imageUrl':
          'http://www2.nakhonphanom.go.th/files/com_travel/2022-03_01516888244fa1d.jpg',
      'url': 'https://thai.tourismthailand.org/Attraction/พระธาตุพนม',
      'description':
          'พระธาตุประจำปีวอกและวันอาทิตย์ เป็นสถานที่ศักดิ์สิทธิ์สำคัญของภาคอีสาน'
    },
    {
      'name': 'ท่าน้ำนครพนม (ริมฝั่งโขง)',
      'location': 'อำเภอเมืองนครพนม',
      'review': '⭐ 4.5 (นักท่องเที่ยวนิยมมาชมพระอาทิตย์ตก)',
      'imageUrl': 'https://s.isanook.com/tr/0/ui/285/1425165/Image-1.jpg',
      'url': 'https://www.wongnai.com/attractions/nakhon-phanom-mekong-river',
      'description': 'จุดชมวิวแม่น้ำโขงและฝั่งลาวตรงข้าม บรรยากาศสงบร่มรื่น'
    },
    {
      'name': 'อนุสาวรีย์ประธานโฮจิมินต์',
      'location': 'อำเภอเมืองนครพนม',
      'review': '⭐ 4.3 (สถานที่ประวัติศาสตร์สำคัญ)',
      'imageUrl':
          'https://themomentum.co/wp-content/uploads/2023/05/Body-Web_Vietnam-Feature1.jpg',
      'url':
          'https://www.tat.or.th/th/attractions/อนุสาวรีย์ประธานโฮจิมินต์-จังหวัดนครพนม',
      'description':
          'อนุสาวรีย์เพื่อระลึกถึงผู้นำเวียดนามที่เคยอาศัยในจังหวัดนครพนม'
    },
    {
      'name': 'พระธาตุเรณู',
      'location': 'อำเภอเรณูนคร',
      'review': '⭐ 4.6 (พระธาตุสีชมพูเฉพาะตัว)',
      'imageUrl':
          'https://scontent.fbkk13-3.fna.fbcdn.net/v/t1.6435-9/109502390_1530647907115809_4776549909297713209_n.jpg?_nc_cat=110&_nc_cb=64d46a15-5a82848f&ccb=1-7&_nc_sid=833d8c&_nc_ohc=QwCrPBJEgtEQ7kNvwGze1fG&_nc_oc=Adm67iLL-s20rgYvcU45YBRB-qQaBz77gtezhRrIQBetfksBG-wkgqtwJH0j-VYblUQ&_nc_zt=23&_nc_ht=scontent.fbkk13-3.fna&_nc_gid=9Y9qXZjMv3n7HbPkzgftPQ&oh=00_AfIc3YiUqKZincJk0NLRAinPIlxvZTvW-KK_JLRokFY-nQ&oe=6864C442',
      'url': 'https://www.wongnai.com/attractions/phra-that-raenu',
      'description': 'พระธาตุประจำวันจันทร์ มีสีชมพูสวยงามเป็นเอกลักษณ์'
    },
    {
      'name': 'วัดนักบุญอันนา หนองแสง',
      'location': 'อำเภอเมืองนครพนม',
      'review': '⭐ 4.4 (โบสถ์คาทอลิกริมโขง)',
      'imageUrl':
          'https://mpics.mgronline.com/pics/Images/566000005562101.JPEG',
      'url': 'https://www.wongnai.com/attractions/st-anna-nong-saeng-church',
      'description': 'โบสถ์คาทอลิกสไตล์โคโลเนียลสวยงามริมแม่น้ำโขง'
    },
    {
      'name': 'หาดทรายทองแก้ว (สันทรายริมโขง)',
      'location': 'อำเภอธาตุพนม',
      'review': '⭐ 4.2 (หาดทรายธรรมชาติริมโขง)',
      'imageUrl':
          'https://cms.dmpcdn.com/travel/2020/05/14/462cab90-95c5-11ea-bcb3-0320ce420b5e_original.jpg',
      'url': 'https://www.wongnai.com/trips/golden-sand-beach-nakhon-phanom',
      'description': 'หาดทรายริมแม่น้ำโขง บรรยากาศธรรมชาติสงบเงียบ'
    },
    {
      'name': 'พิพิธภัณฑ์โฮจิมินต์',
      'location': 'อำเภอเมืองนครพนม',
      'review': '⭐ 4.1 (พิพิธภัณฑ์ประวัติศาสตร์)',
      'imageUrl':
          'https://media.timeout.com/images/103951834/750/562/image.jpg',
      'url': 'https://www.matichon.co.th/travel/nakhon-phanom-museum',
      'description': 'พิพิธภัณฑ์แสดงประวัติความสัมพันธ์ไทย-เวียดนาม'
    },
    {
      'name': 'ประตูเมืองนครพนม',
      'location': 'อำเภอเมืองนครพนม',
      'review': '⭐ 4.0 (สัญลักษณ์ของเมือง)',
      'imageUrl':
          'https://travel.mthai.com/app/uploads/2018/05/nakhon-phanom-gate.jpg',
      'url': 'https://travel.mthai.com/nakhon-phanom-city-gate',
      'description': 'ประตูเมืองที่เป็นสัญลักษณ์และจุดเช็คอินยอดนิยม'
    }
  ];

  Widget _buildTravel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ท่องเที่ยวยอดนิยม',
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
                      builder: (context) => TravelPlacesList(
                        title: 'สถานที่ท่องยอดนิ',
                        places: nakhonPhanomTravelPlaces,
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(), // เพิ่ม physics
                scrollDirection: Axis.horizontal,
                itemCount: nakhonPhanomTravelPlaces.length,
                itemBuilder: (context, index) {
                  final place = nakhonPhanomTravelPlaces[index];
                  return InkWell(
                    onTap: () async {
                      try {
                        final uri = Uri.parse(place['url']!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ไม่สามารถเปิดลิงก์ได้'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('เกิดข้อผิดพลาดในการเปิดลิงก์'),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: MediaQuery.of(context).size.width * 0.55,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: double.infinity,
                              child: Image.network(
                                place['imageUrl']!,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                        color: const Color(0xFFbf9000),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ไม่สามารถโหลดรูปภาพ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    place['name']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFbf9000),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 12,
                                        color: Color(0xFF666666),
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          place['location']!,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF666666),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    place['review']!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF27544F),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (place.containsKey('description') &&
                                      place['description']!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        place['description']!,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFF888888),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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

    _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});

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
    _hasMoreNews = true;

    try {
      var newsData = await postDio('${newsApi}read', {
        'skip': 0,
        'limit': _newsLimit,
        'app': 'marine',
      });

      setState(() {
        _newsList = newsData ?? [];
        print("รีเฟรชข้อมูลเสร็จสิ้น: ${_newsList.length} รายการ");
      });

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
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          this.setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false,
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
          barrierDismissible: false,
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
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        currentLocation = placemarks.first.administrativeArea ?? 'Unknown';
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
