import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evente/evente.dart';
import 'package:pro_hotel_fullapps/app/view/home/search_screen.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../featured_event/featured_event_detail2.dart';
import '../home/tab/tab_home.dart';

class PopularEventList extends StatefulWidget {
  const PopularEventList({Key? key}) : super(key: key);

  @override
  State<PopularEventList> createState() => _PopularEventListState();
}

class _PopularEventListState extends State<PopularEventList> {
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
       appBar: AppBar(
             centerTitle: true,
             backgroundColor: Colors.white,
             elevation: 0.0,
             iconTheme: IconThemeData(color: Colors.black),
             title: getCustomFont(
               ("Popular Hotel"),
               21.sp,
               Colors.black,
               1,
               fontWeight: FontWeight.w700,
             ),
             actions: [
               Padding(
                 padding: const EdgeInsets.only(right: 15.0),
                 child: InkWell(
                     onTap: (() {
                       Navigator.of(context).push(PageRouteBuilder(
                           pageBuilder: (_, __, ___) => new SearchPage()));
                     }),
                     child: getSvgImage('search.svg', color: accentColor,height: 20.0,width: 20.0)),
               ),
             ]),
        body: SafeArea(
          child: ListView(
            children: [
              getDivider(
                dividerColor,
                1.h,
              ),
              getVerSpace(0.h),
   StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("hotel")
                       .orderBy('count', descending: true)
                      .snapshots(),
                  builder: (BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.hasData
                        ? new buildPopularHotelList(
                            list: snapshot.data?.docs,
                          )
                        : Container();
                  },
                ),
              // Expanded(
              //     child: GetBuilder<PopularEventController>(
              //   init: PopularEventController(),
              //   builder: (controller) => ListView.builder(
              //     padding: EdgeInsets.symmetric(horizontal: 20.h),
              //     itemCount: controller.newPopularEventLists.length,
              //     primary: false,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       ModalPopularEvent modalPopularEvent =
              //           controller.newPopularEventLists[index];
              //       return Container(
              //         margin: EdgeInsets.only(bottom: 20.h),
              //         decoration: BoxDecoration(
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                   color: shadowColor,
              //                   blurRadius: 27,
              //                   offset: const Offset(0, 8))
              //             ],
              //             borderRadius: BorderRadius.circular(22.h)),
              //         padding: EdgeInsets.only(
              //             top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Row(
              //                 children: [
              //                   getAssetImage(modalPopularEvent.image ?? "",
              //                       width: 82.h, height: 82.h),
              //                   getHorSpace(10.h),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       getCustomFont(modalPopularEvent.name ?? "",
              //                           18.sp, Colors.black, 1,
              //                           fontWeight: FontWeight.w600,
              //                           txtHeight: 1.5.h),
              //                       getVerSpace(4.h),
              //                       getCustomFont(modalPopularEvent.date ?? '',
              //                           15.sp, greyColor, 1,
              //                           fontWeight: FontWeight.w500,
              //                           txtHeight: 1.46.h)
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             ),
              //             Container(
              //               height: 34.h,
              //               decoration: BoxDecoration(
              //                   color: lightAccent,
              //                   borderRadius: BorderRadius.circular(12.h)),
              //               alignment: Alignment.center,
              //               padding: EdgeInsets.symmetric(horizontal: 12.h),
              //               child: getCustomFont(modalPopularEvent.price ?? '',
              //                   15.sp, accentColor, 1,
              //                   fontWeight: FontWeight.w600, txtHeight: 1.46.h),
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ))
   
            ],
          ),
        ),
      ),
    );
  }
}



class buildPopularEventList2 extends StatelessWidget {
    final List<DocumentSnapshot>? list;
  const buildPopularEventList2({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
      itemBuilder: (context,i){
          final events = list?.map((e) {
            return Event.fromFirestore(e);
          }).toList();

        //  String? category = list?[i]['category'].toString();
        //   String? date = list?[i]['date'].toString();
        //   String? image = list?[i]['image'].toString();
        //   String? description = list?[i]['description'].toString();
        //   String? id = list?[i]['id'].toString();
        //   String? location = list?[i]['location'].toString();
        //   double? mapsLangLink = list?[i]['mapsLangLink'];
        //   double? mapsLatLink = list?[i]['mapsLatLink'];
        //   int? price = list?[i]['price'];
        //   String? title = list?[i]['title'].toString();
        //   String? type = list?[i]['type'].toString();
        //   String? userDesc = list?[i]['userDesc'].toString();
        //   String? userName = list?[i]['userName'].toString();
        //   String? userProfile = list?[i]['userProfile'].toString();


        return InkWell(
            onTap: (){
   Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>FeaturedEvent2Detail( 
                      
                    event: events?[i],
                        )));  },
          child: Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 27,
                                  offset: const Offset(0, 8))
                            ],
                            borderRadius: BorderRadius.circular(22.h)),
                        padding: EdgeInsets.only(
                            top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  getAssetImage(events?[i].image ?? "",
                                      width: 82.h, height: 82.h),
                                  getHorSpace(10.h),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont(events?[i].title ?? "",
                                          18.sp, Colors.black, 1,
                                          fontWeight: FontWeight.w600,
                                          txtHeight: 1.5.h),
                                      getVerSpace(4.h),
                                      getCustomFont("events?[i].date" ?? '',
                                          15.sp, greyColor, 1,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.46.h)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 34.h,
                              decoration: BoxDecoration(
                                  color: lightAccent,
                                  borderRadius: BorderRadius.circular(12.h)),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 12.h),
                              child: getCustomFont(events?[i].price.toString() ?? '',
                                  15.sp, accentColor, 1,
                                  fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                            )
                          ],
                        ),
                      ),
        );
      },
    );
  }
}