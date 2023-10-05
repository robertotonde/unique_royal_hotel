import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pro_hotel_fullapps/app/controller/controller.dart' as cs;
import 'package:pro_hotel_fullapps/app/data/data_file.dart';
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Near_hotel_detail.dart';
import 'package:pro_hotel_fullapps/app/view/home/UpComing_Screen.dart';
import 'package:pro_hotel_fullapps/app/view/home/category_screen.dart';
import 'package:pro_hotel_fullapps/app/view/home/filtering_screen.dart';
import 'package:pro_hotel_fullapps/app/view/popular_event/popular_event_list.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:pro_hotel_fullapps/base/constant.dart';
import 'package:pro_hotel_fullapps/base/widget_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math' as math;
import '../../../controller/controller.dart';
import '../../../model/hotel_model.dart';
import '../../../widget/HomeSuggestCard.dart';
import '../../bloc/Hotel_bloc.dart';
import '../../bloc/sign_in_bloc.dart';
import '../../notification/notification_screen.dart';
import '../search_screen.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  HomeScreenController controller = Get.put(HomeScreenController());
  String? mtoken;
  Position? userPosition;
  late List<Hotel> nearbyHotels = [];

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    final SignInBloc sb = context.read<SignInBloc>();
    await FirebaseFirestore.instance.collection("UserTokens").doc(sb.uid).set({
      'token': token,
    });

    print("INI TOKENNYA");
    print(sb.uid);
  }

  List<DocumentSnapshot> nearestHotels = [];

  Future<Position> getUserLocation() async {
    // LocationPermission permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied) {
    //   // Handle izin ditolak
    // }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Hotel>> fetchHotelsNearby(
      double latitude, double longitude) async {
    List<Hotel> hotels = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('hotel').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      double hotelLatitude =
          (doc.data() as Map<String, dynamic>)['lat'] as double? ?? 0.0;
      double hotelLongitude =
          (doc.data() as Map<String, dynamic>)['lang'] as double? ?? 0.0;

      double distance =
          calculateDistance(latitude, longitude, hotelLatitude, hotelLongitude);

      if (distance < 50000000000000.0) {
        // Misalnya, tampilkan hotel yang berjarak kurang dari 10 km dari lokasi pengguna.
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
        (math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = earthRadius * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  void initState() {
    // requestLocationPermission();

    // requestPermission();
    getToken();
    super.initState();
    // getFromSharedPreferences();
    getUserLocation().then((position) {
      setState(() {
        userPosition = position;
      });
      fetchHotelsNearby(userPosition!.latitude, userPosition!.longitude)
          .then((hotels) {
        hotels.sort((a, b) => a.distance!.compareTo(b.distance as num));
        setState(() {
          nearbyHotels = hotels;
        });
      });
    });
  }

  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //       alert: true,
  //       announcement: true,
  //       badge: true,
  //       carPlay: false,
  //       criticalAlert: false,
  //       provisional: false,
  //       sound: true);

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }


  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  String? role;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.zero,
              primary: true,
              shrinkWrap: true,
              children: [
                buildAppBar(),
                getVerSpace(20.h),
                Row(children: [
                  Expanded(child: buildSearchWidget(context)),
                  Container(
                    height: 50.h,
                    width: 50.h,
                    margin: EdgeInsets.only(top: 0.h, right: 15.h, bottom: 5.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 13.h, horizontal: 0.h),
                    decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1.0),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.h)),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => FilterScreen()));

                          //  Navigator.of(context).push(PageRouteBuilder(
                          //   pageBuilder: (_, __, ___) => HotelList22()));

                          // Constant.sendToNext(context, Routes.notificationScreenRoute);
                        },
                        child: getSvgImage("Filter.svg",
                            height: 24.h, width: 24.h, color: Colors.black87)),
                  ),
                ]),

                SizedBox(
                  height: 20.0,
                ),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h, vertical: 0.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont("Nearby Hotels", 20.sp, Colors.black, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new UpcomingList()));

                          // Constant.sendToNext(
                          //     context, Routes.featureHotelListRoute);
                        },
                        child: getCustomFont("View All", 15.sp, greyColor, 1,
                            fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      )
                    ],
                  ),
                ),

                getVerSpace(12.h),
                Container(
                  height: 194.h,
                  child: nearbyHotels == null
                      ? Center(child: CircularProgressIndicator())
                      : nearbyHotels.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: nearbyHotels.take(5).length ?? 0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final hotel = nearbyHotels[index];
                                return buildNearHotelList(
                                  hotel: hotel,
                                );
                              },
                            ),
                  // StreamBuilder(
                  //   stream: FirebaseFirestore.instance
                  //       .collection("hotel")
                  //        .limit(5)
                  //        .orderBy('date', descending: false)
                  //       .snapshots(),

                  //   builder: (BuildContext ctx,
                  //       AsyncSnapshot<QuerySnapshot> snapshot) {
                  //     return snapshot.hasData
                  //         ? buildFeatureHotelList(
                  //             list: snapshot.data?.docs,
                  //           )
                  //         : Container();
                  //   },
                  // ),
                ),
                // buildFeatureHotelList(context),
                getVerSpace(34.h),

                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont("Country Hotels", 20.sp, Colors.black, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.0.h),
                      GestureDetector(
                        onTap: () {
                          Constant.sendToNext(
                              context, Routes.trendingScreenRoute);
                        },
                        child: getCustomFont("View All", 15.sp, greyColor, 1,
                            fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      )
                    ],
                  ),
                ),
                getVerSpace(0.h),
                Container(
                  height: 330.0,
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
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TabBarView(
                          children: [
                            Container(
                              height: 310.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'unitedstate')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'italy')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'spain')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'australia')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'france')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'greece')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'singapore')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'switzerland')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'japan')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'thailand')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'egypt')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'canada')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("hotel")
                                    .where('country', isEqualTo: 'indonesia')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingHotelCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                getVerSpace(0.h),
                Container(
                  height: 318.0,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20.0, bottom: 10.0),
                        child: getCustomFont(
                            "Category ", 20.sp, Colors.black, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      ),
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 20.0)),
                            cardSuggeted(
                              img: 'assets/images/hotel.png',
                              txtTitle: 'Hotel',
                              txtSize: 48.0,
                              txtHeader: 'Best Hotel Choice',
                              txtDesc:
                                  '"Best Hotel Choice" is the ultimate accommodation option for you, offering a range of luxurious amenities, friendly service, and a strategic location. Staying here allows you to enjoy comfort and top-notch quality that will make your trip truly unforgettable.',
                              navigatorOntap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        CategoryScreenT1(
                                          title: "Hotel",
                                          desc:
                                              "Best Hotel Choice is the ultimate accommodation option for you, offering a range of luxurious amenities, friendly service, and a strategic location. Staying here allows you to enjoy comfort and top-notch quality that will make your trip truly unforgettable.",
                                        )));
                              },
                            ),
                            cardSuggeted(
                              img: 'assets/images/home.png',
                              txtTitle: 'House',
                              txtSize: 50.0,
                              txtHeader: 'Best House Choice',
                              txtDesc:
                                  '"Best House Choice" represents the finest selection of homes tailored to your preferences. Whether youre seeking modern elegance, cozy comfort, or spacious luxury, our properties offer a wide array of options to make your housing decision the perfect one for your needs.',
                              navigatorOntap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        CategoryScreenT1(
                                          title: "House",
                                          desc:
                                              "Best House Choice represents the finest selection of homes tailored to your preferences. Whether youre seeking modern elegance, cozy comfort, or spacious luxury, our properties offer a wide array of options to make your housing decision the perfect one for your needs.",
                                        )));
                              },
                            ),
                            cardSuggeted(
                              img: 'assets/images/experience.png',
                              txtTitle: 'Experience',
                              txtSize: 35.0,
                              txtHeader: 'Get Best Experience Event',
                              txtDesc:
                                  '"Get Best Experience Event" promises to deliver unparalleled experiences that will leave you with lasting memories. Our events are meticulously curated to provide you with the finest moments, whether its a thrilling adventure, a cultural immersion, or a luxurious retreat. Join us and immerse yourself in the world of extraordinary experiences.',
                              navigatorOntap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        CategoryScreenT1(
                                          title: "Experience",
                                          desc:
                                              "Get Best Experience Event promises to deliver unparalleled experiences that will leave you with lasting memories. Our events are meticulously curated to provide you with the finest moments, whether its a thrilling adventure, a cultural immersion, or a luxurious retreat. Join us and immerse yourself in the world of extraordinary experiences.",
                                        )));
                              },
                            ),
                            cardSuggeted(
                              img: 'assets/images/travel.png',
                              txtTitle: 'Travel',
                              txtSize: 40.0,
                              txtHeader: 'Best Travel Choice',
                              txtDesc:
                                  '"Best Travel Choice" offers you a remarkable selection of travel options tailored to your desires. Whether youre dreaming of exotic adventures, serene getaways, or cultural explorations, our services provide a diverse range of possibilities to make your travel decisions truly exceptional. Explore the world with us and discover your ideal journey.',
                              navigatorOntap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        CategoryScreenT1(
                                          title: "Travel",
                                          desc:
                                              "Best Travel Choice offers you a remarkable selection of travel options tailored to your desires. Whether youre dreaming of exotic adventures, serene getaways, or cultural explorations, our services provide a diverse range of possibilities to make your travel decisions truly exceptional. Explore the world with us and discover your ideal journey.",
                                        )));
                              },
                            ),
                            Padding(padding: EdgeInsets.only(right: 10.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // buildTrendingHotelList(),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont("Popular Hotels", 20.sp, Colors.black, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => PopularEventList()));
                        },
                        child: getCustomFont("View All", 15.sp, greyColor, 1,
                            fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      )
                    ],
                  ),
                ),
                // cb.hasData == false
                // ignore: unnecessary_null_comparison
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("hotel")
                      .orderBy('count', descending: true)
                      .limit(5)
                      .snapshots(),
                  builder: (BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.hasData
                        ? buildPopularHotelList(
                            list: snapshot.data?.docs,
                          )
                        : Container();
                  },
                ),

                // if (cb.data.isEmpty)
                //   Column(
                //     children: [
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.20,
                //       ),
                //       Text("Empty"),
                //     ],
                //   ),
                // ListView.separated(
                //   padding: EdgeInsets.all(15),
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: cb.data.length,
                //   separatorBuilder: (BuildContext context, int index) =>
                //       SizedBox(
                //     height: 15,
                //   ),
                //   shrinkWrap: true,
                //   itemBuilder: (_, int index) {
                //     //  return Card1(d: cb.data[index], heroTag: 'tab1$index');
                //     // return Card2(d: cb.data[index], heroTag: 'tab1$index');
                //     return buildPopularHotelList(cb.data[index]);

                //     // return Opacity(
                //     //   opacity: cb.isLoading ? 1.0 : 0.0,
                //     //   child: cb.lastVisible == null
                //     //       ? LoadingCard(height: 250)
                //     //       : Center(
                //     //           child: SizedBox(
                //     //               width: 32.0,
                //     //               height: 32.0,
                //     //               child: new CupertinoActivityIndicator()),
                //     //         ),
                //     // );
                //   },
                // ),

                // buildPopularHotelList(),
                getVerSpace(40.h),
              ],
            ))
      ],
    );
  }

  // Widget buildPopularHotelList(Hotel Hotel) {
  //   // return ListView.builder(
  //   //   padding: EdgeInsets.symmetric(horizontal: 20.h),
  //   //   itemCount: popularHotelLists.length,
  //   //   primary: false,
  //   //   shrinkWrap: true,
  //   //   itemBuilder: (context, index) {
  //   //     ModalPopularHotel modalPopularHotel = popularHotelLists[index];
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 20.h),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //               color: shadowColor, blurRadius: 27, offset: const Offset(0, 8))
  //         ],
  //         borderRadius: BorderRadius.circular(22.h)),
  //     padding: EdgeInsets.only(top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 82,
  //                 width: 82,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //                     image: DecorationImage(
  //                         image: NetworkImage(
  //                           Hotel.image ?? '',
  //                         ),
  //                         fit: BoxFit.cover)),
  //               ),
  //               // Image.network(Hotel.image??'',height: 82,width: 82,),
  //               // getAssetImage(Hotel.image ?? "",
  //               //     width: 82.h, height: 82.h),
  //               getHorSpace(10.h),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   getCustomFont(Hotel.title ?? "", 18.sp, Colors.black, 1,
  //                       fontWeight: FontWeight.w600, txtHeight: 1.5.h),
  //                   getVerSpace(4.h),
  //                   getCustomFont(Hotel.date ?? '', 15.sp, greyColor, 1,
  //                       fontWeight: FontWeight.w500, txtHeight: 1.46.h)
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 34.h,
  //           decoration: BoxDecoration(
  //               color: lightAccent, borderRadius: BorderRadius.circular(12.h)),
  //           alignment: Alignment.center,
  //           padding: EdgeInsets.symmetric(horizontal: 12.h),
  //           child: Row(
  //             children: [
  //               getCustomFont('\$ ', 15.sp, accentColor, 1,
  //                   fontWeight: FontWeight.w600, txtHeight: 1.46.h),
  //               getCustomFont(
  //                   Hotel.price.toString() ?? '', 15.sp, accentColor, 1,
  //                   fontWeight: FontWeight.w600, txtHeight: 1.46.h),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  //   //   },
  //   // );
  // }

  // Widget buildTrendingHotelList(Hotel2 Hotel) {
  //   return SizedBox(
  //     height: 289.h,
  //     child: GestureDetector(
  //       onTap: () {
  //         Constant.sendToNext(context, Routes.featuredHotelDetailRoute);
  //       },
  //       child: Container(
  //         margin: EdgeInsets.only(right: 20.h, left: 20.h),
  //         child: Stack(
  //           alignment: Alignment.topCenter,
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(22.h),
  //                   image: DecorationImage(
  //                       image: NetworkImage(Hotel.image ?? ''),
  //                       fit: BoxFit.fill)),
  //               height: 170.h,
  //               width: 248.h,
  //               padding: EdgeInsets.only(left: 12.h, top: 12.h),
  //               child: Wrap(
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                         color: "#B2000000".toColor(),
  //                         borderRadius: BorderRadius.circular(12.h)),
  //                     padding:
  //                         EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.h),
  //                     child: getCustomFont(
  //                         Hotel.date ?? "", 13.sp, Colors.white, 1,
  //                         fontWeight: FontWeight.w600, txtHeight: 1.69.h),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Positioned(
  //               width: 230.h,
  //               top: 132.h,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: shadowColor,
  //                           blurRadius: 27,
  //                           offset: const Offset(0, 8))
  //                     ],
  //                     borderRadius: BorderRadius.circular(22.h)),
  //                 padding: EdgeInsets.symmetric(horizontal: 16.h),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     getVerSpace(16.h),
  //                     getCustomFont(Hotel.title ?? "", 18.sp, Colors.black, 1,
  //                         fontWeight: FontWeight.w600, txtHeight: 1.5.h),
  //                     getVerSpace(3.h),
  //                     Row(
  //                       children: [
  //                         getSvgImage("location.svg",
  //                             width: 20.h, height: 20.h, color: greyColor),
  //                         getHorSpace(5.h),
  //                         getCustomFont(
  //                             Hotel.location ?? "", 15.sp, greyColor, 1,
  //                             fontWeight: FontWeight.w500, txtHeight: 1.5.h)
  //                       ],
  //                     ),
  //                     getVerSpace(10.h),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             CircleAvatar(
  //                               backgroundImage:
  //                                   NetworkImage(Hotel.userProfile ?? ''),
  //                               radius: 10.0,
  //                             ),
  //                             // getAssetImage(
  //                             //     Hotel.sponser ?? '',
  //                             //     height: 30.h,
  //                             //     width: 30.h),
  //                             getHorSpace(8.h),
  //                             getCustomFont(
  //                                 Hotel.userName ?? '', 15.sp, greyColor, 1,
  //                                 fontWeight: FontWeight.w500,
  //                                 txtHeight: 1.46.h)
  //                           ],
  //                         ),
  //                         getButton(context, accentColor, "Join", Colors.white,
  //                             () {}, 14.sp,
  //                             weight: FontWeight.w700,
  //                             buttonHeight: 40.h,
  //                             borderRadius: BorderRadius.circular(14.h),
  //                             buttonWidth: 70.h)
  //                       ],
  //                     ),
  //                     getVerSpace(16.h),
  //                   ],
  //                 ),
  //                 // height: 133.h,
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildSearchWidget(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.only(left: 20.h, right: 10.h),
      getDefaultTextFiledWithLabel(
          context, "Search Hotels", controller.searchController,
          isEnable: false, onTap: () {
        Navigator.of(context)
            .push(PageRouteBuilder(pageBuilder: (_, __, ___) => SearchPage()));
      },
          isprefix: true,
          prefix: Row(
            children: [
              getHorSpace(18.h),
              getSvgImage("search.svg", height: 24.h, width: 24.h),
            ],
          ),
          isReadonly: true,
          constraint: BoxConstraints(maxHeight: 24.h, maxWidth: 55.h),
          vertical: 18,
          horizontal: 16),
    );
  }

  Widget buildAppBar() {
    final sb = context.watch<SignInBloc>();
    return getPaddingWidget(
      EdgeInsets.only(left: 20.h, right: 20.0),
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  // ignore: prefer_const_constructors
                  Text(
                    ('Welcome Back!'),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'RedHat',
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/ic_waving_hand.svg',
                    width: 15.0,
                    height: 15.0,
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                sb.name ?? '',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'RedHat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 50.h,
            width: 50.h,
            margin: EdgeInsets.only(top: 40.h, right: 0.h),
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 0.h),
            decoration: BoxDecoration(
                color: lightColor, borderRadius: BorderRadius.circular(22.h)),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => NotificationScreen()));

                  // Constant.sendToNext(context, Routes.notificationScreenRoute);
                },
                child:
                    getSvgImage("notification.svg", height: 24.h, width: 24.h)),
          ),
        ],
      ),
    );
  }
}

class buildPopularHotelList extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const buildPopularHotelList({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10.0),
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final Hotels = list?.map((e) {
            return Hotel.fromFirestore(e, 1);
          }).toList();

          return InkWell(
            onTap: () {
              FirebaseFirestore.instance
                  .collection('hotel')
                  .doc(list?[i].id)
                  .update({'count': FieldValue.increment(1)});

              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new hotelDetail2(
                        hotel: Hotels?[i],
                      ),
                  transitionDuration: const Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
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
                      children: [
                        Hero(
                          tag: 'hero-tagss-${Hotels?[i].id}' ?? '',
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              height: 82.h,
                              width: 82.w,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0.r)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        Hotels?[i].image ?? '',
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
                              child: getCustomFont(Hotels?[i].title ?? "",
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
                                      Hotels?[i].location ?? "",
                                      15.sp,
                                      greyColor,
                                      1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
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
                        getCustomFont(Hotels?[i].price.toString() ?? '', 15.sp,
                            accentColor, 1,
                            fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class buildNearHotelList extends StatelessWidget {
  final Hotel? hotel;
  const buildNearHotelList({this.hotel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: SizedBox(
          height: 196.h,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(PageRouteBuilder(
              //     pageBuilder: (_, __, ___) =>  FeaturedHotel2Detail(
              //       Hotel: Hotels?[i],
              //         )));

              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new hotelDetail2(
                        hotel: hotel,
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
            child: Hero(
              tag: 'hero-tagss-${hotel?.id}' ?? '',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 374.h,
                  height: 196.h,
                  margin: EdgeInsets.only(right: 20.h, left: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.h),
                    image: DecorationImage(
                        image: NetworkImage(hotel?.image ?? ''),
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
                              width: 270.w,
                              child: getCustomFont(
                                  hotel?.title ?? "", 20.sp, Colors.white, 1,
                                  fontWeight: FontWeight.w700,
                                  txtHeight: 1.5.h),
                            ),
                            getVerSpace(4.h),
                            Row(
                              children: [
                                getSvgImage("location.svg",
                                    width: 20.h, height: 20.h),
                                getHorSpace(5.h),
                                Container(
                                  width: 200.w,
                                  child: getCustomFont(hotel?.location ?? "",
                                      15.sp, Colors.white, 1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                ),
                              ],
                            ),
                            getVerSpace(10.h),
                            Container(
                              width: MediaQuery.of(context).size.width / 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  // Text(
                                  //   "\$ ${  Hotels?[i].price.toString() ?? ""}",
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 16.5,
                                  //       fontFamily: "RedHat",
                                  //       fontWeight: FontWeight.w900),
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                  // getCustomFont(
                                  //     date.toString() ?? "", 15.sp, greyColor, 1,
                                  //     fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                                ],
                              ),
                            ),
                            getVerSpace(10.h),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getButton(context, accentColor, "Book Now",
                                      Colors.white, () {}, 14.sp,
                                      weight: FontWeight.w700,
                                      buttonHeight: 40.h,
                                      borderRadius: BorderRadius.circular(14.h),
                                      buttonWidth: 111.h),
                                  Row(
                                    children: [
                                      Text(
                                        'Distance : ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.5,
                                            fontFamily: "RedHat",
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${hotel?.distance?.toStringAsFixed(2)} KM',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.5,
                                            fontFamily: "RedHat",
                                            fontWeight: FontWeight.w900),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class buildFeatureHotelList extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const buildFeatureHotelList({this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196.h,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list?.take(5).length ?? 0,
        itemBuilder: (context, i) {
          final Hotels = list?.map((e) {
            return Hotel.fromFirestore(e, 1);
          }).toList();
          // String? category = list?[i]['category'].toString();
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
              // Navigator.of(context).push(PageRouteBuilder(
              //     pageBuilder: (_, __, ___) =>  FeaturedHotel2Detail(
              //       Hotel: Hotels?[i],
              //         )));
              FirebaseFirestore.instance
                  .collection('hotel')
                  .doc(list?[i].id)
                  .update({'count': FieldValue.increment(1)});
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => hotelDetail2(
                        hotel: Hotels?[i],
                      )));
            },
            child: Container(
              width: 374.h,
              height: 196.h,
              margin: EdgeInsets.only(right: 20.h, left: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.h),
                image: DecorationImage(
                    image: NetworkImage(Hotels?[i].image ?? ''),
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
                          width: 270.w,
                          child: getCustomFont(
                              Hotels?[i].title ?? "", 20.sp, Colors.white, 1,
                              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        ),
                        getVerSpace(4.h),
                        Row(
                          children: [
                            getSvgImage("location.svg",
                                width: 20.h, height: 20.h),
                            getHorSpace(5.h),
                            Container(
                              width: 200.w,
                              child: getCustomFont(Hotels?[i].location ?? "",
                                  15.sp, Colors.white, 1,
                                  fontWeight: FontWeight.w500,
                                  txtHeight: 1.5.h),
                            ),
                          ],
                        ),
                        getVerSpace(10.h),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
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
                              // Text(
                              //   "\$ ${  Hotels?[i].price.toString() ?? ""}",
                              //   style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 16.5,
                              //       fontFamily: "RedHat",
                              //       fontWeight: FontWeight.w900),
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              // getCustomFont(
                              //     date.toString() ?? "", 15.sp, greyColor, 1,
                              //     fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                            ],
                          ),
                        ),
                        getVerSpace(10.h),
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
      ),
    );
  }
}

class TrendingHotelCard extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const TrendingHotelCard({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.take(5).length,
        itemBuilder: (context, i) {
          final Hotels = list?.map((e) {
            return Hotel.fromFirestore(e, 1);
          }).toList();
          // String? category = list?[i]['category'].toString();
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

          return SizedBox(
            height: 289.h,
            child: GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => hotelDetail2(
                          hotel: Hotels?[i],
                        )));
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.h, left: 20.h),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.h),
                          image: DecorationImage(
                              image: NetworkImage(Hotels?[i].image ?? ''),
                              fit: BoxFit.fill)),
                      height: 170.h,
                      width: 248.h,
                      padding: EdgeInsets.only(left: 12.h, top: 12.h),
                      // child: Wrap(
                      //   children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //           color: "#B2000000".toColor(),
                      //           borderRadius: BorderRadius.circular(12.h)),
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 4.h, horizontal: 10.h),
                      //       child: getCustomFont(
                      //           "Hotels?[i].date" ?? "", 13.sp, Colors.white, 1,
                      //           fontWeight: FontWeight.w600, txtHeight: 1.69.h),
                      //     ),
                      //   ],
                      // ),
                    ),
                    Positioned(
                      width: 230.h,
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
                            Container(
                              width: 200.w,
                              child: getCustomFont(Hotels?[i].title ?? "",
                                  18.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600,
                                  txtHeight: 1.5.h),
                            ),
                            getVerSpace(3.h),
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
                                      Hotels?[i].location ?? "",
                                      15.sp,
                                      greyColor,
                                      1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                )
                              ],
                            ),
                            getVerSpace(5.h),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    "\$ ${Hotels?[i].price.toString() ?? ""}",
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
                            ),
                            getVerSpace(10.h),
                          ],
                        ),
                        // height: 133.h,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
