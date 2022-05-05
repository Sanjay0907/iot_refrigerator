import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/colours.dart';

class DTHDataContainer extends StatelessWidget {
  DTHDataContainer({required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      height: 18.h,
      width: 100.w,
      // color: Colors.amber,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: containerColor,
      ),
      child: child,
    );
  }
}
