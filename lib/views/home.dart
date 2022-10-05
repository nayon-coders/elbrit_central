import 'package:elbrit_central/views/notification.dart';
import 'package:elbrit_central/views/price_list.dart';
import 'package:elbrit_central/views/products.dart';
import 'package:elbrit_central/views/wall.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get/get.dart';
import '../notificationservice/local_notification_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    WallPage(),
    ProductPage(),
    PriceListPage(),
    NotificationPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // // 1. This method call when app in terminated state and you get a notification
      // // when you click on notification app open from terminated state and you can get notification data in this method
      // FirebaseMessaging.instance.getInitialMessage().then(
      //       (message) {
      //     print("FirebaseMessaging.instance.getInitialMessage");
      //     if (message != null) {
      //       print("New Notification");
      //       // if (message.data['_id'] != null) {
      //       //   Navigator.of(context).push(
      //       //     MaterialPageRoute(
      //       //       builder: (context) => DemoScreen(
      //       //         id: message.data['_id'],
      //       //       ),
      //       //     ),
      //       //   );
      //       // }
      //     }
      //   },
      // );
      FirebaseMessaging.instance.getInitialMessage();
      // 2. This method only call when App in foreground it mean app must be opened
      FirebaseMessaging.onMessage.listen(
            (message) {
          print("FirebaseMessaging.onMessage.listen =========== $message");
          if (message.notification != null) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("message.data11 ${message.data}");
             LocalNotificationService.createanddisplaynotification(message);
          }
        },
      );

      // 3. This method only call when App in background and not terminated(not closed)
      FirebaseMessaging.onMessageOpenedApp.listen(
            (message) {
          print("FirebaseMessaging.onMessageOpenedApp.listen");
          if (message.notification != null) {
            print(message.notification!.title);
            print(message.notification!.body);
            //print("message.data22 ${message.data['_id']}");
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/Vector-7.png',
              scale: 1.3,
            ),
            label: 'Wall',
// backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/Vector-8.png',
              scale: 1.3,
            ),
            label: 'Products',
// backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/Vector-9.png',
              scale: 1.3,
            ),
            label: 'Pricelist',
// backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/Vector-10.png',
            ),
            label: 'Notification',
// backgroundColor: Colors.pink,
          ),
        ],
      ),

    );
  }

  void checkNotificationIsSet() async{

    Get.defaultDialog(
      title: "This app went to send you notification.",
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text("This app want to send you Notification."),
              SizedBox(height: 5,),
              Divider(height: 1, color: Colors.grey.shade300,),
              SizedBox(height: 5,),
              TextButton(
                onPressed: ()=>Navigator.pop(context),
                child: const Text("Allow"),
              ),
            ],
          ),
        ),
      )
    );
  }
}
//
// items: <BottomNavigationBarItem>[
// BottomNavigationBarItem(
// icon: Image.asset(
// 'images/Vector-7.png',
// scale: 1.3,
// ),
// label: 'Wall',
// // backgroundColor: Colors.white,
// ),
// BottomNavigationBarItem(
// icon: Image.asset(
// 'images/Vector-8.png',
// scale: 1.3,
// ),
// label: 'Products',
// // backgroundColor: Colors.black,
// ),
// BottomNavigationBarItem(
// icon: Image.asset(
// 'images/Vector-9.png',
// scale: 1.3,
// ),
// label: 'Pricelist',
// // backgroundColor: Colors.purple,
// ),
// BottomNavigationBarItem(
// icon: Image.asset(
// 'images/Vector-10.png',
// ),
// label: 'Notification',
// // backgroundColor: Colors.pink,
// ),
// ],
// onTap: _onItemTapped,
