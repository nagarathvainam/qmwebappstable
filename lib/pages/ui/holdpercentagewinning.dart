import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:quizmaster/pages/ui/percentage.dart';
import 'package:quizmaster/pages/ui/questionwinninglist.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'dart:async';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:video_player/video_player.dart';
//import 'package:quizmaster/pages/ui/correctansweresultpercentage.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
class HoldPercentWinner extends StatefulWidget {
  //Congratulations({Key? key}) : super(key: key);
  List option;
  String question;
  String selectedQues;
  String answerstring;
  String questionRefID;
  String winningPrice;
  String correctAnswer;
  String qPlayCount;
  String qTotalCount;
  String page;
  HoldPercentWinner({ required this.option,required this.question,required this.selectedQues,required this.answerstring,required this.questionRefID,required this.winningPrice,required this.correctAnswer,required this.qPlayCount,required this.qTotalCount,required this.page});
  @override
  _HoldPercentWinnerState createState() => _HoldPercentWinnerState();
}


class _HoldPercentWinnerState extends State<HoldPercentWinner> {
  late VideoPlayerController _controller;
  late SimpleAudioPlayer simpleAudioPlayer;
  double rateValue = 1.0;
  bool _visible = false;
  late StreamSubscription<ConnectivityResult> subscription;
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }
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


    Future.delayed(Duration(seconds: 2), () async {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Percentage(
                  option:widget.option,
                  question:
                  widget.question,
                  selectedQues:widget.selectedQues,
                  answerstring:widget.answerstring,
                  questionRefID:widget.questionRefID.toString(),
                  winningPrice:widget.winningPrice.toString(),
                  correctAnswer:widget.correctAnswer,
                  qPlayCount:widget.qPlayCount,
                  qTotalCount:widget.qTotalCount,
                  page:widget.page
              )),
              (e) => false);
    });

    if(widget.page=='correct') {
      _controller = VideoPlayerController.asset("assets/video/winning.mp4");
      _controller.initialize().then((_) {
        _controller.setLooping(true);
        Timer(Duration(milliseconds: 100), () {
          setState(() {
            _controller.play();
            _controller.setLooping(false);
            _visible = true;
          });
        });
      });
    }


  }



  @override
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
            body: (widget.page=='correct')?Center(
              child: Stack(
                children: <Widget>[
                  _getVideoBackground(),
                ],
              ),
            ):Container(
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
                                        )), //<-- SEE HERE
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
                              'Please wait....',
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
