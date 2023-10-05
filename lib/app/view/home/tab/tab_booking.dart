import 'package:pro_hotel_fullapps/app/view/Booking/upcoming_screen.dart';
import 'package:pro_hotel_fullapps/base/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../Booking/past_screen.dart';

class TabBooking extends StatefulWidget {
  const TabBooking({Key? key}) : super(key: key);

  @override
  State<TabBooking> createState() => _TabBookingState();
}

class _TabBookingState extends State<TabBooking>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  // TicketController pageController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          AppBar(
          leading: Icon(Icons.arrow_back,color: Colors.transparent,),
          centerTitle: true,
          title:  getCustomFont("My Booking", 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        ),
        // Divider(color: dividerColor, thickness: 1.h, height: 1.h),
        getVerSpace(15.h),
        buildTabBar(),
        Expanded(
          flex: 1,
          child: PageView(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: const [UpComingScreen(), PastScreen()],
            onPageChanged: (value) {
              controller.animateTo(value);
            },
          ),
        )
      ],
    );
  }

  Container buildTabBar() {
    return Container(
      padding: EdgeInsets.all(0.h),
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(41.h),
          boxShadow: [
            BoxShadow(
                color: shadowColor, offset: const Offset(0, 8), blurRadius: 27)
          ]),
      child: TabBar(
          controller: controller,
          unselectedLabelColor: greyColor,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(44.h), color: accentColor),
          onTap: (index) {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          tabs: [
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text("Upcoming",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: Constant.fontsFamily,
                        fontSize: 18.sp)),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text("Past",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: Constant.fontsFamily,
                        fontSize: 18.sp)),
              ),
            ),
          ]),
    );
  }

  AppBar buildAppBar() {
    return getToolBar(() {},
        title: getCustomFont("My Booking", 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        leading: false);
  }
}
