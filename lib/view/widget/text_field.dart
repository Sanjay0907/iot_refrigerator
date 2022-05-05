import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot_refridgerator/view/utils/colours.dart';
import 'package:sizer/sizer.dart';

class TextInputField extends StatelessWidget {
  // const TextInputField({ Key? key }) : super(key: key);
  TextInputField({required this.hintText, required this.controller});

  String hintText;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
          color: lightTealColor, borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.only(left: 3.w),
      height: 5.h,
      width: 70.w,
      alignment: Alignment.center,
      child: TextField(
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        controller: controller,
        onChanged: (value) {},
        // autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.black,
          prefixStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 65, 64, 64),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
