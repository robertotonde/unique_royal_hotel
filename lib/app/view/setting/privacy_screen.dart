import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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
              "Privacy",
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
                          "Privacy Policy\n\nAt Pro Hotel Booking, we prioritize your privacy and are committed to safeguarding your personal information. This Privacy Policy outlines how we collect, use, and protect your data while you use our hotel booking application. By using our services, you consent to the practices described in this policy.\n\nInformation We Collect\n\nWe may collect the following information when you use our app:\nPersonal Information: This includes your name, contact details, and payment information, which is essential for booking hotels.\n\nLocation Data: We may access your device's location to provide you with hotel options in your preferred area.\n\nUsage Information: We gather data on how you interact with our app to improve your experience.\n\nHow We Use Your Information\n\nWe use your data for the following purposes:\n\nHotel Reservations: To process your bookings and provide confirmation details.\n\nCustomer Support: To assist you with inquiries, requests, and issues.\n\nPersonalization: To tailor hotel recommendations and offers based on your preferences.\n\nData Security\n\nWe take data security seriously and implement industry-standard measures to protect your information from unauthorized access, disclosure, alteration, and destruction.\n\nThird-Party Services\n\nOur app may include links to third-party services. Please be aware that their privacy practices may differ from ours. We encourage you to review their policies.\n\nYour Choices\n\nYou have the right to access, correct, or delete your personal information. You can also opt out of receiving marketing communications from us.\n\nChanges to Privacy Policy\n\nWe may update this Privacy Policy to reflect changes in our practices. Please review it periodically.\n\nBy using our app, you agree to this Privacy Policy. If you have questions or concerns, please contact us at [Your Contact Information].\n\nThank you for trusting [Your App Name] for your hotel booking needs.",
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
