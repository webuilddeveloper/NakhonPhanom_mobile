import 'package:flutter/material.dart';
import 'package:marine_mobile/pages/complain/complain_add_detail.dart';
import 'package:marine_mobile/shared/api_provider.dart';

class ComplainDetail extends StatefulWidget {
  const ComplainDetail({super.key});

  @override
  State<ComplainDetail> createState() => _ComplainDetailState();
}

class _ComplainDetailState extends State<ComplainDetail> {
  late Future<dynamic> _futureCategoryReporter;

  @override
  void initState() {
    super.initState();
    _futureCategoryReporter = post('${reporterCategoryApi}read', {
      'skip': 0,
      'limit': 50,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf6f8fc),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'เลือกหัวข้อ\nที่ต้องการร้องเรียน',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w600,
                        fontSize: 42,
                        color: Color(0XFFe9ca61),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<dynamic>(
                    future: _futureCategoryReporter,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            // child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                            child: Text('ไม่มีข้อมูลหมวดหมู่'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('ไม่มีข้อมูลหมวดหมู่'));
                      }
                      final gridItems = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 3),
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: gridItems.length,
                        itemBuilder: (context, index) {
                          final item = gridItems[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ComplainAddDetail(
                                    label: item['title'],
                                    code: item['code'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFe7b014),
                                      Color(0XFFfbd749)
                                    ],
                                    stops: [0.0, 0.9],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.network(
                                        item['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      item['title'] ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Kanit',
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
