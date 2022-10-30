import 'dart:isolate';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elbrit_central/components/button.dart';
import 'package:elbrit_central/models/employee_info.dart';
import 'package:elbrit_central/services/api.dart';
import 'package:elbrit_central/views/home.dart';

import 'package:elbrit_central/views/log_in_otp.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:elbrit_central/main.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  // EmployeeModel? employeeModel;
  String? deviceTokenToSendPushNotification;
  @override
  void initState() {
    super.initState();
    // check_if_already_login();
    // getEmployeeInfo();

    _Controller.text = "+91";

    getDeviceTokenToSendNotification();

  }


  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

  final TextEditingController _Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        // resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Stack(
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: const Color(0xffF8FAFC),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xffFFFFFF),
                          ),
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            'images/logo.png',
                            scale: 1.2,
                          )),
                    ),
                    // GradientText(
                    //   'Elbrit Central',
                    //   style: const TextStyle(
                    //     fontSize: 40.0,
                    //   ),
                    //   colors: const [
                    //     Color(0xff09A9ED),
                    //     Color(0xfffC55AE),
                    //     Color(0xfff4435EC)
                    //   ],
                    // ),
                    //
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 300,
                  decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Enter Your",
                            style: GoogleFonts.roboto(
                                color: const Color(0xff191919), fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            "Phone Number",
                            style: GoogleFonts.roboto(
                                color: const Color(0xff191919),
                                fontSize: 22,
                                height: 0.8),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'We will send OTP to your phone',
                            style: GoogleFonts.roboto(
                                color: const Color(0xff8394AA),
                                fontSize: 16,
                                height: 3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Container(
                            height: 50,
                            width: 328,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xffEFF3F8),
                            ),
                            child: TextField(
                              controller: _Controller,
                              keyboardType: TextInputType.phone,
                              obscureText: false,
                              decoration: InputDecoration(
                                focusColor: const Color(0xffEFF3F8),
                                icon: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: const Color(0xffFFFFFF),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                        'images/Vector-2.png',
                                        scale: 1.2,
                                      )),
                                ),
                                hintText: "Mobile Number",
                                enabledBorder: const OutlineInputBorder(
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Color(0xffEFF3F8),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Color(0xffEFF3F8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Visibility(

                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: GestureDetector(
                              onTap: () => sendOTP(),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xff0DA7ED)),
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 10, bottom: 10),
                                padding: const EdgeInsets.only(top: 13, bottom: 13),
                                alignment: Alignment.center,
                                child: isLoading ? CircularProgressIndicator()
                                    : Text(
                                    "Send OTP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 10),
              //     child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(6),
              //           color: const Color(0xffFFFFFF),
              //         ),
              //         height: 200,
              //         width: 200,
              //         child: Image.asset(
              //           'images/logo.png',
              //           scale: 1.2,
              //         )),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  //send otp
sendOTP()async{
  setState(() {
    isLoading = true;
  });
  FocusScope.of(context).unfocus();
  final EmployeeModel? employeeModel = await Api()
      .getEmployeeData(
      mobileNo: _Controller.text);

  print(employeeModel!.name);
  final localDatabase = await SharedPreferences.getInstance();
  var user_id =  employeeModel!.id.toString();
  var userID = localDatabase.setString("userId", employeeModel!.id.toString());
  print("User id: ${employeeModel!.id}");
  print(
      ">>>>>>>>>>>>>>ok got it<<<<<<<<<<<<<<<<<<<");

  //  initOneSignal(context, employeeModel!.id);


  if (employeeModel != null) {
    //send devide token
    if (deviceTokenToSendPushNotification != null) {
      print("deviceTokenToSendPushNotification code ================= $deviceTokenToSendPushNotification");
      var response = await Api().sendDeviceToken(
        player_id: deviceTokenToSendPushNotification!,
        user_id: user_id,
      );
      print("Status code ================= ${response.statusCode}");
      print("Body code ================= ${response.body}");

      if (response.statusCode == 200) {
        print("Send device token Success ====================== $deviceTokenToSendPushNotification");
        //========================================//
        localDatabase.setString("teamID", employeeModel.team!.id.toString());
        localDatabase.setString("phone", _Controller.text.toString());
        localDatabase.setInt("device_token", 1);
        //localDatabase.setString("daily_login", "1");
        //datosusuarioPhone = _Controller.text;
        //GlobalData().setId(employeeModel.team!.id);
        print("Team ID" + employeeModel.team!.id.toString());
        print(">>>>>>>>>>>>>>ok got it<<<<<<<<<<<<<<<<<<<");

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Otp Sent"),
        ));

        if(_Controller.text == "+8801943869105"){
          //TODO: Delete when release
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()),
                  (route) => false);
        }else{
          //TODO: Comment out when release
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  LogInOtpPage(_Controller.text, employeeModel!.id.toString())));
        }




      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(
          duration: Duration(seconds: 5),
          content: Text(
              " You have entered wrong Phone Number"),
        ));
      }


    } else {
      print("Push notification is OFF");
    }



  }
  setState(() {
    isLoading = false;
  });
}




  //=========== Notification =================
  // String? osUserID;
  //
  // Future<void> initOneSignal(BuildContext context, userID) async {
  //
  //   //send devide token
  //   if (osUserID != null && osUserID != "null") {
  //     var response = await http.post(
  //         Uri.parse("https://admin.elbrit.org/api/updateToken"),
  //         body: {
  //           "player_id": osUserID.toString(),
  //           "userId": userID.toString(),
  //         }
  //     );
  //     print("Status code ================= ${response.statusCode}");
  //
  //     if (response.statusCode == 200) {
  //       Fluttertoast.showToast(
  //           msg: "Push notification is ON",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           fontSize: 16.0
  //       );
  //       print("Send device token ====================== $osUserID");
  //     } else {
  //       print("Push notification is OFF");
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Device ID is Null. You can't get Notification",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 4,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0
  //     );
  //   }
  //
  //
  //   sendData(userID) async {
  //
  //   }
  //
  //   handleForegroundNotifications() {
  //     return null;
  //   }
  // }

}
