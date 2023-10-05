import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart'hide Trans ;
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../widget/empty_screen.dart';
import '../home/search_screen.dart';
import '../home/tab/tab_home.dart';
import 'dart:math' as math;

class UpcomingList extends StatefulWidget {
  const UpcomingList({Key? key}) : super(key: key);

  @override
  State<UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<UpcomingList> {
   Position? userPosition;
 late List<Hotel> nearbyHotels = [];
 
 
  void backClick() {
    Navigator.of(context).pop();
    // Constant.backToPrev(context);
  }


  
  List<DocumentSnapshot> nearestHotels = [];


Future<Position> getUserLocation() async {
 

  return await Geolocator.getCurrentPosition();
}

Future<List<Hotel>> fetchHotelsNearby(double latitude, double longitude) async {
  List<Hotel> hotels = [];
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('hotel').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
double hotelLatitude = (doc.data() as Map<String, dynamic>)['lat'] as double? ?? 0.0;
double hotelLongitude = (doc.data() as Map<String, dynamic>)['lang'] as double? ?? 0.0;


    double distance = calculateDistance(latitude, longitude, hotelLatitude, hotelLongitude);

    if (distance < 50000000000000.0) { // Misalnya, tampilkan hotel yang berjarak kurang dari 10 km dari lokasi pengguna.
      hotels.add(Hotel.fromFirestore(doc, distance));
    }
  }

  return hotels;
}




double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  // Implementasikan perhitungan jarak antara dua koordinat geografis di sini (misalnya, menggunakan haversine formula).
  // Anda dapat mencari library yang sesuai atau mengimplementasikan sendiri.
  const double earthRadius = 6371.0; // Radius Bumi dalam km
  final double dLat = _degreesToRadians(lat2 - lat1);
  final double dLon = _degreesToRadians(lon2 - lon1);
  final double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
      (math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2));
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  final double distance = earthRadius * c;
  return distance;
}

double _degreesToRadians(double degrees) {
  return degrees * math.pi / 180;
}

@override
  void initState() {
    // TODO: implement initState
   getUserLocation().then((position) {
      setState(() {
        userPosition = position;
      });
      fetchHotelsNearby(userPosition!.latitude, userPosition!.longitude).then((hotels) {
        hotels.sort((a, b) => a.distance!.compareTo(b.distance as num));
        setState(() {
          nearbyHotels = hotels;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
   child:  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            title: getCustomFont(
              "Nearby Hotel",
              22.sp,
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
            ]
            ),
        body:  Container(
          
          child: Padding(
            padding: const EdgeInsets.only(top:10.0),
            child:       nearbyHotels == null
  ? Center(child: CircularProgressIndicator())
  : nearbyHotels.isEmpty
    ? Center(child: CircularProgressIndicator())
    : ListView.builder(
      itemCount: nearbyHotels.length??0,
        scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final hotel = nearbyHotels[index];
        return buildNearHotelList(
                        hotel: hotel,
                      );
      },
    ),
                // buildFeatureHotelList(context),
         
            // StreamBuilder(
            //                 stream: FirebaseFirestore.instance
            //                     .collection("hotel")
            //                  .snapshots(),
            //                 builder: (BuildContext ctx,
            //                     AsyncSnapshot<QuerySnapshot> snapshot) {
            //                   if (snapshot.connectionState ==
            //                       ConnectionState.waiting) {
            //                     return Center(
            //                         child: CircularProgressIndicator());
            //                   }
                    
            //                   if (!snapshot.hasData ||
            //                       snapshot.data!.docs.isEmpty) {
            //                     return Center(child: EmptyScreen());
            //                   }
            //                   if (snapshot.hasError) {
            //                     return Center(child: Text('Error'));
            //                   }
                    
            //                   return snapshot.hasData
            //                       ? buildFeatureEventList2(
            //                           list: snapshot.data?.docs,
            //                         )
            //                       : Container();
            //                 },
            //               ),
          
          ),
        )
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
          return Hotel.fromFirestore(e, 1);
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
            FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => hotelDetail2(
                       hotel: events?[i],
                    )));
          },
          child: Container(
            width: 374.h,
            height: 190.h,
            margin: EdgeInsets.only(right: 20.h, left: 20.h,bottom: 20.h),
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
                      getCustomFont(
                          events?[i].title ?? "", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      getVerSpace(10.h),
                      Row(
                        children: [
                          getSvgImage("location.svg",
                              width: 20.h, height: 20.h),
                          getHorSpace(5.h),
                          Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: getCustomFont(
                                events?[i].location ?? "", 15.sp, Colors.white, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                          ),
                        ],
                      ),

                                 getVerSpace(10.h),
                                            Container(
                      width: MediaQuery.of(context).size.width / 2.5.w,
                      child: Row(
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
                          Container(),
                          Text(
                            "\$ ${  events?[i].price.toString() ?? ""}",
                            style: TextStyle(
                                color: Colors.white,
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
                    ),
              
                      getVerSpace(10.h),
                      getButton(context, accentColor, "Book Now", Colors.white,
                          () {}, 14.sp,
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
