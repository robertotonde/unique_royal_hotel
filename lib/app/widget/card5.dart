

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';

import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/widget_utils.dart';
import '../view/featured_event/featured_event_detail2.dart';

class Card5 extends StatelessWidget {
  final Hotel d;
  final String heroTag;
  const Card5({Key? key, required this.d, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            boxShadow: [
            BoxShadow(
                        color: shadowColor,
                        offset: const Offset(0, 8),
                        blurRadius: 27) ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(  tag: 'hero-tagss-${d.id}' ?? '',
                   
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100.0))
                          ),
                          child: Image.network( d.image??'',fit: BoxFit.cover,)
                          ),
                        ),
                      ),

                      // VideoIcon(contentType: d.contentType, iconSize: 40,)
                    ],
              ),
              Container(
                  padding: EdgeInsets.only(left: 15, right: 15,top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-220.0,
                        child: Text(
                            d.title!,
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              fontFamily: Constant.fontsFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 5,),

                            getVerSpace(5.h),

                      Row(
                        children: <Widget>[
                         
                      getSvgImage("location.svg",
                          height: 20.h, width: 20.h, color: greyColor),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                        width: MediaQuery.of(context).size.width-270.0,
                            child: Text(
                              d.location!,
                              style: TextStyle(
                                
                              fontFamily: Constant.fontsFamily,
                                color:Colors.black54, fontSize: 13),
                                maxLines: 3,
                            ),
                          ),
                         
              
                        ],
                      ),
                            getVerSpace(5.h),
                          Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                    decoration: BoxDecoration(
                        color: lightAccent,
                        borderRadius: BorderRadius.circular(12.h)),
                    child: Row(
                      children: 
                            [
                                getCustomFont(
                           "\$ ", 15.sp, accentColor, 1,
                            fontWeight: FontWeight.w600),
                              getCustomFont(
                            d.price.toString(), 15.sp, accentColor, 1,
                            fontWeight: FontWeight.w600),
                          ],
                    ),
                  )
                    ],
                  ),
                ),
                Spacer(),
                 getAssetImage("favourite_select.png",
                            width: 30.h, height: 30.h)
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
        // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> new hotelDetail2(hotel: d,)));
        
        }
    );
  }
}
