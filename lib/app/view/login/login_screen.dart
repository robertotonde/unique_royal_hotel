import 'package:permission_handler/permission_handler.dart';
import 'package:pro_hotel_fullapps/app/controller/controller.dart' as cs;
import 'package:pro_hotel_fullapps/app/routes/app_routes.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../base/constant.dart';
import '../../../base/pref_data.dart';
import '../../../base/widget_utils.dart';
import '../../dialog/snacbar.dart';
import 'package:evente/evente.dart';
import '../bloc/sign_in_bloc.dart';
import '../select_interset/select_interest_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void backClick() {
    Constant.closeApp();
  }

  LoginController controlller = Get.put(LoginController());

  final formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  
  late String email;
  late String pass;
  // Icon lockIcon = LockIcon().lock;
  bool offsecureText = true;

  handleSignInwithemailPassword () async{
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false );
    if (formKey.currentState!.validate()){
      formKey.currentState!.save();
      await AppService().checkInternet().then((hasInternet){
        if(hasInternet == false){
          openSnacbar(_scaffoldKey, 'no internet');
        }else{
          setState(() {
            signInStart = true;
          });
          sb.signInwithEmailPassword(email, pass).then((_)async{
            if(sb.hasError == false){
              
              sb.getUserDatafromFirebase(sb.uid)
              .then((value) => sb.guestSignout())
              .then((value) => sb.saveDataToSP()
              .then((value) => sb.setSignIn()
              .then((value){
                setState(() {
                  // signInComplete = true;
                });
                
              Constant.sendToNext(
                                context, Routes.homeScreenRoute);
              })));
            } else{
                _btnController.reset();
               ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Failed Login Please Check Your Mail and Password!',
              textAlign: TextAlign.center,
            ),
          ),
        );
              setState(() {
                signInStart = false;
              });
              openSnacbar(_scaffoldKey, sb.errorCode);
            
            }
          }); 
        }
      });
    }
     else{
              _btnController.reset();}
  }


  
  Future<void> requestLocationPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasPermission = prefs.getBool('hasLocationPermission') ?? false;

    if (hasPermission == false) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Container(
                  color: Colors.white,
                  height: 480,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/location.gif',
                        width: double.infinity,
                        height: 200.0,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Location Permission",
                        style: TextStyle(
                            fontSize: 16 + 1,
                            fontWeight: FontWeight.w800,
                            fontFamily: "RedHat"),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "This app collects location data to enable access location to allow location for show near hotel, when the app is closed not in use.",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black26,
                            fontFamily: "RedHat"),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                              ),
                              onPressed: () async {
                                await Permission.location.request();
                                prefs.setBool('hasLocationPermission', true);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
    }
  }



  final _btnController = new RoundedLoadingButtonController();
  void lockPressed (){
    if(offsecureText == true){
      setState(() {
        offsecureText = false;
        // lockIcon = LockIcon().open;
        
      });
    } else {
      setState(() {
        offsecureText = true;
        // lockIcon = LockIcon().lock;

      });
    }
  }

  
  bool signInStart = false;
  @override
  Widget build(BuildContext context) {

    
    setStatusBarColor(Colors.white);
    
    return WillPopScope(
        child: Scaffold(
        key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: getToolBar(
            () {
              backClick();
            },
          ),
          body: Form(
            key: formKey,
            child: SafeArea(
              child: Column(
                
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  getVerSpace(50.h),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     getCustomFont("Sign In", 32.sp, Colors.black, 1,
                        fontWeight: FontWeight.w900,
                        fontFamily: "RedHat",
                        textAlign: TextAlign.center,
                        txtHeight: 1.5.h),
                    getVerSpace(8.h),
                    getMultilineCustomFont(
                        "Sign in to continue to your account.",
                        16.sp,
                        Colors.black,
                        txtHeight: 1.5.h,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
               
                  getVerSpace(78.h),
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            getVerSpace(30.h),
                              getCustomFont("Email", 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600),
                            getVerSpace(20.h),
                              
                  TextFormField(
                     style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            fontFamily: Constant.fontsFamily),
        decoration: InputDecoration(
             hintText: 'username@mail.com',
                      labelText: 'Enter Email',
            counter: Container(),
            contentPadding: EdgeInsets.symmetric(
                vertical: 20, horizontal: 20),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: borderColor, width: 1.h)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: borderColor, width: 1.h)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: accentColor, width: 1.h)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: errorColor, width: 1.h)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: errorColor, width: 1.h)),
            errorStyle: TextStyle(
                color: Colors.red,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.5.h,
                fontFamily: Constant.fontsFamily),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: borderColor, width: 1.h)),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 24.h,
            ),
          
            hintStyle: TextStyle(
                color: greyColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                fontFamily: Constant.fontsFamily)),
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value){
                      if (value!.isEmpty) return "Email can't be empty";
                      return null;
                    },
                    onChanged: (String value){
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                     getCustomFont("Password", 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600),
                         
                  SizedBox(height: 20,),
                  
                  TextFormField(
                     style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            fontFamily: Constant.fontsFamily),
            
        decoration: InputDecoration(
            counter: Container(),
            contentPadding: EdgeInsets.symmetric(
                vertical: 20.0, horizontal: 20.0),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: borderColor, width: 1.h)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: borderColor, width: 1.h)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: accentColor, width: 1.h)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: errorColor, width: 1.h)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: errorColor, width: 1.h)),
            errorStyle: TextStyle(
                color: Colors.red,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.5.h,
                fontFamily: Constant.fontsFamily),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.h),
                borderSide: BorderSide(color: borderColor, width: 1.h)),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 24.h,
            ),
            suffixIcon:  GestureDetector(
                    onTap: () {
                       lockPressed();
                    },
                    child: getPaddingWidget(
                      EdgeInsets.only(right: 18.h),
                      getSvgImage("show.svg".toString(),
                        width: 24.h, height: 24.h),
                    )),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 12.h,
            ),
            hintText: "Enter Password",
         ),
                    obscureText: offsecureText,
                    controller: passCtrl,
                    validator: (String? value){
                      if (value!.isEmpty) return "Password can't be empty";
                      return null;
                    },
                    onChanged: (String value){
                      setState(() {
                        pass = value;
                      });
                    },
                  ),
                  
                             getVerSpace(24.h),
                            GestureDetector(
                              onTap: () {
                                Constant.sendToNext(
                                    context, Routes.forgotPasswordRoute);
                              },
                              child: getCustomFont(
                                  "Forgot Password?", 14.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end),
                            ),
                            getVerSpace(36.h),
                               RoundedLoadingButton(
                    animateOnTap: true,
                    successColor: accentColor,
                    controller: _btnController,
                    onPressed: () {
                     handleSignInwithemailPassword();
                    },
                    width: MediaQuery.of(context).size.width * 1.0,
                    color:accentColor,
                    elevation: 0,
                    child: Wrap(
                      children: const [  Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                             Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    child: getRichText(
                                        "If you are new / ",
                                        Colors.black,
                                        FontWeight.w500,
                                        15.sp,
                                        "Create New Account",
                                        Colors.black,
                                        FontWeight.w700,
                                        14.sp),
                                    onTap: () {
                                      Constant.sendToNext(
                                          context, Routes.signUpRoute);
                                    },
                                  ),
                                  getVerSpace(38.h)
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          backClick();
          return false;
        });
  }
  

}
