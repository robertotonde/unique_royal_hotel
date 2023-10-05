import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro_hotel_fullapps/app/controller/controller.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/featured_event_detail2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import 'package:evente/evente.dart';
import '../../routes/app_routes.dart';
import '../home/search_screen.dart';
import '../home/tab/tab_home.dart';
import 'featured_event_detail.dart';

class FeatureEventList extends StatefulWidget {
  const FeatureEventList({Key? key}) : super(key: key);

  @override
  State<FeatureEventList> createState() => _FeatureEventListState();
}

class _FeatureEventListState extends State<FeatureEventList> {
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
              "All Featured Events",
              24.sp,
              Colors.black,
              1,
              fontWeight: FontWeight.w700,
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                getDivider(
                  dividerColor,
                  1.h,
                ),
                getVerSpace(5.h),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("event")
                            .where('type', isEqualTo: 'feature')
                            .snapshots(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return snapshot.hasData
                              ? new buildFeatureEventList2(
                                  list: snapshot.data?.docs,
                                )
                              : Container();
                        },
                      ),
                // Expanded(
                //     child: GetBuilder<FeatureEventController>(
                //   init: FeatureEventController(),
                //   builder: (controller) => ListView.builder(
                //     padding: EdgeInsets.symmetric(horizontal: 20.h),
                //     primary: false,
                //     shrinkWrap: true,
                //     itemCount: controller.newfeatureEventLists.length,
                //     itemBuilder: (context, index) {
                //       ModalFeatureEvent modalFeatureEvent =
                //           controller.newfeatureEventLists[index];
                //       return Container(
                //         margin: EdgeInsets.only(bottom: 20.h),
                //         height: 196.h,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(22.h),
                //           image: DecorationImage(
                //               image: AssetImage(Constant.assetImagePath +
                //                   modalFeatureEvent.image.toString()),
                //               fit: BoxFit.fill),
                //         ),
                //         child: GestureDetector(
                //           onTap: () {
                //             Constant.sendToNext(
                //                 context, Routes.featuredEventDetailRoute);
                //           },
                //           child: Stack(
                //             children: [
                //               Container(
                //                 height: 196.h,
                //                 width: double.infinity,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(22.h),
                //                     gradient: LinearGradient(
                //                         colors: [
                //                           "#000000".toColor().withOpacity(0.0),
                //                           "#000000".toColor().withOpacity(0.88)
                //                         ],
                //                         stops: const [
                //                           0.0,
                //                           1.0
                //                         ],
                //                         begin: Alignment.centerRight,
                //                         end: Alignment.centerLeft)),
                //                 padding: EdgeInsets.only(left: 24.h),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     getCustomFont(modalFeatureEvent.name ?? "",
                //                         20.sp, Colors.white, 1,
                //                         fontWeight: FontWeight.w700,
                //                         txtHeight: 1.5.h),
                //                     getVerSpace(4.h),
                //                     Row(
                //                       children: [
                //                         getSvgImage("location.svg",
                //                             width: 20.h, height: 20.h),
                //                         getHorSpace(5.h),
                //                         getCustomFont(
                //                             modalFeatureEvent.location ?? "",
                //                             15.sp,
                //                             Colors.white,
                //                             1,
                //                             fontWeight: FontWeight.w500,
                //                             txtHeight: 1.5.h),
                //                       ],
                //                     ),
                //                     getVerSpace(22.h),
                //                     getButton(context, accentColor, "Book Now",
                //                         Colors.white, () {}, 14.sp,
                //                         weight: FontWeight.w700,
                //                         buttonHeight: 40.h,
                //                         borderRadius: BorderRadius.circular(14.h),
                //                         buttonWidth: 111.h)
                //                   ],
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ))
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class buildFeatureEventList2 extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const buildFeatureEventList2({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list?.length,
      itemBuilder: (context, i) {
        
          final events = list?.map((e) {
            return Event.fromFirestore(e);
          }).toList();
          
        //  String? category = list?[i]['category'].toString();
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

       return InkWell(
         onTap: () {
Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> FeaturedEvent2Detail(
  event: events?[i],
)));
             },
         child: Container(
            width: 374.h,
            height: 190.h,
            margin: EdgeInsets.only(right: 20.h, left: 20.h,top: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.h),
              image: DecorationImage(
                  image: NetworkImage(events?[i].image ?? ''),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Container(
                  height: 196.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.h),
                      gradient: LinearGradient(
                          colors: [
                            "#000000".toColor().withOpacity(0.0),
                            "#000000".toColor().withOpacity(0.88)
                          ],
                          stops: const [
                            0.0,
                            1.0
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft)),
                  padding: EdgeInsets.only(left: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                            width: MediaQuery.of(context).size.width-100,
                        child: getCustomFont(events?[i].title ?? "", 20.sp,
                            Colors.white, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      ),
                      getVerSpace(4.h),
                      Row(
                        children: [
                          getSvgImage("location.svg",
                              width: 20.h, height: 20.h),
                          getHorSpace(5.h),
                          Container(
                            width: MediaQuery.of(context).size.width-100,
                            child: getCustomFont(events?[i].location ?? "",
                                15.sp, Colors.white, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                          ),
                        ],
                      ),
                      getVerSpace(22.h),
                      getButton(context, accentColor, "Book Now",
                          Colors.white, () {}, 14.sp,
                          weight: FontWeight.w700,
                          buttonHeight: 40.h,
                          borderRadius: BorderRadius.circular(14.h),
                          buttonWidth: 111.h)
                    ],
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

