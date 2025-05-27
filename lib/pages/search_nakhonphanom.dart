import 'package:flutter/material.dart';

class SearchNakhonPhanomPage extends StatefulWidget {
  const SearchNakhonPhanomPage({super.key});

  @override
  State<SearchNakhonPhanomPage> createState() => _SearchNakhonPhanomPageState();
}

class _SearchNakhonPhanomPageState extends State<SearchNakhonPhanomPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allData = [
    'OTOP - กระเป๋าสานมือ',
    'OTOP - สบู่สมุนไพรตะไคร้',
    'ข่าว - ถนนคนเดินนครพนมเปิดทุกเสาร์',
    'สถานที่ท่องเที่ยว - วัดพระธาตุพนม',
    'หน่วยงาน - สำนักงานคลังจังหวัดนครพนม',
    'กิจกรรม - งานแห่เทียนเข้าพรรษา',
  ];

  List<String> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = allData;
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredData = allData
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ค้นหานครพนม',
          style: TextStyle(fontFamily: 'Kanit', color: Colors.white),
        ),
        backgroundColor: Color(0xFFe7b014),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFf6f8fc),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ค้นหา... เช่น OTOP, วัด, ข่าว',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontFamily: 'Kanit'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredData.isEmpty
                  ? Center(
                      child: Text(
                        'ไม่พบข้อมูลที่ค้นหา',
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(Icons.location_on,
                                color: Color(0xFFe7b014)),
                            title: Text(
                              filteredData[index],
                              style: TextStyle(fontFamily: 'Kanit'),
                            ),
                            onTap: () {
                              // TODO: ในอนาคตสามารถไปยังหน้ารายละเอียดได้
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('คุณเลือก:',
                                      style: TextStyle(fontFamily: 'Kanit')),
                                  content: Text(filteredData[index],
                                      style: TextStyle(fontFamily: 'Kanit')),
                                  actions: [
                                    TextButton(
                                      child: Text('ปิด',
                                          style:
                                              TextStyle(fontFamily: 'Kanit')),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
