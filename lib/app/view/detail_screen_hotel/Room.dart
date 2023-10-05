import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/sign_in_bloc.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/RoomDetail.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:provider/provider.dart';

class RoomScreen extends StatefulWidget {
  List<Room>? room;
  String? checkin,checkout;
  num? count;
  Hotel? hotel;
   RoomScreen({
    this.checkin,
    this.checkout,
    this.hotel,
    this.count,
   this.room,
  });

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {

    final sb = context.watch<SignInBloc>();

    var _appBar = PreferredSize(
      preferredSize: Size.fromHeight(45.0),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(('Choose Room'),
            style: TextStyle(
                fontFamily: "RedHat",
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ),
    );

    var _recommended = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        cardList(
          checkin: widget.checkin,
          checkout: widget.checkout,
          hotel: widget.hotel,
                              room: widget.room,
                              count: widget.count,
                              
                     
                    )
      
      
      ],
    );


    return  Scaffold(
        appBar: _appBar,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Recommended
              _recommended,
            ],
          ),
        ),
      
    );
  }
}

// ignore: must_be_immutable
class cardList extends StatelessWidget {


  String? checkin,checkout;
 List<Room>? room;
 Hotel? hotel;
 num? count;


  var _txtStyleTitle = TextStyle(
    color: Colors.black87,
    fontFamily: "RedHat",
    fontSize: 19.0,
    fontWeight: FontWeight.w800,
  );

  var _txtStyleSub = TextStyle(
    color: Colors.black26,
    fontFamily: "RedHat",
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  cardList({
    this.checkin,
    this.checkout,
    this.hotel,
   this.room,
   this.count
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: room?.length,
        itemBuilder: (context, i) {
          // final Hotels = room?.map((e) {
          //   return Hotel.fromFirestore(e, 1);
          // }).toList();
          
    String? price =  room?[i].price.toString();

    num quantity = room?[i].quantity??0;
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: 
           
            Stack(
              children: [
                 if( quantity<1)  Stack(
                   children: [
                     Container(
                       height: 220.0,
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
                           tag: 'hero-tag-${room?[i].image??""}',
                           child: Material(
                             child: Stack(
                               children: [
                                 Container(
                                   height: 135.0,
                                   width: double.infinity,
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.only(
                                         topRight: Radius.circular(10.0),
                                         topLeft: Radius.circular(10.0)),
                                     image: DecorationImage(
                                         image: NetworkImage(
                                          room?[i].image??"",
                                         ), fit: BoxFit.cover),
                                   ),
                                   alignment: Alignment.topRight,
                                 ),
                                  if( quantity>1)     Align(
                                   alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:10.0,right: 10.0),
                                      child: Container(
                                                 child: Container(
                                                   height: 36.0,
                                                   width: 96.0,
                                                   decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.all(Radius.circular(40)),
                                                     color: accentColor
                                                   ),
                                                   child: Center(
                                                     child: Row(
                                                       mainAxisAlignment: MainAxisAlignment.center,
                                                       children: [
                                                         //   Text(
                                                         //   "Available : ",
                                                         //   style: _txtStyleSub.copyWith(color: Colors.white),
                                                         //   overflow: TextOverflow.ellipsis,
                                                         // ),
                                                         Text(
                                                           room![i].quantity.toString() + " Rooms",
                                                           style: _txtStyleSub.copyWith(color: Colors.white),
                                                           overflow: TextOverflow.ellipsis,
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 )),
                                    ),
                                  ),
                               ],
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
                                         width: 220.0,
                                         child: Text(
                                           room?[i].type??"",
                                           style: _txtStyleTitle,
                                           overflow: TextOverflow.ellipsis,
                                         )),
                           SizedBox(height: 2.0,),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Container(
                                             width: MediaQuery.of(context).size.width-120,
                                             child: Text(
                                               room?[i].information??"",
                                               style: _txtStyleSub,
                                               overflow: TextOverflow.ellipsis,
                                             )),
                                             SizedBox(height: 0.0,),
                                    if( quantity<1)  Container(
                                             width: MediaQuery.of(context).size.width-120,
                                             child: Row(
                                               children: [
                                                   Text(
                                                   "Not Have Available Room ",
                                                   style: _txtStyleSub,
                                                   overflow: TextOverflow.ellipsis,
                                                 ),
                                               
                                               ],
                                             )),  
                                    
                                 
                                       ],
                                     ),
                     
                     
                                     Padding(padding: EdgeInsets.only(top: 5.0)),
                                   ],
                                 ),
                               ),
                               Padding(
                                 padding:  EdgeInsets.only(right: 13.0.w),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: <Widget>[
                                     Text(
                                       "\$" +  price!,
                                       style: TextStyle(
                                           fontSize: 25.0.sp,
                                           color: Colors.blueAccent,
                                           fontWeight: FontWeight.w700,
                                           fontFamily: "RedHat"),
                                     ),
                                     Text(('/Night'),
                                         style: _txtStyleSub.copyWith(fontSize: 11.0.sp))
                                   ],
                                 ),
                               ),
                             ],
                           ),
                         )
                       ]),
                     ),

                      Container(
                       height: 220.0,
                       decoration: BoxDecoration(
                           color: Colors.black12,
                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
                           boxShadow: [
                             BoxShadow(
                                 color: Colors.black12.withOpacity(0.1),
                                 blurRadius: 3.0,
                                 spreadRadius: 1.0)
                           ]),
                           child: Center(
                            child: Text("Room Not Available",style: TextStyle(
                              fontFamily: "RedHat",
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700
                              
                            ),),
                           ),
                           ),
                           
                   ],
                 ),
           
                if( quantity>0) InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new RoomDetail(   
                          checkin:checkin,
                          count: count,
                          checkout:checkout,
                          hotel: hotel,
                          gallery:  room?[i].gallery, 
                          image:  room?[i].image,
                          information:  room?[i].information,
                          nama:  room?[i].nama,
                          price:  room?[i].price,
                          quantity:  room?[i].quantity,
                          type:  room?[i].type,           
                            ),
                        transitionDuration: Duration(milliseconds: 600),
                        transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return Opacity(
                            opacity: animation.value,
                            child: child,
                          );
                        }));
                  },
                  child: Container(
                    height: 210.0,
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
                        tag: 'hero-tag-${room?[i].image??""}',
                        child: Material(
                          child: Stack(
                            children: [
                              Container(
                                height: 135.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                       room?[i].image??"",
                                      ), fit: BoxFit.cover),
                                ),
                                alignment: Alignment.topRight,
                              ),
                               if( quantity>1)     Align(
                                alignment: Alignment.topRight,
                                 child: Padding(
                                   padding: const EdgeInsets.only(top:10.0,right: 10.0),
                                  //  child: Container(
                                  //             child: Container(
                                  //               height: 36.0,
                                  //               width: 96.0,
                                  //               decoration: BoxDecoration(
                                  //                 borderRadius: BorderRadius.all(Radius.circular(40)),
                                  //                 color: accentColor
                                  //               ),
                                  //               child: Center(
                                  //                 child: Row(
                                  //                   mainAxisAlignment: MainAxisAlignment.center,
                                  //                   children: [
                                  //                     //   Text(
                                  //                     //   "Available : ",
                                  //                     //   style: _txtStyleSub.copyWith(color: Colors.white),
                                  //                     //   overflow: TextOverflow.ellipsis,
                                  //                     // ),
                                  //                     Text(
                                  //                       room![i].quantity.toString() + " Rooms",
                                  //                       style: _txtStyleSub.copyWith(color: Colors.white),
                                  //                       overflow: TextOverflow.ellipsis,
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             )),
                        
                                 ),
                               ),
                            ],
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
                                      width: 220.0,
                                      child: Text(
                                        room?[i].type??"",
                                        style: _txtStyleTitle,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                        SizedBox(height: 2.0,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width-120,
                                          child: Text(
                                            room?[i].information??"",
                                            style: _txtStyleSub,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                          SizedBox(height: 0.0,),
                                 if( quantity<1)  Container(
                                          width: MediaQuery.of(context).size.width-120,
                                          child: Row(
                                            children: [
                                                Text(
                                                "Not Have Available Room ",
                                                style: _txtStyleSub,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            
                                            ],
                                          )),  
                                 
                              
                                    ],
                                  ),


                                  Padding(padding: EdgeInsets.only(top: 5.0)),
                                ],
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(right: 13.0.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "\$" +  price!,
                                    style: TextStyle(
                                        fontSize: 25.0.sp,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "RedHat"),
                                  ),
                                  Text(('/Night'),
                                      style: _txtStyleSub.copyWith(fontSize: 11.0.sp))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
