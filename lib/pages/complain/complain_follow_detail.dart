import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ComplainFollowDetail extends StatefulWidget {
  final item;
  const ComplainFollowDetail({super.key, required this.item});

  @override
  State<ComplainFollowDetail> createState() => _ComplainFollowDetailState();
}

class _ComplainFollowDetailState extends State<ComplainFollowDetail> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final images = widget.item['imageUrl'] ?? [];
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFf6f8fc),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery Section
                Container(
                  height: screenHeight * 0.28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final imageUrl = images[index]['imgaeUrl'];
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0XFFe9ca61),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Page Indicator
                if (images.isNotEmpty)
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: images.length,
                      effect: const WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 8,
                        activeDotColor: Color(0XFFe9ca61),
                        dotColor: Colors.grey,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'เรื่อง: ',
                        style: const TextStyle(
                          color: Color(0XFFe9ca61),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: widget.item['title'],
                            style: const TextStyle(
                              color: Color(0xFF2c2c2c),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text.rich(
                      TextSpan(
                        text: 'รายละเอียด: ',
                        style: const TextStyle(
                          color: Color(0XFFe9ca61),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: widget.item['description'],
                            style: const TextStyle(
                              color: Color(0xFF2c2c2c),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Status Section
                    Row(
                      children: [
                        const Text(
                          'สถานะ: ',
                          style: TextStyle(
                            color: Color(0XFFe9ca61),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                              widget.item['reportList'].last['status'],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: getStatusColor(
                                  widget.item['reportList'].last['status'],
                                ).withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.item['reportList'].last['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.item['reportList'].length,
                      itemBuilder: (context, index) {
                        var reportList = widget.item['reportList'][index];
                        bool isLast =
                            index == widget.item['reportList'].length - 1;

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color:
                                          getStatusColor(reportList['status']),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: getStatusColor(
                                                  reportList['status'])
                                              .withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 3,
                                        margin: const EdgeInsets.only(top: 8),
                                        decoration: BoxDecoration(
                                          color: getStatusColor(
                                                  reportList['status'])
                                              .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reportList['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF2c2c2c),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      reportList['description'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Color(0xFF5a5a5a),
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatThaiDate(reportList['createDate']),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (reportList['officer'] != '')
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'โดย ${reportList['officer']}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getStatusColor(dynamic statusValue) {
    int status = int.tryParse(statusValue.toString()) ?? -1;
    switch (status) {
      case 0:
        return const Color(0xFFE57373); // Soft red
      case 1:
        return const Color(0xFFFFB74D); // Soft orange
      case 2:
        return const Color(0xFF81C784); // Soft green
      default:
        return Colors.grey;
    }
  }

  String formatThaiDate(String dateString) {
    // แยกส่วนต่างๆ จาก string "20250522115824"
    String year = dateString.substring(0, 4);
    String month = dateString.substring(4, 6);
    String day = dateString.substring(6, 8);
    String hour = dateString.substring(8, 10);
    String minute = dateString.substring(10, 12);

    // แปลงเป็นปี พ.ศ.
    int buddhistYear = int.parse(year) + 543;

    // ชื่อเดือนภาษาไทย
    List<String> thaiMonths = [
      "มกราคม",
      "กุมภาพันธ์",
      "มีนาคม",
      "เมษายน",
      "พฤษภาคม",
      "มิถุนายน",
      "กรกฎาคม",
      "สิงหาคม",
      "กันยายน",
      "ตุลาคม",
      "พฤศจิกายน",
      "ธันวาคม"
    ];

    // ดึงชื่อเดือน
    String monthName = thaiMonths[int.parse(month) - 1];

    // จัดรูปแบบผลลัพธ์
    return '$hour:$minute น. วันที่ ${int.parse(day)} $monthName $buddhistYear';
  }
}
