import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: getToolBar(() {
          backClick();
        },
            title: getCustomFont(
              "Help",
              24.sp,
              Colors.black,
              1,
              fontWeight: FontWeight.w700,
            )),
        body: SafeArea(
          child: Column(
            children: [
              getDivider(
                dividerColor,
                1.h,
              ),
              Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    children: [
                      getVerSpace(20.h),
                      getMultilineCustomFont(
                          "Help and Information\n\nWelcome to Pro Hotel App! We're here to make your hotel booking experience seamless and enjoyable. If you have any questions or need assistance, you've come to the right place.\n\nFrequently Asked Questions (FAQ)\n\nExplore common queries and find quick answers in our FAQ section. From booking procedures to payment methods, you'll likely find the information you need here.\n\nContact Us\n\nHave a specific question or issue that isn't covered in the FAQ? Our dedicated support team is available 24/7 to assist you. You can reach us through the following channels:\n\nLive Chat: Chat with a support agent in real-time for immediate assistance.\nEmail: Send us an email at : jeffdeveloper.contact@gmail.com\n\nHow-to Guides\n\nBrowse our collection of how-to guides to learn more about using our app effectively. Whether it's searching for hotels, making reservations, or managing your bookings, these guides provide step-by-step instructions.\n\nTerms and Policies\n\nFor detailed information on our terms of service, privacy policy, and other policies, please refer to the 'Terms and Policies' section.\n\nFeedback\n\nWe value your feedback and suggestions. If you have any ideas for improving our app or if you've encountered any issues, please let us know. Your input helps us enhance your experience.\n\nApp Updates\n\nStay informed about the latest app updates and features. We regularly release improvements to make your hotel booking journey even better.\n\nThank you for choosing Pro Hotel App for your hotel reservations. We're here to assist you every step of the way!",
                          15.sp,
                          greyColor,
                          fontWeight: FontWeight.w500,
                          txtHeight: 1.46.h,
                          textAlign: TextAlign.start)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
