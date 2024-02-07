import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/ui/holdpercentagewinning.dart';
import 'package:quizmaster/pages/ui/questionwinninglist.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:video_player/video_player.dart';
import 'package:quizmaster/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
import 'package:quizmaster/pages/ui/congratulations.dart';
//import 'package:percent_indicator/percent_indicator.dart';
import 'package:progress_indicator/progress_indicator.dart';
import '../webview/rateus.dart';
import 'hold.dart';
import 'login.dart';
import 'package:quizmaster/pages/user/model/user.dart';
final timesupmusic = "asset:///audios/times-up.mp3";
final wronganswermusic = "asset:///audios/wrong-answer.mp3";
final conguratulations_congrat = "asset:///audios/congratulations.mp3";
class Percentage extends StatefulWidget {
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
  Percentage({ required this.option,required this.question,required this.selectedQues,required this.answerstring,required this.questionRefID,required this.correctAnswer,required this.qPlayCount,required this.qTotalCount,required this.page,required this.winningPrice});

  @override
  _PercentageState createState() => _PercentageState();
}

class _PercentageState extends State<Percentage>   with SingleTickerProviderStateMixin {
  Question databaseQuestion = new Question();
  User databaseUser = new User();
  late SimpleAudioPlayer simpleAudioPlayer;
  double rateValue = 1.0;
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  //List data = [];
  List percentagedata=[];

  String optionA="";
  String optionB="";
  String optionC="";
  String optionD="";
  String percentageA="";
  String percentageB="";
  String percentageC="";
  String correctOption="";

  void onEnd() {
  }
  late StreamSubscription<ConnectivityResult> subscription;
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }

  getAnswerPercentageData() async {
    databaseQuestion
        .getAnswerPercentageData(widget.questionRefID)
        .whenComplete(() async{
      setState(() {
       // percentagedata=databaseHelper.answerpercentagedata as List;
        //deviceAuthCheck();
        syncData();
        optionA=databaseQuestion.optionA;
        optionB=databaseQuestion.optionB;
        optionC=databaseQuestion.optionC;
        percentageA=databaseQuestion.percentageA;
        percentageB=databaseQuestion.percentageB;
        percentageC=databaseQuestion.percentageC;
        correctOption=databaseQuestion.correctOption;
      });
    });
  }


  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  String correctAnswerChoosen = "";
  final _formKey = GlobalKey<FormBuilderState>();
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  int endTime = DateTime.now().millisecondsSinceEpoch +
      Duration(seconds: 30).inMilliseconds;
  late int tappedIndex;
  late bool is_video_loaded=false;
  String finalD = '';
  bool questionContainer = true;
  bool answerContainer = true;
  bool submitContainer = true;
  late Timer _timer1;
  late Timer _timer2;
  late Timer _timer3;
 // int currentQuestion = 0;
  //int totalQuestion = 0;
  late VideoPlayerController _controller;
  bool _visible = false;
  var _question="";
  var imageURl="";
  var categoryRefID="1";
  var imgWidth;
  var imgHeight;
  var questionOptions=['A','B','C'];
  // Sync calling...
  var qTotalCount="";
  var qPlayCount=0;
  var qSchemeRefID="";
  String scheduleRefID="";

  String QuestionRefID="";
  syncData() async {
    final prefs = await SharedPreferences.getInstance();
    scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
    databaseQuestion.QuestionSync(scheduleRefID)
        .whenComplete(() async{
      setState(() {
        qTotalCount=databaseQuestion.qTotalCount;//5 Total Question Count
        qPlayCount=int.parse(databaseQuestion.qPlayCount);//1  Paly Count Question
        qSchemeRefID=databaseQuestion.qSchemeRefID;// Scheme Id
        QuestionRefID=databaseQuestion.questionRefID;
      });
    });
  }
// Sync calling...
  @override
  void initState() {



    simpleAudioPlayer = SimpleAudioPlayer();
    simpleAudioPlayer.songStateStream.listen((event) {

    });
    if(widget.page=='timesup'){
      simpleAudioPlayer.prepare(uri: timesupmusic);
    }
    if(widget.page=='wrong'){
      simpleAudioPlayer.prepare(uri: wronganswermusic);
    }
    if(widget.page=='correct'){
      simpleAudioPlayer.prepare(uri: conguratulations_congrat);
    }


    simpleAudioPlayer.setPlaybackRate(rate: rateValue);
    simpleAudioPlayer.play();
    if(widget.page=='wrong'){
      is_video_loaded=false;
    }
    if(widget.page=='timesup'){
      is_video_loaded=false;
    }
    if(widget.page=='correct'){
      is_video_loaded=false;
    }


    super.initState();
    tappedIndex = 0;
    databaseQuestion.getQuestioninfo(widget.questionRefID).whenComplete(() {
      setState(() {
        _question = databaseQuestion.question;
        //categoryRefID=databaseQuestion.categoryRefID;
        categoryRefID=(Constants.prefix!='')?"1":databaseQuestion.categoryRefID;
        Constants.printMsg("Category ?ID:$categoryRefID");
        Constants.printMsg("_question:$_question");
        imgWidth=databaseQuestion.width;
        imgHeight=databaseQuestion.height;
        imageURl=databaseQuestion.imageURl;
      });
    });
    /*_controller = VideoPlayerController.asset("assets/video/winning.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(seconds: 1), () {
        setState(() {
          _controller.play();
          _visible = true;
          is_video_loaded=false;
        });
      });
    });*/

  /*  Future.delayed(Duration(seconds: 5), () async{
      setState(() {
        if(widget.page=='correct'){
         // is_video_loaded=true;
        }

      });

    });*/


   Future.delayed(Duration(seconds: 3), () async {
      simpleAudioPlayer.stop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionWinningList(
                  question: widget.question,questionRefID:widget.questionRefID,qPlayCount:widget.qPlayCount,qTotalCount:widget.qTotalCount,page:widget.page)),
              (e) => false);//HoldPercentWinner(option: widget.option, question: widget.question, selectedQues: widget.selectedQues, answerstring: widget.answerstring, questionRefID: widget.questionRefID, winningPrice: widget.winningPrice, correctAnswer: widget.correctAnswer, qPlayCount: widget.qPlayCount, qTotalCount: qTotalCount, page: widget.page));

    });
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){

      }
      // Got a new connectivity status!
    });

    getAnswerPercentageData();
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
      }else if(databaseUser.responseCode=='503'){
        setState(() {
          showSnackBarSessionTimeOut(databaseUser
              .responseDescription);
        });
      }
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
    await //prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginUiPage(title: '',url: '',)),
            (e) => false);
  }

  @override
  void dispose() {

    super.dispose();
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
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionDynamicUiPage()),
                              (e) => false);
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

  @override
  Widget build(BuildContext context) {
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
        //drawer: const CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading:  GestureDetector(
            onTap: () {
    setState(() {
    // Toggle light when tapped.
    showCloseAppConfirm(context);
    });
    },
      child:Icon(
        Icons.home,
        color: Colors.pink,
        size: 40.0,

      )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[


              Text("Question",style: TextStyle(color: Colors.black,fontSize: 18.0),),



              Text(widget.qPlayCount,style: TextStyle(color: Colors.black),),
              Text("/",style: TextStyle(fontSize: 18,color: Colors.black),),
              Text(widget.qTotalCount,style: TextStyle(color: Colors.black,fontSize: 28),)
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/logo.png",
                width: 40,
                height: 40,
              ),
              tooltip: 'Show Snackbar',
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Color(0xFFD9D9D9),
        body:  Padding(
            padding: const EdgeInsets.only(top: 0),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(20),
                        )),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(
                            height: 50.0,
                          ),
                        ])),
                // First Question Started
                Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16, right: 16),
                    child: Stack(
                      children: <Widget>[
                        FormBuilder(
                            key: _formKey,
                            onChanged: () {
                              _formKey.currentState!.save();
                            },
                            autovalidateMode: AutovalidateMode.disabled,
                            skipDisabled: true,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration:  const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  )),
                              child: Column(
                                children: <Widget>[
                                  //const SizedBox(height: 150),
                                  SizedBox(height: (categoryRefID=="2")?180:150),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 16*fem, 0*fem),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        for(int x = 0; x<questionOptions.length;x++)...[// Loop Start For
                                        SizedBox(
                                          height: 16*fem,
                                        ),
                                        (questionOptions[x]==correctOption)?
                                        Container(
                                          padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 20 * fem, 0 * fem),
                                          width: double.infinity,
                                          height: 48 * fem,
                                          decoration:  BoxDecoration (
                                              color: Color(0x2c33b871),
                                              border: Border.all(color: Color(0x2c33b871)),
                                              borderRadius:BorderRadius.only(
                                                bottomLeft: Radius.circular(12*fem),
                                                topLeft: Radius.circular(12*fem),
                                                bottomRight: Radius.circular(12*fem),
                                                topRight: Radius.circular(12*fem),
                                              )
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                //margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 153 * fem, 0 * fem),
                                                //padding: EdgeInsets.fromLTRB(12 * fem, 13 * fem, 29 * fem, 15 * fem),
                                                height: double.infinity,
                                                decoration:  BoxDecoration (
                                                    color: Color(0x2c33b871),
                                                    border: Border.all(color: Color(0x2c33b871)),
                                                    borderRadius:BorderRadius.only(
                                                      bottomLeft: Radius.circular(12*fem),
                                                      topLeft: Radius.circular(12*fem),
                                                    )
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(
                                                          0 * fem, 0 * fem, 10 * fem, 0 * fem),
                                                      width: 26 * fem,
                                                      height: 20 * fem,
                                                      child: Image.asset(
                                                        'assets/icons/auto-group-yuux.png',
                                                        width: 26 * fem,
                                                        height: 20 * fem,
                                                      ),
                                                    ),
                                                    (x==0)?SizedBox(
                                                        width: 275* ffem,
                                                        child:Text(
                                                      optionA,
                                                      style: SafeGoogleFont(
                                                        'Open Sans',
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.125 * ffem / fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    )):SizedBox(),


                                                    (x==1)?SizedBox(
                                                        width: 275* ffem,
                                                        child:Text(
                                                      optionB,
                                                      style: SafeGoogleFont(
                                                        'Open Sans',
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.125 * ffem / fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    )):SizedBox(),


                                                    (x==2)?SizedBox(
                                                      width: 275* ffem,
                                                        child:Text(
                                                      optionC,
                                                      style: SafeGoogleFont(
                                                        'Open Sans',
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.125 * ffem / fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    )):SizedBox(),


                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 5 * ffem,),
                                              (x==0)?Text(
                                                '',// (4.5K)
                                                textAlign: TextAlign.right,
                                                style: SafeGoogleFont(
                                                  'Open Sans',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3333333333 * ffem / fem,
                                                  color: Color(0xff808080),
                                                ),
                                              ):SizedBox(),


                                              (x==1)?Text(
                                                '',// (4.5K)
                                                textAlign: TextAlign.right,
                                                style: SafeGoogleFont(
                                                  'Open Sans',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3333333333 * ffem / fem,
                                                  color: Color(0xff808080),
                                                ),
                                              ):SizedBox(),


                                              (x==2)?Text(
                                                '',// (4.5K)
                                                textAlign: TextAlign.right,
                                                style: SafeGoogleFont(
                                                  'Open Sans',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3333333333 * ffem / fem,
                                                  color: Color(0xff808080),
                                                ),
                                              ):SizedBox(),


                                            ],
                                          ),
                                        ): Container(
                                          padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 20*fem, 0*fem),
                                          width: double.infinity,
                                          height: 48*fem,
                                         /* decoration: BoxDecoration (
                                            border: Border.all(color: Color(0xffebb3b3)),
                                            borderRadius: BorderRadius.circular(12*fem),
                                          ),*/

                                          decoration:  BoxDecoration (
                                              color: Color(0xffebb3b3),
                                              border: Border.all(color: Color(0xffebb3b3)),
                                              borderRadius:BorderRadius.only(
                                                bottomLeft: Radius.circular(12*fem),
                                                topLeft: Radius.circular(12*fem),
                                                bottomRight: Radius.circular(12*fem),
                                                topRight: Radius.circular(12*fem),
                                              )
                                          ),

                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              Container(
                                                // margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 160*fem, 0*fem),
                                                padding: EdgeInsets.fromLTRB(13*fem, 12*fem, 17*fem, 16*fem),
                                                height: double.infinity,
                                                decoration:  BoxDecoration (
                                                    color: Color(0xffebb3b3),
                                                    border: Border.all(color: Color(0xffebb3b3)),
                                                    borderRadius:BorderRadius.only(
                                                      bottomLeft: Radius.circular(12*fem),
                                                      topLeft: Radius.circular(12*fem),
                                                    )
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                                      width: 20*fem,
                                                      height: 20*fem,
                                                      child: Image.asset(
                                                        'assets/icons/group-24-6iA.png',
                                                        width: 20*fem,
                                                        height: 20*fem,
                                                      ),
                                                    ),
                                                    (x==0)?SizedBox(
                                                        width: 275* ffem,
                                                        child:Text(
                                                      optionA,
                                                      style: SafeGoogleFont(
                                                        'Open Sans',
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.125 * ffem / fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ))/*Padding(
                                                      padding: EdgeInsets.all(15.0),
                                                      child: new LinearPercentIndicator(
                                                        width: MediaQuery.of(context).size.width - 50,
                                                        animation: true,
                                                        lineHeight: 20.0,
                                                        animationDuration: 2000,
                                                        percent: 0.9,
                                                        center: Text("90.0%"),
                                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                                        progressColor: Colors.greenAccent,
                                                      ),
                                                    )*/:SizedBox(),


                                                    (x==1)?SizedBox(
                                                        width: 275* ffem,
                                                        child:Text(
                                                      optionB,
                                                      style: SafeGoogleFont(
                                                        'Open Sans',
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.125 * ffem / fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    )):SizedBox(),


                                                    (x==2)?SizedBox(
                                                        width: 275* ffem,
                                                        child:Text(
                                                     optionC,
                                                      style: SafeGoogleFont(
                                                        'Open Sans',
                                                        fontSize: 16 * ffem,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.125 * ffem / fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    )):SizedBox(),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 5 * ffem,),
                                              (x==0)?Text(
                                                '',//(64.5K)
                                                textAlign: TextAlign.right,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 12*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3333333333*ffem/fem,
                                                  color: Color(0xff808080),
                                                ),
                                              ):SizedBox(),

                                              (x==1)?Text(
                                                '',//(64.5K)
                                                textAlign: TextAlign.right,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 12*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3333333333*ffem/fem,
                                                  color: Color(0xff808080),
                                                ),
                                              ):SizedBox(),

                                              (x==2)?Text(
                                                '',//(64.5K)
                                                textAlign: TextAlign.right,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 12*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3333333333*ffem/fem,
                                                  color: Color(0xff808080),
                                                ),
                                              ):SizedBox(),

                                              // you can add widget here as well


                                            ],
                                          ),
                                        ),




                                      ],// Loop End For
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            )),

                        Container(
                          padding: EdgeInsets.all(8.0),
                         // height: 150,
                          height: (categoryRefID=="1")?150:198,
                          width: MediaQuery.of(context).size.width,

                          decoration: (categoryRefID=="1")?BoxDecoration(
                              color: Color(0xFF11E5DD),
                              border: Border.all(
                                color: Color(0xFFe5e5e5),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              )):BoxDecoration(

                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),

                            image: DecorationImage(
                              image: NetworkImage(imageURl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(

                            padding: EdgeInsets.only(left: 0.0, top: 0.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Column(

                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        (categoryRefID=="1")?Align(
                                          alignment: Alignment.center,
                                          child:Center(
                                            child: SizedBox(
                                              child: Container(
                                                constraints: BoxConstraints (
                                                  maxWidth: 318*fem,
                                                ),
                                                child: (widget.question!=null)?Text(widget.question,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 20*ffem,
                                                    fontWeight: FontWeight.w800,
                                                    height: 1.3333333333*ffem/fem,
                                                    color: Color(0xff000000),
                                                  ),
                                                ):CircularProgressIndicator(),
                                              ),
                                            ),
                                          ) ):SizedBox(),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        )
                        ,
                      ],
                    )),
                // First Question Ended


                const SizedBox(
                  height: 40.0,
                ),
                (widget.page=='timesup' || widget.page=='wrong')?Container(
              margin: EdgeInsets.fromLTRB(5*fem, 100*fem, 0*fem, 34*fem),
              width: 366*fem,
              height: 175*fem,
              child: Stack(
                children: [
                  Positioned(
                    left: 0*fem,
                    top: 87*fem,
                    child: Container(
                      width: 366*fem,
                      height: 88*fem,
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.circular(8*fem),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0*fem,
                            top: 0*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(27*fem, 10*fem, 29*fem, 10*fem),
                              width: 366*fem,
                              height: 88*fem,
                              decoration: BoxDecoration (
                                color: (widget.page=='timesup')?Color(0xff11e5dd):Color(0xffFE5959),
                                borderRadius: BorderRadius.circular(8*fem),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration (
                                      color: Color(0xfffcfcfc),
                                      borderRadius: BorderRadius.only (
                                        topLeft: Radius.circular(24*fem),
                                        topRight: Radius.circular(24*fem),
                                        bottomRight: Radius.circular(24*fem),
                                        bottomLeft: Radius.circular(24*fem),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                    width: 35*fem,
                                    height: 35*fem,
                                    child: Image.asset(
                                      'assets/icons/timesup_almost.png',
                                      width: 20*fem,
                                      height: 20*fem,
                                    ),
                                  ),

                                  (widget.page=='timesup')?Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 2*fem),
                                          child: Text(
                                            'Whoops ! Time Over',
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 24*ffem,
                                              fontWeight: FontWeight.w800,
                                              height: 1.3333333333*ffem/fem,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Better Luck Next Time Though!',
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 18*ffem,
                                            fontWeight: FontWeight.w400,
                                            height: 1.2222222222*ffem/fem,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ):SizedBox(),







                                  (widget.page=='wrong')?Container(
                                    height: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Oops ! Wrong Answer ',
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 24*ffem,
                                            fontWeight: FontWeight.w800,
                                            height: 1.3333333333*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4*fem, 0*fem),
                                          child: Text(
                                            'Better Luck Next Time Though!',
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 18*ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2222222222*ffem/fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ):SizedBox()


                                ],
                              ),
                            ),
                          ),






                          // (widget.page=='timesup')?Positioned(
                          //   // vectorYQE (1246:945)
                          //   left: 34*fem,
                          //   top: 31*fem,
                          //   child: Align(
                          //     child: SizedBox(
                          //       width: 18*fem,
                          //       height: 21*fem,
                          //       child: Image.asset(
                          //         'assets/icons/vector-Bcz.png',
                          //         width: 18*fem,
                          //         height: 21*fem,
                          //       ),
                          //     ),
                          //   ),
                          // ):SizedBox(),


                          (widget.page=='wrong')?Positioned(
                            // vectorYQE (1246:945)
                            left: 32*fem,
                            top: 31*fem,
                            //  right: 10*fem,
                            child: Align(
                              child: SizedBox(
                                width: 25*fem,
                                height: 25*fem,
                                child: Image.asset(
                                  'assets/icons/group-24-6iA.png',
                                  // width: 35*fem,
                                  // height: 28*fem,
                                ),
                              ),
                            ),
                          ):SizedBox(),

                        ],
                      ),
                    ),
                  ),





                  (widget.page=='timesup')?Positioned(
                    left: 145*fem,
                    top: 0*fem,
                    child: Align(
                      child: SizedBox(
                        width: 99*fem,
                        height: 99*fem,
                        child: Image.asset(
                          'assets/icons/sleeping-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ):SizedBox(),

                  (widget.page=='wrong')?Positioned(
                    left: 144*fem,
                    top: 0*fem,
                    child: Align(
                      child: SizedBox(
                        width: 86*fem,
                        height: 86*fem,
                        child: Image.asset(
                          'assets/icons/sad-1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ):SizedBox()

                ],
              ),
            ):SizedBox(),
                (widget.page=='correct')?Container(
                    width: 267.99*fem,
                    height: 165.77*fem,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 167.9907226562*fem,
                          top: 72.9844970703*fem,
                          child: Align(
                            child: SizedBox(
                              width: 96*fem,
                              height: 92.79*fem,
                              child: Image.asset(
                                'assets/icons/bitmap.png',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0*fem,
                          top: 0*fem,
                          child: Align(
                            child: SizedBox(
                              width: 267.99*fem,
                              height: 155.46*fem,
                              child: Image.asset(
                                'assets/background/group-762360.png',
                                width: 267.99*fem,
                                height: 155.46*fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 147.1733398438*fem,
                          top: 20.0146484375*fem,
                          child: Align(
                            child: SizedBox(
                              width: 18.08*fem,
                              height: 16.68*fem,
                              child: Image.asset(
                                'assets/icons/group.png',
                                width: 18.08*fem,
                                height: 16.68*fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 13.9907226562*fem,
                          top: 98.9844970703*fem,
                          child: Align(
                            child: SizedBox(
                              width: 59.59*fem,
                              height: 60.46*fem,
                              child: Image.asset(
                                'assets/icons/star-1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 83.9907226562*fem,
                          top: 61.9844970703*fem,
                          child: Align(
                            child: SizedBox(
                              width: 88*fem,
                              height: 83*fem,
                              child: Image.asset(
                                'assets/icons/layer-2-2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                ):SizedBox(),





                (widget.page=='almost')?Container(
                  width: 267.99*fem,
                  height: 165.77*fem,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 167.9907226562*fem,
                        top: 72.9844970703*fem,
                        child: Align(
                          child: SizedBox(
                            width: 96*fem,
                            height: 92.79*fem,
                            child: SizedBox(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0*fem,
                        top: 0*fem,
                        child: Align(
                          child: SizedBox(
                            width: 267.99*fem,
                            height: 155.46*fem,
                            child: Image.asset(
                              'assets/background/group-762360.png',
                              width: 267.99*fem,
                              height: 155.46*fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 147.1733398438*fem,
                        top: 20.0146484375*fem,
                        child: Align(
                          child: SizedBox(
                            width: 18.08*fem,
                            height: 16.68*fem,
                            child: Image.asset(
                              'assets/icons/group.png',
                              width: 18.08*fem,
                              height: 16.68*fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13.9907226562*fem,
                        top: 98.9844970703*fem,
                        child: Align(
                          child: SizedBox(
                            width: 59.59*fem,
                            height: 60.46*fem,
                            child: SizedBox(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 83.9907226562*fem,
                        top: 85.9844970703*fem,
                        child: Align(
                          child: SizedBox(
                            width: 88*fem,
                            height: 83*fem,
                            child: Image.asset(
                              'assets/icons/star-1.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ):SizedBox(),



                // Correct Answer Part
                (widget.page=='correct')? Container(
                    width: 366*fem,
                    height: 88*fem,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(8*fem),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 31*fem, 16*fem),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration (
                        color: Color(0xffffb400),
                        borderRadius: BorderRadius.circular(8*fem),
                      ),
                      child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: SingleChildScrollView(child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /*Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                      width: 32*fem,
                                      height: 32*fem,
                                      child: Image.asset(
                                        'assets/icons/vector-zTQ.png',
                                        width: 32*fem,
                                        height: 32*fem,
                                      ),
                                    ),*/

                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 18*fem, 5*fem),
                                      width: 33*fem,
                                      height: 33*fem,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 32.0,

                                      ),
                                    ),
                                    Text(
                                      'Excellent ! Great Job!!',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 24*ffem,
                                        fontWeight: FontWeight.w800,
                                        height: 1.3333333333*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 0*fem, 0*fem),
                                child: RichText(
                                  text: TextSpan(
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 20*ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2*ffem/fem,
                                      color: Color(0xff29320b),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'You won ',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 20*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2*ffem/fem,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '₹'+widget.winningPrice,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 20*ffem,
                                          fontWeight: FontWeight.w800,
                                          height: 1.2*ffem/fem,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          )),
                    ),

                ):SizedBox(),




                // Almost  Part
                (widget.page=='almost')? Container(
                  width: 366*fem,
                  height: 88*fem,
                  decoration: BoxDecoration (
                    borderRadius: BorderRadius.circular(8*fem),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(24*fem, 16*fem, 31*fem, 16*fem),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration (
                      color: Color(0xff1D5997),
                      borderRadius: BorderRadius.circular(8*fem),
                    ),
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: SingleChildScrollView(child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                    decoration: BoxDecoration (
                                      color: Color(0xfffcfcfc),
                                      borderRadius: BorderRadius.only (
                                        topLeft: Radius.circular(24*fem),
                                        topRight: Radius.circular(24*fem),
                                        bottomRight: Radius.circular(24*fem),
                                        bottomLeft: Radius.circular(24*fem),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                    width: 35*fem,
                                    height: 35*fem,
                                    child: Image.asset(
                                      'assets/icons/timesup_almost.png',
                                      width: 20*fem,
                                      height: 20*fem,
                                    ),
                                  ),
                                  // Container(
                                  //     margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                  //     width: 32*fem,
                                  //     height: 32*fem,
                                  //     child: Image.asset(
                                  //       'assets/icons/group-24-6iA.png',
                                  //       width: 32*fem,
                                  //       height: 32*fem,
                                  //     ),
                                  //   ),

                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                    width: 35*fem,
                                    height: 35*fem,
                                    child: SizedBox(),
                                  ),
                                  Text(
                                    'Oh! Almost there',
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 24*ffem,
                                      fontWeight: FontWeight.w800,
                                      height: 1.3333333333*ffem/fem,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 0*fem, 0*fem),
                              child: RichText(
                                text: TextSpan(
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 20*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2*ffem/fem,
                                    color: Color(0xff29320b),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'but you can be faster next time.',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w800,
                                        height: 1.2*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        )),
                  ),

                ):SizedBox(),

// Correct Answer Part
              ]),
            ))//(widget.page=='correct')?Congratulations(option: widget.option, question: widget.question, selectedQues: widget.selectedQues, answerstring: widget.answerstring, questionRefID: widget.questionRefID, winningPrice: widget.winningPrice, correctAnswer: widget.correctAnswer, qPlayCount: widget.qPlayCount, qTotalCount: widget.qTotalCount, page: widget.page):SizedBox(),//Congratulations(option: widget.option, question: widget.question, selectedQues: widget.selectedQues, answerstring: widget.answerstring, questionRefID: widget.questionRefID, winningPrice: widget.winningPrice, correctAnswer: widget.correctAnswer, qPlayCount: widget.qPlayCount, qTotalCount: widget.qTotalCount, page: widget.page),



    ));
  }
}
