import 'package:flutter/material.dart';

class OtopProductDetailPage extends StatelessWidget {
  final Map<String, String> product;

  const OtopProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> comments = [
      {
        'name': 'คุณสมศรี',
        'comment': 'กลิ่นหอมมาก ใช้แล้วผิวนุ่มสุด ๆ เลยค่ะ',
      },
      {
        'name': 'คุณเอกชัย',
        'comment': 'แพ็กเกจดูดี สะอาด น่าซื้ออีกแน่นอนครับ',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFe7b014),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          product['name']!,
          style: TextStyle(fontFamily: 'Kanit', color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xFFf6f8fc),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product['image']!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                product['name']!,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                product['description']!,
                style: TextStyle(fontFamily: 'Kanit', fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < 4 ? Colors.orange : Colors.grey,
                    size: 28,
                  );
                }),
              ),
              SizedBox(height: 24),
              Text(
                'ความคิดเห็นจากผู้ใช้:',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              ...comments.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFe7b014),
                        child: Text(
                          c['name']![0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        c['name']!,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        c['comment']!,
                        style: TextStyle(fontFamily: 'Kanit'),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
