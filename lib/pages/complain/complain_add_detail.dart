import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:marine_mobile/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ComplainAddDetail extends StatefulWidget {
  final String label;
  final String code;

  const ComplainAddDetail({
    super.key,
    required this.label,
    required this.code,
  });

  @override
  State<ComplainAddDetail> createState() => _ComplainAddDetailState();
}

class _ComplainAddDetailState extends State<ComplainAddDetail> {
  static const Color titleColor = Color(0XFFe9ca61);
  static const Color borderColor = Colors.grey;

  final txtTitle = TextEditingController();
  final txtDescription = TextEditingController();

  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  List<Map<String, String>> _images = [];
  final int _maxImages = 3;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _takePhoto() async {
    if (_images.length >= _maxImages) {
      _showMaxImagesReachedDialog();
      return;
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      try {
        String imageUrl = await uploadImage(photo);

        setState(() {
          _images.add({"imageUrl": imageUrl});
        });
      } catch (e) {
        print("Upload failed: $e");
      }
    }
  }

  Future<void> _pickImage() async {
    if (_images.length >= _maxImages) {
      _showMaxImagesReachedDialog();
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        String imageUrl = await uploadImage(image);

        setState(() {
          _images.add({"imageUrl": imageUrl});
        });
      } catch (e) {
        print("Upload failed: $e");
      }
    }
  }

  void _showMaxImagesReachedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ขออภัย'),
          content: const Text('คุณสามารถเลือกรูปภาพได้สูงสุด 3 รูปเท่านั้น'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('เข้าใจแล้ว'),
            ),
          ],
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<dynamic> submitReporter() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    json.decode(value!);

    var data = {
      "title": txtTitle.text.trim(),
      "category": widget.code,
      "description": txtDescription.text.trim(),
      "gallery": _images,
    };

    final result = await postObjectData('m/Reporter/create', data);

    if (result['status'] == 'S') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'บันทึกข้อมูลเรียบร้อยแล้ว',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: const Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    goBack();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'บันทึกข้อมูลไม่สำเร็จ',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: new Text(
                result['message'],
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f8fc),
      body: Form(
        // เพิ่ม Form widget และเชื่อมกับ _formKey
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'เพิ่มเรื่องร้องเรียน\nหัวข้อ ${widget.label}',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        color: titleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  buildRequiredLabel('เรื่อง'),
                  const SizedBox(height: 8),
                  buildTextFormField(
                      isMultiline: false,
                      controller: txtTitle), // เปลี่ยนเป็น TextFormField
                  const SizedBox(height: 20),

                  buildRequiredLabel('รายละเอียด'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: buildTextFormField(
                        isMultiline: true, controller: txtDescription),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'แนบรูป (ไม่เกิน 3 รูป)',
                    style: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: buildImageButton(
                          icon: Icons.camera_alt,
                          label: 'ถ่ายรูป',
                          onTap: () {
                            _takePhoto();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: buildImageButton(
                          icon: Icons.photo_camera_back,
                          label: 'แนบรูป',
                          onTap: () {
                            _pickImage();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _images.isEmpty
                      ? SizedBox()
                      : Text(
                          'รูปภาพที่เลือก (${_images.length}/$_maxImages)',
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 120,
                    child: _images.isEmpty
                        ? SizedBox()
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            _images[index]["imageUrl"] ?? ''),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (txtTitle.text.isEmpty) {
                        _showErrorDialog('กรุณาระบุหัวข้อเรื่อง');
                        return;
                      }
                      if (txtDescription.text.isEmpty) {
                        _showErrorDialog('กรุณาระบุรายละเอียด');
                        return;
                      }

                      submitReporter();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: titleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'แจ้งเรื่อง',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRequiredLabel(String labelText) {
    return Text.rich(
      TextSpan(
        text: '$labelText ',
        style: const TextStyle(
          fontFamily: 'Kanit',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        children: const [
          TextSpan(
            text: '*',
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'Kanit',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField({
    required bool isMultiline,
    required TextEditingController controller,
  }) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.top,
      controller: controller,
      expands: isMultiline,
      maxLines: isMultiline ? null : 1,
      minLines: isMultiline ? null : 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกข้อมูล';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: titleColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'แจ้งเตือน',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                "ตกลง",
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Color(0xFF005C9E),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: borderColor,
              size: 35,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Kanit',
                color: borderColor,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
