import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart'hide Trans ;
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';

import '../../../base/widget_utils.dart';

import '../../widget/empty_screen.dart';
import '../featured_event/featured_event_detail2.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _isCategoryASelected = false;
  bool _isCategoryBSelected = false;
  bool _isCategoryCSelected = false;
  bool _isCategoryDSelected = false;
  bool _isCategoryESelected = false;
  bool _isCategoryFSelected = false;
  bool _isCategoryGSelected = false;
  bool _isCategoryHSelected = false;
  bool _isCategoryISelected = false;
  bool _isCategoryJSelected = false;
  bool _isCategoryKSelected = false;
  bool _isCategoryLSelected = false;
  bool _isCategoryMSelected = false;
  bool _isCategoryNSelected = false;
  bool _isCategoryOSelected = false;
  bool _isCategoryPSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          ('Filter Hotel By Category').tr(),
          style: TextStyle(
              fontFamily: 'RedHat',
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 17.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 1.0, right: 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                ("Category").tr(),
                style: TextStyle(
                    fontFamily: "RedHat",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20.0),
              child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  Container(
                    width: 120.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: accentColor,
                          value: _isCategoryBSelected,
                          onChanged: (value) {
                            setState(() {
                              _isCategoryBSelected = value!;
                            });
                          },
                        ),
                        Text(
                          ('Hotel').tr(),
                          style: TextStyle(
                              fontFamily: 'RedHat', fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: accentColor,
                          value: _isCategoryCSelected,
                          onChanged: (value) {
                            setState(() {
                              _isCategoryCSelected = value!;
                            });
                          },
                        ),
                        Text(
                          ('House').tr(),
                          style: TextStyle(
                              fontFamily: 'RedHat', fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 140.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: accentColor,
                          value: _isCategoryDSelected,
                          onChanged: (value) {
                            setState(() {
                              _isCategoryDSelected = value!;
                            });
                          },
                        ),
                        Text(
                          ('Experience').tr(),
                          style: TextStyle(
                              fontFamily: 'RedHat', fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: accentColor,
                          value: _isCategoryESelected,
                          onChanged: (value) {
                            setState(() {
                              _isCategoryESelected = value!;
                            });
                          },
                        ),
                        Text(
                          ('Travel').tr(),
                          style: TextStyle(
                              fontFamily: 'RedHat', fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),       ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                ("Result").tr(),
                style: TextStyle(
                    fontFamily: "RedHat",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('hotel')
                  .where('category', whereIn: [
                    '',
                    if (_isCategoryBSelected) 'hotel',
                    if (_isCategoryCSelected) 'house',
                    if (_isCategoryDSelected) 'experience',
                    if (_isCategoryESelected) 'travel',
                  ]

                      //  whereIn: [
                      //   if (_isCategoryASelected) 'Category A',
                      //   if (_isCategoryBSelected) 'Category B',
                      //   if (_isCategoryCSelected) 'Category C',
                      // ]
                      )
                  .where(
                    'category',
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: EmptyScreen());
                }

                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, i) {
                        final events = snapshot.data?.docs.map((e) {
                          return Hotel.fromFirestore(e, 1);
                        }).toList();

                        return InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('hotel')
                                .doc(snapshot.data!.docs[i].id)
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
                        }));
                          },
                          child:InkWell(
            onTap: () {
              FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(events?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>hotelDetail2(

                    hotel: events?[i],
                        )));
              // Navigator.of(context).push(PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => FeaturedHotel2Detail(
              //           Hotel: Hotels?[i],
              //         )));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20.h, left: 20.0, right: 20.0),
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
                      children: [Hero( 
              tag: 'hero-tagss-${events?[i].id}' ?? '',
                  
                          child: Material(
                      color:  Colors.transparent,
                            child: Container(
                              height: 82.h,
                              width: 82.w,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        events?[i].image ?? '',
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        // Image.network(Hotel.image??'',height: 82,width: 82,),
                        // getAssetImage(Hotel.image ?? "",
                        //     width: 82.h, height: 82.h),
                        getHorSpace(10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 185.w,
                              
                              child: getCustomFont(events?[i].title ?? "",
                                  18.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                  txtHeight: 1.5.h),
                            ),
                            getVerSpace(4.h),
                                 Row(
                              children: [
                                getSvgImage("location.svg",
                                    width: 20.h,
                                    height: 20.h,
                                    color: greyColor),
                                getHorSpace(5.h),
                                Container(
                                  width: 150.w,
                                  child: getCustomFont(
                                      events?[i].location ?? "",
                                      15.sp,
                                      greyColor,
                                      1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                )
                              ],
                            ),
                            SizedBox(height: 5.0,),
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
                    child: Row(
                      children: [
                        getCustomFont('\$ ', 15.sp, accentColor, 1,
                            fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                        getCustomFont(events?[i].price.toString() ?? '', 15.sp,
                            accentColor, 1,
                            fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        
          );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


