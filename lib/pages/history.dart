import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> historyList = [
    {
      'type': 'สินค้า OTOP',
      'title': 'สบู่สมุนไพรตะไคร้',
      'timestamp': '25 พ.ค. 2567 14:20',
      'description': 'สบู่สมุนไพรกลิ่นตะไคร้ หอมสดชื่น',
      'icon': 'shopping_bag',
    },
    {
      'type': 'สถานที่ท่องเที่ยว',
      'title': 'วัดพระธาตุพนม',
      'timestamp': '24 พ.ค. 2567 09:15',
      'description': 'สถานที่ท่องเที่ยวสำคัญของจังหวัดนครพนม',
      'icon': 'place',
    },
    {
      'type': 'ข่าว',
      'title': 'ถนนคนเดินเปิดอีกครั้งทุกวันเสาร์',
      'timestamp': '23 พ.ค. 2567 18:45',
      'description': 'ข่าวสารกิจกรรมและเหตุการณ์ต่างๆ',
      'icon': 'newspaper',
    },
    {
      'type': 'หน่วยงาน',
      'title': 'สำนักงานคลังจังหวัด',
      'timestamp': '22 พ.ค. 2567 11:10',
      'description': 'หน่วยงานราชการในจังหวัดนครพนม',
      'icon': 'business',
    },
    {
      'type': 'กิจกรรม',
      'title': 'งานแห่เทียนเข้าพรรษา',
      'timestamp': '21 พ.ค. 2567 16:30',
      'description': 'กิจกรรมประจำปีของจังหวัดนครพนม',
      'icon': 'event',
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

  IconData _getIconByName(String iconName) {
    switch (iconName) {
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'place':
        return Icons.place_outlined;
      case 'newspaper':
        return Icons.newspaper_outlined;
      case 'business':
        return Icons.business_outlined;
      case 'event':
        return Icons.event_outlined;
      default:
        return Icons.history_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'สินค้า OTOP':
        return Color(0xFFe7b014);
      case 'ข่าว':
        return Color(0xFF42a5f5);
      case 'สถานที่ท่องเที่ยว':
        return Color(0xFF66bb6a);
      case 'หน่วยงาน':
        return Color(0xFFef5350);
      case 'กิจกรรม':
        return Color(0xFFab47bc);
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(String timestamp) {
    // Simple time ago calculation - in real app, use proper date parsing
    if (timestamp.contains('25 พ.ค.')) return '2 วันที่แล้ว';
    if (timestamp.contains('24 พ.ค.')) return '3 วันที่แล้ว';
    if (timestamp.contains('23 พ.ค.')) return '4 วันที่แล้ว';
    if (timestamp.contains('22 พ.ค.')) return '5 วันที่แล้ว';
    if (timestamp.contains('21 พ.ค.')) return '6 วันที่แล้ว';
    return 'ไม่ทราบ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'ประวัติการใช้งาน',
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
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: Colors.white),
            onPressed: () {
              _showClearHistoryDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFe7b014).withOpacity(0.1),
                          Color(0xFFe7b014).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: Color(0xFFe7b014),
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายการทั้งหมด',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${historyList.length} รายการ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFe7b014).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFFe7b014).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '7 วันล่าสุด',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 12,
                        color: Color(0xFFe7b014),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // History List
          Expanded(
            child: historyList.isEmpty
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.history_toggle_off_rounded,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'ไม่มีประวัติการใช้งาน',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'เริ่มต้นใช้งานเพื่อดูประวัติที่นี่',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final item = historyList[index];
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
                                (index * 0.1).clamp(0.0, 1.0),
                                ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                                curve: Curves.easeOutCubic,
                              ),
                            )),
                            child: FadeTransition(
                              opacity:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(
                                    (index * 0.1).clamp(0.0, 1.0),
                                    ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                                  ),
                                ),
                              ),
                              child:
                                  _buildModernHistoryCard(context, item, index),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildModernHistoryCard(
      BuildContext context, Map<String, String> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showHistoryDetailDialog(item);
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
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon Container
                  Hero(
                    tag: 'history_${index}',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getCategoryColor(item['type']!).withOpacity(0.1),
                            _getCategoryColor(item['type']!).withOpacity(0.2),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getCategoryColor(item['type']!)
                                .withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getIconByName(item['icon']!),
                        size: 28,
                        color: _getCategoryColor(item['type']!),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge & Time
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getCategoryColor(item['type']!)
                                        .withOpacity(0.2),
                                    _getCategoryColor(item['type']!)
                                        .withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getCategoryColor(item['type']!)
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                item['type']!,
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 10,
                                  color: _getCategoryColor(item['type']!),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getTimeAgo(item['timestamp']!),
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Title
                        Text(
                          item['title']!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                            height: 1.2,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),

                        // Description
                        Text(
                          item['description'] ?? 'ไม่มีรายละเอียด',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.3,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),

                        // Timestamp
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 4),
                            Text(
                              item['timestamp']!,
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFe7b014),
                          Color(0xFFf4c430),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFe7b014).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Colors.white,
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

  void _showHistoryDetailDialog(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getCategoryColor(item['type']!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getIconByName(item['icon']!),
                  size: 40,
                  color: _getCategoryColor(item['type']!),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(item['type']!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _getCategoryColor(item['type']!).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  item['type']!,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 12,
                    color: _getCategoryColor(item['type']!),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                item['title']!,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                item['description'] ?? 'ไม่มีรายละเอียด',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Text(
                      item['timestamp']!,
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                '(ในอนาคตสามารถไปยังหน้ารายละเอียดได้)',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[700],
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'ปิด',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to detail page in the future
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFe7b014),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'ดูรายละเอียด',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'ล้างประวัติทั้งหมด',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'คุณต้องการลบประวัติการใช้งานทั้งหมดใช่หรือไม่? การดำเนินการนี้ไม่สามารถย้อนกลับได้',
          style: TextStyle(
            fontFamily: 'Kanit',
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                fontFamily: 'Kanit',
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                historyList.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'ลบประวัติเรียบร้อยแล้ว',
                    style: TextStyle(fontFamily: 'Kanit'),
                  ),
                  backgroundColor: Color(0xFFe7b014),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[500],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'ลบทั้งหมด',
              style: TextStyle(fontFamily: 'Kanit'),
            ),
          ),
        ],
      ),
    );
  }
}
