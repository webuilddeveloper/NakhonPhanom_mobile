// import 'package:weconnectsecurity/widget/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:marine_mobile/widget/text_form_field.dart';

textbox(
    {TextEditingController? controller,
    String title = '',
    bool enabled = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      labelTextFormField(title),
      // Text(
      //   title,
      //   style: TextStyle(
      //     fontSize: 18.00,
      //     fontFamily: 'Sarabun',
      //     fontWeight: FontWeight.w500,
      //     // color: Color(0xFFBC0611),
      //   ),
      // ),
      const SizedBox(height: 2.0),
      // labelTextFormField('* ชื่อผู้ใช้งาน'),
      textFormField(
        controller,
        null,
        title,
        title,
        enabled,
        false,
        false,
      ),
    ],
  );
}
