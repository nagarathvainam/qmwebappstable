import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/percentage.dart';
import 'package:quizmaster/pages/ui/questionwinninglist.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
//import 'package:quizmaster/pages/ui/correctansweresultpercentage.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
//import 'package:loading_animation_widget/loading_animation_widget.dart';
class Congratulations extends StatefulWidget {
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
  Congratulations({ required this.option,required this.question,required this.selectedQues,required this.answerstring,required this.questionRefID,required this.winningPrice,required this.correctAnswer,required this.qPlayCount,required this.qTotalCount,required this.page});
  @override
  _CongratulationsState createState() => _CongratulationsState();
}

class _CongratulationsState extends State<Congratulations> {
    late VideoPlayerController _controller;
    late SimpleAudioPlayer simpleAudioPlayer;
    double rateValue = 1.0;
  bool _visible = false;
  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    late double _kSize = 100;

  @override
  void initState() {



    Future.delayed(Duration(seconds: 2), () async {

      _controller.setLooping(false);
     /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionWinningList(
                option:widget.option,
                question:
                widget.question,
                selectedQues:widget.selectedQues,
                answerstring:widget.answerstring,
                  questionRefID:widget.questionRefID,
                  correctAnswer:widget.correctAnswer,
                qPlayCount:widget.qPlayCount,
                qTotalCount:widget.qTotalCount,
                page:widget.page,
                winningPrice:widget.winningPrice,
              )),
              (e) => false);*/


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>QuestionWinningList(
          question: widget.question,questionRefID:widget.questionRefID,qPlayCount:widget.qPlayCount,qTotalCount:widget.qTotalCount,page:'correct')),
      (e) => false);



    });

    _controller = VideoPlayerController.asset("assets/video/winning.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped

      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
          ],
        ),
      ),
    ));
  }
}
