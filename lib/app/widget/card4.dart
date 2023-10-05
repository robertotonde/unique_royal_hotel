
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:evente/evente.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:pro_hotel_fullapps/base/widget_utils.dart';
import '../view/featured_event/featured_event_detail2.dart';

class Card4 extends StatelessWidget {
  final Hotel d;
  final String heroTag;
  const Card4({Key? key, required this.d, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:  Container(
              margin: EdgeInsets.only(bottom: 20.h, left: 0.0, right: 0.0),
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
                       Hero(
                    tag: 'hero-tagss-${d.id}' ?? '',
                   
                          child: Material(
                      color:  Colors.transparent,
                            child: Container(
                              height: 82,
                              width: 82,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        d.image ?? '',
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
                              width: 190.w,
                              
                              child: getCustomFont(d.title ?? "",
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
                                      d.location ?? "",
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
                        getCustomFont(d.price.toString() ?? '', 15.sp,
                            accentColor, 1,
                            fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
      onTap: () {
         Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new hotelDetail2(
                              hotel: d,
                            ),
                        transitionDuration: const Duration(milliseconds: 1000),
                        transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return Opacity(
                            opacity: animation.value,
                            child: child,
                          );
                        }));
       
       }
    );
  }
}
