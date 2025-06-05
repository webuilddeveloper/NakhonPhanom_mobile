import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marine_mobile/pages/notification/notification_list.dart';

import '../../shared/api_provider.dart';
import '../blank_page/dialog_fail.dart';

import 'change_password.dart';
import 'connect_social.dart';
import 'edit_user_information.dart';

import 'identity_verification.dart';

import 'setting_notification.dart';

class UserInformationPage extends StatefulWidget {
  UserInformationPage({super.key, this.changePage});
  Function? changePage;
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final storage = new FlutterSecureStorage();
  Future<dynamic>? _futureProfile;
  // Future<dynamic>? _futureAboutUs;
  dynamic _tempData = {'imageUrl': '', 'firstName': '', 'lastName': ''};

  @override
  void initState() {
    _read();
    // _futureAboutUs = postDio('${aboutUsApi}read', {});

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: _futureProfile,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return card(snapshot.data);
          } else if (snapshot.hasError) {
            return dialogFail(context);
          } else {
            return card(_tempData);
          }
        },
      ),
    );
  }

  _read() async {
    print('--------read profile---------');
    var profileCode = await storage.read(key: 'profileCode2');

    if (profileCode != '' && profileCode != null) {
      var response = await postDio(profileReadApi, {"code": profileCode});

      setState(() {
        _futureProfile = Future.value(response[0]);
      });
    }
  }

  int SelectedIndex = 0;

  card(dynamic model) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.6,
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            'assets/background/profile_bg.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: statusBarHeight + 10,
                left: 10,
                child: InkWell(
                  onTap: () {
                    widget.changePage!(0);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: statusBarHeight + 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationList(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      color: Color(0xFF9e6e19),
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: statusBarHeight + 70,
                right: 10,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          SelectedIndex = 0;
                        });
                      },
                      child: Container(
                        height: 30,
                        width: 45,
                        decoration: BoxDecoration(
                          color: SelectedIndex == 0
                              ? Color(0xFF9e6e19)
                              : Colors.white,
                          border: Border.all(
                            color: SelectedIndex == 0
                                ? Colors.transparent
                                : Color(0xFF9e6e19),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'TH',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SelectedIndex == 0
                                  ? Colors.white
                                  : Color(0xFF9e6e19),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          SelectedIndex = 1;
                        });
                      },
                      child: Container(
                        height: 30,
                        width: 45,
                        decoration: BoxDecoration(
                          color: SelectedIndex == 1
                              ? Color(0xFF9e6e19)
                              : Colors.white,
                          border: Border.all(
                            color: SelectedIndex == 1
                                ? Colors.transparent
                                : Color(0xFF9e6e19),

                            // width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'EN',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SelectedIndex == 1
                                  ? Colors.white
                                  : Color(0xFF9e6e19),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          SelectedIndex = 2;
                        });
                      },
                      child: Container(
                        height: 30,
                        width: 45,
                        decoration: BoxDecoration(
                          color: SelectedIndex == 2
                              ? Color(0xFF9e6e19)
                              : Colors.white,
                          border: Border.all(
                            color: SelectedIndex == 2
                                ? Colors.transparent
                                : Color(0xFF9e6e19),

                            // width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'CH',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SelectedIndex == 2
                                  ? Colors.white
                                  : Color(0xFF9e6e19),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.only(top: 70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: model['imageUrl'] != ''
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: model['imageUrl'] != null
                              ? NetworkImage(model['imageUrl'])
                              : null,
                        )
                      : Container(
                          color: Colors.black12,
                          child: Image.asset(
                            'assets/profile.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Container(
                height: 35,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2,
                  left: 20.0,
                  right: 20.0,
                  bottom: 30.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          model['firstName'] + '   ' + model['lastName'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Sarabun',
                              fontSize: 25.0,
                              color: Color(0xFF9e6e19)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: 20.0,
                  right: 20.0,
                  bottom: 30.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFF9e6e19),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF9e6e19),
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'ชาวนครพนม',
                      style: TextStyle(
                        color: Color(0xFF9e6e19),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.32,
                  left: 20.0,
                  right: 20.0,
                  bottom: 30.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                        Text(
                          'QR Code',
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.edit_square,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                        Text(
                          'แก้ไขข้อมูล',
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.42,
                    bottom: 30.0),
                constraints: const BoxConstraints(
                  minHeight: 200,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ตั้งค่าผู้ใช้',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserInformationPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                            'assets/icons/person.png',
                            'ข้อมูลผู้ใช้งาน',
                            'ดูและแก้ไขข้อมูลส่วนตัวของคุณ เช่น ชื่อ, เบอร์โทร, อีเมล'),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IdentityVerificationPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/papers.png',
                          'ข้อมูลสมาชิก',
                          'ดูรายละเอียดข้อมูลของสมาชิก เช่น ชื่อ ที่อยู่ และเบอร์โทรศัพท์',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ตั้งค่าอื่นๆ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingNotificationPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/bell.png',
                          'ตั้งค่าการแจ้งเตือน',
                          'ตั้งเวลาและรูปแบบการแจ้งเตือนสำหรับกิจกรรมต่าง ๆ',
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectSocialPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/link.png',
                          'การเชื่อมต่อ',
                          'จัดการการเชื่อมต่อกับบัญชีอื่น เช่น Google, Facebook',
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/lock.png',
                          'เปลี่ยนรหัสผ่าน',
                          'เปลี่ยนรหัสผ่านบัญชีของคุณได้ที่นี่',
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          versionName,
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => logout(context),
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () => logout(context),
                                child: Text(
                                  'ออกจากระบบ',
                                  style: TextStyle(
                                    fontFamily: 'Sarabun',
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }

  buttonMenuUser(String image, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: EdgeInsets.only(bottom: 2.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.02),
        ),
        margin: EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFfffadd),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
