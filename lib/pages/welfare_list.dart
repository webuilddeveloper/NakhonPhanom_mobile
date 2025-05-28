import 'package:flutter/material.dart';

class WelfareListPage extends StatefulWidget {
  @override
  _WelfareListPageState createState() => _WelfareListPageState();
}

class _WelfareListPageState extends State<WelfareListPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> welfareList = [
    {
      'title': 'เบี้ยยังชีพผู้สูงอายุ',
      'subtitle': 'รับเงินช่วยเหลือต่อเดือนสำหรับผู้สูงอายุ',
      'icon': 'elderly',
      'amount': '฿600-1,000',
      'status': 'เปิดรับสมัคร',
    },
    {
      'title': 'บัตรสวัสดิการแห่งรัฐ',
      'subtitle': 'ลดค่าใช้จ่ายพื้นฐานสำหรับผู้มีรายได้น้อย',
      'icon': 'credit_card',
      'amount': 'ลดราคา 50%',
      'status': 'ใช้งานได้',
    },
    {
      'title': 'สิทธิประกันสุขภาพ',
      'subtitle': 'การเข้ารับบริการในโรงพยาบาลใกล้บ้าน',
      'icon': 'local_hospital',
      'amount': 'ฟรี',
      'status': 'พร้อมใช้',
    },
    {
      'title': 'เงินช่วยเหลือผู้พิการ',
      'subtitle': 'เงินสนับสนุนและบริการดูแลสำหรับผู้พิการ',
      'icon': 'accessible',
      'amount': '฿800',
      'status': 'เปิดรับสมัคร',
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

  Color _getIconColor(String iconName) {
    switch (iconName) {
      case 'elderly':
        return Color(0xFF66bb6a);
      case 'credit_card':
        return Color(0xFF42a5f5);
      case 'local_hospital':
        return Color(0xFFef5350);
      case 'accessible':
        return Color(0xFFab47bc);
      default:
        return Color(0xFFe7b014);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'เปิดรับสมัคร':
        return Color(0xFF66bb6a);
      case 'ใช้งานได้':
        return Color(0xFF42a5f5);
      case 'พร้อมใช้':
        return Color(0xFFe7b014);
      default:
        return Colors.grey;
    }
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
          'สวัสดิการชาวนครพนม',
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
                  'สวัสดิการและสิทธิประโยชน์',
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
                    Icon(Icons.health_and_safety_outlined,
                        color: Color(0xFFe7b014), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${welfareList.length} รายการ',
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

          // Welfare List
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: welfareList.length,
              itemBuilder: (context, index) {
                final welfare = welfareList[index];
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
                        child: _buildModernWelfareCard(context, welfare, index),
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

  Widget _buildModernWelfareCard(
      BuildContext context, Map<String, String> welfare, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
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
                          color:
                              _getIconColor(welfare['icon']!).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _mapIcon(welfare['icon']!),
                          size: 40,
                          color: _getIconColor(welfare['icon']!),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        welfare['title']!,
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
                        welfare['subtitle']!,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFe7b014).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFFe7b014).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'จำนวนเงิน: ${welfare['amount']!}',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 14,
                            color: Color(0xFFe7b014),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '(รายละเอียดเพิ่มเติมสามารถเชื่อม API หรือเขียนเพิ่มได้ในอนาคต)',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
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
                            'ปิด',
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
                ),
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
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                children: [
                  Hero(
                    tag: 'welfare_${index}',
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getIconColor(welfare['icon']!).withOpacity(0.1),
                            _getIconColor(welfare['icon']!).withOpacity(0.2),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getIconColor(welfare['icon']!)
                                .withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        _mapIcon(welfare['icon']!),
                        size: 40,
                        color: _getIconColor(welfare['icon']!),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welfare Title
                        Text(
                          welfare['title']!,
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
                          welfare['subtitle']!,
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

                        // Status Badge
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getStatusColor(welfare['status']!)
                                    .withOpacity(0.2),
                                _getStatusColor(welfare['status']!)
                                    .withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getStatusColor(welfare['status']!)
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            welfare['status']!,
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 10,
                              color: _getStatusColor(welfare['status']!),
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
                                if (welfare['amount'] != null)
                                  Text(
                                    welfare['amount']!,
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFe7b014),
                                      letterSpacing: 0.3,
                                    ),
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
