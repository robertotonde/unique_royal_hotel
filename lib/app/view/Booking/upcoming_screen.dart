import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pro_hotel_fullapps/app/data/data_file.dart';
import 'package:pro_hotel_fullapps/app/model/booking_hotel_model.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:pro_hotel_fullapps/app/view/Booking/booking_detail.dart';
import 'package:pro_hotel_fullapps/app/widget/Ratting/Rating.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:pro_hotel_fullapps/base/constant.dart';
import 'package:pro_hotel_fullapps/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:evente/evente.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

import '../bloc/sign_in_bloc.dart';

class UpComingScreen extends StatefulWidget {
  const UpComingScreen({Key? key}) : super(key: key);

  @override
  State<UpComingScreen> createState() => _UpComingScreenState();
}

class _UpComingScreenState extends State<UpComingScreen> {
  //
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
// Mendefinisikan tanggal yang akan dibandingkan (11/09/2023)

// Mendapatkan tanggal hari ini
    DateTime tanggalHariIni = DateTime.now();

// Membuat objek DateFormat untuk memformat tanggal
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

// Mengonversi tanggalHariIni ke format yang Anda inginkan
    String tanggalDalamFormat = formatter.format(tanggalHariIni);
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  right: 0.h, left: 0.h, top: 15.h, bottom: 20.h),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("AllBooking")
                    .where("userID", isEqualTo: sb.uid)
                    .where("status", isEqualTo: "upcoming")
                    // .where('checkIn', isGreaterThanOrEqualTo: tanggalDalamFormat)
                    .snapshots(),
                builder: (
                  BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return noItem();
                  } else {
                    if (snapshot.data?.docs.length == 0) {
                      return noItem();
                    } else {
                      if (loadImage) {
                        return _loadingDataList(
                            ctx, snapshot.data!.docs.length);
                      } else {
                        return itemData(list: snapshot.data?.docs);
                      }
                      // return new dataFirestore(list: snapshot.data.docs);
                    }
                    //  return  new noItem();
                  }
                },
              )),
          SizedBox(
            height: 40.0,
          )
        ],
      ),
    );
  }

  Widget _loadingDataList(BuildContext context, int panjang) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.only(top: 0.0),
        itemCount: panjang,
        itemBuilder: (ctx, i) {
          return loadingCard(ctx);
        },
      ),
    );
  }

  Widget loadingCard(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: Container(
        height: 250.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 3.0,
                  spreadRadius: 1.0)
            ]),
        child: Shimmer.fromColors(
          baseColor: Colors.black38,
          highlightColor: Colors.white,
          child: Column(children: [
            Container(
              height: 165.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.black12,
                ),
              ),
              alignment: Alignment.topRight,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 220.0,
                          height: 25.0,
                          color: Colors.black12,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0)),
                        Container(
                          height: 15.0,
                          width: 100.0,
                          color: Colors.black12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.9),
                          child: Container(
                            height: 12.0,
                            width: 140.0,
                            color: Colors.black12,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 35.0,
                          width: 55.0,
                          color: Colors.black12,
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Container(
                          height: 10.0,
                          width: 55.0,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget noItem() {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.h,
          ),
          getAssetImage("avflight.png", height: 254.h),
          getVerSpace(28.h),
          getCustomFont("Not have booking hotel!", 20.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
          getVerSpace(8.h),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: getMultilineCustomFont(
                "Currently, at this moment, not have any hotel booking.",
                17.sp,
                Colors.black54,
                fontWeight: FontWeight.w500,
                txtHeight: 1.5.h,
                textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter({required this.right, required this.holeRadius});

  final double right;
  final double holeRadius;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_3 = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.h;

    final path2 = Path()
      ..moveTo(size.width - right - holeRadius, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(
        Offset(size.width - right, 0),
        clockwise: false,
        radius: Radius.circular(1.h),
      )
      ..quadraticBezierTo(size.width * 0.86, 0, size.width * 0.94, 0)
      ..quadraticBezierTo(
          size.width * 1.00, size.height * 0.00, size.width, size.height * 0.13)
      ..lineTo(size.width, size.height * 0.88)
      ..quadraticBezierTo(
          size.width * 1.00, size.height * 1.00, size.width * 0.94, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(
        Offset(size.width - right - holeRadius, size.height),
        clockwise: false,
        radius: Radius.circular(1.h),
      )
      ..quadraticBezierTo(size.width * 0.200000, size.height,
          size.width * 0.0625000, size.height)
      ..quadraticBezierTo(size.width * 0.0013375, size.height * 0.9976500, 0,
          size.height * 0.8750000)
      ..quadraticBezierTo(
          0, size.height * 0.1875000, 0, size.height * 0.1250000)
      ..quadraticBezierTo(size.width * 0.0031875, size.height * 0.0027500,
          size.width * 0.0625000, 0);

    path2.close();

    canvas.drawPath(path2, paint_3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5.h, dashSpace = 4.h, startY = 0;
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 2.h;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class itemData extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  itemData({this.list});

  var _txtStyleTitle = TextStyle(
    color: Colors.black87,
    fontFamily: "RedHat",
    fontSize: 19.0.sp,
    fontWeight: FontWeight.w800,
  );

  var _txtStyleSub = TextStyle(
    color: Colors.black26,
    fontFamily: "RedHat",
    fontSize: 12.5.sp,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    final sb = context.watch<SignInBloc>();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(0.0),
      itemCount: list?.length,
      itemBuilder: (context, i) {
        final hotel = list?.map((e) {
          return BookingHotel.fromFirestore(e);
        }).toList();

        return InkWell(
          onTap: () {
             Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new BookingDetailScreen(
                              hotel: hotel?[i],
                      doc: list![i].reference,
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
            //     pageBuilder: (_, __, ___) => BookingDetailScreen(
            //           hotel: hotel[i],
            //           doc: list![i].reference,
            //         )));
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, bottom: 20.0.h),
            child: Container(
              height: 280.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 3.0,
                        spreadRadius: 1.0)
                  ]),
              child: Column(children: [
                Hero(
                    tag: 'hero-tagss-${hotel?[i].id}' ?? '',
                   
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 165.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0)),
                        image: DecorationImage(
                            image: NetworkImage(hotel?[i].image ?? ""),
                            fit: BoxFit.cover),
                      ),
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black54,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  
                                    context: context,
                                    builder: (BuildContext context) {
                                      return GiffyDialog.image(
                                        backgroundColor: Colors.white,
                                  
                                        Image.network(
                                          hotel?[i].image ?? "",
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text("Cancel Booking?",
                                            // AppLocalizations.of(context)
                                            //     .tr('cancelBooking'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "RedHat",
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w600)),
                                        content: Text(
                                          "Are you sure want to cancel booking ${hotel?[i].hotelName} ?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "RedHat",
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black26),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('CANCEL'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                  
                                              FirebaseFirestore.instance
                                                  .runTransaction(
                                                      (transaction) async {
                                                DocumentReference<Object?> a =
                                                    list![i].reference;
                                                DocumentSnapshot snapshot =
                                                    await transaction
                                                        .get(list![i].reference);
                                                await transaction
                                                    .delete(snapshot.reference);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Cancel booking ${hotel?[i].hotelName}"),
                                                backgroundColor: Colors.red,
                                                duration: Duration(seconds: 3),
                                              ));
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 220.0.w,
                                child: Text(
                                  hotel?[i].hotelName ?? "",
                                  style: _txtStyleTitle,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    ratingbar(
                                      starRating: hotel?[i].rattingHotel ?? 4.5,
                                      color: Color(0xFF09314F),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 5.0)),
                                    Text(
                                      "(" +
                                          hotel![i].rattingHotel.toString() +
                                          ")",
                                      style: _txtStyleSub,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Booking :   ",
                                      style: _txtStyleSub.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      hotel![i].totalBooking.toString() +
                                          "/Days",
                                      style: _txtStyleSub,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 16.0,
                                    color: Colors.black26,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 3.0)),
                                  Text(hotel?[i].location ?? "",
                                      style: _txtStyleSub)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "\$ " + hotel[i].roomPrice!.toString(),
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xFF09314F),
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "RedHat"),
                            ),
                            Text(('/Night'),
                                style: _txtStyleSub.copyWith(fontSize: 11.0.sp))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(('checkIn') + " : \t",
                              style: _txtStyleSub.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Padding(padding: EdgeInsets.only(top: 3.0)),
                          Text(hotel![i].checkIn.toString(),
                              style: _txtStyleSub)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(('checkOut') + " : \t",
                              style: _txtStyleSub.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Padding(padding: EdgeInsets.only(top: 3.0)),
                          Text(hotel![i].checkOut.toString(),
                              style: _txtStyleSub)
                        ],
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
