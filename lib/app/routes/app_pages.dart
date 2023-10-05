
import 'package:pro_hotel_fullapps/app/view/featured_event/buy_ticket.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/feature_event_list.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/featured_event_detail.dart';
import 'package:pro_hotel_fullapps/app/view/featured_event/payment.dart';
import 'package:pro_hotel_fullapps/app/view/home/home_screen.dart';
import 'package:pro_hotel_fullapps/app/view/intro/intro.dart';
import 'package:pro_hotel_fullapps/app/view/login/forgot_password.dart';
import 'package:pro_hotel_fullapps/app/view/login/reset_password.dart';
import 'package:pro_hotel_fullapps/app/view/my_card/edit_card_screen.dart';
import 'package:pro_hotel_fullapps/app/view/my_card/my_card_screen.dart';
import 'package:pro_hotel_fullapps/app/view/notification/notification_screen.dart';
import 'package:pro_hotel_fullapps/app/view/profile/edit_profile.dart';
import 'package:pro_hotel_fullapps/app/view/select_interset/select_interest_screen.dart';
import 'package:pro_hotel_fullapps/app/view/setting/help_screen.dart';
import 'package:pro_hotel_fullapps/app/view/setting/privacy_screen.dart';
import 'package:pro_hotel_fullapps/app/view/setting/setting_screen.dart';
import 'package:pro_hotel_fullapps/app/view/signup/select_country_screen.dart';
import 'package:pro_hotel_fullapps/app/view/signup/signup_screen.dart';
import 'package:pro_hotel_fullapps/app/view/signup/verify_screen.dart';
import 'package:pro_hotel_fullapps/app/view/splash_screen.dart';
import 'package:pro_hotel_fullapps/app/view/Booking/booking_detail.dart';
import 'package:pro_hotel_fullapps/app/view/trending/trending_screen.dart';
import 'package:flutter/material.dart';

import '../view/login/login_screen.dart';

import '../view/popular_event/popular_event_list.dart';
import 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.homeRoute: (context) => const SplashScreen(),
    Routes.introRoute: (context) => const OnBoardingScreen(),
    Routes.loginRoute: (context) => const LoginScreen(),
    Routes.homeScreenRoute: (context) => const HomeScreen(),
    Routes.forgotPasswordRoute: (context) => const ForgotPassword(),
    Routes.resetPasswordRoute: (context) => const ResetPassword(),
    Routes.signUpRoute: (context) => const SignUpScreen(),
    Routes.selectCountryRoute: (context) => const SelectCountryScreen(),
    // Routes.verifyRoute: (context) => const VerifyScreen(),
    Routes.selectInterestRoute: (context) => const SelectInterestScreen(),
    Routes.trendingScreenRoute: (context) => const TrendingScreen(),
    // Routes.featuredEventDetailRoute: (context) =>  FeaturedEventDetail(),

    Routes.paymentRoute: (context) => const PaymentScreen(),
    // Routes.createEventRoute: (context) => const CreateEventScreen(),
    // Routes.ticketDetailRoute: (context) =>  TicketDetail(),
    Routes.settingRoute: (context) => const SettingScreen(),
    Routes.editProfileRoute: (context) => const EditProfile(),
    Routes.notificationScreenRoute: (context) => const NotificationScreen(),
    Routes.editCardScreenRoute: (context) => const EditCardScreen(),
    Routes.privacyScreenRoute: (context) => const PrivacyScreen(),
    Routes.helpScreenRoute: (context) => const HelpScreen(),
    Routes.featureEventListRoute: (context) => const FeatureEventList(),
    Routes.popularEventListRoute: (context) => const PopularEventList()
  };
}
