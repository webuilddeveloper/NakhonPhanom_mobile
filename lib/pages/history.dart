import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, String>> historyList = [
    {
      'type': 'สินค้า OTOP',
      'title': 'สบู่สมุนไพรตะไคร้',
      'timestamp': '25 พ.ค. 2567 14:20',
    },
    {
      'type': 'สถานที่ท่องเที่ยว',
      'title': 'วัดพระธาตุพนม',
      'timestamp': '24 พ.ค. 2567 09:15',
    },
    {
      'type': 'ข่าว',
      'title': 'ถนนคนเดินเปิดอีกครั้งทุกวันเสาร์',
      'timestamp': '23 พ.ค. 2567 18:45',
    },
    {
      'type': 'หน่วยงาน',
      'title': 'สำนักงานคลังจังหวัด',
      'timestamp': '22 พ.ค. 2567 11:10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติการใช้งาน',
          style: TextStyle(fontFamily: 'Kanit', color: Colors.white),
        ),
        backgroundColor: Color(0xFFe7b014),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFf6f8fc),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: _buildIconByType(item['type'] ?? ''),
                title: Text(
                  item['title'] ?? '',
                  style: TextStyle(
                      fontFamily: 'Kanit', fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${item['type']} • ${item['timestamp']}',
                  style: TextStyle(fontFamily: 'Kanit'),
                ),
                onTap: () {
                  // ในอนาคตสามารถเปิดหน้ารายละเอียดได้
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(item['title']!,
                          style: TextStyle(fontFamily: 'Kanit')),
                      content: Text(
                        'หมวดหมู่: ${item['type']}\nวันที่: ${item['timestamp']}',
                        style: TextStyle(fontFamily: 'Kanit'),
                      ),
                      actions: [
                        TextButton(
                          child: Text('ปิด',
                              style: TextStyle(fontFamily: 'Kanit')),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Icon _buildIconByType(String type) {
    switch (type) {
      case 'สินค้า OTOP':
        return Icon(Icons.shopping_bag, color: Color(0xFFe7b014));
      case 'สถานที่ท่องเที่ยว':
        return Icon(Icons.location_on, color: Color(0xFFe7b014));
      case 'ข่าว':
        return Icon(Icons.article, color: Color(0xFFe7b014));
      case 'หน่วยงาน':
        return Icon(Icons.account_balance, color: Color(0xFFe7b014));
      default:
        return Icon(Icons.history, color: Color(0xFFe7b014));
    }
  }
}
