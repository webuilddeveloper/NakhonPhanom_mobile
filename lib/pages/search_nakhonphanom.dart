import 'package:flutter/material.dart';

class SearchNakhonPhanomPage extends StatefulWidget {
  const SearchNakhonPhanomPage({super.key});

  @override
  State<SearchNakhonPhanomPage> createState() => _SearchNakhonPhanomPageState();
}

class _SearchNakhonPhanomPageState extends State<SearchNakhonPhanomPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _searchAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _searchFadeAnimation;

  List<Map<String, String>> allData = [
    {
      'title': 'กระเป๋าสานมือ',
      'category': 'OTOP',
      'description': 'กระเป๋าสานจากใบเตยหอม ทำมือ 100%',
      'icon': 'shopping_bag',
    },
    {
      'title': 'สบู่สมุนไพรตะไคร้',
      'category': 'OTOP',
      'description': 'สบู่สมุนไพรกลิ่นตะไคร้ หอมสดชื่น',
      'icon': 'soap',
    },
    {
      'title': 'ถนนคนเดินนครพนมเปิดทุกเสาร์',
      'category': 'ข่าว',
      'description': 'ข่าวสารกิจกรรมและเหตุการณ์ต่างๆ',
      'icon': 'newspaper',
    },
    {
      'title': 'วัดพระธาตุพนม',
      'category': 'สถานที่ท่องเที่ยว',
      'description': 'สถานที่ท่องเที่ยวสำคัญของจังหวัดนครพนม',
      'icon': 'place',
    },
    {
      'title': 'สำนักงานคลังจังหวัดนครพนม',
      'category': 'หน่วยงาน',
      'description': 'หน่วยงานราชการในจังหวัดนครพนม',
      'icon': 'business',
    },
    {
      'title': 'งานแห่เทียนเข้าพรรษา',
      'category': 'กิจกรรม',
      'description': 'กิจกรรมประจำปีของจังหวัดนครพนม',
      'icon': 'event',
    },
  ];

  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = allData;

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _searchAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _searchFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _searchAnimationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _searchAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = allData;
      } else {
        filteredData = allData
            .where((item) =>
                item['title']!.toLowerCase().contains(query.toLowerCase()) ||
                item['category']!.toLowerCase().contains(query.toLowerCase()) ||
                item['description']!
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  IconData _getIconByName(String iconName) {
    switch (iconName) {
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'soap':
        return Icons.soap_outlined;
      case 'newspaper':
        return Icons.newspaper_outlined;
      case 'place':
        return Icons.place_outlined;
      case 'business':
        return Icons.business_outlined;
      case 'event':
        return Icons.event_outlined;
      default:
        return Icons.search_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'OTOP':
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'ค้นหานครพนม',
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: FadeTransition(
              opacity: _searchFadeAnimation,
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
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                  decoration: InputDecoration(
                    hintText: 'ค้นหา... เช่น OTOP, วัด, ข่าว',
                    hintStyle: TextStyle(
                      fontFamily: 'Kanit',
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.search_rounded,
                        color: Color(0xFFe7b014),
                        size: 24,
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.clear_rounded,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFFe7b014).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Search Results
          Expanded(
            child: filteredData.isEmpty
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
                              Icons.search_off_rounded,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'ไม่พบข้อมูลที่ค้นหา',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ลองใช้คำค้นหาอื่น หรือตรวจสอบการสะกด',
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
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
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
                                  _buildModernSearchCard(context, item, index),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _buildModernSearchCard(
      BuildContext context, Map<String, String> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
                          color: _getCategoryColor(item['category']!)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getIconByName(item['icon']!),
                          size: 40,
                          color: _getCategoryColor(item['category']!),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(item['category']!)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _getCategoryColor(item['category']!)
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          item['category']!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 12,
                            color: _getCategoryColor(item['category']!),
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
                        item['description']!,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
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
                  Hero(
                    tag: 'search_${index}',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getCategoryColor(item['category']!)
                                .withOpacity(0.1),
                            _getCategoryColor(item['category']!)
                                .withOpacity(0.2),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getCategoryColor(item['category']!)
                                .withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getIconByName(item['icon']!),
                        size: 28,
                        color: _getCategoryColor(item['category']!),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(item['category']!)
                                    .withOpacity(0.2),
                                _getCategoryColor(item['category']!)
                                    .withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getCategoryColor(item['category']!)
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item['category']!,
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 10,
                              color: _getCategoryColor(item['category']!),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
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
                          item['description']!,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.3,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
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
}
