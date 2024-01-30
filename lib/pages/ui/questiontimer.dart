import 'package:simple_audio_player/simple_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/hold-processing-question.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_audio_player/simple_audio_focus_manager.dart';
import 'package:simple_audio_player/simple_audio_notification_manager.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:quizmaster/circle_painter.dart';
import 'package:quizmaster/curve_wave.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:quizmaster/pages/user/model/user.dart';

import '../../constant/constants.dart';
import '../webview/rateus.dart';
import 'login.dart';
final tick_tick = "asset:///audios/tick-tick.mp3";
class QuestionTimerIntroUiPage extends StatefulWidget {
    String currentTime;
    String scheduleRefID;
    QuestionTimerIntroUiPage({required this.currentTime,required this.scheduleRefID});
  @override
  _QuestionTimerIntroUiPageState createState() => _QuestionTimerIntroUiPageState();
}


class _QuestionTimerIntroUiPageState extends State<QuestionTimerIntroUiPage>  with TickerProviderStateMixin{
  var _visible = true;
  String quizGroupName="";
  String scheduleStartTime="";
  late AnimationController animationController;
  late Animation<double> animation;
  void onEnd() {

  }
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  late CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch +
      Duration(seconds: 30).inMilliseconds;
  late SimpleAudioPlayer simpleAudioPlayer_tick_tick;
  final focusManager = SimpleAudioFocusManager();
  final notificationManager = SimpleAudioNotificationManager();
  double volumeValue = 1.0;
  double rateValue = 1.0;
  double sliderValue = 0;
  int reachsecond=0;
  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();

  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      quizGroupName = (prefs.getString('ScheduleName') ?? "");
      scheduleStartTime = (prefs.getString('scheduleStartTime') ?? "");
      var now = new DateTime.now();
      var currentFormatDate = new DateFormat('yyyy-MM-dd');
      String currentDate = currentFormatDate.format(now);
      String currentTime=widget.currentTime;
     var currentDateTimeSplit=currentTime.split(" ");
      var currentDateSplit=currentDateTimeSplit[0].split("-");
      var current_yr=currentDateSplit[2];
      var current_mn=currentDateSplit[1];
      var current_dt=currentDateSplit[0];
      var currentTimeSplit=currentDateTimeSplit[1].split(":");
      var current_hr=currentTimeSplit[0];
      var current_mi=currentTimeSplit[1];
      var current_ms=currentTimeSplit[2];
      print("IndianCurrentHour:$current_hr");
      print("IndianCurrentMinutes:$current_mi");
      print("IndianCurrenSeconds:$current_ms");
          DateTime dt1 = DateTime.parse("$current_yr-$current_mn-$current_dt $current_hr:$current_mi:$current_ms");
          DateTime dt2 = DateTime.parse("$currentDate $scheduleStartTime");
          Duration diff = dt2.difference(dt1);
          print(diff.inDays);
//output (in days): 1198
          print(diff.inHours);
//output (in hours): 28752
          print(diff.inMinutes);
//output (in minutes): 1725170
          print("Schedule Reached Seconds:"+diff.inSeconds.toString());
          reachsecond=diff.inSeconds;
//output (in seconds): 103510200

          Future.delayed(Duration(seconds: reachsecond), () async {
            simpleAudioPlayer_tick_tick.stop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HoldQuestionProcessing(scheduleRefID: widget.scheduleRefID,)));
            simpleAudioPlayer_tick_tick.stop();
          });

     // });



    });
  }
  @override
  void initState() {




    simpleAudioPlayer_tick_tick = SimpleAudioPlayer();
    simpleAudioPlayer_tick_tick.songStateStream.listen((event) {

    });
    simpleAudioPlayer_tick_tick.prepare(uri: tick_tick);
    simpleAudioPlayer_tick_tick.setPlaybackRate(rate: rateValue);
    simpleAudioPlayer_tick_tick.play();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    setState(() {
      _visible = !_visible;
    });
    // startTime();


    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
    readSharedPrefs();
    deviceAuthCheck();


  }

  deviceAuthCheck() async {
    databaseUser
        .deviceAuth()
        .whenComplete(() async{
      if(databaseUser.responseCode=='token_expired'){
        setState(() {
          showSnackBarSessionTimeOut(databaseUser.responseDescription);
        });
      }else if(databaseUser.responseCode=='107'){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginUiPage(title:'You are used Old Version. Please Check &  Update the Latest Version from the Google Play Store, Tab on the Information.',url: 'https://play.google.com/store/apps/details?id=com.quizMaster.quiz_master',)),
                (e) => false);
      }else if(databaseUser.responseCode!='0'){
        setState(() {
          showSnackBarSessionTimeOut(databaseUser
              .responseDescription);
        });
      }e:
    });
  }
  showSnackBarSessionTimeOut(message) async {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
    await prefs.setString('userRefID', "");
    Constants.displayName="";
    Constants.surName="";
    Constants.mobileNumber="";
    Constants.photo="";
    Constants.mailID="";
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginUiPage(title: '',url: '',)),
            (e) => false);
  }
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }


  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80.0),
        /*child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                Colors.red,
              ],
            ),
          ),*/
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: const CurveWave(),
                ),
              ),
              //child: Icon(Icons.speaker_phone, size: 44,)
          ),
        //),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final diff_sc = reachsecond;
    endTime = DateTime.now().millisecondsSinceEpoch +
        Duration(seconds: diff_sc).inMilliseconds;
    controller =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
            return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        body:  Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    children:  <Widget>[
        SizedBox(height: 10),
                      SizedBox(height: 50.0,),
                       Center(
                        child: Text(
                          quizGroupName,style: TextStyle(color: Color(0xff662797,),fontSize: 32,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 5.0,),
                       Center(
                        child: Text(
                          scheduleStartTime,style: TextStyle(color: Color(0xff662797,),fontSize: 24,fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
//Text(reachsecond.toString()),
                      SizedBox(height: 5.0,),
                      const Center(
                        child: Text(
                          "Your Quiz will start in...",style: TextStyle(color: Color(0xff000000,),fontSize: 24,fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 100.0,),
                      Center(
                        child:
                      Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CustomPaint(
                              painter: CirclePainter(
                                animationController,
                                color:Color(0xff662797,),
                              ),
                              child: SizedBox(
                                width: 80.0 * 4.125,
                                height: 80.0* 4.125,
                                child: _button(),
                              ),
                            ),
                            Image.asset("assets/clock-with-text.png"),
                            Center(child: Center(
                                child: CountdownTimer(
                                  controller: controller,
                                  widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {
                                    if (time == null) {
                                     return Text("",
                                        style: TextStyle(
                                            fontSize: 60.0,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()..shader = linearGradient),);
                                    }
                                    List<Widget> list = [];

                                    if (time.sec != null) {
                                      list.add(Row(
                                        children: <Widget>[
                                          Text(time.sec.toString(),
                                            style: TextStyle(
                                                fontSize: 60.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),),
                                        ],
                                      ));
                                    }
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: list,
                                    );
                                  },
                                ),
                                  )
                                ),
                          ]
                      )),

                    ]
                )
            )
        )
    ));
  }
}