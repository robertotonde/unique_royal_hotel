import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro_hotel_fullapps/app/data/data_file.dart' as cs;
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:pro_hotel_fullapps/base/pref_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/sign_in_bloc.dart';
import 'package:evente/evente.dart';

class SelectInterestScreen extends StatefulWidget {
  const SelectInterestScreen({Key? key}) : super(key: key);

  @override
  State<SelectInterestScreen> createState() => _SelectInterestScreenState();
}

class _SelectInterestScreenState extends State<SelectInterestScreen> {
  void backClick() {
    Constant.sendToNext(context, Routes.loginRoute);
  }

  List<ModalSelectInterest> selectIntersetList =  [
    
    ModalSelectInterest("assets/images/destination1.jpg", "Museum", "#FDEEEC", false),
    ModalSelectInterest("assets/images/destination5.jpg", "Park", "#FDEEEC", false),
    ModalSelectInterest("assets/images/populer2.png", "Beach", "#FDEEEC", false),
    ModalSelectInterest("assets/images/destination4.jpg", "Mountain", "#FDEEEC", false),
    ModalSelectInterest("assets/images/hotel.png", "Hotel", "#FDEEEC", false),
    ModalSelectInterest("assets/images/experience.png", "Experience", "#FDEEEC", false),
    ];



  final _multiSelectKey = GlobalKey<FormFieldState>();

  List<String> _selectedInterest = [];

  Future addDataInterest(List v) async {
    final BookmarkBloc sb = Provider.of<BookmarkBloc>(context, listen: false);
    sb.saveDataToSP(v);
    sb.saveInterestToFirebase(v);

    Constant.sendToNext(context, Routes.homeScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkBloc sb = Provider.of<BookmarkBloc>(context, listen: false);

    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: getToolBar(
          () {
            backClick();
          },
          title: getCustomFont("", 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        ),
        body: SafeArea(
          child: Column(
            children: [
           
              getVerSpace(0.h),
              getPaddingWidget(
                EdgeInsets.only(left: 30.h),
                Text("Please choose your favorite destination to get the best experience",style: 
                TextStyle(
                  fontSize:  27.5.sp,
               color:    Colors.black,
                    fontWeight: FontWeight.w700,
                    height: 1.6.h,
                    wordSpacing: 1.0,
                    letterSpacing: 0.5,
                    fontFamily: "RedHat"
                ),
                
                ),
              ),
              getVerSpace(40.h),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(34.h)),
                        boxShadow: [
                          BoxShadow(
                              color: "#2B9CC3C6".toColor(),
                              blurRadius: 24,
                              offset: const Offset(0, -2))
                        ]),
                    child: Column(
                      children: [
                        getVerSpace(20.h),
                        Expanded(
                          flex: 1,
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            itemCount: selectIntersetList.length,
                            itemBuilder: (context, index) {
                              ModalSelectInterest modalSelect =
                                  selectIntersetList[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (modalSelect.select == true) {
                                      modalSelect.select = false;
                                      _selectedInterest
                                          .remove(modalSelect.name!);
                                    } else {
                                      modalSelect.select = true;
                                      _selectedInterest.add(modalSelect.name!);
                                    }
                                  });
                                  print("$index : $_selectedInterest");
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    SizedBox(
                                      height: 153.h,
                                      width: double.infinity,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                 modalSelect.image??"" ,
                                                ),
                                                fit: BoxFit.cover),
                                            color: modalSelect.color!.toColor(),
                                            borderRadius:
                                                BorderRadius.circular(22.h),
                                            border: modalSelect.select == true
                                                ? Border.all(
                                                    color: accentColor,
                                                    width: 2.h)
                                                : null),
                                        height: 153.h,
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        height: 42.h,
                                        decoration: BoxDecoration(
                                          color: modalSelect.select == true
                                              ? accentColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          boxShadow: [
                                            BoxShadow(
                                                color: "#2690B7B9".toColor(),
                                                offset: const Offset(0, 8),
                                                blurRadius: 27)
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: getCustomFont(
                                            modalSelect.name ?? '',
                                            15.sp,
                                            modalSelect.select == true
                                                ? Colors.white
                                                : Colors.black,
                                            1,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                            
                                  ],
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 163.h,
                                    crossAxisSpacing: 19.h,
                                    mainAxisSpacing: 20.h),
                          ),
                        ),
                     SizedBox(height: 10.0,),
                        getPaddingWidget(
                          EdgeInsets.symmetric(horizontal: 20.h),
                          getButton(
                              context, accentColor, "Continue", Colors.white,
                              () async {
                            addDataInterest(_selectedInterest);

                            context.read<SignInBloc>().checkSignIn();
                          }, 18.sp,
                              weight: FontWeight.w700,
                              buttonHeight: 60.h,
                              borderRadius: BorderRadius.circular(22.h)),
                        ),
                        getVerSpace(10.h)
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
