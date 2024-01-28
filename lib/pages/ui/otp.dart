import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:quizmaster/pages/ui/password.dart';
import 'package:quizmaster/pages/ui/pin.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/constant/duration.dart';
class OtpUiPage extends StatefulWidget {
  String mobile;
  String otp;
  int isnewdevice;
  OtpUiPage({required this.mobile,required this.otp,required this.isnewdevice});

  @override
  _OtpUiPageState createState() => _OtpUiPageState();
}

class _OtpUiPageState extends State<OtpUiPage> {
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser = new User();
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  String otp = "";
  late Timer _timer;
  String otpdisplay="";

  bool resendtextdisplay=false;
  late StreamSubscription<ConnectivityResult> subscription;
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  int milliseconds=0;
  startTimeout([milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }
  @override
  void initState() {

    startTimeout();
    Future.delayed(Duration(seconds: 60), () async{
      setState(() {
        resendtextdisplay=true;
      });
    });

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });

    this.setState(() {
      otp = randomNumber();
      getqsid();
    });
    super.initState();
  }
  getqsid() async{
    final prefs = await SharedPreferences.getInstance();
      final String? qsid = prefs.getString('qsid');
  }
  String randomNumber() {
    var rnd = new Random();
    var rndnumber = "";
    for (var i = 0; i < 6; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    return rndnumber;
  }
  final _formKey = GlobalKey<FormBuilderState>();
  var genderOptions = ['Male', 'Female', 'Other'];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginUiPage(title: '',url: '',)),
                  (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SingleChildScrollView(
        //  physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),

              SizedBox(
                  height: 47,
                  width: 246,
                  child: Image.asset(
                      "assets/loginqtitle.png")
                  ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Quiz Game",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              Image.asset("assets/photo.png"),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                    )),
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: FormBuilder(
                              key: _formKey,
                              onChanged: () {
                                _formKey.currentState!.save();
                                debugPrint(
                                    _formKey.currentState!.value.toString());
                              },
                              autovalidateMode: AutovalidateMode.disabled,
                              initialValue:  {
                                'movie_rating': 5,
                                'best_language': 'Dart',
                               // 'mobile': widget.mobile,
                                'gender': 'Male',
                                'languages_filter': ['Dart']
                              },
                              skipDisabled: true,
                              child: Column(
                                children: <Widget>[

                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Enter the 6-digit OTP",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      )),
                                 // (Durations.otpdisplay==0)?Text(widget.otp,style: TextStyle(color: Colors.red,fontSize: 18.0),):SizedBox(),
                                  const SizedBox(height: 15),
                                  OtpTextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    numberOfFields: 6,
                                    borderColor: _colorFromHex(Constants.buttonColor),
                                    //set to true to show as box or false to show as dash
                                    showFieldAsBox: true,
                                    //runs when a code is typed in
                                    onCodeChanged: (String code) {
                                    },
                                    //runs when every textfield is filled
                                    onSubmit: (String verificationCode) {


                                      databaseUser
                                          .verifyOTPLogin(
                                          widget.mobile,verificationCode)
                                          .whenComplete(() {
                                        if (databaseUser.responseCode == "0") {


if(widget.isnewdevice>0){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PinUiPage(
                  mobile:widget.mobile,
                  qsid:databaseUser.qsid.toString()
              )),
          (e) => false);
}else{
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => PasswordUiPage(
              mobile:widget.mobile
          )),
          (e) => false);
}






                                        }else{
                                          showDialog(
                                              context: context,
                                              builder: (context) {


                                                return AlertDialog(
                                                  title:  Text('OTP Validate Error'),
                                                  content: SingleChildScrollView(
                                                    child: ListBody(
                                                      children:  <Widget>[
                                                        Text("Verification OTP entered is Wrong"),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );

                                              });
                                        }
                                      });

                                    }, // end onSubmit
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                "SMS sent to",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Color(0xFF808080)),
                                              )),
                                          Text(
                                            "+91 "+widget.mobile,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Color(0xFF000000)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 150.0,
                                      ),
                                      //Expanded(
                                        //child:
                                      (resendtextdisplay==true)?GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              // Toggle light when tapped.


                                              databaseUser
                                                  .sendOTPLogin(widget.mobile,'2')
                                                  .whenComplete(() {
                                                if(databaseUser.responseCode=="0"){
                                                  otpdisplay=databaseUser.otp;
                                                  print("databaseHelper.mobileNo");
                                                  print(databaseUser.mobileNo);
                                                  print(otpdisplay);
                                                  print(databaseUser.otp);
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OtpUiPage(
                                                                mobile:databaseUser.mobileNo,
                                                                otp:databaseUser.otp,
                                                                isnewdevice:0,
                                                              )),
                                                          (e) => false);
                                                }

                                              });


                                            });
                                          },
                                          child:Text("Resend",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xFF5A2DBC),
                                                fontWeight: FontWeight.bold))):SizedBox(),
                                     // ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            )),

                        Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                        child: Text(
                                      'The OTP Expires in',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                    )),
                                //),
                                SizedBox(
                                  width: 10,
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.timer),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(timerText)
                                  ],
                                )
                                /*TweenAnimationBuilder<Duration>(
                                    duration: Duration(minutes: 3),
                                    tween: Tween(begin: Duration(minutes: expirtime), end: Duration.zero),
                                    onEnd: () {
                                      print('Timer ended');
                                    },
                                    builder: (BuildContext context, Duration value, Widget? child) {
                                      final minutes = value.inMinutes;
                                      final seconds = value.inSeconds % 60;
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Text('$minutes:$seconds',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:_colorFromHex(Constants.baseThemeColor),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)));
                                    }),*/
                              ],
                            )),
                        /*Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child:
                            SizedBox(
                                      height: 44.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: _colorFromHex(Constants.buttonColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // <-- Radius
                                            ) // foreground
                                            ),
                                        onPressed: () {
                                              databaseHelper
                                                  .verifyOTPLogin(
                                                  widget.mobile,widget.otp)
                                                  .whenComplete(() {
                                                if (databaseHelper.responseCode == "0") {

                                                }
                                              });
                                        },
                                        child: const Text(
                                          'Verify & Continue',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      )),
                                ),
                              ],
                            )),*/

                        Image.asset(
                          "assets/bottom-bar-line.png",
                          height: MediaQuery.of(context).size.height,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ))));
  }
}
