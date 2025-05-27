import 'package:flutter/material.dart';
import 'otop_product_detail.dart';

class OtopProductListPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'name': 'กระเป๋าสานมือ',
      'image':
          'https://gateway.we-builds.com/wb-py-media/uploads/nakhonphanom\\20250527-111652-2fbb960de6bdcc8577d47800645cc477.jpeg',
      'description': 'กระเป๋าสานจากใบเตยหอม ทำมือ 100%',
    },
    {
      'name': 'สบู่สมุนไพร',
      'image':
          'https://gateway.we-builds.com/wb-py-media/uploads/nakhonphanom\\20250527-111808-039b2f71f192a0989e12f688a9140df0.png_720x720q80.png',
      'description': 'สบู่สมุนไพรกลิ่นตะไคร้ หอมสดชื่น',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFe7b014),
        iconTheme: IconThemeData(
          color: Colors.white, // สีของปุ่ม Back
        ),
        title: Text(
          'สินค้า OTOP',
          style: TextStyle(
            fontFamily: 'Kanit',
            color: Colors.white, // สีของข้อความ Title
          ),
        ),
      ),
      backgroundColor: Color(0xFFf6f8fc),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(product['name']!,
                  style: TextStyle(fontFamily: 'Kanit', fontSize: 18)),
              subtitle: Text(product['description']!,
                  style: TextStyle(fontFamily: 'Kanit')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtopProductDetailPage(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
