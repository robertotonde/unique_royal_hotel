import 'package:pro_hotel_fullapps/app/data/data_file.dart';
import 'package:pro_hotel_fullapps/app/view/notification/custom_notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import 'package:evente/evente.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void backClick() {
    Constant.backToPrev(context);
  }


  @override
  Widget build(BuildContext context) {
   final notificationList =   Hive.box("notifications");

   
    void _openClearAllDialog (){
      showModalBottomSheet(
      elevation: 2,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      )),
      context: context, builder: (context){
      return Container(
        padding: EdgeInsets.all(20),
        height: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('clear all notification-dialog', 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              wordSpacing: 1
            ),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Yes', style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith((states) => Size(100, 50)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ))

                  ),
                  onPressed: (){
                    NotificationService().deleteAllNotificationData();
                    // Navigator.pop(context);
                  },
                ),

                SizedBox(width: 20,),

                TextButton(
                  child: Text('Cancel', style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith((states) => Size(100, 50)),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey[400]),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                ))

                ),
                onPressed: ()=> Navigator.pop(context),
                )
                ],
              ),

            
            ],
          ),
        );
      });
    }


    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            
    color: Colors.black, 
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => _openClearAllDialog(),
            child: Text('clear all',style: TextStyle(color: Colors.white),),
            style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith(
                    (states) => EdgeInsets.only(right: 15, left: 15))),
          ),
        ],
          title: getCustomFont("Notifications", 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        ),
        
        body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: notificationList.listenable(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                List items = notificationList.values.toList();
                items.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
                // ignore: curly_braces_in_flow_control_structures
                if (items.isEmpty) return Center(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 
                    //  Container(
                    //           height: 208.h,
                    //           width: 208.h,
                    //           decoration: BoxDecoration(
                    //               color: lightColor,
                    //               borderRadius: BorderRadius.circular(187.h)),
                    //           padding: EdgeInsets.all(27.h),
                    //           child: getAssetImage("avnotification.png",
                    //               height: 114.h, width: 114.h),
                    //         ),
                    getAssetImage("avnotification.png",
                                  height: 280.h),
                            getVerSpace(28.h),
                            getCustomFont(
                                "No Notifications Yet!", 20.sp, Colors.black, 1,
                                fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                            getVerSpace(8.h),
                            getMultilineCustomFont(
                                "We’ll notify you when something arrives.",
                                16.sp,
                                Colors.black,
                                fontWeight: FontWeight.w500,
                                txtHeight: 1.5.h)
              ],
            ),
                );
                
                  // return EmptyPageWithImage(
                  //   image: Config.notificationImage,
                  //   title: 'no notification title'.tr(),
                  //   description: 'no notification description'.tr(),
                  // );
                 return _NotificationList(items: items);
              //  return Text("s"); 
              }),
        ],
      ),
      ),
    );
  }
}


  
class _NotificationList extends StatelessWidget {
  const _NotificationList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(
          height: 15,
        ),
        itemBuilder: (BuildContext context, int index) {

          final NotificationModel notificationModel = NotificationModel(
            timestamp: items[index]['timestamp'],
            date: items[index]['date'],
            title: items[index]['title'],
            body: items[index]['body'],
            postID: items[index]['post_id'] == null ? null : int.parse(items[index]['post_id']),
            thumbnailUrl: items[index]['image'],

          );

            
            String date = Jiffy.parse(notificationModel.date as String).format(pattern: "dd MMMM yyyy"); 
          final String timeAgo = Jiffy.parse(notificationModel.date as String).format(pattern: 'HH:mm');
          // return Text("data");
 return CustomNotificationCard(notificationModel: notificationModel, timeAgo: timeAgo,date:date);
          // if(notificationModel.postID == null){
          //   return CustomNotificationCard(notificationModel: notificationModel, timeAgo: timeAgo);
          // }else{
          //   return PostNotificationCard(notificationModel: notificationModel, timeAgo: timeAgo,);
          // }

          
        },
      ),
    );
  }
}


