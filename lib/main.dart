import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/service/helper_notifications.dart';
import 'package:evente/service/notification_hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/bookmark_bloc.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/hotel_bloc.dart';
import 'package:pro_hotel_fullapps/app/view/bloc/search_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pro_hotel_fullapps/base/color_data.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/view/bloc/sign_in_bloc.dart';
import 'app/view/bloc/theme_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      "pk_test_51MkcnODzHsmg6hHDOxhHPeN6U4tJXa6IMOcFROtQDq7jXUseOUKmCxXXHt1Ktmld2dV0o1bOfwP2S1b68Zxxr7pr00PU1lElJj";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox("notifications");
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.dark
  // ));
  setupFcm();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? notifTitle, notifBody;

  String? mtoken = " ";

  @override
  void initState() {
    
    NotificationService().initFirebasePushNotification(context);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mendapatkan message di foreground!');
      print('Message data adalah : ${message.data}');
      if (message.notification != null) {
        print(
            'Message also contained a notification : ${message.notification}');
        setState(() {
          notifTitle = message.notification!.title;
          notifBody = message.notification!.body;
        });
      }
    });

    FirebaseMessaging.instance
        .getToken()
        .then((value) => {print("FCM Token Is: "), print(value)});
    // TODO: implement initState
    super.initState();
  }


  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
        child: Consumer<ThemeBloc>(builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<SignInBloc>(
                create: (context) => SignInBloc(),
              ),
              ChangeNotifierProvider<BookmarkBloc>(
                create: (context) => BookmarkBloc(),
              ),
              ChangeNotifierProvider<SearchBloc>(
                create: (context) => SearchBloc(),
              ),
            ],
            child: GetMaterialApp(
                    theme: ThemeData(
                      colorScheme:  ColorScheme.fromSeed(seedColor: accentColor),
        useMaterial3: true,
        textTheme: GoogleFonts.redHatDisplayTextTheme(),
      ),
              debugShowCheckedModeBanner: false,
              initialRoute: "/",
              // initialRoute:  "/SelectInterestScreen",

              routes: AppPages.routes,
            ),
          );
        }));
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  FirebaseMessaging.onMessage.listen((event) async {
    print("firebase Background");
    try {
      print("getLoc");
    } catch (e) {}
  });
}
