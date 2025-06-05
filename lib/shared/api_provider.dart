// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/io.dart';

import '../login.dart';
import '../models/user.dart';
import 'facebook_firebase.dart';
import 'google.dart';
import 'line.dart';

const appName = 'Khub Dee DLT';
const versionName = '0.0.1';
const versionNumber = 1;

// flutter build apk --build-name=0.0.1 --build-number=1

//dev
// const server = 'http://122.155.223.63/td-khub-dee-api/';
// const serverUpload = 'http://mobile.khubdee.com/khubdee-document/upload';
// const serverMW = 'http://122.155.223.63/td-khub-dee-middleware-api/';

//prod
// const server = 'http://mobile.khubdee.com/khubdee-api/';
// const serverUpload = 'http://122.155.223.63/td-doc/upload';
// const serverMW = 'http://mobile.khubdee.com/khubdee-middleware/';

//prod inet

//http://gateway.we-builds.com/nakhonphanom-api

const serverPrefix = 'https://khubdeedlt.we-builds.com/';
const server = '$serverPrefix/khubdeedlt-api/';
const serverNpm = 'http://gateway.we-builds.com/nakhonphanom-api';
const serverUpload = '$serverPrefix/khubdeedlt-document/upload';
const serverMW = 'http://122.155.223.63/td-khub-dee-middleware-api/';

//new
const newsApi = serverNpm + '/m/news/';

//banner
const mainBannerApi = serverNpm + '/Banner/';

//rotation
const rotationApi = serverNpm + '/m/rotation/';
//Category
const reporterCategoryApi = serverNpm + '/reporter/category/';

const sharedApi = server + 'configulation/shared/';
const registerApi = server + 'm/register/';

const newsGalleryApi = 'm/news/gallery/read';
const pollApi = server + 'm/poll/';
const poiApi = serverNpm + '/poi/';
const poiGalleryApi = serverNpm + '/poi/gallery/read';
const faqApi = server + 'm/faq/';
const knowledgeApi = serverNpm + '/m/knowledge/';
const cooperativeApi = server + 'm/cooperativeForm/';
const contactApi = serverNpm + '/m/contact/';
const bannerApi = server + 'banner/';
const bannerGalleryApi = 'm/banner/gallery/read';
const privilegeApi = serverNpm + "/privilege/";
const menuApi = server + "m/menu/";
const aboutUsApi = server + "m/aboutus/";
const notificationApi = server + 'm/notification/';
const welfareApi = server + 'm/welfare/';
const welfareGalleryApi = server + 'm/welfare/gallery/read';
const eventCalendarApi = serverNpm + '/eventCalendar/';
const eventCalendarCategoryApi = serverNpm + '/eventCalendar/category/';
const eventCalendarCommentApi = server + 'm/eventCalendar/comment/';
const eventCalendarGalleryApi = server + 'm/eventCalendar/gallery/read';
const pollGalleryApi = server + 'm/poll/gallery/read';
const reporterApi = server + 'm/reporter/';
const reporterGalleryApi = server + 'm/Reporter/gallery/';
const fundApi = server + 'm/fund/';
const fundGalleryApi = server + 'm/fund/gallery/read';
const warningApi = server + 'm/warning/';
const warningGalleryApi = 'm/warning/gallery/read';

const contactBannerApi = server + 'm/Banner/contact/';
const reporterBannerApi = server + 'm/Banner/reporter/';

const mainRotationApi = server + 'm/Rotation/main/';
const rotationGalleryApi = 'm/rotation/gallery/read';

//mainPopup
const mainPopupHomeApi = server + 'm/MainPopup/';
const forceAdsApi = server + 'm/ForceAds/';

// comment
const newsCommentApi = server + 'm/news/comment/';
const welfareCommentApi = server + 'm/welfare/comment/';
const poiCommentApi = serverNpm + '/poi/comment/';
const fundCommentApi = server + 'm/fund/comment/';
const warningCommentApi = server + 'm/warning/comment/';

//category
const knowledgeCategoryApi = server + 'm/knowledge/category/';
const cooperativeCategoryApi = server + 'm/cooperativeForm/category/';
const newsCategoryApi = server + 'm/news/category/';
const privilegeCategoryApi = serverNpm + '/privilege/category/';
const contactCategoryApi = server + 'm/contact/category/';
const welfareCategoryApi = server + 'm/welfare/category/';
const fundCategoryApi = server + 'm/fund/category/';
const pollCategoryApi = server + 'm/poll/category/';
const poiCategoryApi = serverNpm + '/poi/category/';

const warningCategoryApi = server + 'm/warning/category/';
const comingSoonApi = server + 'm/comingsoon/read';
const comingSoonGalleryApi = server + 'm/comingsoon/gallery/read';

const splashApi = server + 'm/splash/read';

const privilegeGalleryApi = server + 'm/privilege/gallery/read';
const privilegeSpecialReadApi =
    'http://122.155.223.63/td-we-mart-api/m/privilege/khubdeedlt/read';
const privilegeSpecialCategoryReadApi =
    'http://122.155.223.63/td-we-mart-api/m/privilege/category/read';

Future<dynamic> postCategory(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();

  var value = await storage.read(key: 'dataUserLoginKSP');
  var dataUser = value != null ? json.decode(value) : {};

  List<dynamic> dataOrganization =
      dataUser['countUnit'] != null && dataUser['countUnit'] != ''
          ? json.decode(dataUser['countUnit'])
          : [];

  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] ?? 0,
    "limit": criteria['limit'] ?? 1,
    "code": criteria['code'] ?? '',
    "reference": criteria['reference'] ?? '',
    "description": criteria['description'] ?? '',
    "category": criteria['category'] ?? '',
    "keySearch": criteria['keySearch'] ?? '',
    "username": criteria['username'] ?? '',
    "isHighlight": criteria['isHighlight'] ?? false,
    "language": criteria['language'] ?? 'th',
    "organization": dataOrganization,
  });

  var response = await http.post(Uri.parse(url), body: body, headers: {
    "Accept": "application/json",
    "Content-Type": "application/json"
  });

  var data = json.decode(response.body);
  print('-----------postCategory---1---------');
  print('url: $url');
  print('criteria: $criteria');
  print('objectData: ${data['objectData']}');

  List<dynamic> list = [
    {'code': "", 'title': 'ทั้งหมด'}
  ];
  list = [...list, ...data['objectData'] ?? []];

  return Future.value(list);
}

Future<dynamic> post(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();
  var value = await storage.read(key: 'dataUserLoginDDPM');
  var dataUser = value != null ? json.decode(value) : {};

  List<dynamic> dataOrganization =
      dataUser['countUnit'] != null && dataUser['countUnit'] != ''
          ? json.decode(dataUser['countUnit'])
          : [];

  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] ?? 0,
    "limit": criteria['limit'] ?? 1,
    "code": criteria['code'] ?? '',
    "reference": criteria['reference'] ?? '',
    "description": criteria['description'] ?? '',
    "category": criteria['category'] ?? '',
    "keySearch": criteria['keySearch'] ?? '',
    "username": criteria['username'] ?? '',
    "firstName": criteria['firstName'] ?? '',
    "lastName": criteria['lastName'] ?? '',
    "title": criteria['title'] ?? '',
    "answer": criteria['answer'] ?? '',
    "isHighlight": criteria['isHighlight'] ?? false,
    "createBy": criteria['createBy'] ?? '',
    "isPublic": criteria['isPublic'] ?? false,
    "language": criteria['language'] ?? 'th',
    "organization": dataOrganization,
    "latitude": criteria['latitude'] ?? 0,
    "longitude": criteria['longitude'] ?? 0,
  });

  var response = await http.post(Uri.parse(url), body: body, headers: {
    "Accept": "application/json",
    "Content-Type": "application/json"
  });

  print('-----------post------------');
  print('url: $url');
  print('criteria: $criteria');
  print('objectData: ${response.body}');

  var data = json.decode(response.body);
  return Future.value(data['objectData'] ?? {});
}

Future<dynamic> postAny(String url, dynamic criteria) async {
  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] != null ? criteria['skip'] : 0,
    "limit": criteria['limit'] != null ? criteria['limit'] : 1,
    "code": criteria['code'] != null ? criteria['code'] : '',
    "category": criteria['category'] != null ? criteria['category'] : '',
    "username": criteria['username'] != null ? criteria['username'] : '',
    "password": criteria['password'] != null ? criteria['password'] : '',
    "createBy": criteria['createBy'] != null ? criteria['createBy'] : '',
    "imageUrlCreateBy": criteria['imageUrlCreateBy'] != null
        ? criteria['imageUrlCreateBy']
        : '',
    "reference": criteria['reference'] != null ? criteria['reference'] : '',
    "description":
        criteria['description'] != null ? criteria['description'] : '',
  });

  var response = await http.post(Uri.parse(url), body: body, headers: {
    "Accept": "application/json",
    "Content-Type": "application/json"
  });

  var data = json.decode(response.body);

  return Future.value(data['status']);
}

Future<dynamic> postAnyObj(String url, dynamic criteria) async {
  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] != null ? criteria['skip'] : 0,
    "limit": criteria['limit'] != null ? criteria['limit'] : 1,
    "code": criteria['code'] != null ? criteria['code'] : '',
    "createBy": criteria['createBy'] != null ? criteria['createBy'] : '',
    "imageUrlCreateBy": criteria['imageUrlCreateBy'] != null
        ? criteria['imageUrlCreateBy']
        : '',
    "reference": criteria['reference'] != null ? criteria['reference'] : '',
    "description":
        criteria['description'] != null ? criteria['description'] : '',
  });

  var response = await http.post(Uri.parse(url), body: body, headers: {
    "Accept": "application/json",
    "Content-Type": "application/json"
  });

  var data = json.decode(response.body);

  return Future.value(data);
}

Future<dynamic> postLogin(String url, dynamic criteria) async {
  var body = json.encode({
    "category": criteria['category'] != null ? criteria['category'] : '',
    "password": criteria['password'] != null ? criteria['password'] : '',
    "username": criteria['username'] != null ? criteria['username'] : '',
    "email": criteria['email'] != null ? criteria['email'] : '',
  });

  var response = await http.post(Uri.parse(url), body: body, headers: {
    "Accept": "application/json",
    "Content-Type": "application/json"
  });

  var data = json.decode(response.body);

  return Future.value(data['objectData']);
}

Future<dynamic> postObjectData(String url, dynamic criteria) async {
  print('-----------postObjectData------------');
  print('url: $url');
  print('criteria: $criteria');
  var body = json.encode(criteria);

  var response = await http.post(Uri.parse(serverNpm + url),
      body: body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });

  if (response.statusCode == 200) {
    print('postObjectData Success');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // ดู response นี้
    var data = json.decode(response.body);
    // เพิ่ม debug เพื่อดูค่าที่ server ตอบกลับ
    print('API Status: ${data['status']}');
    print('API Message: ${data['message']}');
    return {
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData']
    };
  } else {
    print('HTTP Error: ${response.statusCode}');
    print('HTTP Body: ${response.body}');
    return {"status": "F"};
  }
}

Future<dynamic> postObjectDataMW(String url, dynamic criteria) async {
  var body = json.encode(criteria);
  // print('-----------$url------------');
  // print('-----------$body------------');
  var response = await http.post(Uri.parse(url), body: body, headers: {
    "Accept": "application/json",
    "Content-Type": "application/json"
  });
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return {
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData']
    };
    // Future.value(data['objectData']);
  } else {
    return {"status": "F"};
  }
}

Future<dynamic> postConfigShare() async {
  var body = json.encode({});

  var response = await http.post(
      Uri.parse(server + 'configulation/shared/read'),
      body: body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return {
      // Future.value(data['objectData']);
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData']
    };
  } else {
    return {"status": "F"};
  }
}

Future<LoginRegister> postLoginRegister(String url, dynamic criteria) async {
  print('-----------postLoginRegister------------');
  print('url: $url');
  print('criteria: $criteria');
  var body = json.encode(criteria);

  var response = await http.post(Uri.parse(serverNpm + url),
      body: body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });

  if (response.statusCode == 200) {
    print('-----------postLoginRegister Success------------');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var userMap = jsonDecode(response.body);

    var user = new LoginRegister.fromJson(userMap);
    return Future.value(user);
  } else {
    return Future.value();
  }
}

//upload with dio
Future<String> uploadImage(XFile file) async {
  Dio dio = new Dio();

  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "ImageCaption": "flutter",
    "Image": await MultipartFile.fromFile(file.path, filename: fileName),
  });

  var response = await dio.post(serverUpload, data: formData);

  return response.data['imageUrl'];
}

//upload with http
upload(File file) async {
  var uri = Uri.parse(serverUpload);
  var request = http.MultipartRequest('POST', uri)
    ..fields['ImageCaption'] = 'flutter2'
    ..files.add(await http.MultipartFile.fromPath('Image', file.path,
        contentType: MediaType('application', 'x-tar')));
  var response = await request.send();
  if (response.statusCode == 200) {
    return response;
  }
}

createStorageApp({dynamic model, String? category}) {
  final storage = new FlutterSecureStorage();

  storage.write(key: 'profileCategory', value: category);
  storage.write(key: 'profileCode2', value: model['code']);
  storage.write(key: 'profileImageUrl', value: model['imageUrl']);
  storage.write(key: 'profileFirstName', value: model['firstName']);
  storage.write(key: 'profileLastName', value: model['lastName']);
  storage.write(key: 'username', value: model['username']);
  storage.write(key: 'idcard', value: model['idcard']);
  storage.write(key: 'dataUserLoginDDPM', value: jsonEncode(model));
}

logout(BuildContext context) async {
  final storage = new FlutterSecureStorage();
  storage.delete(key: 'profileCode2');
  var profileCategory = await storage.read(key: 'profileCategory');
  if (profileCategory != '' && profileCategory != null) {
    switch (profileCategory) {
      case 'facebook':
        // logoutFacebook();
        logoutFacebook();
        break;
      case 'google':
        logoutGoogle();
        break;
      case 'line':
        logoutLine();
        break;
      default:
    }
  }

  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false);

  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
}

Future<dynamic> postDio(String url, dynamic criteria) async {
  final storage = new FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode2');
  final idcard = await storage.read(key: 'idcard');
  final username = await storage.read(key: 'username');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  if (criteria['card_id'] == '' ||
      // ignore: curly_braces_in_flow_control_structures
      criteria['card_id'] == null) if (idcard != '' && idcard != null) {
    criteria = {'card_id': idcard, ...criteria};
  }

  if (username != '' && username != null) {
    criteria = {'username': username, ...criteria};
  }

  // สร้าง Dio instance พร้อม options
  Dio dio = new Dio(BaseOptions(
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
  ));

  // แก้ปัญหา SSL Certificate
  (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  };

  try {
    var response = await dio.post(url, data: criteria);
    return Future.value(response.data['objectData']);
  } catch (e) {
    print('Error in postDio: $e');
    throw e;
  }
}
// Future<dynamic> postDio(String url, dynamic criteria) async {
//   print('-----postDio-----');

//   print('-----url-----' + url);
//   print('-----criteria-----' + criteria.toString());
//   final storage = new FlutterSecureStorage();
//   final profileCode = await storage.read(key: 'profileCode2');
//   final idcard = await storage.read(key: 'idcard');
//   final username = await storage.read(key: 'username');

//   if (profileCode != '' && profileCode != null) {
//     criteria = {'profileCode': profileCode, ...criteria};
//   }

//   if (criteria['card_id'] == '' ||
//       criteria['card_id'] == null) if (idcard != '' && idcard != null) {
//     criteria = {'card_id': idcard, ...criteria};
//   }

//   if (username != '' && username != null) {
//     criteria = {'username': username, ...criteria};
//   }

//   Dio dio = new Dio(BaseOptions(
//     connectTimeout: Duration(seconds: 60),
//     receiveTimeout: Duration(seconds: 60),
//   ));

//   (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
//     client.badCertificateCallback = (cert, host, port) => true;
//     return client;
//   };

//   try {
//     var response = await dio.post(url, data: criteria);
//     return Future.value(response.data['objectData']);
//   } catch (e) {
//     print('Error in postDio: $e');
//     throw e;
//   }
// }

Future<dynamic> postAnyDio(String url, dynamic criteria) async {
  final storage = new FlutterSecureStorage();

  final profileCode = await storage.read(key: 'profileCode2');
  var idcard = await storage.read(key: 'idcard');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }
  if (criteria['card_id'] == '' ||
      criteria['card_id'] == null) if (idcard != '' && idcard != null) {
    criteria = {'card_id': idcard, ...criteria};
  }

  Dio dio = new Dio();
  var response = await dio.post(url, data: criteria);
  // print(response.data['objectData'].toString());
  return Future.value(response.data);
}

Future<dynamic> postDioMessage(String url, dynamic criteria) async {
  print('-----hello dio-----');
  final storage = new FlutterSecureStorage();

  var sa = await storage.readAll();
  print(sa.toString());

  final profileCode = await storage.read(key: 'profileCode2');
  var idcard = await storage.read(key: 'idcard');

  if (profileCode != '' && profileCode != null) {
    print('-----profileCode-----' + profileCode);
    criteria = {'profileCode': profileCode, ...criteria};
  }
  if (criteria['card_id'] == '' ||
      criteria['card_id'] == null) if (idcard != '' && idcard != null) {
    print('-----card_id-----' + idcard);
    criteria = {'card_id': idcard, ...criteria};
  }

  print('-----dio url-----' + url);
  Dio dio = new Dio();
  print('-----dio criteria-----' + criteria.toString());
  var response = await dio.post(url, data: criteria);
  print('-----dio message-----' + response.data['objectData'].toString());
  return Future.value(response.data['objectData']);
}

Future<dynamic> postDioMessage2(String url, dynamic criteria) async {
  print('-----dio url-----' + url);
  Dio dio = new Dio();
  print('-----dio criteria-----' + criteria.toString());
  var response = await dio.post(url, data: criteria);
  print('-----dio message-----' + response.data.toString());
  return Future.value(response.data);
}

Future<dynamic> getDio(String url, String param) async {
  Dio dio = new Dio();
  var response = await dio.get(url);
  print(response.data);
  return Future.value(response.data);
}

Future<dynamic> postDioFull(String url, dynamic criteria) async {
  print(url);
  print(criteria);
  final storage = new FlutterSecureStorage();
  var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode2');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = new Dio();
  var response = await dio.post(url, data: criteria);
  // print(response.data['objectData'].toString());
  return Future.value(response.data);
}

Future<dynamic> postDioCategoryWeMart(String url, dynamic criteria) async {
  // print(url);
  // print(criteria);
  final storage = new FlutterSecureStorage();
  // var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode2');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = new Dio();
  var response = await dio.post(url, data: criteria);
  var data = response.data['objectData'];

  List<dynamic> list = [
    {'code': "", 'title': 'ทั้งหมด'}
  ];

  list = [...data, ...list];
  return Future.value(list);
}

Future<dynamic> postDioCategoryWeMartNoAll(String url, dynamic criteria) async {
  // print(url);
  // print(criteria);
  final storage = new FlutterSecureStorage();
  // var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode2');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = new Dio();
  var response = await dio.post(url, data: criteria);
  var data = response.data['objectData'];

  List<dynamic> list = [
    // {'code': "", 'title': 'ทั้งหมด'}
  ];

  list = [...data];
  return Future.value(list);
}

const splashReadApi = server + 'm/splash/read';
const profileReadApi = serverNpm + '/m/register/read';
const organizationImageReadApi = server + 'm/v2/organization/image/read';
const getDriverLicenceByDocNoApi = serverMW + 'DLTLC/getDriverLicenceByDocNo';
const getAllTicketListApi = serverMW + 'ptm/getAllTicketList';
const getNotpaidTicketListApi = serverMW + 'ptm/getNotpaidTicketList';
const getPaidTicketListApi = serverMW + 'ptm/getPaidTicketList';
const getTimeoutTicketListApi = serverMW + 'ptm/getTimeoutTicketList';
const getTicketDetailApi = serverMW + 'ptm/getTicketDetail';
