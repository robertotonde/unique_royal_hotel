import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/bookmark_bloc.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/sign_in_bloc.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Room.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/chooseDateScreen.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/Gallery.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/SeeAll/questionSeeAll.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/SeeAll/reviewSeeAll.dart';
import 'package:pro_hotel_fullapps/app/widget/love_icon.dart';
import 'package:pro_hotel_fullapps/app/widget/map_sheet.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:pro_hotel_fullapps/base/widget_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class hotelDetail2 extends StatefulWidget {
 Hotel? hotel;

  hotelDetail2(
      { this.hotel,});

  @override
  _hotelDetail2State createState() => _hotelDetail2State();
}

class _hotelDetail2State extends State<hotelDetail2> {
  /// Check user

     
  // ignore: unused_field
  String _book = "Book Now";
  

  String? _nama, _photoProfile, _email;

  final Set<Marker> _markers = {};

  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final sb = context.watch<SignInBloc>();
     final Hotel hotel = widget.hotel!;
    double _height = MediaQuery.of(context).size.height;

    var _location = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.only(
              top: 40.0.h, left: 20.0.w, right: 20.0.w, bottom: 10.0.h),
          child: Text(
          ('Location'),
            style: TextStyle(
                fontFamily: "RedHat",
                fontSize: 20.0.sp,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(left: 15.0.w, right: 15.0.w),
          child: Stack(
            children: <Widget>[
              Container(
                height: 190.0.h,
                child: GoogleMap(
                      trafficEnabled: true,
                   initialCameraPosition: CameraPosition(
                        target: LatLng(hotel.lat as double,
                            hotel.lang as double),
                        zoom: 12,
                   ),
                     onMapCreated: _onMapCreated,
                      markers: {
                        Marker(
                          markerId: const MarkerId("marker1"),
                          position: LatLng(hotel.lat as double,
                              hotel.lang as double),
                          draggable: true,
                          onDragEnd: (value) {
                            // value is the new position
                          },
                          // To do: custom marker icon
                        ),

                        // Marker(
                        //   markerId: const MarkerId("marker2"),
                        //   position: const LatLng(37.415768808487435, -122.08440050482749),
                        // ),
                      },
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: 135.0.h, left: 10.0.w),
                child:   InkWell(
                    onTap: (() {
                      MapsSheet.show(
                        context: context,
                        onMapTap: (map) {
                          map.showDirections(
                            destination: Coords(hotel.lat as double,
                                hotel.lang as double),
                            directionsMode: DirectionsMode.driving,
                          );
                        },
                      );
                    }),
                    child: Padding(
                      padding:  EdgeInsets.only(left:5.0.w),
                      child: Container(
                        height: 45.h,
                        width: 150.0.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  blurRadius: 27,
                                  offset: const Offset(0, 8))
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.navigation_rounded,
                                color: Colors.black,
                                size: 15.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Navigate',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'RedHat',
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              )
            ],
          ),
        ),
      ],
    );

  handleLoveClick() {
    final Hotel event = widget.hotel!;
    context.read<BookmarkBloc>().onBookmarkIconClick(event.title);
  }



    return  Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              /// AppBar
              SliverPersistentHeader(
                delegate: MySliverAppBar(
                    expandedHeight: _height - 30.0.h,
                    img: hotel.image,
                    id: hotel.id,
                    title: hotel.title,
                    price: hotel.price,
                    location: hotel.location,
                    ratting: hotel.ratting),
                pinned: true,
              ),

              SliverToBoxAdapter(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
              getVerSpace(15.h),
              Center(
                child: Container(
                  height: 8.0.h,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.all(Radius.circular(30.0))),
                ),
              ),
              getVerSpace(20.h),
                // Padding(
                //   padding: const EdgeInsets.only(left:20.0,right: 20.0),
                //   child: Row(
                //   children: [
                //     Icon(Icons.star,color: Colors.yellow,size: 20.h,),getHorSpace(5.h),
                //     getCustomFont(
                //       hotel.ratting.toString()?? '',
                //       15.sp,
                //       greyColor,
                //       1,
                //       fontWeight: FontWeight.w500,
                //     ),
                  
                //   ],
                //               ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left:20.0,right:20),
                  child: getCustomFont(hotel.title ?? '', 24.sp, Colors.black, 2,
                    fontWeight: FontWeight.w700, txtHeight: 1.5.h,),
                ),
              getVerSpace(10.h),
               Padding(
                 padding: const EdgeInsets.only(left:20.0,right: 20.0),
                 child: Row(
                  children: [
                    SvgPicture.asset("assets/svg/Location.svg",
                        height: 20.h, width: 20.h, color: accentColor),
                    getHorSpace(5.h),
                    Container(
                      width: 300.w,
                      child: getCustomFont(
                        hotel.location ?? '',
                        17.sp,
                        greyColor,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                             ),
               ),
                    /// Description
                 
              getVerSpace(20.h),
             Container(
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      decoration: BoxDecoration(
          color: accentColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(22.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
           Image.asset("assets/images/bed.png", width: 24.h, height: 24.h,),
           getHorSpace(5.h),
              getRichText(("Room Price "), Colors.black, FontWeight.w600, 15.sp,
                  "", greyColor, FontWeight.w500, 13.sp),
            ],
          ),
          Row(
            children: [
                  getCustomFont(
                  "\$" + hotel.price.toString() ?? "", 20.sp,accentColor, 1,
                  fontWeight: FontWeight.w800), 
                    Container(
                      child: getCustomFont(
                        ' /night',
                        17.sp,
                        greyColor,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                ],
          )
        ],
      ),
    ),
                   getVerSpace(25.h),
              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: getCustomFont(('Description'), 19.sp, Colors.black, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              ),
              getVerSpace(20.h),
            
                 
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 20.0, right: 0.0, bottom: 0.0),
                      child:Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, left: 0.0, bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.12,
                                          child: Text(
                                            hotel.description??"",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontFamily: "RedHat",
                                                color: Colors.black54,
                                                letterSpacing: 1.0,
                                                wordSpacing: 1.2,height: 1.5,
                                                fontSize: 16.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                    ),

                    /// Location
                    _location,

                    /// service
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
                      child: Text(
                        ('Amneties'),
                        style: TextStyle(
                            fontFamily: "RedHat",
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    //Text(_nama),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: hotel.service!
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 10.0, bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "-   ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.3,
                                          child: new Text(
                                            item,
                                            style: TextStyle(
                                                fontFamily: "RedHat",
                                                color: Colors.black54,
                                                fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList()),
           
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ('Photos'),
                            style: TextStyle(
                                fontFamily: "RedHat",
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.justify,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      gallery(image: hotel.gallery)));
                            },
                            child: Text(
                              ('See All'),
                              style: TextStyle(
                                  fontFamily: "RedHat",
                                  color: Colors.black38,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 0.0, right: 0.0, bottom: 40.0),
                      child: Container(
                        height: 150.0,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: hotel.gallery!
                                .map((item) => Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 10.0, bottom: 10.0),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                PageRouteBuilder(
                                                    opaque: false,
                                                    pageBuilder:
                                                        (BuildContext context,
                                                            _, __) {
                                                      return new Material(
                                                        color: Colors.black54,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  30.0),
                                                          child: InkWell(
                                                            child: Hero(
                                                                tag:
                                                                    "hero-grid-${hotel.id}",
                                                                child: Image
                                                                    .network(
                                                                  item,
                                                                  width: 300.0,
                                                                  height: 300.0,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                )),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    transitionDuration:
                                                        Duration(
                                                            milliseconds:
                                                                500)));
                                          },
                                          child: Container(
                                            height: 130.0,
                                            width: 130.0,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(item),
                                                    fit: BoxFit.cover),
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 5.0,
                                                      color: Colors.black12
                                                          .withOpacity(0.1),
                                                      spreadRadius: 2.0)
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList()),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 0.0,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              ('Question'),
                              style: TextStyle(
                                  fontFamily: "RedHat",
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => questionSeeAll(
                                          title: hotel.title??"",
                                          name: sb.name??"",
                                          photoProfile: sb.photoProfile??"",
                                        )));
                              },
                              child: Text(
                               ('See All'),
                                style: TextStyle(
                                    fontFamily: "RedHat",
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 0.0,
                    ),
                    // Question
                    Column(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Q&A")
                                .doc(hotel.title)
                                .collection('question')
                                .snapshots(),
                            builder: (
                              context,
                              snapshot,
                            ) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Column(children: [
                                    Image.asset(
                                        "assets/images/noQuestion.jpeg"),
                                    Text(('Not Have Question'))
                                  ]),
                                ));
                              } else {
                                if (snapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Column(children: [
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Image.asset(
                                      "assets/images/noQuestion.jpeg",
                                      fit: BoxFit.cover,
                                        height: 140,
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(('Not Have Question'),
                                      style: TextStyle(
                                          fontFamily: "RedHat",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black45,
                                          fontSize: 15.0),
                                    )
                                  ]));
                                } else {
                                  return questionCard(
                                      userId: sb.uid!,
                                      list: snapshot.data!.docs);
                                }
                              }
                            }),

                      ],
                    ),

                         getVerSpace(40.h),
                    // Review
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     SizedBox(
                    //       height: 25.0,
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(
                    //         left: 20.0,
                    //         right: 20.0,
                    //         top: 0.0,
                    //       ),
                    //       child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: <Widget>[
                    //             Text(
                    //            ('reviews'),
                    //               style: TextStyle(
                    //                   fontFamily: "RedHat",
                    //                   fontSize: 20.0,
                    //                   color: Colors.black,
                    //                   fontWeight: FontWeight.w700),
                    //             ),
                    //             InkWell(
                    //               onTap: () {
                    //                 Navigator.of(context).push(PageRouteBuilder(
                    //                     pageBuilder: (_, __, ___) =>
                    //                         new reviewSeeAll(
                    //                           name: sb.name!,
                    //                           photoProfile: sb.photoProfile,
                    //                           title: hotel.title!,
                    //                         )));
                    //               },
                    //               child: Text(
                    //                 ('seeAll'),
                    //                 style: TextStyle(
                    //                     fontFamily: "RedHat",
                    //                     color: Colors.black54,
                    //                     fontSize: 16.0,
                    //                     fontWeight: FontWeight.w400),
                    //               ),
                    //             ),
                    //           ]),
                    //     ),
                    //     SizedBox(
                    //       height: 20.0,
                    //     ),
                    //     Column(
                    //       children: [
                    //         StreamBuilder(
                    //             stream: FirebaseFirestore.instance
                    //                 .collection("Reviews")
                    //                 .doc(hotel.id)
                    //                 .collection('rating')
                    //                 .snapshots(),
                    //             builder: (
                    //               context,
                    //               snapshot,
                    //             ) {
                    //               if (!snapshot.hasData) {
                    //                 return Center(
                    //                     child: Column(children: [
                    //                   SizedBox(
                    //                     height: 15.0,
                    //                   ),
                    //                   Image.asset(
                    //                     "assets/images/noReview.jpeg",
                    //                     fit: BoxFit.cover,
                    //                     height: 140,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 15.0,
                    //                   ),
                    //                   Text(
                    //                    ('notHaveReview'),
                    //                     style: TextStyle(
                    //                         fontFamily: "RedHat",
                    //                         fontWeight: FontWeight.w600,
                    //                         color: Colors.black45,
                    //                         fontSize: 15.0),
                    //                   )
                    //                 ]));
                    //               } else {
                    //                 if (snapshot.data!.docs.isEmpty) {
                    //                   return Center(
                    //                       child: Column(children: [
                    //                     SizedBox(
                    //                       height: 15.0,
                    //                     ),
                    //                     Image.asset(
                    //                       "assets/images/noReview.jpeg",
                    //                       fit: BoxFit.cover,
                    //                     height: 140,
                    //                     ),
                    //                     SizedBox(
                    //                       height: 15.0,
                    //                     ),
                    //                     Text(
                    //                       ('notHaveReview'),
                    //                       style: TextStyle(
                    //                           fontFamily: "RedHat",
                    //                           fontWeight: FontWeight.w600,
                    //                           color: Colors.black45,
                    //                           fontSize: 15.0),
                    //                     )
                    //                   ]));
                    //                 } else {
                    //                   return ratingCard(
                    //                       userId: sb.uid!,
                    //                       list: snapshot.data!.docs);
                    //                 }
                    //               }
                    //             })
                    //       ],
                    //     ),
                    //     SizedBox(
                    //       height: 50.0,
                    //     )
                    //   ],
                    // ),

                    /// Button
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 10.0),
                      child: InkWell(
                        onTap: () async {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new ChooseDateScreen(
                                hotel:hotel,
                                 room: hotel.room,
                                  )));
                          // ChooseDateScreen
                          // Navigator.of(context).push(PageRouteBuilder(
                          //     pageBuilder: (_, __, ___) => new RoomScreen(
                          //       hotel:hotel,
                          //        room: hotel.room,
                          //         )));
                        },
                        child: Container(
                          height: 55.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF09314F),
                                    Color(0xFF09314F),
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp)),
                          child: Center(
                            child: Text(
                              ('Booking Now'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19.0,
                                  fontFamily: "RedHat",
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  String? img, id, title, location;
  num? price;
  num? ratting;

  MySliverAppBar(
      {required this.expandedHeight,
      this.img,
      this.id,
      this.title,
      this.price,
      this.location,
      this.ratting});

  var _txtStyleTitle = TextStyle(
    color: Colors.black54,
    fontFamily: "RedHat",
    fontSize: 18.0,
    fontWeight: FontWeight.w800,
  );

  var _txtStyleSub = TextStyle(
    color: Colors.black26,
    fontFamily: "RedHat",
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
   
    final sb = context.watch<SignInBloc>();
   
handleLoveClick() {
    context.read<BookmarkBloc>().onBookmarkIconClick(title);
  }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 50.0.h,
          width: double.infinity,
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/logo.png",
            height: (expandedHeight / 30) - (shrinkOffset / 40) + 24,
          ),
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            tag: 'hero-tagss-${id}',
            child: Stack(
              children: [
                new DecoratedBox(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: new NetworkImage(img!),
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 620.0.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(0.0, 1.0),
                        stops: [0.0, 1.0],
                        colors: <Color>[
                          Color(0x00FFFFFF),
                          Color(0xFFFFFFFF),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right:20.0,top: 30.0),
                    child: Container(
                            width: 45.0.w,
                            height: 45.0.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                color: Colors.white),
                            child: IconButton(
                                icon: BuildLoveIcon(
                                    collectionName: 'hotel',
                                    uid: sb.uid,
                                    timestamp: title),
                                onPressed: () {
                                  handleLoveClick();
                                }),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
            
        Align(
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Padding(
              padding:  EdgeInsets.only(
                  top: 20.0.h, right: 20.0.w, left: 20.0.w, bottom: 40.0.h),
              child: Container(
                height: 170.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white.withOpacity(0.85)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                 EdgeInsets.only(left: 15.0.w, right: 2.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    width: 210.0.w,
                                    child: Text(
                                      title!,
                                      style: _txtStyleTitle.copyWith(
                                         color: Colors.black,
                                         letterSpacing: 0.0,
                                         height: 0.0,
                                         wordSpacing: 0.0,
                                          fontSize: 25.0.sp),
                                          maxLines: 3,
                                      overflow: TextOverflow.clip,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 13.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "\$ " + price.toString(),
                                        style: TextStyle(
                                            fontSize: 28.0.sp,
                                            color: Color(0xFF09314F),
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "RedHat"),
                                      ),
                                      Text(
                                        ('/Night'),
                                          style: _txtStyleSub.copyWith(
                                              fontSize: 13.0.sp))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0.h,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0.h,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0.h,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0.h,
                                        ),
                                        Icon(
                                          Icons.star_half,
                                          color: Color(0xFF09314F),
                                          size: 22.0.h,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            size: 14.0,
                                            color: Colors.black26,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width-100.w,
                                            child: Text(
                                              location!,
                                              style: TextStyle(
                                                  color: Colors.black26,
                                                  fontSize: 14.5.sp,
                                                  fontFamily: "RedHat",
                                                  fontWeight: FontWeight.w400),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                            color: Colors.white70,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          )),
                    ))),
            SizedBox(
              width: 36.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class questionCard extends StatelessWidget {
  final String? userId;
  questionCard({this.list, this.userId});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: 1,
          itemBuilder: (context, i) {
            String pp = list![i]['Photo Profile'].toString();
            String question = list![i]['Detail question'].toString();
            String name = list![i]['Name'].toString();
            String answer = list![i]['Answer'].toString();
            Timestamp date = list![i]['Date'];
            String image = list![i]['Image'].toString();

// Ubah Timestamp ke dalam DateTime
DateTime dateTime = date.toDate();

// Format tanggal dan waktu ke dalam string yang diinginkan
String _timestamp = DateFormat('dd MMMM yyyy').format(dateTime);

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 33.0.h,
                      width: 33.0.w,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.black12),
                        image: DecorationImage(
                            image: NetworkImage(pp), fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    SizedBox(width: 10.0.w,),
                     Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            fontFamily: "RedHat",
                              fontSize: 17.0.sp),
                        ),
                        SizedBox(width: 10.0.w,),
                        CircleAvatar(backgroundColor: Colors.black54,radius: 3.0,),
                        SizedBox(width: 5.0.w,),
                        Container(
                          width: 200.0.w,
                          child: Text(
                            _timestamp??"",
                            style: TextStyle(
                              fontFamily: "RedHat",
                                fontWeight: FontWeight.w300,
                                color: Colors.black38,
                                fontSize: 14.0.sp),
                                maxLines: 1,
                          ),
                        ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                       Container(
                      width: MediaQuery.of(context).size.width ,
                         padding: EdgeInsets.only(
                          left: 15.0, top: 15.0, bottom: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        color: Color(0xFF09314F).withOpacity(0.1),
                      ),
                         child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                                    question,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black54,
                                        fontSize: 15.5),
                                    overflow: TextOverflow.fade,
                                  ),
                                    SizedBox(height: 5.0),
                         Container(
                          width: double.infinity,
                          color: Colors.black12,
                          height: 1.0,
                         ),
                          Wrap(
                            children: [
                              Text(
                          ('answer :'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 15.5),
                              ),
                              Text(
                                answer,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54,
                                    fontSize: 15.5),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                           ],
                         ),
                       ),     
                       
                // Padding(
                //   padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                //   child: Container(
                //     width: MediaQuery.of(context).size.width - 100,
                //     padding: EdgeInsets.only(
                //         left: 15.0, top: 0.0, bottom: 15.0, right: 15.0),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(20.0),
                //         bottomLeft: Radius.circular(20.0),
                //         topRight: Radius.circular(20.0),
                //       ),
                //       color: Color(0xFF09314F).withOpacity(0.1),
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //           height: 15.0,
                //         ),
                //         Text(
                //           name,
                //           style: TextStyle(
                //               fontWeight: FontWeight.w600,
                //               color: Colors.black87,
                //               fontSize: 18.0),
                //         ),
                //         SizedBox(
                //           height: 15.0,
                //         ),
                //         image == null
                //             ? Container(height: 1, width: 1)
                //             : Container(
                //                 height: 50.0,
                //                 width: 50.0,
                //                 decoration: BoxDecoration(
                //                     color: Colors.black12,
                //                     image: DecorationImage(
                //                         image: NetworkImage(image),
                //                         fit: BoxFit.cover)),
                //               ),
                //         SizedBox(
                //           height: 10.0,
                //         ),
                //         Wrap(
                //           children: [
                //             Text(
                //              ("ask") + ": ",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w500,
                //                   color: Colors.black54,
                //                   fontSize: 15.5),
                //             ),
                //             Text(
                //               question,
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w300,
                //                   color: Colors.black54,
                //                   fontSize: 15.5),
                //               overflow: TextOverflow.fade,
                //             ),
                //           ],
                //         ),
                //         SizedBox(height: 5.0),
                //    if(answer.isEmpty) Container(),
                //  if(answer.characters.length>1)  Wrap(
                //           children: [
                //             Text(
                //               ('answer') + ": ",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w500,
                //                   color: Colors.black54,
                //                   fontSize: 15.5),
                //             ),
                //             Text(
                //               answer,
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w300,
                //                   color: Colors.black54,
                //                   fontSize: 15.5),
                //               overflow: TextOverflow.fade,
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // )
            
              ],
            );
          }),
    );
  }
}

class ratingCard extends StatelessWidget {
  final String? userId;
  ratingCard({this.list, this.userId});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: 1,
          itemBuilder: (context, i) {
            // String pp = list[i].data()['Photo Profile'].toString();
            // String review = list[i].data()['Detail rating'].toString();
            // String name = list[i].data()['Name'].toString();
            // String rating = list[i].data()['rating'].toString();
            return Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: NetworkImage(
                                "pp",
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 22.0,
                              color: Colors.yellow,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                "rating",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "RedHat",
                                    fontSize: 16.0),
                              ),
                            ),
                            SizedBox(
                              width: 35.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: EdgeInsets.only(
                          left: 15.0, top: 15.0, bottom: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                        color: Color(0xFF09314F).withOpacity(0.1),
                      ),
                      child: Text(
                        "review",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 17.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
