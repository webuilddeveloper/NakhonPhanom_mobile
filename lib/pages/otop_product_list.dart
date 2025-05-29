import 'package:flutter/material.dart';
import 'otop_product_detail.dart';

class OtopProductListPage extends StatefulWidget {
  @override
  _OtopProductListPageState createState() => _OtopProductListPageState();
}

class _OtopProductListPageState extends State<OtopProductListPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> products = [
    {
      'name': 'กระเป๋าสานมือ',
      'image':
          'https://gateway.we-builds.com/wb-py-media/uploads/nakhonphanom\\20250527-111652-2fbb960de6bdcc8577d47800645cc477.jpeg',
      'description': 'กระเป๋าสานจากใบเตยหอม ทำมือ 100%',
      'price': '฿850',
      'category': 'งานฝีมือ',
      'rating': '4.8',
    },
    {
      'name': 'สบู่สมุนไพร',
      'image':
          'https://gateway.we-builds.com/wb-py-media/uploads/nakhonphanom\\20250527-111808-039b2f71f192a0989e12f688a9140df0.png_720x720q80.png',
      'description': 'สบู่สมุนไพรกลิ่นตะไคร้ หอมสดชื่น',
      'price': '฿120',
      'category': 'ผลิตภัณฑ์ธรรมชาติ',
      'rating': '4.9',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'สินค้า OTOP',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Color(0xFFe7b014),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFe7b014),
                Color(0xFFf4c430),
                Color(0xFFe7b014),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สินค้าคุณภาพจากชุมชน',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        color: Color(0xFFe7b014), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${products.length} รายการ',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats Section
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: FadeTransition(
          //     opacity: _fadeAnimation,
          //     child: Container(
          //       padding: EdgeInsets.all(20),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(24),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withOpacity(0.04),
          //             blurRadius: 20,
          //             offset: Offset(0, 8),
          //           ),
          //         ],
          //       ),
          //       child: Row(
          //         children: [
          //           _buildStatItem(
          //             icon: Icons.inventory_2_outlined,
          //             value: '${products.length}',
          //             label: 'รายการ',
          //             color: Color(0xFFe7b014),
          //           ),
          //           SizedBox(width: 20),
          //           _buildStatItem(
          //             icon: Icons.star_rounded,
          //             value: '4.8',
          //             label: 'คะแนน',
          //             color: Color(0xFFffa726),
          //           ),
          //           SizedBox(width: 20),
          //           _buildStatItem(
          //             icon: Icons.local_shipping_outlined,
          //             value: 'ฟรี',
          //             label: 'จัดส่ง',
          //             color: Color(0xFF66bb6a),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 20),

          // Product List
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index * 0.2).clamp(0.0, 1.0),
                          ((index * 0.2) + 0.4).clamp(0.0, 1.0),
                          curve: Curves.easeOutCubic,
                        ),
                      )),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index * 0.2).clamp(0.0, 1.0),
                              ((index * 0.2) + 0.4).clamp(0.0, 1.0),
                            ),
                          ),
                        ),
                        child: _buildModernProductCard(context, product, index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernProductCard(
      BuildContext context, Map<String, String> product, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    OtopProductDetailPage(product: product),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                children: [
                  Hero(
                    tag: 'product_${index}',
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFe7b014).withOpacity(0.1),
                            Color(0xFFf4c430).withOpacity(0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFe7b014).withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          product['image']!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey[200]!,
                                    Colors.grey[100]!,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFe7b014),
                                  ),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey[200]!,
                                    Colors.grey[100]!,
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey[400],
                                size: 36,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          product['name']!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                            height: 1.2,
                            letterSpacing: 0.3,
                          ),
                        ),

                        SizedBox(height: 6),

                        // Description
                        Text(
                          product['description']!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.4,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 12),
                        if (product['category'] != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFe7b014).withOpacity(0.2),
                                  Color(0xFFf4c430).withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xFFe7b014).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              product['category']!,
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 10,
                                color: Color(0xFFe7b014),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product['price'] != null)
                                  Text(
                                    product['price']!,
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFe7b014),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                if (product['rating'] != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: Color(0xFFffa726),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        product['rating']!,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFe7b014),
                                    Color(0xFFf4c430),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFe7b014).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
