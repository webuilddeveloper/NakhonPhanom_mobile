import 'package:flutter/material.dart';

class WelfareListPage extends StatelessWidget {
  final List<Map<String, String>> welfareList = [
    {
      'title': 'เบี้ยยังชีพผู้สูงอายุ',
      'subtitle': 'รับเงินช่วยเหลือต่อเดือนสำหรับผู้สูงอายุ',
      'icon': 'elderly',
    },
    {
      'title': 'บัตรสวัสดิการแห่งรัฐ',
      'subtitle': 'ลดค่าใช้จ่ายพื้นฐานสำหรับผู้มีรายได้น้อย',
      'icon': 'credit_card',
    },
    {
      'title': 'สิทธิประกันสุขภาพ',
      'subtitle': 'การเข้ารับบริการในโรงพยาบาลใกล้บ้าน',
      'icon': 'local_hospital',
    },
    {
      'title': 'เงินช่วยเหลือผู้พิการ',
      'subtitle': 'เงินสนับสนุนและบริการดูแลสำหรับผู้พิการ',
      'icon': 'accessible',
    },
  ];

  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'elderly':
        return Icons.elderly;
      case 'credit_card':
        return Icons.credit_card;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'accessible':
        return Icons.accessible;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFe7b014),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'สวัสดิการชาวนครพนม',
          style: TextStyle(
            fontFamily: 'Kanit',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Color(0xFFf6f8fc),
      body: ListView.builder(
        itemCount: welfareList.length,
        itemBuilder: (context, index) {
          final item = welfareList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(
                  _mapIcon(item['icon']!),
                  size: 40,
                  color: Color(0xFFe7b014),
                ),
                title: Text(
                  item['title']!,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  item['subtitle']!,
                  style: TextStyle(fontFamily: 'Kanit'),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // เพิ่มการเปิดหน้ารายละเอียดในอนาคตได้ที่นี่
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(item['title']!,
                          style: TextStyle(fontFamily: 'Kanit')),
                      content: Text(
                          '${item['subtitle']}\n\n(รายละเอียดเพิ่มเติมสามารถเชื่อม API หรือเขียนเพิ่มได้ในอนาคต)',
                          style: TextStyle(fontFamily: 'Kanit')),
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
}
