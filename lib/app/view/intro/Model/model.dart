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
      title: "Unique Royal Hotel and SUITES",
      subTitle: "You can book a hotel easily and quickly with unique hotel application make easier.",
      image: "assets/images/OB1.png"),
  ESModel(
      title: "Discover Place",
      subTitle: "Discover interesting places around you with unique hotel application make easier.",
      image: "assets/images/OB2.png"),
  ESModel(
      title: "Easy Find a room",
      subTitle: "Easy to find a hotel that suits your needs with unique hotel application make easier.",
      image: "assets/images/OB3.png"),
];