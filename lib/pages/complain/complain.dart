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
    return Scaffold(
      backgroundColor: Color(0xFFf6f8fc),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Image.network(
                            'https://nakhonphanom.treasury.go.th/web-upload/49x7302a2369b742d9bd9ab21aeb3dcfbfa/tinymce/pic.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Smart\nนครพนม',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: '',
                          fontWeight: FontWeight.w600,
                          fontSize: 45,
                          color: Color(0xFFe7b014),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      const Text(
                        'รับเรื่องร้องเรียน',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w600,
                          fontSize: 50,
                          color: Color(0xFFe7b014),
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: buildCategoryButton(
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
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: buildCategoryButton(
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
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFe7b014), Color(0xFFfbd749)],
            stops: [0.0, 0.9],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                icon,
                color: Colors.white,
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
