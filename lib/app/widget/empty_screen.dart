import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 
                      getAssetImage("avNoData.png",
                                  height: 210.h),
                            getVerSpace(28.h),
                            getCustomFont(
                                "No Item Yet!", 20.sp, Colors.black, 1,
                                fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                            getVerSpace(8.h),
                            Padding(
                              padding: const EdgeInsets.only(left:25.0,right: 25),
                              child: getMultilineCustomFont(
                                  "Currently does not have the required item!",
                                  17.sp,
                                  Colors.black54,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w500,
                                  txtHeight: 1.5.h),
                            )
              ],
            ),
                );
  }
}