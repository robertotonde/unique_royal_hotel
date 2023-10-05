// ignore_for_file: must_be_immutable
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/BookItNow.dart';
import 'package:pro_hotel_fullapps/base/Carousel/CarouselPro.dart';

class RoomDetail extends StatefulWidget {
  
  String? checkin,checkout;
  String? type;
  String? nama;
  String? image;
  num? quantity;
  num? price;
  String? information;
  num? count;
  List? gallery;
  Hotel? hotel;

  RoomDetail(
      {
        this.checkin,
        this.checkout,
    this.count,
        this.gallery,
      this.image,
      this.information,
      this.nama,
      this.price,
      this.quantity,
      this.hotel,
      this.type});

  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Room Detail",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "RedHat",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.image ?? ""),
                      fit: BoxFit.cover)),
            ),
            //         Container(
            //           height: 270.0,
            //           width: double.infinity,
            //           child: Material(
            //             child: CarouselSlider(
            //            options: CarouselOptions(
            //           height: 270,
            //           aspectRatio: 24 / 24,
            //           viewportFraction: 0.9,
            //           initialPage: 0,
            //           enableInfiniteScroll: true,
            //           reverse: false,
            //           autoPlay: true,
            //           autoPlayInterval: const Duration(seconds: 2),
            //           autoPlayAnimationDuration: const Duration(milliseconds: 800),
            //           autoPlayCurve: Curves.fastOutSlowIn,
            //           enlargeCenterPage: true,
            //           scrollDirection: Axis.horizontal,
            //         ),
            //         items:widget.gallery!.map((imageUrl) {
            //   return Builder(
            //     builder: (BuildContext context) {
            //       return Image.network(
            //         imageUrl,
            //         fit: BoxFit.cover,
            //       );
            //     },
            //   );
            // }).toList(),
            //             )

            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.type ?? "",
                    style: TextStyle(
                        fontFamily: "RedHat",
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "\$" + widget.price.toString() ?? "",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w700,
                              fontFamily: "RedHat"),
                        ),
                        Text(('/Night'),
                            style: TextStyle(
                              color: Colors.black26,
                              fontFamily: "RedHat",
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
        SizedBox(height: 20.0,),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.black12.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15.0),
              child: Text(
                ('Detail Information'),
                style: TextStyle(
                    fontFamily: "RedHat",
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.justify,
              ),
            ),
                Padding(
              padding:
                  const EdgeInsets.only(top: 5.0, left: 0.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 15.0),
                    child: Text(
                      widget.information ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                          fontFamily: "RedHat",
                          fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    width: 35.0,
                  ),
                    

                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(left:15.0,top: 10),
                child: Text(
                              ('photos'),
                              style: TextStyle(
                                  fontFamily: "RedHat",
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.justify,
                            ),
              ),
                                 Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 0.0, right: 0.0, bottom: 40.0),
                      child: Container(
                        height: 150.0,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: widget.gallery!
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
                                                            ),
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

           
            

                 /// Button
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 10.0, top: 20.0),
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new Bookitnow(
                        count: widget.count,
                        checkin:widget.checkin,
                        checkout:widget.checkout,
                         room: Room(gallery: widget.gallery,image: widget.image,information: widget.information,nama: widget.nama,price: widget.price,quantity: widget.quantity,type: widget.type),
                         hotel: widget.hotel,
                          )));
                },
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
          ],
        ),
      ),
    );
  }
}
