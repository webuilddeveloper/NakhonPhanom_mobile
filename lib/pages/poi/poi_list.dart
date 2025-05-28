import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../component/header.dart';
import '../../component/key_search.dart';
import '../../component/tab_category.dart';
import '../../shared/api_provider.dart';
import '../../shared/extension.dart';
import '../blank_page/blank_data.dart';
import '../blank_page/blank_loading.dart';
import 'poi_form.dart';
import 'poi_list_vertical.dart';

class PoiList extends StatefulWidget {
  PoiList({super.key, this.title, this.latLng});
  final String? title;
  final LatLng? latLng;

  @override
  _PoiList createState() => _PoiList();
}

class _PoiList extends State<PoiList> {
  Completer<GoogleMapController>? _mapController;
  GoogleMapController? _controller;
  bool _mapReady = false;

  PoiListVertical? gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String category = '';
  int _limit = 10;

  // แยก RefreshController สำหรับแต่ละส่วน
  final RefreshController _panelRefreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _listRefreshController =
      RefreshController(initialRefresh: false);

  Future<dynamic>? _futureModel;
  LatLngBounds? initLatLngBounds;

  double? positionScroll;
  bool showMap = true;

  Future<dynamic>? futureCategory;
  List<dynamic> listTemp = [
    {
      'code': '',
      'title': '',
      'imageUrl': '',
      'createDate': '',
      'userList': [
        {'imageUrl': '', 'firstName': '', 'lastName': ''}
      ]
    }
  ];
  bool showLoadingItem = true;

  @override
  void dispose() {
    txtDescription.dispose();
    _panelRefreshController.dispose();
    _listRefreshController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    const defaultLatitude = 17.4108;
    const defaultLongitude = 104.7784;

    final latitude = widget.latLng?.latitude ?? defaultLatitude;
    final longitude = widget.latLng?.longitude ?? defaultLongitude;

    print('=== INIT STATE ===');
    print('Using coordinates: $latitude, $longitude');

    _futureModel = post('${poiApi}read', {
      'skip': 0,
      'limit': 10,
      'latitude': latitude,
      'longitude': longitude,
    });

    setState(() {
      initLatLngBounds = LatLngBounds(
        southwest: LatLng(latitude - 0.2, longitude - 0.15),
        northeast: LatLng(latitude + 0.1, longitude + 0.1),
      );
    });

    futureCategory = postCategory(
      '${poiCategoryApi}read',
      {'skip': 0, 'limit': 100},
    );

    gridView = PoiListVertical(model: _futureModel);

    // Debug data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugMapData();
    });
  }

  void debugMapData() async {
    try {
      final data = await _futureModel;
      print('=== DEBUG MAP DATA ===');
      print('Data length: ${data?.length ?? 0}');
      print('Widget latLng: ${widget.latLng}');
      print('InitLatLngBounds: $initLatLngBounds');

      if (data != null && data.length > 0) {
        print('First item: ${data[0]}');
        data.forEach((item) {
          print(
              'Item - Code: ${item['code']}, Lat: ${item['latitude']}, Lng: ${item['longitude']}');
        });
      }
      print('=====================');
    } catch (e) {
      print('Debug error: $e');
    }
  }

  // สำหรับ Panel loading
  void _onPanelLoading() async {
    final latitude = widget.latLng?.latitude ?? 17.4108;
    final longitude = widget.latLng?.longitude ?? 104.7784;

    setState(() {
      _limit = _limit + 10;
      _futureModel = post('${poiApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': category,
        "keySearch": keySearch,
        'latitude': latitude,
        'longitude': longitude
      });
      gridView = PoiListVertical(model: _futureModel);
      _mapReady = false; // Reset map ready state
    });

    await Future.delayed(Duration(milliseconds: 1000));
    _panelRefreshController.loadComplete();
  }

  // สำหรับ List loading
  void _onListLoading() async {
    final latitude = widget.latLng?.latitude ?? 17.4108;
    final longitude = widget.latLng?.longitude ?? 104.7784;

    setState(() {
      _limit = _limit + 10;
      _futureModel = post('${poiApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': category,
        "keySearch": keySearch,
        'latitude': latitude,
        'longitude': longitude
      });
    });

    await Future.delayed(Duration(milliseconds: 1000));
    _listRefreshController.loadComplete();
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
        title: 'จุดบริการ',
        isButtonRight: true,
        imageRightButton:
            showMap ? 'assets/icons/menu.png' : 'assets/icons/location.png',
        rightButton: () => setState(() {
          showMap = !showMap;
          _limit = 10;
        }),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: showMap ? _buildMap() : _buildList(),
      ),
    );
  }

  // Show map with fixed implementation
  SlidingUpPanel _buildMap() {
    double _panelHeightOpen = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 50);
    double _panelHeightClosed = 90;

    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(
          bottom: _panelHeightClosed,
        ),
        child: googleMap(_futureModel),
      ),
      panelBuilder: (sc) => _panel(sc),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
      onPanelSlide: (double pos) {
        setState(() {
          positionScroll = pos;
        });
      },
    );
  }

  // Fixed Google Map implementation
  Widget googleMap(modelData) {
    List<Marker> _markers = <Marker>[];

    // Set initial position
    LatLng initialPosition = widget.latLng ?? LatLng(17.4108, 104.7784);

    return FutureBuilder<dynamic>(
      future: modelData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // Create markers from data
        if (snapshot.hasData && snapshot.data.length > 0) {
          _markers.clear();
          for (var item in snapshot.data) {
            if (item['latitude'] != null && item['longitude'] != null) {
              try {
                double lat = double.parse(item['latitude'].toString());
                double lng = double.parse(item['longitude'].toString());

                _markers.add(
                  Marker(
                    markerId: MarkerId(item['code']?.toString() ??
                        'marker_${_markers.length}'),
                    position: LatLng(lat, lng),
                    infoWindow: InfoWindow(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PoiForm(
                              code: item['code'],
                              model: item,
                            ),
                          ),
                        );
                      },
                      title: item['title']?.toString() ?? 'ไม่ระบุชื่อ',
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                );
              } catch (e) {
                print('Error creating marker for item ${item['code']}: $e');
              }
            }
          }
        }

        return GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 15,
          ),
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          ].toSet(),
          onMapCreated: (GoogleMapController controller) async {
            print('Map created successfully');

            if (_mapController == null || _mapController!.isCompleted) {
              _mapController = Completer<GoogleMapController>();
            }

            _controller = controller;
            _mapController!.complete(controller);

            // Wait a bit before setting map as ready
            await Future.delayed(Duration(milliseconds: 500));

            if (mounted) {
              setState(() {
                _mapReady = true;
              });

              // Move camera after map is ready
              _moveCameraToPosition();
            }
          },
          markers: _markers.toSet(),
          onCameraMove: (CameraPosition position) {
            // Only log occasionally to reduce spam
            if (DateTime.now().millisecondsSinceEpoch % 1000 < 100) {
              print('Camera moved to: ${position.target}');
            }
          },
          onTap: (LatLng latLng) {
            print('Map tapped at: $latLng');
          },
        );
      },
    );
  }

  void _moveCameraToPosition() async {
    if (!_mapReady || _controller == null) return;

    try {
      await Future.delayed(Duration(milliseconds: 500));

      if (initLatLngBounds != null) {
        await _controller!.animateCamera(
          CameraUpdate.newLatLngBounds(initLatLngBounds!, 100.0),
        );
      } else if (widget.latLng != null) {
        await _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: widget.latLng!, zoom: 15),
          ),
        );
      }
    } catch (e) {
      print('Camera animation error: $e');
      // Don't try fallback, just log the error
    }
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        footer: ClassicFooter(
          loadingText: 'กำลังโหลด...',
          canLoadingText: ' ',
          idleText: '',
          idleIcon: Icon(
            Icons.arrow_upward,
            color: Colors.transparent,
          ),
        ),
        controller: _panelRefreshController, // ใช้ controller แยก
        onLoading: _onPanelLoading, // ใช้ function แยก
        child: ListView(
          controller: sc,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                height: 4,
              ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'จุดบริการ',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: gridView,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildList() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // ใช้ Container แทน SizedBox เพื่อควบคุม height ได้ดีกว่า
          Container(height: 5),
          Container(
            child: CategorySelector(
              model: futureCategory,
              onChange: (String val) {
                setData(val, keySearch);
              },
            ),
          ),
          Container(height: 5),
          Container(
            child: KeySearch(
              show: hideSearch,
              onKeySearchChange: (String val) {
                setData(category, val);
              },
            ),
          ),
          Container(height: 10),
          Expanded(
            child: buildList(),
          )
        ],
      ),
    );
  }

  FutureBuilder buildList() {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (showLoadingItem) {
            return blankListData(context, height: 300);
          } else {
            return refreshList(listTemp);
          }
        } else if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                showLoadingItem = false;
                listTemp = snapshot.data;
              });
            });
            return refreshList(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return InkWell(
            onTap: () {
              final latitude = widget.latLng?.latitude ?? 17.4108;
              final longitude = widget.latLng?.longitude ?? 104.7784;

              setState(() {
                _futureModel = post('${poiApi}read', {
                  'skip': 0,
                  'limit': _limit,
                  'category': category,
                  "keySearch": keySearch,
                  'latitude': latitude,
                  'longitude': longitude
                });
                futureCategory = futureCategory;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                Text('ลองใหม่อีกครั้ง')
              ],
            ),
          );
        } else {
          return refreshList(listTemp);
        }
      },
    );
  }

  SmartRefresher refreshList(List<dynamic> model) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
      ),
      controller: _listRefreshController, // ใช้ controller แยกสำหรับ list
      onLoading: _onListLoading, // ใช้ function แยกสำหรับ list
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return card(context, model[index]);
        },
      ),
    );
  }

  Container card(BuildContext context, dynamic model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoiForm(
                code: model['code'],
                model: model,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                child: model['imageUrl'] != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        child: Image.network(
                          '${model['imageUrl']}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : BlankLoading(height: 200),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                  color: Color(0xFFFFFFFF),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'วันที่ ${dateStringToDate(model['createDate'] ?? '')}',
                      style: const TextStyle(
                        color: Color(0xFF8F8F8F),
                        fontFamily: 'Sarabun',
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setData(String categorych, String keySearkch) {
    final latitude = widget.latLng?.latitude ?? 17.4108;
    final longitude = widget.latLng?.longitude ?? 104.7784;

    setState(() {
      if (keySearch != "") {
        showLoadingItem = true;
      }
      keySearch = keySearkch;
      category = categorych;
      _limit = 10;
      _mapReady = false; // Reset map ready state when data changes
      _futureModel = post('${poiApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': category,
        "keySearch": keySearch,
        'latitude': latitude,
        'longitude': longitude
      });
    });
  }
}
