import 'package:flutter/material.dart';
import 'package:quizmaster/constant/duration.dart';
import 'package:quizmaster/pages/ui/myperformance-screen-one.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:quizmaster/pages/ui/questiontimer.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/constant/constants.dart';
//import '../../model/databasehelper.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';

import '../question/schedule.dart';
class ScheduleComplete extends StatefulWidget {
  //ScheduleComplete({Key? key}) : super(key: key);
  String scheduleRefID;
  ScheduleComplete({required this.scheduleRefID});
  @override
  _ScheduleCompleteState createState() => _ScheduleCompleteState();
}

class _ScheduleCompleteState extends State<ScheduleComplete> {
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  Question databaseQuestion = new Question();
  User databaseUser= new User();
  late VideoPlayerController _controller;
  bool _visible = false;
  late StreamSubscription<ConnectivityResult> subscription;
  // String scheduleRefID="";
  // String userRefID="";

  @override
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  // void readSharedPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
  //     userRefID= (prefs.getString('scheduleRefID') ?? "");
  //   });
  // }
  @override
  void initState() {
    //readSharedPrefs();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){

      }
      // Got a new connectivity status!
    });
    super.initState();
    _controller=VideoPlayerController.network(Constants.closeURL);
    _controller.initialize().then((_) {
      _controller.setLooping(false);
      Timer(Duration(milliseconds: Constants.closeDuration), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });
    Future.delayed(Duration(seconds: Constants.closeDuration), () async{
      //if(Durations.endvideomyperformancescrrenon>0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'scheduleCurrentTime', databaseQuestion.currentTime);
        prefs.setString('scheduleRefID', "");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MyPerformanceScreenOne(scheduleRefID: widget.scheduleRefID)),
                (e) => false);
      //}
    });
  }


  clearScheduleRefID() async {
    final prefs = await SharedPreferences.getInstance();
    Constants.scheduleRefID=(prefs.getString('scheduleRefID') ?? "");
    prefs.setString('scheduleRefID', "");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>QuestionDynamicUiPage()),
            (e) => false);
  }




  showCloseAppConfirm(BuildContext context)
  {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(Size(
          MediaQuery.of(context).size.width,
          fem * 280)),
      context: context,
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration (
              color: Color(0xfffcfcfc),
              borderRadius: BorderRadius.only (
                topLeft: Radius.circular(24*fem),
                topRight: Radius.circular(24*fem),
              ),
            ),
            padding:EdgeInsets.all(8),child:Column(
            children: <Widget>[
              Row(
                children:  const <Widget>[

                  Text('Close',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                ],
              ),
              SizedBox(height: 20,),
              Row(
                children:  <Widget>[
                  Expanded(child: Text('Are you sure you wish to close your quiz?',style: TextStyle(fontSize: 14*fem,fontWeight: FontWeight.w600),)),

                ],
              ),

              SizedBox(height: 20,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: _colorFromHex(Constants.buttonColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // <-- Radius
                        ) // foreground
                    ),
                    onPressed: () async{
                      clearScheduleRefID();
                    },
                    child: const Text(
                      'Confirm Close',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,
                          fontSize: 14.0),
                    ),
                  )),
              SizedBox(height: 10,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(
                              12), // <-- Radius
                        ) // foreground
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,
                          fontSize: 14.0),
                    ),
                  )),

            ]));
      },
    );
  }
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    _getVideoBackground() {
      return AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 1000),
        child: VideoPlayer(_controller),
      );
    }



    return GestureDetector(
        onTap: () {
      setState(() {
        // Toggle light when tapped.
       Constants.printMsg("Close Schedule confirmed");
       showCloseAppConfirm(context);
      });
    },
    child:Container(
        child: WillPopScope(
          onWillPop: () async {
            showCloseAppConfirm(context);
            // await showDialog or Show add banners or whatever
            // return true if the route to be popped
            return false; // return false if you want to disable device back button click
          },
          child: Scaffold(
              body: Container(
                height:  double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/quesintrobackground.png"),
                      fit: BoxFit.cover),
                ),
                child:  Center(
                  child: Stack(
                    children: <Widget>[
                      _getVideoBackground(),
                    ],
                  ),
                ),
              )),
        )));
  }
}