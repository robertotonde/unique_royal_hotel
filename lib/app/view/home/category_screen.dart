import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:pro_hotel_fullapps/app/model/hotel_model.dart';
import 'package:pro_hotel_fullapps/app/view/detail_screen_hotel/Hotel_Detail_Screen.dart';
import 'package:pro_hotel_fullapps/app/widget/empty_screen.dart';
import '../../../base/color_data.dart';

class CategoryScreenT1 extends StatefulWidget {
  String? title,desc;
  CategoryScreenT1({this.title,this.desc});

  @override
  _CategoryScreenT1State createState({title}) => _CategoryScreenT1State();
}

class _CategoryScreenT1State extends State<CategoryScreenT1> {
  int _currentSlide = 0;
  @override
  Widget build(BuildContext context) {
  String inputString = widget.title.toString();
String title = inputString.toLowerCase();
    final _recommended = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 40.0,
        ),
         Padding(
          padding: EdgeInsets.only(left: 22.0),
          child: Text(
            "Recommendation",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "RedHat",
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("hotel")
                .where('category', isEqualTo: title)
                .snapshots(),
            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const EmptyScreen();
              }
              if (snapshot.hasError) {
                return const EmptyScreen();
              }

              return snapshot.hasData
                  ? cardList(
                      list: snapshot.data?.docs,
                    )
                  : Container();
            },
          ),
          // Container(
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     primary: false,
          //     itemBuilder: (ctx, index) {
          //       return cardList(categoryArray[index]);
          //     },
          //     itemCount: categoryArray.length,
          //   ),
          // ),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
    var _appBar = PreferredSize(
      preferredSize: const Size.fromHeight(45.0),
      child: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title!,
          style: const TextStyle(color: Colors.black, fontFamily: "RedHat",fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
    );

    Future<QuerySnapshot<Map<String, dynamic>>> getCarouselData() async {
      var firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection("banner").get();
      return snapshot;
    }

    Widget _sliderImage() {
      return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getCarouselData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                snapshot.data!.docs;
            return CarouselSlider(
              options: CarouselOptions(
                height: 240,
                aspectRatio: 24 / 24,
                viewportFraction: 1.1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 200),
                autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  // _currentSlide = index;
                  setState(() {
                    _currentSlide = index;
                  });
                },
              ),
              items: data.map((item) {
                String image = item.data()['image'].toString();
                // List<String> description =
                //     List<String>.from(item.data()['description']);
                return Column(
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.of(context).push(PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) =>
                            //         BannerScreen1(image: image, desc: desc),
                            //     transitionDuration:
                            //         const Duration(milliseconds: 1000),
                            //     transitionsBuilder: (_, Animation<double> animation,
                            //         __, Widget child) {
                            //       return Opacity(
                            //         opacity: animation.value,
                            //         child: child,
                            //       );
                            //     }));
                            // Implement your desired action on item tap
                          },
                          child: Hero(
                            tag: 'hero-tagss-$image',
                            child: Material(
                              color: Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 9.0,
                                      spreadRadius: 8.0,
                                      color: Colors.black12.withOpacity(0.05),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: data.map((item) {
                              int index = data.indexOf(item);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentSlide == index
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
        ],
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              height: 292.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/564x/be/17/88/be17880995d36aed7fab5679d01faa00.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        },
      );
    }


    /// Variable Category (Sub Category)
    var _subCategory = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 0.0),
            child: Text(
              "Description",
               style: TextStyle(
                  fontFamily: "RedHat",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
            child: Text(
              widget.desc ?? '',
              style: TextStyle(
                  fontFamily: "RedHat",
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  fontSize: 16.0),
            ),
          ),
        ],
      ),
    );

   


    return Scaffold(
      appBar: _appBar,
      backgroundColor:  Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _sliderImage(),
            _subCategory,
            _recommended,
          ],
        ),
      ),
    );
  }
}

class cardList extends StatelessWidget {
  final List<DocumentSnapshot>? list;

  @override
  final _txtStyleTitle = const TextStyle(
    color: Colors.white,
    fontFamily: "RedHat",
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  final _txtStyleSub = const TextStyle(
    color: Colors.white,
    fontFamily: "RedHat",
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  cardList({this.list});

  Widget build(BuildContext context) {
    return GridView.builder(
       scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(0.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          childAspectRatio: 0.63, // Sesuaikan sesuai kebutuhan Anda
        ),
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final hotel = list?.map((e) {
            return Hotel.fromFirestore(e, 1);
          }).toList();
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: InkWell(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>   hotelDetail2(
                   hotel  : hotel?[i],
                        )));
              },
              child: Container(
                // height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.15),
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                      )
                    ]),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Hero(
                                tag: 'hero-tagss-${hotel?[i].id}' ?? '',
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  child: Container(
                                    height: 185.0,
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(7.0),
                                          topRight: Radius.circular(7.0)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            hotel![i].image ?? ""
                                               ,
                                          ),
                                          fit:  BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30.5,
                                width: 65.0,
                                decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(5.0))),
                                child: Center(
                                    child: Container(
                                      child: Text(
                                        "\$ " +(hotel?[i].price.toString() ?? ''),
                                                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "RedHat",
                                        fontWeight: FontWeight.w700),
                                                                    ),
                                    )),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 7.0)),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 15.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.8,
                              child: Text(
                                hotel?[i].title ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                    fontFamily: "RedHat",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Icon(
                                  Icons.location_on,
                                  size: 16.0,
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Container(
                              width: MediaQuery.of(context).size.width / 3.4,
                                  child: Text(
                                    hotel?[i].location ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black38,
                                        fontFamily: "RedHat",
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                  
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 14.0,
                                    ),  
                                      SizedBox(width: 4.0,),Text(
                                      hotel?[i].ratting.toString() ?? '',
                                      style: TextStyle(
                                          fontFamily: "RedHat",
                                          color: Colors.yellow.shade600,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13.0),
                                    ),
                                  ],
                                ),
                            
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ], 
                ),
              ),  ),
          );
        });
  }
}

class Card extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  String? id;
  Card({super.key, this.list, this.id});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final hotel = list?.map((e) {
            return Hotel.fromFirestore(e, 1);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('hotel')
                        .doc(list?[i].id)
                        .update({'count': FieldValue.increment(1)});

                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new hotelDetail2(
                              hotel: hotel?[i],
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
                    tag: 'hero-tagss-${hotel?[i].id}' ?? '',
                    child: Material(
                      color: const Color(0xFF1E2026),
                      child: Container(
                        height: 220.0,
                        width: 160.0,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1E2026),
                                  Color(0xFF23252E),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            image: DecorationImage(
                                image: NetworkImage(
                                  hotel?[i].image??"",
                                ),
                                fit: BoxFit.fill),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              const BoxShadow(
                                  blurRadius: 0.0, color: Colors.black87)
                            ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  hotel?[i].title ?? '',
                  style: const TextStyle(
                      fontFamily: "RedHat",
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      size: 18.0,
                      color: Colors.white12,
                    ),
                    Text(
                      hotel?[i].location ?? '',
                      style: const TextStyle(
                          fontFamily: "RedHat",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          color: Colors.white38),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.star,
                      size: 18.0,
                      color: Colors.yellow,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        hotel?[i].ratting.toString() ?? '-',
                        style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w700,
                            fontFamily: "RedHat",
                            fontSize: 13.0),
                      ),
                    ),
                    const SizedBox(
                      width: 35.0,
                    ),
                    Container(
                      height: 27.0,
                      width: 82.0,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFF975D),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Center(
                        child: Text("\$ " + (hotel?[i].price.toString() ?? '-'),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "RedHat",
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
