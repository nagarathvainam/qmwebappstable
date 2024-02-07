import 'package:flutter/material.dart';
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

import '../webview/rateus.dart';
import 'login.dart';
class QuestionIntroUiPage extends StatefulWidget {
  //QuestionIntroUiPage({Key? key}) : super(key: key);
  String scheduleRefID;
  QuestionIntroUiPage({required this.scheduleRefID});
  @override
  _QuestionIntroUiPageState createState() => _QuestionIntroUiPageState();
}

class _QuestionIntroUiPageState extends State<QuestionIntroUiPage> {
  Question databaseQuestion = new Question();
  User databaseUser= new User();
  late VideoPlayerController _controller;
  bool _visible = false;
  late StreamSubscription<ConnectivityResult> subscription;
  String scheduleRefID="";
  @override
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
    });
  }
  @override
  void initState() {
    readSharedPrefs();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
    super.initState();
    //deviceAuthCheck();
    _controller=VideoPlayerController.network(Constants.openURL);
    _controller.initialize().then((_) {
      _controller.setLooping(false);
      Timer(Duration(milliseconds: Constants.openDuration), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });
    Future.delayed(Duration(seconds: Constants.openDuration), () async{
      databaseQuestion.QuestionSync(scheduleRefID)
          .whenComplete(() async{
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('scheduleCurrentTime', databaseQuestion.currentTime);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionTimerIntroUiPage(currentTime:databaseQuestion.currentTime,scheduleRefID:widget.scheduleRefID)),
                (e) => false);
      });
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


    Constants.displayName="";
    Constants.surName="";
 // Replaced Constants.userRefID
    Constants.mobileNumber="";
    Constants.photo="";
    Constants.mailID="";
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginUiPage(title: '',url: '',)),
            (e) => false);
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
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    _getVideoBackground() {
      return AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 1000),
        child: VideoPlayer(_controller),
      );
    }



    return Container(
      decoration: const BoxDecoration(


          image: DecorationImage(
            image: AssetImage("assets/quiz-2.png"),
            fit: BoxFit.cover,
          ),

      ),
      child: WillPopScope(
      onWillPop: () async {
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
    ));
  }
}