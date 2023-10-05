import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:pro_hotel_fullapps/app/controller/controller.dart';
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../dialog/ticket_confirm_dialog.dart';
import '../bloc/sign_in_bloc.dart';
import '../Booking/booking_detail.dart';
import 'package:http/http.dart' as http;

import 'package:evente/evente.dart';
class BuyTicket extends StatefulWidget {
  Event? event;
  BuyTicket({Key? key, this.event}) : super(key: key);

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  void backClick() {
    Constant.backToPrev(context);
  }


  int _itemCount = 1;

  Map<String, dynamic>? paymentIntent;
  //  var prices = price?? 0
  int? prices;
  int? totalPrice;

  @override
  void initState() {
    prices = widget.event?.price ?? 0;
    totalPrice = widget.event?.price ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final Event event = widget.event!;

    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getToolBar(
          () {
            backClick();
          },
          title: getCustomFont("Buy Ticket", 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Divider(color: dividerColor, thickness: 1.h, height: 1.h),
              Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      getVerSpace(30.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: getCustomFont(
                                "Price", 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                          ),

                          getVerSpace(10.h),
                          GestureDetector(
                            onTap: () {
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.h),
                                  border: Border.all(
                                      color: borderColor, width: 1.h)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.h, vertical: 18.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // GetX<BuyTicketController>(
                                      //   builder: (controller) => getSvgImage(
                                      //       controller.select.value == 0
                                      //           ? "checkRadio.svg"
                                      //           : "uncheckRadio.svg",
                                      //       width: 24.h,
                                      //       height: 24.h),
                                      //   init: BuyTicketController(),
                                      // ),
                                      getHorSpace(10.h),
                                      getCustomFont("Ticket Price", 16.sp,
                                          Colors.black, 1,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.5.h)
                                    ],
                                  ),
                                  getCustomFont("\$ " + event.price.toString(),
                                      18.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w600,
                                      txtHeight: 1.5.h)
                                ],
                              ),
                            ),
                          ),
                          getVerSpace(20.h),
                          // GestureDetector(
                          //   onTap: () {
                          //     controller.onChange(1.obs);
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.symmetric(horizontal: 20.h),
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(22.h),
                          //         border: Border.all(color: borderColor, width: 1.h)),
                          //     padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 18.h),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             GetX<BuyTicketController>(
                          //               builder: (controller) => getSvgImage(
                          //                   controller.select.value == 1
                          //                       ? "checkRadio.svg"
                          //                       : "uncheckRadio.svg",
                          //                   width: 24.h,
                          //                   height: 24.h),
                          //               init: BuyTicketController(),
                          //             ),
                          //             getHorSpace(10.h),
                          //             getCustomFont("Economy", 16.sp, Colors.black, 1,
                          //                 fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                          //           ],
                          //         ),
                          //         getCustomFont("\$21.00", 18.sp, Colors.black, 1,
                          //             fontWeight: FontWeight.w600, txtHeight: 1.5.h)
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      getVerSpace(30.h),
                      Divider(
                        color: dividerColor,
                        thickness: 1.h,
                        height: 1.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: getCustomFont(
                                "Quantity Seat", 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                          ),
                          // getPaddingWidget(
                          //   EdgeInsets.symmetric(horizontal: 20.h),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       getCustomFont("64", 16.sp, Colors.black, 1,
                          //           fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                          //       getCustomFont("People joined", 15.sp, greyColor, 1,
                          //           fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                          //     ],
                          //   ),
                          // ),
                          getVerSpace(10.h),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: borderColor, width: 1.h),
                                borderRadius: BorderRadius.circular(22.h)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.h, vertical: 6.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: "#E8F6F6".toColor(),
                                        borderRadius:
                                            BorderRadius.circular(18.h)),
                                    height: 68.h,
                                    width: 68.h,
                                    padding: EdgeInsets.all(22.h),
                                    child: getSvgImage("minus.svg",
                                        width: 24.h, height: 24.h),
                                  ),
                                  onTap: () {
                                    if (_itemCount == 1) {
                                    } else {
                                      _itemCount--;
                                      setState(() {
                                        // totalPrice = controller.count.value * widget.price;
                                        var prices = event.price ?? 0;
                                        totalPrice = _itemCount * prices;
                                      });
                                      //  controller.countChange(controller.count.obs.value--);
                                    }
                                  },
                                ),
                                getCustomFont(_itemCount.toString(), 22.sp,
                                    Colors.black, 1,
                                    fontWeight: FontWeight.w700,
                                    txtHeight: 1.5.h),
                                GestureDetector(
                                  onTap: () {
                                    _itemCount++;
                                    // controller.countChange(controller.count.obs.value++);
                                    setState(() {
                                      var prices = event.price ?? 0;
                                      // totalPrice = controller.count.value * widget.price;
                                      totalPrice = _itemCount * prices;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: "#E8F6F6".toColor(),
                                        borderRadius:
                                            BorderRadius.circular(18.h)),
                                    height: 68.h,
                                    width: 68.h,
                                    padding: EdgeInsets.all(22.h),
                                    child: getSvgImage("add.svg",
                                        width: 24.h,
                                        height: 24.h,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),

                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("JoinEvent")
                                .doc("user")
                                .collection(event.title ?? '')
                                .snapshots(),
                            builder: (BuildContext ctx,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return snapshot.hasData
                                  ? getPaddingWidget(
                                      EdgeInsets.symmetric(
                                          horizontal: 30.h, vertical: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          getCustomFont(
                                              snapshot.data?.docs.length
                                                      .toString() ??
                                                  '',
                                              16.sp,
                                              Colors.black,
                                              1,
                                              fontWeight: FontWeight.w600,
                                              txtHeight: 1.5.h),
                                          getCustomFont(" People joined", 15.sp,
                                              greyColor, 1,
                                              fontWeight: FontWeight.w500,
                                              txtHeight: 1.5.h)
                                        ],
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomFont("Total", 22.sp, Colors.black, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        getCustomFont("\$ " + totalPrice.toString() ?? '',
                            22.sp, accentColor, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h)
                      ],
                    ),
                    getVerSpace(30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getButton(
                            context, accentColor, "Checkout COD", Colors.white,buttonWidth: MediaQuery.of(context).size.width/2.5,
                           
                           
                            () async {
                          Constant.sendToNext(context, Routes.paymentRoute);
                          showDialog(
                              builder: (context) {
                                return const TicketConfirmDialog();
                              },
                              context: context);
                          userSaved();
                          addData();

                          // // Navigator.of(context).push(PageRouteBuilder(
                          // //     pageBuilder: (_, __, ___) => TicketDetail(
                          // //           event: widget.event,
                          //         )));
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                        getVerSpace(30.h),
                        getButton(
                            context, accentColor, "Checkout Stripe", Colors.white,buttonWidth: MediaQuery.of(context).size.width/2.5,
                            () async {
                          await makePayment();
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                        getVerSpace(30.h),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void userSaved() {
    final SignInBloc sb = context.read<SignInBloc>();
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      FirebaseFirestore.instance
          .collection("users")
          .doc(sb.uid)
          .collection('Join Event')
          .add({
        "uid": sb.uid,
        "user": sb.name,
        "category": widget.event?.category,
        "date": widget.event?.date,
        "description": widget.event?.description,
        "id": widget.event?.id,
        "image": widget.event?.image,
        "location": widget.event?.location,
        "mapsLangLink": widget.event?.mapsLangLink,
        "mapsLatLink": widget.event?.mapsLatLink,
        "price": totalPrice,
        "title": widget.event?.title,
        "type": widget.event?.type,
        "userDesc": widget.event?.userDesc,
        "userName": widget.event?.userName,
        "userProfile": widget.event?.userProfile,
        "ticket": _itemCount
      });
    });
    Navigator.pop(context);
  }

  void addData() {
    final SignInBloc sb = context.read<SignInBloc>();
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      FirebaseFirestore.instance
          .collection("JoinEvent")
          .doc("user")
          .collection(widget.event?.title ?? '')
          .doc(sb.uid)
          .set({"name": sb.name, "uid": sb.uid, "photoProfile": sb.imageUrl});
    });
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(totalPrice.toString(), 'USD');

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
        Constant.sendToNext(context, Routes.paymentRoute);
        showDialog(
            builder: (context) {
              return const TicketConfirmDialog();
            },
            context: context);
        userSaved();
        addData();

        // Navigator.of(context).push(PageRouteBuilder(
        //     pageBuilder: (_, __, ___) => TicketDetail(
        //           event: widget.event,
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
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
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
