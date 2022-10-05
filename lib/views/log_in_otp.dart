import 'package:elbrit_central/components/button.dart';
import 'package:elbrit_central/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_application/view.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LogInOtpPage extends StatefulWidget {
  final String phone;
  final String id;
  LogInOtpPage(this.phone, this.id);

  @override
  State<LogInOtpPage> createState() => _LogInOtpPageState();
}

class _LogInOtpPageState extends State<LogInOtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color(0xffEFF3F8),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  ConnectivityResult result = ConnectivityResult.none;



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        'images/Vector-1.png',
                        scale: .8,
                      ),
                    ),
                    Positioned(
                        top: 40,
                        left: 57,
                        child: Image.asset(
                          'images/Vector-3.png',
                          scale: 1.2,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Enter code',
                  style: GoogleFonts.roboto(
                      fontSize: 26, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'We have send an OTP',
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8394AA)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'to your phone',
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8394AA),
                      height: 1.5),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: PinPut(
                  fieldsCount: 6,
                  textStyle:
                      const TextStyle(fontSize: 25.0, color: Colors.black),
                  eachFieldWidth: 40.0,
                  eachFieldHeight: 55.0,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: pinPutDecoration,
                  selectedFieldDecoration: pinPutDecoration,
                  followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.fade,
                  onSubmit: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        SharedPreferences localDatabase = await SharedPreferences.getInstance();
                        if (value.user != null) {
                          localDatabase.setString("daily_login", "${DateTime.now().day}");
                          //========= onesignal ==========
                          //========= onesignal ==========
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      _scaffoldkey.currentState?.showSnackBar(
                          SnackBar(content: const Text('invalid OTP')));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    //Shared Local Database
    SharedPreferences localDatabase = await SharedPreferences.getInstance();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            print('User logged in');
          }
        });
      },

      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (verificationId, forceResendingToken) {
        setState(() {
          _verificationCode = verificationId;
          localDatabase.setString("daily_login", "1");
        });
      },
      codeAutoRetrievalTimeout: (verificationID) {
        setState(() {
          _verificationCode = verificationID;
          localDatabase.setString("daily_login", "1");
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkNotificationIsSet();
    _verifyPhone();
  }


  void checkNotificationIsSet() async{
    SharedPreferences localDatabase = await SharedPreferences.getInstance();
    print(localDatabase.getInt("device_token"));
    if(localDatabase.getInt('device_token') == 1 && localDatabase.getInt("set_push") != 1) {
      Get.defaultDialog(
        barrierDismissible: false,
        title: "Notification",
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text("This app want to send you Notification.", textAlign: TextAlign.center,),
              SizedBox(height: 5,),
              Divider(height: 1, color: Colors.grey.shade300,),
              SizedBox(height: 5,),
              TextButton(
                onPressed: (){
                  localDatabase.setInt("set_push", 1);
                  Navigator.pop(context);
                },
                child: const Text("Allow"),
              ),
            ],
          ),
        ),
      );
    }
    return;
  }


}
