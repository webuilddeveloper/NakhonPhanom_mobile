import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marine_mobile/pages/complain/complain_follow_detail.dart';

class ComplainFollow extends StatefulWidget {
  const ComplainFollow({super.key});

  @override
  State<ComplainFollow> createState() => _ComplainFollowState();
}

class _ComplainFollowState extends State<ComplainFollow> {
  Map<String, dynamic>? reporterdetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ReporterRead();
  }

  Future<void> ReporterRead() async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      var data = json.encode({});
      var dio = Dio();
      var response = await dio.request(
        'http://gateway.we-builds.com/nakhonphanom-api/m/Reporter/read',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        setState(() {
          reporterdetail = response.data;
          isLoading = false;
        });
      } else {
        print(response.statusMessage);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf8fafc),
      body: RefreshIndicator(
        onRefresh: ReporterRead,
        color: Color(0xFFe9ca61),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'เรื่องร้องเรียน',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w700,
                            fontSize: 42,
                            color: Color(0xFFe9ca61),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'ติดตามสถานะเรื่องร้องเรียนของคุณ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Content Section
                  if (isLoading)
                    Container(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFe9ca61)),
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'กำลังโหลดข้อมูล...',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (reporterdetail == null ||
                      reporterdetail!['objectData'] == null)
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'ไม่มีเรื่องร้องเรียน',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'คุณยังไม่มีเรื่องร้องเรียนในระบบ',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        // Stats Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFe9ca61).withOpacity(0.1),
                                Color(0xFFfbd749).withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xFFe9ca61).withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFe9ca61),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.assignment_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'จำนวนเรื่องร้องเรียน',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '${reporterdetail!['objectData'].length} เรื่อง',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFe9ca61),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // List of Complaints
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reporterdetail!['objectData'].length,
                          itemBuilder: (context, index) {
                            var item = reporterdetail!['objectData'][index];

                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ComplainFollowDetail(
                                          item: item,
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFe7b014),
                                          Color(0xFFf4c430),
                                          Color(0xFFfbd749),
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFe9ca61)
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['title'] ??
                                                      'ไม่มีหัวข้อ',
                                                  style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    height: 1.2,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  item['description'] ??
                                                      'ไม่มีรายละเอียด',
                                                  style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    height: 1.3,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 14,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'คลิกเพื่อดูรายละเอียด',
                                                      style: TextStyle(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 12,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
