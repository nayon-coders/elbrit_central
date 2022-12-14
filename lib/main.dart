import 'package:elbrit_central/views/home.dart';
import 'package:elbrit_central/views/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'notificationservice/local_notification_service.dart';

var datosusuario;
var datosusuarioPhone;
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //check daily login
  bool? validDayLogin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logOut();
  }

  logOut()async{
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    var saveDay = prefs.getString("daily_login");
    var currentDay = DateTime.now().day;
    print(currentDay);
    print(saveDay);
    if (currentDay.toString() != saveDay) {
      setState(()=>validDayLogin = false);
    }else {
      await prefs.remove('phone');
      setState(()=>validDayLogin = true);
    }

  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: validDayLogin == false ? LogInPage() : HomePage(),
      // home: HomePage(),
    );
  }
}

//keytool -list -v -keystore C:/Users/ASUS/upload-keystore.jks -alias upload
