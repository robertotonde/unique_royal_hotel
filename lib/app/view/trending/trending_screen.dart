import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro_hotel_fullapps/app/controller/controller.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/featured_event_detail2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pro_hotel_fullapps/app/widget/empty_screen.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../data/data_file.dart';
import 'package:evente/evente.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
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
              "Country Hotels",
              20.sp,
              Colors.black,
              1,
              fontWeight: FontWeight.w700,
            ),
            
            ),
        body: SafeArea(
          child: DefaultTabController(
            length: 13,
            child: Scaffold(
              backgroundColor: Colors.white,
                               appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(
                            45.0), // here the desired height
                        // ignore: unnecessary_new
                        child: new AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            centerTitle: true,
                            automaticallyImplyLeading: false,
                            title: TabBar(
                              padding: EdgeInsets.all(0.0),
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.white,
                              labelStyle: const TextStyle(fontSize: 19.0),
                              indicatorPadding: EdgeInsets.all(0),

                              // ignore: unnecessary_new
                              // ignore: prefer_const_constr
                              indicator: BubbleTabIndicator(
                                indicatorHeight: 45.0,
                                indicatorColor: accentColor,
                                padding: EdgeInsets.all(0.0),
                                // insets: EdgeInsets.only(left:14,right: 10.0),
                                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                              ),
                              tabs: <Widget>[
                                // ignore: unnecessary_new

                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0,
                                                bottom: 2.0,
                                                left: 0.0),
                                            child: Container(
                                              height: 44.h,
                                              width: 44.h,
                                              decoration: BoxDecoration(
                                                  color: lightAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.h)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 9.h,
                                                  vertical: 9.h),
                                              child: getAssetIcon(
                                                  "unitedstates.png",
                                                  height: 26.h,
                                                  width: 26.h),
                                            ),
                                          ),
                                          getHorSpace(6.h),
                                        ],
                                      ),
                                      const Text(
                                        "United State",
                                        style: TextStyle(
                                            fontFamily: Constant.fontsFamily,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600),
                                      ),

                                      // getHorSpace(6.h)
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon("italy.png",
                                                    height: 26.h, width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Italy",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon("spain.png",
                                                    height: 26.h, width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Spain",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "australia.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Australia",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),

                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "france.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "France",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "greece.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Greece",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "singapore.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Singapore",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),

                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "switzerland.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Switzerland",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon("japan.png",
                                                    height: 26.h, width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Japan",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "thailand.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Thailand",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon("egypt.png",
                                                    height: 26.h, width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Egypt",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "canada.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Canada",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),

                                Tab(
                                  child: Container(
                                    height: 47.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetIcon(
                                                    "indonesia.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Indonesia",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        getHorSpace(6.h)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
      
                       body: Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: TabBarView(
                  children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'unitedstate')
                                .snapshots(),
                          builder: (BuildContext ctx,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return snapshot.hasData
                                  ? buildTrendingEventList(
                                      list: snapshot.data?.docs,
                                    )
                                  : EmptyScreen();
                          },
                        ),
                                   StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'italy')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                     : EmptyScreen();
                     
                                     },
                                   ),
                                   StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'spain')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),
                                   StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'australia')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),
                                   StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'france')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),

                                         StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'greece')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),
      StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'singapore')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),

                                         StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'switzerland')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),

                                         StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'japan')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),
                       StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'thailand')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),

                                         StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'egypt')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),

                                         StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'canada')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),

                                         StreamBuilder(
                                     stream: FirebaseFirestore.instance
                                  .collection("hotel")
                                  .where('country', isEqualTo: 'indonesia')
                  .snapshots(),
                                     builder: (BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                     if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: EmptyScreen());
                            }
                return snapshot.hasData
                    ? buildTrendingEventList(
                        list: snapshot.data?.docs,
                      )
                    : Container();
                                     },
                                   ),

       
                                     
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

 }



class buildTrendingEventList extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const buildTrendingEventList({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          primary: false,
        scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list?.length,
          itemBuilder: (context, i) {

          final events = list?.map((e) {
            return Hotel.fromFirestore(e, 1);
          }).toList();
          //     String? category = list?[i]['category'].toString();
          // String? date = list?[i]['date'].toString();
          // String? image = list?[i]['image'].toString();
          // String? description = list?[i]['description'].toString();
          // String? id = list?[i]['id'].toString();
          // String? location = list?[i]['location'].toString();
          // double? mapsLangLink = list?[i]['mapsLangLink'];
          // double? mapsLatLink = list?[i]['mapsLatLink'];
          // int? price = list?[i]['price'];
          // String? title = list?[i]['title'].toString();
          // String? type = list?[i]['type'].toString();
          // String? userDesc = list?[i]['userDesc'].toString();
          // String? userName = list?[i]['userName'].toString();
          // String? userProfile = list?[i]['userProfile'].toString();


            return GestureDetector(
              onTap: () {
           FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
  Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new hotelDetail2(
                              hotel: events?[i],
                            ),
                        transitionDuration: const Duration(milliseconds: 1000),
                        transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return Opacity(
                            opacity: animation.value,
                            child: child,
                          );
                        })); },
              child: SizedBox(
                height: 285.h,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Hero(
                    tag: 'hero-tagss-${events?[i].id}' ?? '',
                     
                child: Material(
                  
                      color:  Colors.transparent,
                 child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.h),
                              image: DecorationImage(
                                  image: NetworkImage(events?[i].image ?? ''),
                                  fit: BoxFit.fill)),
                          height: 170.h,
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 12.h, top: 12.h),
                          child: Wrap(
                            children: [
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      width: 362.w,
                      top: 132.h,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 27,
                                  offset: const Offset(0, 8))
                            ],
                            borderRadius: BorderRadius.circular(22.h)),
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getVerSpace(16.h),
                            getCustomFont(events?[i].title ?? "", 18.sp,
                                Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                            getVerSpace(2.h),
                            Row(
                              children: [
                                getSvgImage("location.svg",
                                    width: 20.h,
                                    height: 20.h,
                                    color: greyColor),
                                getHorSpace(5.h),
                                Container(
                                  width: MediaQuery.of(context).size.width-200,
                                  child: getCustomFont(events?[i].location ?? "",
                                      15.sp, greyColor, 1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                )
                              ],
                            ),
                            getVerSpace(15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     children: [
                                                       Row(
                                                         children: [
                                                           Row(
                                                             children: <Widget>[
                                                               Icon(
                                                                 Icons.star,
                                                                 color: Colors.yellow[600],
                                                                 size: 15.0,
                                                               ),
                                                               Icon(
                                                                 Icons.star,
                                                                 color: Colors.yellow[600],
                                                                 size: 15.0,
                                                               ),
                                                               Icon(
                                                                 Icons.star,
                                                                 color: Colors.yellow[600],
                                                                 size: 15.0,
                                                               ),
                                                               Icon(
                                                                 Icons.star,
                                                                 color: Colors.yellow[600],
                                                                 size: 15.0,
                                                               ),
                                                               Icon(
                                                                 Icons.star_half,
                                                                 color: Colors.yellow[600],
                                                                 size: 15.0,
                                                               ),
                                                             ],
                                                           ),
                                                         ],
                                                       ),
                                                       // SvgPicture.asset("assets/svg/calender.svg",
                                                       // color: accentColor, width: 16.h, height: 16.h),
                                                       Container(width: 10.0,),
                                                       Text(
                                                         "\$ ${  events?[i].price.toString() ?? ""}",
                                                         style: TextStyle(
                                                             color: accentColor,
                                                             fontSize: 16.5,
                                                             fontFamily: "RedHat",
                                                             fontWeight: FontWeight.w900),
                                                         maxLines: 1,
                                                         overflow: TextOverflow.ellipsis,
                                                       ),
                                                       // getCustomFont(
                                                       //     date.toString() ?? "", 15.sp, greyColor, 1,
                                                       //     fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                                                     ],
                                                   ),
               
            
                                getButton(context, accentColor, "Join",
                                    Colors.white, () {}, 14.sp,
                                    weight: FontWeight.w700,
                                    buttonHeight: 40.h,
                                    borderRadius: BorderRadius.circular(14.h),
                                    buttonWidth: 102.h)
                              ],
                            ),
                            getVerSpace(16.h),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
    );
  }
}