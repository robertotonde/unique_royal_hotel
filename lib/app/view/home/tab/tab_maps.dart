import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../featured_event/featured_event_detail2.dart';

class MapsScreenT1 extends StatefulWidget {
  MapsScreenT1({Key? key}) : super(key: key);

  @override
  _MapsScreenT1State createState() => _MapsScreenT1State();
}

class _MapsScreenT1State extends State<MapsScreenT1> {
  late GoogleMapController _controller;
  final Completer<GoogleMapController> _controller2 = Completer();
  BitmapDescriptor? customIcon;
  bool isMapCreated = false;
  LatLng? currentPosition;
  // List<Marker> allMarkers = [];
 var markerIdCounter = 0;
  List<Marker> allMarkers = [];
  PageController? _pageController;
  List<DocumentSnapshot> dataList = [];

  List<Map<dynamic, dynamic>> dataList2 = [];

  final firestoreInstance = FirebaseFirestore.instance;

  
  // List<DocumentSnapshot> dataList = [];

  int? prevPage;

  @override
  void initState() {

    
      Geolocator.getCurrentPosition().then((value) {
      setState(() {
        currentPosition = LatLng(value.latitude, value.longitude);
      });
    });
  _getCurrentLocation();
    FirebaseFirestore.instance.collection('hotel').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        LatLng latLng = LatLng(data['lat'], data['lang']);
        // LatLng(40.7078523, -74.008981)
        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: latLng,
          infoWindow: InfoWindow(
            title: data['title'],
            snippet: data['location'],
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );

        markers.add(marker);
      });
    });
    // getMarker();
    getDataFromFirestore();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);

    super.initState();
  }

  Set<Marker> markers = Set<Marker>();
  Map<MarkerId, Marker> markers2 = <MarkerId, Marker>{};

  void getMarker() {
    firestoreInstance.collection("hotel").get().then((querySnapshot) {
      setState(() {
        dataList2.clear();
        Map<dynamic, dynamic> values = querySnapshot.docs.map((doc) {
          return doc.data();
        }).toList() as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          dataList2.add(value);
        });
      });
    });
  }

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  void getDataFromFirestore() {
    FirebaseFirestore.instance.collection("hotel").get().then((querySnapshot) {
      setState(() {
        dataList.clear();
        dataList.addAll(querySnapshot.docs);
      });
    });
  }
   CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(40.7078523, -74.008981),
    zoom: 10.0,
  );

Future<void> _getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  LatLng currentLocation = LatLng(position.latitude, position.longitude);
  setState(() {
    initialCameraPosition = CameraPosition(
      target: currentLocation,
      zoom: 15.0, // Atur zoom sesuai keinginan Anda
    );
  });

  
}


    String markerIdVal({bool increment = false}) {
    String val = 'marker_id_$markerIdCounter';
    if (increment) markerIdCounter++;
    return val;
  }

  void onMapCreated(GoogleMapController controller) {
    _controller2.complete(controller);
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        currentPosition = LatLng(value.latitude, value.longitude);
        if (currentPosition != null) {
          MarkerId markerId = MarkerId(markerIdVal());
          LatLng position = currentPosition!;
          Marker marker = Marker(
            markerId: markerId,
            position: position,
            draggable: false,
          );

          Future.delayed(
            const Duration(seconds: 1),
            () async {
              GoogleMapController controller = await _controller2.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position,
                    zoom: 15.0,
                  ),
                ),
              );
            },
          );
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // if (isMapCreated) {
    //   getJsonFile("assets/nightmode.json").then(setMapStyle);
    // }

    return Scaffold(
        body: Stack(
      children: <Widget>[
       if (currentPosition == null)  CircularProgressIndicator(),
     
       if (currentPosition != null)  Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
          target: currentPosition!,
          zoom: 15,
        ),
        /// Code for current location
        // markers: Set<Marker>.of(markers2.values),
        //  onMapCreated: onMapCreated,

            onTap: (pos) {
              print(pos);
              Marker m = Marker(
                  markerId: MarkerId('1'), icon: customIcon!, position: pos);
              setState(() {
                markers.add(m);
              });
            },
            markers: Set.from(markers),
            //                {
            // Marker(
            //   markerId: const MarkerId("marker1"),
            //   position:  LatLng(40.7078523, -74.008981),
            //   draggable: true,
            //   onDragEnd: (value) {
            //     // value is the new position
            //   },
            //   // To do: custom marker icon
            // ),},

            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
        ),
         
        dataList.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cardMaps(index);
                    },
                  ),
                ),
              ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 27.0),
              child: Container(
                height: 55.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 50.0,),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                      child: Center(
                        child: Text(
                          ("Locations").tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "RedHat",
                            fontWeight: FontWeight.w700,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:15.0),
                      child: InkWell(
                        onTap: () {
                             if (currentPosition != null && _controller != null) {
            _controller!.animateCamera(
              CameraUpdate.newLatLng(currentPosition!),
            );
          }
                        },
                        child: Icon(Icons.my_location_outlined,size: 21,color: Colors.grey[800],)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.6),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  moveCamera() {
    firestoreInstance.collection("hotel").get().then((querySnapshot) {
      final events = querySnapshot.docs.map((e) {
        return Hotel.fromFirestore(e, 1);
      }).toList();

      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: events[_pageController!.page!.toInt()].latLng!,
          zoom: 15.0,
          bearing: 45.0,
          tilt: 45.0)));
    });
  }

  Widget cardMaps(index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('hotel').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final List<Hotel> lokasiList = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final events = snapshot.data?.docs.map((e) {
              return Hotel.fromFirestore(e, 1);
            }).toList();

            return Hotel(
                country: data['country'],
                gallery: data['gallery'],
                latLng: data['latLng'],
                ratting: data['ratting'],
                // room: data['room'],
                service: data['service'],
                status: data['status'],
                category: data['category'],
                date: data['date'],
                image: data['image'],
                description: data['description'],
                id: data['id'],
                location: data['location'],
                lang: data['lang'],
                lat: data['lat'],
                price: data['price'],
                title: data['title'],
                room: () {
                  if (data['room'] == null) return <Room>[];

                  return ((data['room'] ?? <String, dynamic>{})
                          as Map<String, dynamic>)
                      .entries
                      .map((e) {
                    return Room.fromJson(e.value);
                  }).toList();
                }());
            // return Event.fromFirestore(events);
          }).toList();
          // return CardSlider(lokasiList: lokasiList);
          return AnimatedBuilder(
              animation: _pageController!,
              builder: (
                BuildContext context,
                Widget? widget,
              ) {
                // ignore: unused_local_variable

                double value = 1;
                if (_pageController!.position.haveDimensions) {
                  value = _pageController!.page! - index;
                  value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
                }
                return Center(
                  child: SizedBox(
                    height: Curves.easeInOut.transform(value) * 125.0,
                    width: Curves.easeInOut.transform(value) * 350.0,
                    child: widget,
                  ),
                );
              },
              child: card(lokasiList, index));
        });
  }

  Widget card(lokasiList, i) {
    DateTime? dateTime = lokasiList![i].date?.toDate();
    // String date = DateFormat('d MMMM, yyyy').format(dateTime!);

    return Padding(
      padding:
          const EdgeInsets.only(left: 0.0, right: 8.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new hotelDetail2(
                              hotel: lokasiList?[i],
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
            //   pageBuilder: (_, __, ___) => hotelDetail2(
            //         hotel: lokasiList[i],
                   
            //       )));
          FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(i?[i].id)
                    .update({'count': FieldValue.increment(1)});
        
        },
        child: Container(
          height: 140.0,
          width: 340.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    color: Colors.black12.withOpacity(0.03))
              ]),
          child: Row(
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Hero(
                    tag: 'hero-tagss-${lokasiList?[i].id}' ?? '',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 140.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                          image: DecorationImage(
                              image: NetworkImage(lokasiList[i].image ?? ''),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                        width: 150.0,
                        child: Text(
                          lokasiList[i].title ?? '',
                          style: TextStyle(
                              fontFamily: "RedHat",
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.0),
                          overflow: TextOverflow.ellipsis,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset("assets/svg/Location.svg",
                              color: accentColor, width: 13.h, height: 13.h),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            width: 140.0,
                            child: Text(
                              lokasiList[i].location ?? '',
                              style: TextStyle(
                                  color: greyColor,
                                  fontSize: 14.5,
                                  fontFamily: "RedHat",
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
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
                            "\$ ${lokasiList[i].price.toString() ?? ""}",
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
                    // Container(
                    //   height: 35.0,
                    //   width: 80.0,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    //       color: accentColor),
                    //   child: Center(
                    //       child: Text(
                    //     lokasiList[i].category ?? '',
                    //     style: TextStyle(color: Colors.white),
                    //   )),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class joinEvents extends StatelessWidget {
  joinEvents({this.list});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Container(
              height: 25.0,
              width: 54.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list!.length > 3 ? 3 : list?.length,
                itemBuilder: (context, i) {
                  String? _title = list?[i]['name'].toString();
                  String? _uid = list?[i]['uid'].toString();
                  String? _img = list?[i]['photoProfile'].toString();

                  return Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      height: 24.0,
                      width: 24.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(70.0)),
                          image: DecorationImage(
                              image: NetworkImage(_img ?? ''),
                              fit: BoxFit.cover)),
                    ),
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 3.0,
            left: 0.0,
          ),
          child: Row(
            children: [
              Container(
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(30.h),
                    border: Border.all(color: Colors.white, width: 1.5.h)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getCustomFont(
                        list?.length.toString() ?? '', 12.sp, Colors.white, 1,
                        fontWeight: FontWeight.w600),
                    getCustomFont(" +", 12.sp, Colors.white, 1,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
