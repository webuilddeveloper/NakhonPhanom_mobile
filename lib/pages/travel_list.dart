import 'package:flutter/material.dart';
import 'package:marine_mobile/component/header.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelPlacesList extends StatefulWidget {
  final String title;
  final List<Map<String, String>> places;

  const TravelPlacesList({
    Key? key,
    required this.title,
    required this.places,
  }) : super(key: key);

  @override
  State<TravelPlacesList> createState() => _TravelPlacesListState();
}

class _TravelPlacesListState extends State<TravelPlacesList> {
  String _searchQuery = '';
  List<Map<String, String>> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _filteredPlaces = widget.places;
  }

  void _filterPlaces(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPlaces = widget.places;
      } else {
        _filteredPlaces = widget.places.where((place) {
          return place['name']!.toLowerCase().contains(query.toLowerCase()) ||
              place['location']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar('ไม่สามารถเปิดลิงก์ได้');
      }
    } catch (e) {
      _showSnackBar('เกิดข้อผิดพลาดในการเปิดลิงก์');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Kanit'),
        ),
        backgroundColor: const Color(0xFF27544F),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: header(
        context,
        goBack,
        title: 'ท่องเที่ยวยอดนิยม',
      ),
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFe7b014),
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     widget.title,
      //     style: const TextStyle(
      //       fontFamily: 'Kanit',
      //       fontWeight: FontWeight.w500,
      //       color: Colors.white,
      //       fontSize: 18,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF8F9FA),
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: _filterPlaces,
                style: const TextStyle(fontFamily: 'Kanit'),
                decoration: InputDecoration(
                  hintText: 'ค้นหาสถานที่ท่องเที่ยว...',
                  hintStyle: TextStyle(
                    fontFamily: 'Kanit',
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFe7b014),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'พบ ${_filteredPlaces.length} สถานที่',
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF27544F),
                  ),
                ),
                if (_searchQuery.isNotEmpty) ...[
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _filteredPlaces = widget.places;
                      });
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('ล้างการค้นหา'),
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFFe7b014),
                      textStyle: const TextStyle(fontFamily: 'Kanit'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredPlaces.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _filteredPlaces[index];
                      return _buildPlaceCard(place);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่พบสถานที่ท่องเที่ยวที่ค้นหา',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ลองค้นหาด้วยคำอื่น',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, String> place) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _launchURL(place['url']!),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  place['imageUrl']!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 3,
                          color: Color(0xFFe7b014),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ไม่สามารถโหลดรูปภาพ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFe7b014),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF666666),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place['location']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Review
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27544F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      place['review']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF27544F),
                      ),
                    ),
                  ),
                  // Description
                  if (place.containsKey('description') &&
                      place['description']!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      place['description']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchURL(place['url']!),
                      icon: const Icon(Icons.launch, size: 16),
                      label: const Text(
                        'ดูข้อมูลเพิ่มเติม',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFe7b014),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
