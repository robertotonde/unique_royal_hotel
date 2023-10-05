import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giffy_dialog/giffy_dialog.dart' as giffy;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pro_hotel_fullapps/app/model/booking_hotel_model.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/bookmark_bloc.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/Gallery.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/SeeAll/questionSeeAll.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/SeeAll/reviewSeeAll.dart';
import 'package:pro_hotel_fullapps/app/view/home/home_screen.dart';
import 'package:pro_hotel_fullapps/app/widget/love_icon.dart';
import 'package:pro_hotel_fullapps/app/widget/map_sheet.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:evente/evente.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:dotted_line/dotted_line.dart';
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';


class BookingDetailScreen extends StatefulWidget {
   BookingHotel? hotel;
   DocumentReference<Object?>? doc;
   BookingDetailScreen({Key? key,this.hotel,this.doc}) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  /// Check user

     
  // ignore: unused_field
  String _book = "Book Now";
  

  String? _nama, _photoProfile, _email;


  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void initState() {
    super.initState();
  }

   String formatDate(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) {
      return 'No Date'; // or any default value you prefer
    }

    DateTime? date;
    try {
      date = DateFormat('dd/MM/yyyy').parse(inputDate);
    } catch (e) {
      return 'Invalid Date'; // handle parsing errors, if any
    }

    String formattedDate = DateFormat('dd MMMM yyyy').format(date);
    return formattedDate;
  }


  @override
  Widget build(BuildContext context) {

    final sb = context.watch<SignInBloc>();
     final BookingHotel hotel = widget.hotel!;
    double _height = MediaQuery.of(context).size.height;

    var _location = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Text(
          ('location'),
            style: TextStyle(
                fontFamily: "RedHat",
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 190.0,
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
                padding: const EdgeInsets.only(top: 135.0, left: 10.0),
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
                      padding: const EdgeInsets.only(left:5.0),
                      child: Container(
                        height: 45.h,
                        width: 150.0,
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
    final BookingHotel event = widget.hotel!;
    context.read<BookmarkBloc>().onBookmarkIconClick(event.hotelName);
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
                    expandedHeight: _height - 30.0,
                    img: hotel.image,
                    id: hotel.id,
                    title: hotel.hotelName,
                    price: hotel.priceHotel,
                    location: hotel.location,
                    ratting: hotel.ratting),
                pinned: true,
              ),

              SliverToBoxAdapter(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                           Container(
                            // height: 850.0,
                        width: double.infinity,
                        decoration: BoxDecoration(color: accentColor),
                     
                             child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 20.0,bottom: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Detail Booking",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                    SizedBox(height: 10.0,),
                                    Container(
                                      height: 310.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(10.0)),
                                          border: Border.all(
                                              width: 1.0, color: Color(0XFFECECEC))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15, top: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    // SvgPicture.asset("assets/icons/BCA.svg",height: 45.0,),
                                                    Image.asset(
                                                      "assets/icon/hotel.png",
                                                      height: 25.0,
                                                      width: 25.0,
                                                    ),
                                                    SizedBox(
                                                      width: 12.0,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          bottom: 3.0),
                                                      child: Container(
                                                          width:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width -
                                                                  115,
                                                          child: Text(
                                                            widget.hotel?.hotelName ?? "",
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight.w700,
                                                                color: Colors.black),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Check-In",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  formatDate(
                                                    widget.hotel?.checkIn ?? "",
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: "RedHat",
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Check-Out",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  formatDate(
                                                    widget.hotel?.checkOut ?? "",
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: "RedHat",
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Container(
                                              height: 1.0,
                                              width: double.infinity,
                                              color: Colors.black12,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              "Room Information",
                                              style: TextStyle(
                                                  fontFamily: "RedHat",
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(widget.hotel?.roomType ?? ""),
                                            Text(widget.hotel?.informationRoom ?? ""),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Price room : "),
                                                    Text("\$${widget.hotel?.roomPrice
                                                                .toString() ??
                                                            ""}"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Total booking : "),
                                                    Text("${widget.hotel?.totalBooking} Days"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                               SizedBox(
                                              height: 10.0,
                                            ),
                                            Container(
                                              height: 1.0,
                                              width: double.infinity,
                                              color: Colors.black12,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                             Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                               children: [
                                                    Text(('Payment Method :'),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "RedHat",
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    )),
                                                 Text(widget.hotel!.statusPayment??"", style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "RedHat",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    )),
                                               ],
                                             ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Container(
                                              height: 1.0,
                                              width: double.infinity,
                                              color: Colors.black12,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(('Total Price'),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "RedHat",
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    )),
                                                    
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "\$${widget.hotel!.price}" ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 25.0,
                                                          color: Colors.blueAccent,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: "RedHat"),
                                                    ),
                                               
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 20.0,),

                                    Container(
                                      width: double.infinity,
                                      
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(10.0)),
                                          border: Border.all(
                                              width: 1.0, color: Color(0XFFECECEC))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:20.0,right: 20,top: 20.0,bottom: 20.0),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 35.0,
                                                      backgroundColor: Colors.grey,
                                                      child: Image.network(widget.hotel!.photoProfile??"https://www.tech101.in/wp-content/uploads/2018/07/blank-profile-picture.png"),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:15.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Contact Person", style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "RedHat",
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    )),
                                                          SizedBox(height: 3.0,),
                                                          Text("Name : ${widget.hotel!.name}"),
                                                          Text("Email : ${widget.hotel!.email}"),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                    )
                                  ],
                                ),
                              ),
                           ),
                          
              getVerSpace(15.h),
              Center(
                child: Container(
                  height: 8.0,
                  width: 70.0,
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
                  /// Description
                 
                   getVerSpace(5.h),
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
                        ('amneties'),
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
                          children: hotel.serviceHotel!
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
                            ('photos'),
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
                              ('seeAll'),
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

                    SizedBox(
                      height: 0.0,
                    ),
                    // Review
           
                    /// Button
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 15.0, right: 15.0, bottom: 10.0),
//                       child: InkWell(
//                         onTap: () async {
                        
//                           showDialog(
//    context: context,
//    builder: (BuildContext context) {
//      return giffy.GiffyDialog.image(
//                                       Image.network(
//                                         hotel?.image ?? "",
//                                         height: 200,
//                                         fit: BoxFit.cover,
//                                       ),
//                                       title: Text("Cancel Booking?",
//                                           // AppLocalizations.of(context)
//                                           //     .tr('cancelBooking'),
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontFamily: "RedHat",
//                                               fontSize: 22.0,
//                                               fontWeight: FontWeight.w600)),
//                                       content: Text(
//                                         "Are you sure want to cancel booking ${hotel?.hotelName} ?",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontFamily: "RedHat",
//                                             fontWeight: FontWeight.w300,
//                                             color: Colors.black26),
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () 
//                                           {
//                                             Navigator.of(context).pop(); 
//                                           },
//                                           child: const Text('CANCEL'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () async{
//                                             // Navigator.of(context).pop();
//                                                Navigator.of(context).pop();
//                                                Navigator.of(context).pop();
// //                                                   Future.delayed(Duration.zero, () {
// //                                                 Navigator.pushAndRemoveUntil(
// //   context,
// //   MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
// //   (route) => false,
// // );// Ini akan kembali ke screen sebelumnya setelah tindakan selesai
// // }); 
//                                             await FirebaseFirestore.instance
//                                                 .runTransaction(
//                                                     (transaction) async {
//                                               DocumentSnapshot snapshot =
//                                                   await transaction
//                                                       .get(widget.doc!);
//                                               await transaction
//                                                   .delete(snapshot.reference);
                                              
//                                             }); 
                                           
                                            
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(SnackBar(
//                                               content: Text("Cancel booking ${hotel?.hotelName}"),
//                                               backgroundColor: Colors.red,
//                                               duration: Duration(seconds: 3),
//                                             ));
                                          
//                                           },
//                                           child: const Text('OK'),
//                                         ),
//                                       ],
//                             );});
//                         },
//                         child: Container(
//                           height: 55.0,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5.0)),
//                               gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF09314F),
//                                     Color(0xFF09314F),
//                                   ],
//                                   begin: const FractionalOffset(0.0, 0.0),
//                                   end: const FractionalOffset(1.0, 0.0),
//                                   stops: [0.0, 1.0],
//                                   tileMode: TileMode.clamp)),
//                           child: Center(
//                             child: Text(
//                               ('Cancel Booking'),
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 19.0,
//                                   fontFamily: "RedHat",
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
              
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
          height: 50.0,
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
                    margin: EdgeInsets.only(top: 620.0),
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
                            width: 45.0,
                            height: 45.0,
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
              padding: const EdgeInsets.only(
                  top: 20.0, right: 20.0, left: 20.0, bottom: 40.0),
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
                                const EdgeInsets.only(left: 15.0, right: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    width: 210.0,
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
                                        "\$ $price",
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: Color(0xFF09314F),
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "RedHat"),
                                      ),
                                      Text(
                                        ('/Night'),
                                          style: _txtStyleSub.copyWith(
                                              fontSize: 11.0))
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
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star_half,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
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
                                          Text(
                                            location!,
                                            style: TextStyle(
                                                color: Colors.black26,
                                                fontSize: 14.5.sp,
                                                fontFamily: "RedHat",
                                                fontWeight: FontWeight.w400),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
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
            String image = list![i]['Image'].toString();
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: EdgeInsets.only(
                        left: 15.0, top: 0.0, bottom: 15.0, right: 15.0),
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
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        image == null
                            ? Container(height: 1, width: 1)
                            : Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    image: DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.cover)),
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Wrap(
                          children: [
                            Text(
                             "ask: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontSize: 15.5),
                            ),
                            Text(
                              question,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                  fontSize: 15.5),
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                   if(answer.isEmpty) Container(),
                 if(answer.characters.length>1)  Wrap(
                          children: [
                            Text(
                              ('answer') + ": ",
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
                )
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
