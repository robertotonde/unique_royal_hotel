import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

import '../select_interset/select_interest_screen.dart';
import '../welcome/Welcome_Page.dart';
import 'Model/model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentPosition = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: context.height(),
                child: PageView.builder(
                  itemCount: esWalkThroughList.length,
                  itemBuilder: (context, i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [ Image.asset(
                              "assets/images/Background.png",
                              width: context.width(),
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:220.0.h,left: 40.0.w,right: 40.0.w),
                              child: Image.asset(
                                esWalkThroughList[i].image.validate(),
                                width: context.width(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        64.height,
                        Text(
                                esWalkThroughList[currentPosition]
                                    .title
                                    .validate(),
                                style: boldTextStyle(size: 20).copyWith(fontFamily: "RedHat",fontWeight: FontWeight.bold,fontSize: 22.sp))
                            .paddingOnly(left: 16.w),
                        Text(
                                esWalkThroughList[currentPosition]
                                    .subTitle
                                    .validate(),
                                style: secondaryTextStyle().copyWith(fontFamily: "RedHat"))
                            .paddingAll(16.w),
                      ],
                    );
                  },
                  controller: pageController,
                  onPageChanged: (int page) {
                    currentPosition = page;
                    setState(() {});
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DotIndicator(
                    pageController: pageController,
                    indicatorColor: Color(0XFF136EC2),
                    unselectedIndicatorColor: grey.withOpacity(0.2),
                    currentBoxShape: BoxShape.rectangle,
                    boxShape: BoxShape.rectangle,
                    borderRadius: radius(2),
                    currentBorderRadius: radius(3),
                    currentDotSize: 18.h,
                    currentDotWidth: 6.w,
                    dotSize: 6.h,
                    pages: esWalkThroughList,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: boxDecorationDefault(
                            shape: BoxShape.circle, color: Color(0XFF136EC2)),
                        child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ).onTap(
                        () {
                          pageController.nextPage(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.linearToEaseOut);
                        },
                      ).visible(currentPosition < 2),
                      AppButton(
                        color: Color(0XFF136EC2),
                        text: "Get Started",
                        width: context.width() * 0.1,
                        textColor: Colors.white,
                        textStyle: TextStyle(fontFamily: "RedHat",color: Colors.white),
                        onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WelcomePage()));
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SelectInterestScreen()));  
                        },
                      ).visible(currentPosition == 2)
                    ],
                  ),
                ],
              ).paddingOnly(bottom: 40.h, left: 30.w, right: 30.w),
            ],
          ),
        ],
      ),
    );
  }
}
