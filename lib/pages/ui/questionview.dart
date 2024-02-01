import 'package:flutter/material.dart';
//import 'package:quizmaster/pages/ui/correctansweresultpercentage.dart';
import 'dart:async';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:quizmaster/model/databasehelper.dart';
//import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:quizmaster/pages/ui/congratulations.dart';
import 'package:quizmaster/pages/ui/winner-list.dart';
//import 'package:quizmaster/pages/ui/wronganswerresultpercentage.dart';
import 'dart:convert';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
//import 'package:quizmaster/pages/ui/WellAndGood.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/pages/ui/percentage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/constant/duration.dart';
import '../Components/QuestionViewAppBar.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'dart:async';
import 'package:simple_audio_player/simple_audio_player.dart';
import 'package:quizmaster/pages/ui/hold.dart';

import '../webview/rateus.dart';
import 'holdpercentagewinning.dart';
import 'login.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/question/model/questioninsert.dart';
import 'dart:io' show Platform, exit;
final question_load = "asset:///audios/question-load.mp3";
final option_load = "asset:///audios/option-load.mp3";
final submit_answer = "asset:///audios/submit-answer.mp3";

class QuestionViewUiPage extends StatefulWidget {
  // QuestionViewUiPage({Key? key}) : super(key: key);
  String scheduleRefID;
  String questionId;
  QuestionViewUiPage({required this.scheduleRefID,required this.questionId});
  @override
  _QuestionViewUiPageState createState() => _QuestionViewUiPageState();
}

class _QuestionViewUiPageState extends State<QuestionViewUiPage>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  Question databaseQuestion = new Question();
  QuestionInsert databaseQuestionInsert = new QuestionInsert();
  User databaseUser= new User();
  final int _duration = 15;//15
  final int _duration_timer2=5;//5
  final CountDownController _controller = CountDownController();
  late SimpleAudioPlayer simpleAudioPlayer;
  double rateValue = 1.0;

  List data = [];
  late String selectedQues = "";
  late int selectedIndex = -1;
  late Timer _timer;
  String answerPick="";
  late bool is_submitted = false;
  late bool timer_container_1=true;
  late bool timer_container_2=false;
  String unwantedClick="";
  String poornetworkflag="";
  String log="";
  late StreamSubscription<ConnectivityResult> subscription;



  String QuizTypeRefID="";
  //String scheduleRefID="";

  var QuestionRefID="";
  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      QuizTypeRefID = (prefs.getString('QuizTypeRefID') ?? "");
      //scheduleRefID = (prefs.getString('scheduleRefID') ?? "");

      QuestionRefID=(prefs.getString('QuestionRefID') ?? "");
    });
  }
  // Sync calling...
  var qTotalCount="";
  var qPlayCount="";
  var qSchemeRefID="";
  String answer="";
  String answeralphapet="";
  String QuestionSynBody="";
  String QuestionSyncResponseCode="";
  String QuestionSyncResponseDescription="";
  syncData() async {

    //scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
    Constants.printMsg("SyncDataScheduleRefId:");
    Constants.printMsg(widget.scheduleRefID);
    Constants.printMsg("questionId:");
    Constants.printMsg(widget.questionId);
    databaseQuestion.QuestionSync(widget.scheduleRefID)//Question Syncbody Empty
        .whenComplete(() async{
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        qTotalCount=databaseQuestion.qTotalCount;//5 Total Question Count
        qPlayCount=databaseQuestion.qPlayCount;//1  Paly Count Question
        qSchemeRefID=databaseQuestion.qSchemeRefID;// Scheme Id
        QuestionSynBody=databaseQuestion.QuestionSynBody;
        QuestionSyncResponseCode=databaseQuestion.responseCode;
        QuestionSyncResponseDescription=databaseQuestion.responseDescription;
        prefs.setString('questionRefID', databaseQuestion.questionRefID);
        //Constants.QuestionRefID=databaseQuestion.questionRefID;
        prefs.setString('scheduleRefID',widget.scheduleRefID);
        Constants.scheduleRefID=widget.scheduleRefID;
        getQuestions(widget.questionId);

      });
    });
  }
// Sync calling...
  String QuestionBody="";
  String QuestionResponseCode="";
  String QuestionResponseDescription="";
  getQuestions(questionRefID) {
    Constants.printMsg("Question REFID GETQUESTION:$questionRefID");
    databaseQuestion.getQuestioninfo(questionRefID).whenComplete(() {
      setState(() async {
        QuestionBody=databaseQuestion.QuestionBody;
        QuestionResponseCode=databaseQuestion.QuestionResponseCode;
        QuestionResponseDescription=databaseQuestion.QuestionResponseDescription;
        final prefs = await SharedPreferences.getInstance();
        answer = databaseQuestion.answer;
        /*if(Durations.devQuestionDisplay==0){
          answeralphapet= databaseQuestion.answeralphapet;
        }*/
        Constants.scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
        QuestionRefID=(prefs.getString('scheduleRefID') ?? "");
        if (databaseQuestion.responseCode != '0') {
          //QuestionRefID = Constants.QuestionRefID;
          Future.delayed(Duration(seconds: 2), () async {
            syncData();
            showSnackBar("You are used poor network-one");
          });
        }
        _question = databaseQuestion.question;
        categoryRefID=(Constants.prefix!='')?"1":databaseQuestion.categoryRefID;
        caption=databaseQuestion.caption;
        imgWidth=databaseQuestion.width;
        imgHeight=databaseQuestion.height;
        if(_question==null){
          Future.delayed(Duration(seconds: 2), () async {
            getQuestions(widget.questionId);
          });
        }
        _answer = databaseQuestion.answer;


        if (qPlayCount == qTotalCount && QuestionRefID == "") {
          Constants.scheduleRefID = (prefs.getString('scheduleRefID') ?? "");

          // await prefs.setString('scheduleRefID', "");

          simpleAudioPlayer.stop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      WinnerList(scheduleRefID:(prefs.getString('scheduleRefID') ?? ""))));
        }
      });
    });
  }
  @override
  void initState() {
    simpleAudioPlayer = SimpleAudioPlayer();
    simpleAudioPlayer.songStateStream.listen((event) {

    });

    simpleAudioPlayer.prepare(uri: question_load);

    simpleAudioPlayer.setPlaybackRate(rate: rateValue);
    simpleAudioPlayer.play();
    readSharedPrefs();
    deviceAuthCheck();
    syncData();
    Constants.printMsg("printMsg Question RefId:$QuestionRefID");

    if(qPlayCount==qTotalCount && QuestionRefID==""){
      // simpleAudioPlayer.stop();
    }

    subscription = Connectivity().onConnectivityChanged.listen((
        ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        navigateofflinescreen();
      }
      if (result == ConnectivityResult.mobile) {

      }
      // Got a new connectivity status!
    });


    _readQuestionNavigation();
    _answerContainer();
    _submitContainer();
    _timeupContainer();
    _submitButtonEnable();
    super.initState();
    tappedIndex = 0;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    );
    //_animationController.addListener(() => setState(() {}));
    //_animationController.repeat();
    selectedIndex = -1;

    Future.delayed(Duration(seconds: 0), () async{
      //if(Durations.questionTimerBased==0) {
        final prefs = await SharedPreferences.getInstance();
        var QuestionRefID=(prefs.getString('QuestionRefID') ?? "");
        if (qPlayCount == qTotalCount && QuestionRefID == "") {
          Constants.scheduleRefID = (prefs.getString('scheduleRefID') ?? "");

          await prefs.setString('scheduleRefID', "");

          simpleAudioPlayer.stop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      WinnerList(scheduleRefID:(prefs.getString('scheduleRefID') ?? ""))));
        }
      //}
    });

  }
  String answerStatus="";
  String responseCode="";
  String responseDescription="";
  String correctAnswer="";
  dbQuestionInsert(qSchemeRefID,scheduleRefID,questionRefID,answerPick) async {
    final prefs = await SharedPreferences.getInstance();
    questionRefID = (prefs.getString('questionRefID') ?? 0);
    log+="storage questionRefID:-"+questionRefID+"\n";
    log+="widget questionId:-"+widget.questionId+"\n";
    log+="Schedule Refid:-"+scheduleRefID+"\n";
    log+="qSchemeRefID:-"+qSchemeRefID+"\n";

    databaseQuestionInsert.answerinsert(qSchemeRefID,scheduleRefID,questionRefID,answerPick)
        .whenComplete(() {
      log+="answerinsertBody:"+databaseQuestionInsert.answerinsertBody;
      var correctAnswerindex="";
      setState(() {

        // if(databaseQuestionInsert.responseCode!="0") {
        //   dbQuestionInsert(qSchemeRefID,scheduleRefID,questionRefID,answerPick);
        // }
        answerStatus=databaseQuestionInsert.answerStatus;
        log+="answerStatus:-"+databaseQuestionInsert.answerStatus+"\n";
        responseCode=databaseQuestionInsert.responseCode;
        log+="responseCode:-"+responseCode+"\n";
        responseDescription=databaseQuestionInsert.responseDescription;
        log+="responseDescription:-"+responseDescription+"\n";
        correctAnswer==databaseQuestionInsert.correctAnswer;
        log+="correctAnswer:-"+correctAnswer+"\n";

        //showSnackBarWithoutExit("Response Code:"+responseCode);
        //showSnackBarWithoutExit("Response Description:"+responseDescription);
        if(responseCode!="0") {
          Future.delayed(Duration(seconds: 2), () async {
            _animationController.dispose();
            //showSnackBarWithoutExit("Poor Network-2");
            log+="Poor Network-2\n";
            if(scheduleRefID==null || scheduleRefID=="null" || scheduleRefID==""){
              scheduleRefID=widget.scheduleRefID;
            }
            log+="Schedule Refid Poor Network Section:-"+scheduleRefID+"\n";
            databaseQuestionInsert.answerresponsepoornetwork(scheduleRefID,questionRefID)
                .whenComplete(() {

              // if(databaseQuestionInsert.responseCode!="0") {
              //   dbQuestionInsert(qSchemeRefID,scheduleRefID,questionRefID,answerPick);
              // }
              log+="answerresponsepoornetworkBody:"+databaseQuestionInsert.answerinsertPoorNetworkBody;
              var responseCode1=databaseQuestionInsert.responseCode1;
              var responseDescription1=databaseQuestionInsert.responseDescription1;
              Constants.printMsg("Poor Network-2 Response Code:"+responseCode1+"\n");
              log+="Poor Network-2 Response Code:"+responseCode1+"\n";
              Constants.printMsg("Poor Network-2 Response Description:"+responseDescription1);
              log+="Poor Network-2 Response Description:"+responseDescription1+"\n";
              var winningPrice1=databaseQuestionInsert.winningPrice1.toString();
              log+="Poor Network-2 Response winningPrice1:"+winningPrice1+"\n";
              Constants.printMsg("Poor Network-2 Response winningPrice1:"+winningPrice1);
              var answerStatus1=databaseQuestionInsert.answerStatus1;
              var correctAnswer1=databaseQuestionInsert.correctAnswer1;
              if (responseCode1 ==
                  "0") {
                poornetworkflag="correct";

                if(correctAnswer1.toString()=='A'){
                  correctAnswerindex="0";
                }
                if(correctAnswer1.toString()=='B'){
                  correctAnswerindex="1";
                }
                if(correctAnswer1.toString()=='C'){
                  correctAnswerindex="2";
                }
                if (answerStatus1 == "0") {
                  //_animationController.dispose();
                  //simpleAudioPlayer.stop();// Winner
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HoldPercentWinner(
                              option:databaseQuestion.option,
                              question:
                              _question,
                              selectedQues:selectedQues,
                              answerstring:databaseQuestion.answer.toString(),
                              questionRefID:questionRefID,
                              winningPrice:winningPrice1,
                              correctAnswer:correctAnswerindex,
                              qPlayCount:qPlayCount,
                              qTotalCount:qTotalCount,
                              page:'correct'
                          )),
                          (e) => false);
                }

                if (answerStatus1 == "1") {
                  poornetworkflag="wrong";
                  // _animationController.dispose();
                  //simpleAudioPlayer.stop();// Wrong
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HoldPercentWinner(
                              option:databaseQuestion.option,
                              question:
                              _question,
                              selectedQues:selectedQues,
                              answerstring:databaseQuestion.answer.toString(),
                              questionRefID:questionRefID,
                              winningPrice:"0",
                              correctAnswer:correctAnswerindex,
                              qPlayCount:qPlayCount,
                              qTotalCount:qTotalCount,
                              page:'wrong'
                          )),
                          (e) => false);
                }

                if (answerStatus1 == "2") {
                  poornetworkflag="timesup";
                  // _animationController.dispose();
                  //simpleAudioPlayer.stop();// Time Up
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HoldPercentWinner(
                              option:databaseQuestion.option,
                              question:
                              _question,
                              selectedQues:selectedQues,
                              answerstring:databaseQuestion.answer.toString(),
                              questionRefID:questionRefID,
                              winningPrice:"0",
                              correctAnswer:correctAnswerindex,
                              qPlayCount:qPlayCount,
                              qTotalCount:qTotalCount,
                              page:'timesup'
                          )),
                          (e) => false);
                }

                if (answerStatus1 == "3") { // Time Up
                  // _animationController.dispose();
                }


                if (answerStatus1 == "4") {
                  poornetworkflag="almost";
                  // _animationController.dispose();
                  //simpleAudioPlayer.stop();// Time Up
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HoldPercentWinner(
                              option:databaseQuestion.option,
                              question:
                              _question,
                              selectedQues:selectedQues,
                              answerstring:databaseQuestion.answer.toString(),
                              questionRefID:questionRefID,
                              winningPrice:"0",
                              correctAnswer:correctAnswerindex,
                              qPlayCount:qPlayCount,
                              qTotalCount:qTotalCount,
                              page:'almost'
                          )),
                          (e) => false);
                }
              }
            });


          });
        }
        if (responseCode ==
            "0") {
          poornetworkflag="correct";

          if(correctAnswer.toString()=='A'){
            correctAnswerindex="0";
          }
          if(correctAnswer.toString()=='B'){
            correctAnswerindex="1";
          }
          if(correctAnswer.toString()=='C'){
            correctAnswerindex="2";
          }
          if (answerStatus == "0") {
            _animationController.dispose();
            //simpleAudioPlayer.stop();// Winner
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HoldPercentWinner(
                        option:databaseQuestion.option,
                        question:
                        _question,
                        selectedQues:selectedQues,
                        answerstring:databaseQuestion.answer.toString(),
                        questionRefID:questionRefID,
                        winningPrice:databaseQuestionInsert.winningPrice.toString(),
                        correctAnswer:correctAnswerindex,
                        qPlayCount:qPlayCount,
                        qTotalCount:qTotalCount,
                        page:'correct'
                    )),
                    (e) => false);
          }

          if (answerStatus == "1") {
            poornetworkflag="wrong";
            _animationController.dispose();
            //simpleAudioPlayer.stop();// Wrong
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HoldPercentWinner(
                        option:databaseQuestion.option,
                        question:
                        _question,
                        selectedQues:selectedQues,
                        answerstring:databaseQuestion.answer.toString(),
                        questionRefID:questionRefID,
                        winningPrice:databaseQuestionInsert.winningPrice.toString(),
                        correctAnswer:correctAnswerindex,
                        qPlayCount:qPlayCount,
                        qTotalCount:qTotalCount,
                        page:'wrong'
                    )),
                    (e) => false);
          }

          if (answerStatus == "2") {
            poornetworkflag="timesup";
            _animationController.dispose();
            //simpleAudioPlayer.stop();// Time Up
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HoldPercentWinner(
                        option:databaseQuestion.option,
                        question:
                        _question,
                        selectedQues:selectedQues,
                        answerstring:databaseQuestion.answer.toString(),
                        questionRefID:questionRefID,
                        winningPrice:databaseQuestionInsert.winningPrice.toString(),
                        correctAnswer:correctAnswerindex,
                        qPlayCount:qPlayCount,
                        qTotalCount:qTotalCount,
                        page:'timesup'
                    )),
                    (e) => false);
          }

          if (answerStatus == "3") { // Time Up
            _animationController.dispose();
          }


          if (answerStatus == "4") {
            poornetworkflag="almost";
            // _animationController.dispose();
            //simpleAudioPlayer.stop();// Time Up
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HoldPercentWinner(
                        option:databaseQuestion.option,
                        question:
                        _question,
                        selectedQues:selectedQues,
                        answerstring:databaseQuestion.answer.toString(),
                        questionRefID:questionRefID,
                        winningPrice:"0",
                        correctAnswer:correctAnswerindex,
                        qPlayCount:qPlayCount,
                        qTotalCount:qTotalCount,
                        page:'almost'
                    )),
                    (e) => false);
          }

        }

      });
    });
  }
  showSnackBar(message) async {
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
    //Constants.qsid="";
    //await //prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
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


  navigateofflinescreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }

  void onEnd() {

  }



  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  late AnimationController _animationController;
  String correctAnswerChoosen = "";
  final _formKey = GlobalKey<FormBuilderState>();
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  int endTime = DateTime
      .now()
      .millisecondsSinceEpoch +
      Duration(seconds: 30).inMilliseconds; // Constants.granttotalquestionduration=30;
  late int tappedIndex;
  String finalD = '';
  bool questionContainer = true;
  bool answerContainer = false;
  bool submitContainer = false;
  late Timer _timer1;
  late Timer _timer2;
  late Timer _timer3;
  //int currentQuestion = 0;
  //int totalQuestion = 0;
  //int activeQuestion = 0;
  var _question='';
  var caption="Loading...";
  var categoryRefID;
  var imgWidth;
  var imgHeight;
  var _answer;



  _answerContainer() {
    _timer3 = Timer( Duration(seconds:5), () { // Constants.answercontainerduration 5
      setState(() {
        answerContainer = true;
        simpleAudioPlayer = SimpleAudioPlayer();
        simpleAudioPlayer.songStateStream.listen((event) {

        });
        simpleAudioPlayer.prepare(uri: option_load);
        simpleAudioPlayer.setPlaybackRate(rate: rateValue);
        simpleAudioPlayer.play();
      });
    });
  }

  _submitContainer() {
    _timer2 = Timer( Duration(seconds: 10), () { // Constants.submitcontainerduration 10
      setState(() {
        submitContainer = true;

      });
    });
  }

  _submitButtonEnable() {
    //_timer2 = Timer( Duration(seconds: Durations.totalquestionduration), () { // Constants.totalquestionduration 15
      setState(() {
        //is_submitted=false;
        submitContainer=false;
        timer_container_1=false;
        timer_container_2=true;
      });
    //});
  }


  _timeupContainer() async {
   // _timer2 = Timer( Duration(seconds: Durations.timeupduration), () { // Constants.timeupduration 20
      if (selectedQues == "" || is_submitted==false) {
        answerPick="T";
      }
      /*if(Durations.questionviewdevelopent>0) {
        if(Durations.development==1) {
          dbQuestionInsert(qSchemeRefID, widget.scheduleRefID,
              databaseQuestion.questionRefID.toString(), answerPick);
        }
      }*/


   // });
  }
  void _readQuestionNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //totalQuestion = (prefs.getInt('TOTALQUESTION') ?? 0);
      //currentQuestion = (prefs.getInt('CURRENTQUESTION') ?? 0);
      //activeQuestion = currentQuestion + activeQuestion;
    });
  }
  void createHighlightOverlay({
    required AlignmentDirectional alignment,
    required Color borderColor,
  }) {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);

    overlayEntry = OverlayEntry(
      // Create a new OverlayEntry.
      builder: (BuildContext context) {
        // Align is used to position the highlight overlay
        // relative to the NavigationBar destination.
        return SafeArea(
          child: Align(
            alignment: alignment,
            heightFactor: 1.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Builder(builder: (BuildContext context) {
                    return  Column(
                      children: <Widget>[
                        Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),

                      ],
                    );

                  }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width ,
                    height: 50.0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
  @override
  void dispose() {
    //_timer.cancel();
    removeHighlightOverlay();
    super.dispose();
  }
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
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

  Future<void> closeAppUsingExit() async {
    unwantedClick="Unusual action deducted";
    setState(() {
      answerPick="T";
    });
  }
  @override
  Widget build(BuildContext context) {



    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    // final percentage = _animationController.value * 15;

    return  WillPopScope(
        onWillPop: () async {
          //showCloseAppConfirm(context);
          // await showDialog or Show add banners or whatever
          // return true if the route to be popped
          return false; // return false if you want to disable device back button click
        },
        child:Scaffold(

            backgroundColor:Color(0xffededed),
            appBar:  QuestionViewAppBar(
              // mainBalance: (mainBalance!='')?mainBalance:"0.00",

              height: 100,
              amount: '',
              child: Stack(
                children: [

                ],
              ),
            ),
            /* appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: GestureDetector(
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
          title: ( QuestionRefID!="")?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Question",
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              Text(
                qPlayCount.toString(),
                style: TextStyle(color: Colors.black),
              ),
              const Text(
                "/",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Text(
                qTotalCount.toString(),
                style: TextStyle(color: Colors.black, fontSize: 28),
              )
            ],
          ):SizedBox(),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/logo.png",
                width: 40,
                height: 40,
              ),
              onPressed: () {},
            ),
          ],

        ),

        backgroundColor: Color(0xFFD9D9D9),
*/

            body: Container(
                width: double.infinity,
                child: Container(
                  // textquestioneTK (0:40)
                  width: double.infinity,
                  decoration: BoxDecoration (
                    color: Color(0xffededed),
                  ),
                  child: SingleChildScrollView(child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // autogroup4xz5vZF (f5NEFGJt42jsRKyBe4xz5)
                        width: 958*fem,
                        height: 780*fem,
                        child: Stack(
                          children: [
                            Positioned(
                              // Cmf (0:45)
                              left: 23*fem,
                              top: 50*fem,
                              child: Container(
                                width: 366*fem,
                                height: 575*fem,
                                decoration: BoxDecoration (
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.only (
                                    topLeft: Radius.circular(8*fem),
                                    topRight: Radius.circular(8*fem),
                                    bottomRight: Radius.circular(20*fem),
                                    bottomLeft: Radius.circular(20*fem),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3d000000),
                                      offset: Offset(0*fem, 0*fem),
                                      blurRadius: 2*fem,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // group9Dgm (0:46)
                                      width: double.infinity,
                                      height: 275*fem,
                                      decoration: BoxDecoration (
                                        borderRadius: BorderRadius.circular(8*fem),
                                      ),
                                      child: Container(
                                        // frame1KtD (0:47)
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration (
                                          color: Color(0x49e9e7e8),
                                          borderRadius: BorderRadius.circular(8*fem),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // autogroup5zvmseq (f5NVuUtEKh5R33Jjw5zvm)
                                      padding: EdgeInsets.fromLTRB(0*fem, 50*fem, 0*fem, 0*fem),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [


                                          SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                const NeverScrollableScrollPhysics(),
                                                itemCount: databaseQuestion
                                                    .option.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                      child: Card(
                                                        elevation: 0,
                                                        key: ValueKey(
                                                            databaseQuestion
                                                                .option[index]),
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: Container(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                15.0),
                                                            decoration:
                                                            BoxDecoration(
                                                                color: (selectedIndex ==
                                                                    index)
                                                                    ?  _colorFromHex(Constants.baseThemeColor)
                                                                    : const Color(
                                                                    0xffFFFFFF),
                                                                border: Border.all(
                                                                    color: (selectedIndex ==
                                                                        index)
                                                                        ?  _colorFromHex(Constants.baseThemeColor)
                                                                        : const Color(
                                                                        0xffC8C8C8)),
                                                                borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                                  topRight:
                                                                  Radius.circular(
                                                                      12.0),
                                                                  bottomRight:
                                                                  Radius.circular(
                                                                      12.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                      12.0),
                                                                  bottomLeft:
                                                                  Radius.circular(
                                                                      12.0),
                                                                )),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                (selectedIndex ==
                                                                    index)
                                                                    ? Image.asset(
                                                                    "assets/radio-on.png")
                                                                    : Image.asset(
                                                                    "assets/radio-off.png"),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                    child: /*Text(
                                                                      databaseQuestion
                                                                              .option[
                                                                          index],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: (selectedIndex == index)
                                                                              ? Color(0xffffffff)
                                                                              : Color(0xff000000)),
                                                                    )*/
                                                                    Container(
                                                                      /*child: ConstrainedBox(
                                                                      constraints: BoxConstraints(
                                                                        minWidth: 300.0,
                                                                        maxWidth: 300.0,
                                                                        minHeight: 30.0,
                                                                        maxHeight: 100.0,
                                                                      ),*/
                                                                      child:  Text(
                                                                        databaseQuestion
                                                                            .option[
                                                                        index],
                                                                        //overflow:TextOverflow.clip,
                                                                        maxLines: 2,
                                                                        softWrap: true,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            16,
                                                                            color: (selectedIndex == index)
                                                                                ? Color(0xffffffff)
                                                                                : Color(0xff000000)),
                                                                      ),
                                                                      // ),
                                                                    )),
                                                                const Expanded(
                                                                    child:
                                                                    SizedBox(
                                                                      width: 150,
                                                                    )),
                                                                Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .centerRight,
                                                                    child: (is_submitted)
                                                                        ? Image.asset(
                                                                        'assets/question-lock.png')
                                                                        : SizedBox())
                                                              ],
                                                            )),
                                                      ),
                                                      onTap: () {
                                                        Constants.printMsg("Ontap calling when selected options A");
                                                        setState(() {
                                                          if (is_submitted==false) {
                                                            if(index==0){
                                                              answerPick="A";
                                                            }
                                                            if(index==1){
                                                              answerPick="B";
                                                            }
                                                            if(index==2){
                                                              answerPick="C";
                                                            }
                                                            selectedIndex =
                                                                index;

                                                            selectedQues =
                                                            databaseQuestion
                                                                .option[
                                                            index];
                                                          }
                                                        
                                                          //  if(Durations.development==0) {
                                                              if (index == 0) {
                                                                answerPick = "A";
                                                              }
                                                              if (index == 1) {
                                                                answerPick = "B";
                                                              }
                                                              if (index == 2) {
                                                                answerPick = "C";
                                                              }
                                                              selectedIndex =
                                                                  index;
                                                        
                                                              selectedQues =
                                                              databaseQuestion
                                                                  .option[
                                                              index];
                                                           // }

                                                        });
                                                        //if(Durations.development==0){
                                                          Constants.printMsg("Ontap calling when selected options B");
                                                          dbQuestionInsert(qSchemeRefID,widget.scheduleRefID,widget.questionId,answerPick);
                                                        //}
                                                      });
                                                },
                                              )),
                                          /*
                                        Container(
                                          // frame762465zjT (0:138)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                          padding: EdgeInsets.fromLTRB(12*fem, 14*fem, 17*fem, 14*fem),
                                          width: double.infinity,
                                          height: 48*fem,
                                          decoration: BoxDecoration (
                                            color: Color(0xff11e5dd),
                                            borderRadius: BorderRadius.circular(12*fem),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // frame1275HCm (0:141)
                                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 241*fem, 0*fem),
                                                height: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      // group1317nfK (0:142)
                                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                                      width: 20*fem,
                                                      height: 20*fem,
                                                      child: Image.asset(
                                                        'assets/question/group-1317.png',
                                                        width: 20*fem,
                                                        height: 20*fem,
                                                      ),
                                                    ),
                                                    Text(
                                                      // airDEq (0:145)
                                                      'Air',
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 16*ffem,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.125*ffem/fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // vectoru7f (0:146)
                                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 2*fem),
                                                width: 11*fem,
                                                height: 14*fem,
                                                child: Image.asset(
                                                  'assets/question/vector.png',
                                                  width: 11*fem,
                                                  height: 14*fem,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // frame1274pEd (0:147)
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // frame2AJV (0:148)
                                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                                                padding: EdgeInsets.fromLTRB(12*fem, 14*fem, 12*fem, 14*fem),
                                                width: double.infinity,
                                                height: 48*fem,
                                                decoration: BoxDecoration (
                                                  border: Border.all(color: Color(0xffc7c7c7)),
                                                  borderRadius: BorderRadius.circular(12*fem),
                                                ),
                                                child: Container(
                                                  // frame1276fFF (0:150)
                                                  width: 77*fem,
                                                  height: double.infinity,
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        // group241a1 (0:151)
                                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                                        width: 20*fem,
                                                        height: 20*fem,
                                                        child: Image.asset(
                                                          'assets/question/group-24.png',
                                                          width: 20*fem,
                                                          height: 20*fem,
                                                        ),
                                                      ),
                                                      Text(
                                                        // waterjW1 (0:153)
                                                        'Water',
                                                        style: SafeGoogleFont (
                                                          'Open Sans',
                                                          fontSize: 16*ffem,
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.125*ffem/fem,
                                                          color: Color(0xff000000),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                // frame3s6R (0:154)
                                                padding: EdgeInsets.fromLTRB(12*fem, 14*fem, 12*fem, 14*fem),
                                                width: double.infinity,
                                                height: 48*fem,
                                                decoration: BoxDecoration (
                                                  border: Border.all(color: Color(0xffc7c7c7)),
                                                  borderRadius: BorderRadius.circular(12*fem),
                                                ),
                                                child: Container(
                                                  // frame1277C8h (0:157)
                                                  width: 57*fem,
                                                  height: double.infinity,
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        // ellipse3YCZ (0:158)
                                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                                        width: 20*fem,
                                                        height: 20*fem,
                                                        decoration: BoxDecoration (
                                                          borderRadius: BorderRadius.circular(10*fem),
                                                          border: Border.all(color: Color(0xffc7c7c7)),
                                                          color: Color(0xffffffff),
                                                        ),
                                                      ),
                                                      Text(
                                                        // skyFsf (0:159)
                                                        'sky',
                                                        style: SafeGoogleFont (
                                                          'Open Sans',
                                                          fontSize: 16*ffem,
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.125*ffem/fem,
                                                          color: Color(0xff000000),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                    (categoryRefID=="1")?Positioned(
                              // frame762464YkH (0:120)
                              left: 23*fem,
                              top: 100*fem,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(21*fem, 40*fem, 21*fem, 59*fem),
                                width: 368*fem,
                                height: 195*fem,
                                decoration: BoxDecoration (
                                  image: DecorationImage (
                                    fit: BoxFit.cover,
                                    image: AssetImage (
                                      'assets/question/frame-762466.png',
                                    ),
                                  ),
                                ),
                                child: Center(
                                  // soundtravelsthefastestinwhicho (0:136)
                                  child: SizedBox(
                                    child: Container(
                                      constraints: BoxConstraints (
                                        maxWidth: 288*fem,
                                      ),
                                      child: (_question != null)
                                          ?Text(
                                        _question,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 22*ffem,
                                          fontWeight: FontWeight.w800,
                                          height: 1.4545454545*ffem/fem,
                                          color: Color(0xffffffff),
                                        ),
                                      ): CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ):Positioned(
                              // frame762405LMf (0:374)
                              left: 23*fem,
                              top: 100*fem,
                              child: (_question != null)
                                  ?Container(
                                padding: EdgeInsets.fromLTRB(0*fem, 158*fem, 0*fem, 0*fem),
                                width: 366*fem,
                                height: 195*fem,
                                decoration: BoxDecoration (
                                  color: Color(0xfffefefe),
                                  borderRadius: BorderRadius.circular(18*fem),
                                  image: DecorationImage (
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_question),
                                  ),
                                ),
                                child: Align(
                                  // rectangle3ca5 (0:376)
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                    width: 92*fem,
                                    height: 58*fem,
                                    child: SizedBox(),
                                  ),
                                ),
                              ):CircularProgressIndicator(),
                            ),

                            Positioned(
                              // questions15Vow (0:137)
                              left: 175.5*fem,
                              top: 50.5*fem,
                              child:Container(
                                // padding: EdgeInsets.only(top: 20),
                                  height: 35.0,
                                  width: 197.0,
                                  decoration: BoxDecoration (
                                    image: DecorationImage (
                                      fit: BoxFit.cover,
                                      image: AssetImage (
                                        'assets/background/question_indication.png',
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Align(
                                      child: SizedBox(
                                        width: 131*fem,
                                        height: 28*fem,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 18*ffem,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.45*fem,
                                              color: Color(0xffffffff),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Questions ',
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 18*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.3*ffem/fem,
                                                  letterSpacing: 0.45*fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                              TextSpan(
                                                text: qPlayCount.toString(),
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 21*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.3*ffem/fem,
                                                  letterSpacing: 0.525*fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                              TextSpan(
                                                text: '/',
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 18*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3*ffem/fem,
                                                  letterSpacing: 0.45*fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                              TextSpan(
                                                text: qTotalCount.toString(),
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 18*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3*ffem/fem,
                                                  letterSpacing: 0.45*fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            Positioned(
                              // choosethecorrectNRo (0:160)
                              left: 37*fem,
                              top: 60*fem,
                              child: Align(
                                child: SizedBox(
                                  width: 129*fem,
                                  height: 32*fem,
                                  child: Text(
                                    (categoryRefID=="1")?'Choose the Correct'+answeralphapet:caption+answeralphapet,
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 15*ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 2.1333333333*ffem/fem,
                                      letterSpacing: -0.825*fem,
                                      color: Color(0xffaaaaaa),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // group1172Ti9 (0:161)
                              left: 157*fem,
                              top: 250*fem,
                              child: Container(
                                width: 99*fem,
                                height: 99*fem,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // group1169Prh (0:162)
                                      left: 15*fem,
                                      top: 10*fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 75*fem,
                                          height: 75*fem,
                                          child: (timer_container_1)?CircularCountDownTimer(
                                            // Countdown duration in Seconds.
                                            duration: _duration,

                                            // Countdown initial elapsed Duration in Seconds.
                                            initialDuration: 0,

                                            // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                                            controller: _controller,

                                            // Width of the Countdown Widget.
                                            width: MediaQuery.of(context).size.width / 5,

                                            // Height of the Countdown Widget.
                                            height: MediaQuery.of(context).size.height / 5,

                                            // Ring Color for Countdown Widget.
                                            ringColor: Colors.grey[300]!,

                                            // Ring Gradient for Countdown Widget.
                                            ringGradient: null,

                                            // Filling Color for Countdown Widget.
                                            fillColor: Colors.pink!,

                                            // Filling Gradient for Countdown Widget.
                                            fillGradient: null,

                                            // Background Color for Countdown Widget.
                                            backgroundColor: Color(0xff10CEE8),

                                            // Background Gradient for Countdown Widget.
                                            backgroundGradient: null,

                                            // Border Thickness of the Countdown Ring.
                                            strokeWidth: 5.0,

                                            // Begin and end contours with a flat edge and no extension.
                                            strokeCap: StrokeCap.round,

                                            // Text Style for Countdown Text.
                                            textStyle: const TextStyle(
                                              fontSize: 28.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),

                                            // Format for the Countdown Text.
                                            textFormat: CountdownTextFormat.S,

                                            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                                            isReverse: true,

                                            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                                            isReverseAnimation: true,

                                            // Handles visibility of the Countdown Text.
                                            isTimerTextShown: true,

                                            // Handles the timer start.
                                            autoStart: true,

                                            // This Callback will execute when the Countdown Starts.
                                            onStart: () {
                                              // Here, do whatever you want
                                            },

                                            // This Callback will execute when the Countdown Ends.
                                            onComplete: () {
                                              // Here, do whatever you want

                                            },

                                            // This Callback will execute when the Countdown Changes.
                                            onChange: (String timeStamp) {
                                              // Here, do whatever you want

                                            },

                                            /*
            * Function to format the text.
            * Allows you to format the current duration to any String.
            * It also provides the default function in case you want to format specific moments
              as in reverse when reaching '0' show 'GO', and for the rest of the instances follow
              the default behavior.
          */
                                            timeFormatterFunction: (defaultFormatterFunction, duration) {
                                              if (duration.inSeconds == 0) {
                                                // only format for '0'
                                                return "0";
                                              } else {
                                                // other durations by it's default format
                                                return Function.apply(defaultFormatterFunction, [duration]);
                                              }
                                            },
                                          ):SizedBox(),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      // group1169Prh (0:162)
                                      left: 15*fem,
                                      top: 10*fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 75*fem,
                                          height: 75*fem,
                                          child: (timer_container_2)?CircularCountDownTimer(
                                            // Countdown duration in Seconds.
                                            duration: _duration_timer2,

                                            // Countdown initial elapsed Duration in Seconds.
                                            initialDuration: 0,

                                            // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                                            controller: _controller,

                                            // Width of the Countdown Widget.
                                            width: MediaQuery.of(context).size.width / 5,

                                            // Height of the Countdown Widget.
                                            height: MediaQuery.of(context).size.height / 5,

                                            // Ring Color for Countdown Widget.
                                            ringColor: Colors.grey[300]!,

                                            // Ring Gradient for Countdown Widget.
                                            ringGradient: null,

                                            // Filling Color for Countdown Widget.
                                            fillColor: Colors.red!,

                                            // Filling Gradient for Countdown Widget.
                                            fillGradient: null,

                                            // Background Color for Countdown Widget.
                                            backgroundColor: Colors.pink,

                                            // Background Gradient for Countdown Widget.
                                            backgroundGradient: null,

                                            // Border Thickness of the Countdown Ring.
                                            strokeWidth: 5.0,

                                            // Begin and end contours with a flat edge and no extension.
                                            strokeCap: StrokeCap.round,

                                            // Text Style for Countdown Text.
                                            textStyle: const TextStyle(
                                              fontSize: 28.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),

                                            // Format for the Countdown Text.
                                            textFormat: CountdownTextFormat.S,

                                            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                                            isReverse: true,

                                            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                                            isReverseAnimation: true,

                                            // Handles visibility of the Countdown Text.
                                            isTimerTextShown: true,

                                            // Handles the timer start.
                                            autoStart: true,

                                            // This Callback will execute when the Countdown Starts.
                                            onStart: () {
                                              // Here, do whatever you want

                                            },

                                            // This Callback will execute when the Countdown Ends.
                                            onComplete: () {
                                              // Here, do whatever you want

                                            },

                                            // This Callback will execute when the Countdown Changes.
                                            onChange: (String timeStamp) {
                                              // Here, do whatever you want

                                            },

                                            /*
            * Function to format the text.
            * Allows you to format the current duration to any String.
            * It also provides the default function in case you want to format specific moments
              as in reverse when reaching '0' show 'GO', and for the rest of the instances follow
              the default behavior.
          */
                                            timeFormatterFunction: (defaultFormatterFunction, duration) {
                                              if (duration.inSeconds == 0) {
                                                // only format for '0'
                                                return "0";
                                              } else {
                                                // other durations by it's default format
                                                return Function.apply(defaultFormatterFunction, [duration]);
                                              }
                                            },
                                          ):SizedBox(),
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Container(
                      // autogroupchs1CJM (f5PLP67PPkNjKCC2cCHS1)
                      padding: EdgeInsets.fromLTRB(25*fem, 38*fem, 23*fem, 8*fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // frame1inV (0:48)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 21*fem),
                            width: double.infinity,
                            height: 44*fem,
                            decoration: BoxDecoration (
                              color: Color(0xffffb400),
                              borderRadius: BorderRadius.circular(12*fem),
                            ),
                            child: Center(
                              child: Text(
                                'Submit Answer',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont (
                                  'Open Sans',
                                  fontSize: 14*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2857142857*ffem/fem,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // itemsAeV (0:42)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 2*fem, 0*fem),
                            width: 146.83*fem,
                            height: 5*fem,
                            child: Image.asset(
                              'assets/question/items.png',
                              width: 146.83*fem,
                              height: 5*fem,
                            ),
                          ),
                        ],
                      ),
                    ),*/



                      (is_submitted)
                          ? Container(
                        margin: EdgeInsets.fromLTRB(
                            23 * fem, 0 * fem, 33 * fem, 21 * fem),
                        padding: EdgeInsets.fromLTRB(
                            4 * fem, 0 * fem, 0 * fem, 0 * fem),
                        width: double.infinity,
                        height: 56 * fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(
                            //       0 * fem, 2 * fem, 20 * fem, 20 * fem),
                            //   width: 24 * fem,
                            //   height: 28 * fem,
                            //   child: Image.asset(
                            //     'assets/icons/bi_hourglass-split.png',
                            //     width: 24 * fem,
                            //     height: 28 * fem,
                            //   ),
                            // ),
                            Container(
                              height: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    'Loading the Results...',
                                    style: SafeGoogleFont(
                                      'Open Sans',
                                      fontSize: 24 * ffem,
                                      fontWeight: FontWeight.w800,
                                      height: 1.3333333333 * ffem / fem,
                                      color: Color(0xff404040),
                                    ),
                                  ),
                                  Text(
                                    'Let’s see what’s the correct answer.',
                                    style: SafeGoogleFont(
                                      'Open Sans',
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xff404040),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                          : SizedBox(),
                      // (unwantedClick!='')?Text(unwantedClick, style: TextStyle(
                      //     color: Colors.red,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18.0)):SizedBox(),
                      const SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                  ),
                )),
            bottomNavigationBar: (submitContainer == true && !is_submitted)
                ? GestureDetector(// Auto Click Enable / Disabled
                onDoubleTap: () {
                    setState(() {
                      Future.delayed(const Duration(seconds: 1), () {
                        closeAppUsingExit();
                      });
                    });
                },
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: (selectedQues != "")
                                ? _colorFromHex(Constants.buttonColor)
                                : Colors.black.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12), // <-- Radius
                            ) // foreground
                        ),
                        onPressed: () async {

                          simpleAudioPlayer = SimpleAudioPlayer();
                          simpleAudioPlayer.songStateStream.listen((event) {

                          });
                          simpleAudioPlayer.prepare(uri: submit_answer);
                          simpleAudioPlayer.setPlaybackRate(rate: rateValue);
                          simpleAudioPlayer.play();
                          if (selectedIndex >= 0) {
                            setState(() {
                              /*if(Durations.development==0){
                                is_submitted = true;
                                dbQuestionInsert(qSchemeRefID,widget.scheduleRefID,widget.questionId,answerPick);
                              }else {*/
                                is_submitted = true;
                             // }
                            });
                          }
                          /* createHighlightOverlay(
                            alignment: AlignmentDirectional.bottomStart,
                            borderColor: Colors.white,
                          );*/
                        },
                        child:  Text(
                          (unwantedClick!='')?unwantedClick:'Submit Answer',
                          style: TextStyle(
                              color: (unwantedClick!='')?Colors.red:Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),


                    ),
                    (Platform.isIOS)?SizedBox(height: ffem*90,):SizedBox(),
                    (!Platform.isIOS)?SizedBox(height: ffem*90,):SizedBox(),
                  ],
                )
            ) // Auto Click Enable / Disabled
                : SizedBox()));
  }
}
