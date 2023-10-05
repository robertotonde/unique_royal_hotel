import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pro_hotel_fullapps/app/dialog/ticket_confirm_dialog.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/sign_in_bloc.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/buy_ticket.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/payment.dart';
import 'package:pro_hotel_fullapps/app/view/home/home_screen.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:pro_hotel_fullapps/base/widget_utils.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookitnow extends StatefulWidget {
  String? checkin, checkout;
  Hotel? hotel;
  Room? room;
  num? count;
  Bookitnow({this.hotel, this.room, this.checkin, this.checkout, this.count});

  @override
  _BookitnowState createState() => _BookitnowState();
}

class _BookitnowState extends State<Bookitnow> {
  // Hotel? hotel = widget.hotel;

  String _book = "Book Now";
  num? price;
  num? totalPrice2;
  String dynamicPayment = "COD";

  _check() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.hotel!.title ?? "", "1");
  }

  Map<String, dynamic>? paymentIntent;
  late Razorpay _razorpay;
  String? _valOccassion;

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': totalPrice2!*100,
      "currency": "USD",
      'name': 'Checkout',
      'description': widget.hotel?.title ?? "0",
      'prefill': {'contact': '8232378987', 'email': "event_official@gmail.com"},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    toasty(context, "SUCCESS: " + response.paymentId.validate());
           showDialog(
                          builder: (context) {
                            return const TicketConfirmDialog();
                          },
                          context: context);
                            Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  (route) => false,
);
    // Navigator.of(context).pushReplacement(PageRouteBuilder(
    //   pageBuilder: (_, __, ___) => TicketDetail(
    //        event: widget.hotel,
    //       )));
    final Hotel event = widget.hotel!;
    final sb = context.watch<SignInBloc>();
    
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      FirebaseFirestore.instance
       .collection("BookingByUser")
            .doc("UserID:${sb.uid}")
            .collection('allBooking')
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "phone": sb.phone,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });});

        FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("BookingByItem")
            .doc(widget.hotel?.title ?? '')
            .collection(sb.uid ?? "")
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "phone": sb.phone,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
        
    FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("BookingByItem")
            .doc(widget.hotel?.title ?? '')
            .collection("order")
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "phone": sb.phone,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });

       FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("AllBooking")
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "phone": sb.phone,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
      
      }

  void _handlePaymentError(PaymentFailureResponse response) {
    toasty(
        context,
        "ERROR: " +
            response.code.toString() +
            " - " +
            response.message.validate());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    toasty(context, "EXTERNAL_WALLET: " + response.walletName.validate());
  }

  /// Check user
  _checkFirst() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString(widget.hotel?.title ?? "") == null) {
      setState(() {
        _book = "Book Now";
      });
    } else {
      setState(() {
        _book = "Booked";
      });
    }
  }

  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _checkFirst();
    super.initState();
  }

  DateTime selectedDate = DateTime.now();

  num calculateTotalPrice(num count, num roomPrice) {
    return count * roomPrice;
  }


  TextEditingController locationController = new TextEditingController();
  TextEditingController countController = new TextEditingController();
  TextEditingController roomsController = new TextEditingController();
  TextEditingController checkInController = new TextEditingController();
  TextEditingController checkOutController = new TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();

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

    num totalPrice = calculateTotalPrice(widget.count ?? 1, widget.room?.price ?? 1);
    final sb = context.watch<SignInBloc>();

    void addOrderByUser() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("BookingByUser")
            .doc("UserID:${sb.uid}")
            .collection('allBooking')
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "phone": sb.phone,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
    }

    void addOrderByItem() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("BookingByItem")
            .doc(widget.hotel?.title ?? '')
            .collection(sb.uid ?? "")
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "phone": sb.phone,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
    }

    void addOrderByItemAll() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("BookingByItem")
            .doc(widget.hotel?.title ?? '')
            .collection("order")
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "phone": sb.phone,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
    }

    void addAllOrder() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("AllBooking")
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "phone": sb.phone,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
    }

    void addDataBooking() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("Booking")
            .doc("user")
            .collection(widget.hotel?.title ?? "")
            .doc(sb.uid)
            .set({
          "Name": sb.name,
          "photoProfile": sb.photoProfile,
          "Email": sb.email,
          "user ID": sb.uid,
          "Location": widget.hotel?.location,
          // "Check In": _setCheckIn,
          // "Check Out": _setCheckOut,
          "Count": _valOccassion,
          // "Rooms": _rooms + " Rooms",
          "Title": widget.hotel?.title,
          // "Room Name": widget.roomR,
          "Information Room": widget.hotel?.description,
          "Price Room": widget.hotel?.price,
        });
      });
    }

    void userSaved() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        SharedPreferences prefs;
        prefs = await SharedPreferences.getInstance();
        FirebaseFirestore.instance
            .collection("users")
            .doc(sb.uid)
            .collection('Booking')
            .add({
          "title": widget.hotel?.title,
          "image": widget.hotel?.image,
          "price": widget.hotel?.price,
          "photo": widget.hotel?.image,
          "service": widget.hotel?.service,
          "description": widget.hotel?.description,
          "userID": sb.uid,
          // "type": widget.typeD,
          "latLang1": widget.hotel?.lat,
          "latLang2": widget.hotel?.lang,
          "rating": widget.hotel?.ratting,
          "Name": sb.name,
          "photoProfile": sb.photoProfile,
          "Email": sb.email,
          "user ID": sb.uid,
          "Location": widget.hotel?.location,
          // "Check In": _setCheckIn,
          // "Check Out": _setCheckOut,
          "Count": _valOccassion,
          // "Rooms": _rooms + " Rooms",
          // "Room Name": widget.roomR,
          // "Image Room": widget.imageR,
          // "Information Room": widget.informationR,
          // "Price Room": widget.priceR
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          ('Payment Booking'),
          style: TextStyle(
              fontFamily: "RedHat", color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: form,
          child: Stack(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(sb.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Text("Loading");
                  } else {
                    var userDocument = snapshot.data;
                  }

                  var userDocument = snapshot.data;
                  return Stack(
                    children: [
                      Container(
                        height: 310.0,
                        width: double.infinity,
                        decoration: BoxDecoration(color: accentColor),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 20.0),
                              child: Container(
                                height: 270.0,
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
                                                      widget.hotel?.title ?? "",
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
                                              widget.checkin ?? "",
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
                                              widget.checkout ?? "",
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
                                      Text(widget.room?.type ?? ""),
                                      Text(widget.room?.information ?? ""),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Price room : "),
                                              Text("\$" +
                                                  (widget.room?.price
                                                          .toString() ??
                                                      "")),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Total booking : "),
                                              Text((widget.count.toString()) +
                                                  " Days"),
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
                                                "\$" + totalPrice.toString() ??
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
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, bottom: 10),
                                    child: Text(
                                      "Select Payment Method",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "RedHat"),
                                    ),
                                  ),
                                  getVerSpace(10.h),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        totalPrice2 = totalPrice;
                                      });
                                      await makePayment();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: borderColor, width: 1.h),
                                          borderRadius:
                                              BorderRadius.circular(22.h)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 15.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              getAssetImage("stripe.png",
                                                  width: 60.h, height: 50.h),
                                              getHorSpace(10.h),
                                              getCustomFont(("Stripe"), 16.sp,
                                                  Colors.black, 1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.5.h)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  getVerSpace(20.h),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        totalPrice2 = totalPrice;
                                      });
                                      openCheckout();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: borderColor, width: 1.h),
                                          borderRadius:
                                              BorderRadius.circular(22.h)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 15.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              getAssetImage("razor.png",
                                                  width: 50.h, height: 50.h),
                                              getHorSpace(10.h),
                                              getCustomFont(("Razor Pay"),
                                                  16.sp, Colors.black, 1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.5.h)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  getVerSpace(20.h),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        totalPrice2 = totalPrice;
                                      });
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              UsePaypal(
                                                  sandboxMode: true,
                                                  clientId:
                                                      "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                                                  secretKey:
                                                      "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                                                  returnURL:
                                                      "https://samplesite.com/return",
                                                  cancelURL:
                                                      "https://samplesite.com/cancel",
                                                  transactions: [
                                                    {
                                                      "amount": {
                                                        "total": widget
                                                            .hotel?.price
                                                            .toString(),
                                                        "currency": "USD",
                                                        "details": {
                                                          "subtotal": widget
                                                              .hotel?.price
                                                              .toString(),
                                                          "shipping": '0',
                                                          "shipping_discount": 0
                                                        }
                                                      },
                                                      "description":
                                                          "The payment transaction description.",
                                                      // "payment_options": {
                                                      //   "allowed_payment_method":
                                                      //       "INSTANT_FUNDING_SOURCE"
                                                      // },
                                                      "item_list": {
                                                        "items": [
                                                          {
                                                            "name": widget
                                                                .hotel?.title
                                                                .toString(),
                                                            "quantity": 1,
                                                            "price": widget
                                                                .hotel?.price
                                                                .toString(),
                                                            "currency": "USD"
                                                          }
                                                        ],

                                                        // shipping address is not required though
                                                        "shipping_address": {
                                                          "recipient_name":
                                                              sb.name,
                                                          "line1":
                                                              "Travis County",
                                                          "line2": "",
                                                          "city": "Austin",
                                                          "country_code": "US",
                                                          "postal_code":
                                                              "73301",
                                                          "phone": "+00000000",
                                                          "state": "Texas"
                                                        },
                                                      }
                                                    }
                                                  ],
                                                  note:
                                                      ("Contact us for any questions on your order."),
                                                  onSuccess:
                                                      (Map params) async {
                                                     showDialog(
                          builder: (context) {
                            return const TicketConfirmDialog();
                          },
                          context: context);
                                 Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  (route) => false,
);

                                                    addOrderByUser();
                                                    addAllOrder();
                                                    addOrderByItem();
                                                    addOrderByItemAll();
                                                    FirebaseFirestore.instance
                                                        .runTransaction(
                                                            (transaction) async {})
                                                        .then((value) {
                                                      print(
                                                          'Data map dengan array berhasil ditambahkan ke joinwidget.hotel?.');
                                                    }).catchError((error) {
                                                      print('Error: $error');
                                                    });
       showDialog(
                          builder: (context) {
                            return const TicketConfirmDialog();
                          },
                          context: context);
                                 Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  (route) => false,
);
                                                    addOrderByUser();
                                                    addAllOrder();
                                                    addOrderByItem();
                                                    addOrderByItemAll();
                                                    print("onSuccess: $params");
                                                  },
                                                  onError: (error) {
                                                    print("onError: $error");
                                                  },
                                                  onCancel: (params) {
                                                    print('cancelled: $params');
                                                  }),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: borderColor, width: 1.h),
                                          borderRadius:
                                              BorderRadius.circular(22.h)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 15.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              getAssetImage("paypal.png",
                                                  width: 40.h, height: 40.h),
                                              getHorSpace(10.h),
                                              getCustomFont(("Paypal"), 16.sp,
                                                  Colors.black, 1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.5.h)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  getVerSpace(20.h),
                                  InkWell(
                                    onTap: () {
                                       showDialog(
                          builder: (context) {
                            return const TicketConfirmDialog();
                          },
                          context: context);
                                 Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  (route) => false,
);
                                      addOrderByUser();
                                      addAllOrder();
                                      addOrderByItem();
                                      addOrderByItemAll();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: borderColor, width: 1.h),
                                          borderRadius:
                                              BorderRadius.circular(22.h)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 15.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              getAssetImage("money.png",
                                                  width: 40.h, height: 40.h),
                                              getHorSpace(10.h),
                                              getCustomFont(
                                                  ("Cash On Delivery"),
                                                  16.sp,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.5.h)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 50.0,
                            ),

                            /// Button
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 15.0, right: 15.0, bottom: 20.0),
                            //   child: InkWell(
                            //     onTap: () async {
                            //       SharedPreferences prefs;
                            //       prefs = await SharedPreferences.getInstance();

                            //       final formState = form.currentState;
                            //       if (formState!.validate()) {
                            //         formState.save();
                            //         try {
                            //           // user.sendEmailVerification();
                            //         } catch (e) {
                            //           print('Error: $e');
                            //           CircularProgressIndicator();
                            //           print(e);
                            //           // print(_email);
                            //         } finally {
                            //           _check();

                            //           if (prefs.getString(
                            //                   widget.hotel?.title ?? "") ==
                            //               null) {
                            //             setState(() {
                            //               _book = ('bookNow');
                            //             });
                            //             Navigator.of(context)
                            //                 .pushAndRemoveUntil(
                            //                     MaterialPageRoute(
                            //                         builder: (context) =>
                            //                             HomeScreen()),
                            //                     (Route<dynamic> route) =>
                            //                         false);
                            //             // FirebaseFirestore.instance
                            //             //     .collection('room')
                            //             //     .doc(widget.listItem.id)
                            //             //     .update({
                            //             //   "quantity": FieldValue.increment(-1)
                            //             // });

                            //             addDataBooking();
                            //             userSaved();
                            //           } else {
                            //             setState(() {
                            //               _book = ('booked');
                            //             });
                            //           }
                            //         }
                            //       } else {
                            //         showDialog(
                            //             context: context,
                            //             builder: (BuildContext context) {
                            //               return AlertDialog(
                            //                 title: Text(('error')),
                            //                 content: Text(('inputInformation')),
                            //                 actions: <Widget>[
                            //                   TextButton(
                            //                     child: Text(('close')),
                            //                     onPressed: () {
                            //                       Navigator.of(context).pop();
                            //                     },
                            //                   )
                            //                 ],
                            //               );
                            //             });
                            //       }
                            //     },
                            //     child: Container(
                            //       height: 55.0,
                            //       width: double.infinity,
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(5.0)),
                            //           gradient: LinearGradient(
                            //               colors: [
                            //                 const Color(0xFF09314F),
                            //                 Color(0xFF09314F),
                            //               ],
                            //               begin:
                            //                   const FractionalOffset(0.0, 0.0),
                            //               end: const FractionalOffset(1.0, 0.0),
                            //               stops: [0.0, 1.0],
                            //               tileMode: TileMode.clamp)),
                            //       child: Center(
                            //         child: Text(
                            //           _book,
                            //           style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 19.0,
                            //               fontFamily: "RedHat",
                            //               fontWeight: FontWeight.w600),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(totalPrice2.toString(), 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(("Payment Successful!")),
                    ],
                  ),
                ));
   

        final Hotel event = widget.hotel!;
        final sb = context.watch<SignInBloc>();
       showDialog(
                          builder: (context) {
                            return const TicketConfirmDialog();
                          },
                          context: context);
                          Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  (route) => false,
);
                            
    
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
           
      FirebaseFirestore.instance
       .collection("BookingByUser")
            .doc("UserID:${sb.uid}")
            .collection('allBooking')
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });});

        FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("BookingByItem")
            .doc(widget.hotel?.title ?? '')
            .collection(sb.uid ?? "")
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
        
    FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("BookingByItem")
            .doc(widget.hotel?.title ?? '')
            .collection("order")
            .add({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });

       FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("AllBooking")
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          "checkIn": widget.checkin,
          "checkOut": widget.checkout,
          "name": sb.name,
          "photoProfile": sb.photoProfile,
          "email": sb.email,
          "userID": sb.uid,
          "informationRoom": widget.room?.information,
          "location": widget.hotel?.location,
          "price": totalPrice2,
          "statusPayment": dynamicPayment,
          "roomType": widget.room?.type,
          "image": widget.room?.image,
          "totalBooking": widget.count,
          "hotelName": widget.hotel?.title,
          "hotelId": widget.hotel?.id,
          "timeBooking": DateTime.now().millisecondsSinceEpoch,
          "dateBooking": DateTime.now().toString(),
          "hotelImage": widget.hotel?.image,
          "lang": widget.hotel?.lang,
          "lat": widget.hotel?.lat,
          "category": widget.hotel?.category,
          "description": widget.hotel?.description,
          "gallery": widget.hotel?.gallery,
          "priceHotel": widget.hotel?.price,
          "rattingHotel": widget.hotel?.ratting,
          "serviceHotel": widget.hotel?.service,
          "status": "upcoming",
          "country": widget.hotel?.country,
          "roomImage": widget.room?.image,
          "roomQuantity": widget.room?.quantity,
          "roomPrice": widget.room?.price,
          "roomGallery": widget.room?.gallery,
        });
      });
      
     
         Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  (route) => false,
);
        // Navigator.of(context).pushReplacement(PageRouteBuilder(
        //     pageBuilder: (_, __, ___) => TicketDetail(
        //           event: widget.hotel,
        //         )));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text(("Payment Failed")),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
