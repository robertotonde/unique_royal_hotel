import 'package:pro_hotel_fullapps/app/controller/controller.dart';
import 'package:pro_hotel_fullapps/app/dialog/snacbar.dart';
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  void backClick() {
    Constant.backToPrev(context);
  }

  ForgotController controller = Get.put(ForgotController());
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var emailCtrl = TextEditingController();
  late String _email;

  void handleSubmit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      resetPassword(_email);
    }
  }

  Future<void> resetPassword(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text(
            'An email has been sent to $email. \n\nGo to that link & reset your password.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
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
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: getToolBar(
          () {
            backClick();
          },
         ),
        body: SafeArea(
          child: Column(
            children: [
              getDivider(
                dividerColor,
                1.h,
              ),
              getVerSpace(30.h),
              getCustomFont("Forgot your Password?", 24.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  txtHeight: 1.5.h),
              getVerSpace(15.h),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20.0),
                child: getMultilineCustomFont(
                    "Enter your email address below to receive password reset instruction.",
                    16.sp,
                    Colors.black54,
                    txtHeight: 1.5.h,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500),
              ),
              getVerSpace(38.h),
              getVerSpace(30.h),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(34.h)),
                        boxShadow: [
                          BoxShadow(
                              color: "#2B9CC3C6".toColor(),
                              blurRadius: 24,
                              offset: const Offset(0, -2))
                        ]),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          getVerSpace(30.h),
                          getCustomFont("Email", 16.sp, Colors.black, 1,
                              fontWeight: FontWeight.w600),
                          getVerSpace(7.h),
                          getDefaultTextFiledWithLabel(
                              onChanged: (String value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                              context,
                              "Enter email",
                              emailCtrl,
                              isEnable: false,
                              height: 60.h,
                              validator: (email) {
                                if (email!.isEmpty) {
                                  return "Please enter email address.";
                                }
                                return null;
                              }),
                          getVerSpace(36.h),
                          Spacer(),
                          getButton(
                              context, accentColor, "Submit", Colors.white, () {
                         
                      handleSubmit();
                          }, 18.sp,
                              weight: FontWeight.w700,
                              buttonHeight: 60.h,
                              borderRadius: BorderRadius.circular(22.h)),
                      
                      
                          getVerSpace(36.h),  ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
