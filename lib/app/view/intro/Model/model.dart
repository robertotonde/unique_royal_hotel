import 'package:flutter/material.dart';


class ESModel {
  String? title;
  String? subTitle;
  String? image;
  IconData? icon;
  bool? isCheckList;
  Color? color;

  ESModel({this.title, this.subTitle, this.image, this.color, this.isCheckList = false, this.icon});
}

List<ESModel> esWalkThroughList = [
  ESModel(
      title: "Booking Hotel",
      subTitle: "You can book a hotel easily and quickly with Tracvel application make easier.",
      image: "assets/images/OB1.png"),
  ESModel(
      title: "Discover Place",
      subTitle: "Discover interesting places around you with Tracvel application make easier.",
      image: "assets/images/OB2.png"),
  ESModel(
      title: "Easy Find Hotel",
      subTitle: "Easy to find a hotel that suits your needs with Tracvel application make easier.",
      image: "assets/images/OB3.png"),
];