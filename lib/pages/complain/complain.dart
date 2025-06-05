import 'package:flutter/material.dart';
import 'package:marine_mobile/pages/complain/complain_detail.dart';
import 'package:marine_mobile/pages/complain/complain_follow.dart';

class ComplainListCategory extends StatefulWidget {
  final Function? changePage;
  final String? title;

  const ComplainListCategory({super.key, this.title, this.changePage});

  @override
  _ComplainListCategoryState createState() => _ComplainListCategoryState();
}

class _ComplainListCategoryState extends State<ComplainListCategory> {
  void goBack() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFf6f8fc),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section - ลดขนาดลง
              SizedBox(height: screenHeight * 0.04),

              // Logo - ปรับขนาดให้เหมาะสม
              SizedBox(
                height: screenHeight * 0.15,
                child: Image.network(
                  'https://nakhonphanom.treasury.go.th/web-upload/49x7302a2369b742d9bd9ab21aeb3dcfbfa/tinymce/pic.png',
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Smart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Charmonman',
                      fontWeight: FontWeight.w600,
                      fontSize: 42,
                      height: 1.0, // ลดระยะห่างบรรทัด
                      color: Color(0xFFe7b014),
                    ),
                  ),
                  Text(
                    'นครพนม',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Charmonman',
                      fontWeight: FontWeight.w600,
                      fontSize: 62,
                      height: 1.0,
                      color: Color(0xFFe7b014),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'รับเรื่องร้องเรียน',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        color: Color(0xFFe7b014),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    buildCategoryButton(
                      title: 'ร้องเรียน',
                      subtitle:
                          'แจ้งเรื่องร้องทุกข์  แจ้งเหตุต่างๆ แจ้งเรื่องร้องเรียน',
                      icon: Icons.feedback_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplainDetail(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    buildCategoryButton(
                      title: 'ติดตามผล',
                      subtitle:
                          'ติดตามผลเรื่องร้องทุกข์  ติดตามเหตุต่างๆ ติดตามผลเรื่องร้องเรียน',
                      icon: Icons.playlist_add_check,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplainFollow(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.12, // ปรับความสูงตามหน้าจอ
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFe7b014), Color(0xFFfbd749)],
            stops: [0.0, 0.9],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe7b014).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
