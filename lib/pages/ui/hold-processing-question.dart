import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:flutter/gestures.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:quizmaster/pages/ui/winner-list.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:intl/intl.dart';

import '../../constant/duration.dart';
class HoldQuestionProcessing extends StatefulWidget {
  //HoldQuestionProcessing({Key? key}) : super(key: key);
  String scheduleRefID;
  HoldQuestionProcessing({required this.scheduleRefID});
  @override
  _HoldQuestionProcessingState createState() => _HoldQuestionProcessingState();
}

class _HoldQuestionProcessingState extends State<HoldQuestionProcessing> {
  late StreamSubscription<ConnectivityResult> subscription;
  Question databaseQuestion = new Question();
  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
    //if(Durations.questionTimerBased>0){
      syncData();
    /*}else {
      Future.delayed(Duration(seconds: 5), () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('CURRENTQUESTION', 1);
        var questionRefID=(prefs.getString('questionRefID') ?? "");
        var scheduleRefID=(prefs.getString('scheduleRefID') ?? "");
        if (questionRefID == "") {
          ///Constants.scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
          await prefs.setString('scheduleRefID', "");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      WinnerList(scheduleRefID: scheduleRefID)));
        }else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestionViewUiPage(scheduleRefID: widget.scheduleRefID,questionId: '',)),

                  (e) => false);
        }
      });
    }*/
  }

  showSnackBarWithoutExit(message) async {
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


  }
  String scheduleRefID="";
  String qWaitDuration="";
  String currentTime="";
  String qStartTime="";
  int reachsecond=0;
  syncData() async {
    final prefs = await SharedPreferences.getInstance();
    scheduleRefID =widget.scheduleRefID; ///(prefs.getString('scheduleRefID') ?? "");
    databaseQuestion.QuestionSync(scheduleRefID)
        .whenComplete(() async{
      setState(() {
        qWaitDuration=databaseQuestion.qWaitDuration;
        print("qWaitDuration:$qWaitDuration");
        //setState(() {
        if(qWaitDuration==""){
          /*showSnackBarWithoutExit(
              "This schedule unavailable this time try again later");*/
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      WinnerList(scheduleRefID: scheduleRefID)));
        }else {
          /*Future.delayed(Duration(seconds: int.parse(qWaitDuration)), () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('CURRENTQUESTION', 1);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionViewUiPage()),

                    (e) => false);
          });*/
          currentTime=databaseQuestion.currentTime;
          qStartTime=databaseQuestion.qStartTime;
          var now = new DateTime.now();
          var currentFormatDate = new DateFormat('yyyy-MM-dd');
          String currentDate = currentFormatDate.format(now);
          //String currentTime=currentTime;
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
          DateTime dt2 = DateTime.parse("$currentDate $qStartTime");
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
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('CURRENTQUESTION', 1);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionViewUiPage(scheduleRefID: widget.scheduleRefID,questionId: databaseQuestion.questionRefID,)),

                    (e) => false);
          });

        }
      });
    });
  }

  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  @override@override
  Widget build(BuildContext context) {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped

      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(31.07*fem, 21*fem, 12.19*fem, 8*fem),
            width: double.infinity,
            decoration: BoxDecoration (
              color: Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: Color(0x28000000),
                  offset: Offset(0*fem, 2*fem),
                  blurRadius: 2*fem,
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 354*fem),
                    width: 370.74*fem,
                    height: 13*fem,
                    child: SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(41.93*fem, 0*fem, 60.81*fem, 279*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16*fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(74*fem, 0*fem, 74*fem, 40*fem),
                            padding: EdgeInsets.fromLTRB(0*fem, 0.27*fem, 0*fem, 0*fem),
                            width: double.infinity,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    width: 75,
                                    height: 75,

                                    child:  CircularProgressIndicator(
                                      color: _colorFromHex(Constants.baseThemeColor), //<-- SEE HERE
                                      backgroundColor: Color(0xffE6DCEE),
                                      strokeWidth: 8,
                                    )),
                              ],
                            )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 16*fem),
                          child: Text(
                            'Hold On',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont (
                              'Open Sans',
                              fontSize: 24*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1*ffem/fem,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                        Text(
                          'Loading the Question Please wait.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont (
                            'Open Sans',
                            fontSize: 14*ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.1428571429*ffem/fem,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),

        ), bottomNavigationBar: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
          ),
        ],
      ),
      child:Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 18.88*fem, 0*fem),
              width: 146.83*fem,
              height: 5*fem,
              child: SizedBox(),
            ),
          ],
        ),
      ),)));
  }
}
