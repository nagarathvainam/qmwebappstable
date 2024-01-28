import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizmaster/pages/ui/hold-processing-question.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:quizmaster/pages/ui/winner-list.dart';
import 'dart:convert';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
//import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:quizmaster/pages/Components/WinningListAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/constant/duration.dart';
import '../webview/rateus.dart';
import 'login.dart';
final conguratulations_timesup = "asset:///audios/wrong-woops-winnerlist.mp3";
//final conguratulations_congrat = "asset:///audios/wrong-woops-winnerlist.mp3";
class QuestionWinningList extends StatefulWidget {
  String question;
  String questionRefID;
  String qPlayCount;
  String qTotalCount;
  String page;
  QuestionWinningList({required this.question, required this.questionRefID,required this.qPlayCount,required this.qTotalCount,required this.page});

  @override
  _QuestionWinningListState createState() => _QuestionWinningListState();
}

class _QuestionWinningListState extends State<QuestionWinningList>  with SingleTickerProviderStateMixin {
  late SimpleAudioPlayer simpleAudioPlayer;
  double rateValue = 1.0;
  late AnimationController _animationController;
  late StreamSubscription<ConnectivityResult> subscription;
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  Question databaseQuestion = new Question();
  User databaseUser = new User();
  int question_end=1;
  final int _duration = 10;
  final CountDownController _controller = CountDownController();
  //List questionwisewinnerdata=[];
  String responseDescription="";
  String responseCode="";
  bool istaticdisplay=false;
  Duration duration = Duration(milliseconds: 270);
  late Timer _timer1;
  //int currentQuestion = 0;
  //int totalQuestion = 0;
  String displayName="";

// Sync calling...
  int qTotalCount=1;
  String log="";
  String quizwillendtext="";
  String willstartintext="";
  int qPlayCount=1;
  var qSchemeRefID="";
  String scheduleRefID="";
  String questionRefID="";
  String QuestionSynBody="";
  String QuestionSyncResponseCode="";
  String QuestionSyncResponseDescription="";

  syncData() async {
    final prefs = await SharedPreferences.getInstance();
    scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
    databaseQuestion.QuestionSync(scheduleRefID)
        .whenComplete(() async{
      setState(() {
print("databaseQuestion.responseCode");
print(databaseQuestion.responseCode);
        if(databaseQuestion.responseCode!='0'){
          Future.delayed(Duration(seconds: 2), () async {
            syncData();
          });
        }

        qTotalCount=int.parse(databaseQuestion.qTotalCount);//5 Total Question Count
        qPlayCount=int.parse(databaseQuestion.qPlayCount);
        quizwillendtext="Quiz Will End";
        willstartintext="will start in. ...";
        questionRefID=databaseQuestion.questionRefID;
        QuestionSynBody=databaseQuestion.QuestionSynBody;
        QuestionSyncResponseCode=databaseQuestion.QuestionSynResponseCode;
        QuestionSyncResponseDescription=databaseQuestion.QuestionSynResponseDescription;
        //1  Paly Count Question
        qSchemeRefID=databaseQuestion.qSchemeRefID;// Scheme Id
      });
    });
  }
// Sync calling...
  @override
  void initState() {
    getQuestionWiseWinnerData();
    simpleAudioPlayer = SimpleAudioPlayer();
    simpleAudioPlayer.songStateStream.listen((event) {

    });
    if(widget.page=='correct'){
      simpleAudioPlayer.prepare(uri: conguratulations_timesup);
    }
    if(widget.page=='timesup'){
      simpleAudioPlayer.prepare(uri: conguratulations_timesup);
    }
    if(widget.page=='wrong'){
      simpleAudioPlayer.prepare(uri: conguratulations_timesup);
    }
    if(widget.page=='almost'){
      simpleAudioPlayer.prepare(uri: conguratulations_timesup);
    }

    simpleAudioPlayer.setPlaybackRate(rate: rateValue);
    simpleAudioPlayer.play();


    //_readQuestionNavigation();
    // this.getData();
    _questionContainer();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    );
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();


    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){

      }
      // Got a new connectivity status!
    });

  }


  List questionwisewinnerdata=[];
  String IndivitualUserName="";
  String IndivitualUserPrice="";
  String IndivitualUserWinnersRank="";
  String WinnersBody="";
  String WinnersResponseCode="";
  String WinnersResponseDescription="";
  getQuestionWiseWinnerData() async {
    willstartintext="";
    quizwillendtext="";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    databaseQuestion
        .getQuestionWiseWinnerData(widget.questionRefID)
        .whenComplete(() async{
      WinnersResponseCode=databaseQuestion.WinnersResponseCode;
      print("WinnersResponseCode: $WinnersResponseCode");
      WinnersResponseDescription=databaseQuestion.WinnersResponseDescription;
      print("WinnersResponseDescription: $WinnersResponseDescription");
      //if(WinnersResponseCode=='0'){
      //   Future.delayed(Duration(seconds: 2), () async {
      //     getQuestionWiseWinnerData();
      //   });
      //}
      setState(() {
        WinnersBody=databaseQuestion.WinnersBody;
        deviceAuthCheck();
        syncData();
        //("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK:"+databaseQuestion.responseCode);

        if(databaseQuestion.responseCode!='0'){
          Future.delayed(Duration(seconds: 2), () async {
            getQuestionWiseWinnerData();
          });
        }
        questionwisewinnerdata=databaseQuestion.winnerquestiondata as List;
        for(int x = 0; x<questionwisewinnerdata.length;x++){


          if(userRefID==questionwisewinnerdata[x]['userRefID']) {
            IndivitualUserWinnersRank=questionwisewinnerdata[x]['winnersRank'];

            IndivitualUserName=questionwisewinnerdata[x]['displayName'];
            IndivitualUserPrice= questionwisewinnerdata[x]['winningPrice'];
          }
        }

      });
    });
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
    await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
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
          showSnackBar(databaseUser.responseDescription);
        });
      }else if(databaseUser.responseCode=='107'){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginUiPage(title:'You are used Old Version. Please Check &  Update the Latest Version from the Google Play Store, Tab on the Information.',url: 'https://play.google.com/store/apps/details?id=com.quizMaster.quiz_master',)),
                (e) => false);
      }else if(databaseUser.responseCode=='503'){
        setState(() {
          showSnackBar(databaseUser
              .responseDescription);
        });
      }
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
  _questionContainer() async{

    final prefs = await SharedPreferences.getInstance();
    //currentQuestion = (prefs.getInt('CURRENTQUESTION') ?? 0);

    //totalQuestion = (prefs.getInt('TOTALQUESTION') ?? 0);
    scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
    _timer1 = new Timer(const Duration(seconds: 10), () async{
      //setState(() async{
        int q=0;
        if(qPlayCount==5){
          q=qPlayCount-1;
        }else{
          q=qPlayCount;
        }

        if(qPlayCount==qTotalCount && questionRefID==""){
          simpleAudioPlayer.stop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      WinnerList(scheduleRefID: scheduleRefID)));
        }

        if(qPlayCount==widget.qTotalCount){
          simpleAudioPlayer.stop();
         /// question_end=0;
          await prefs.setInt('CURRENTQUESTION', 0);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      WinnerList(scheduleRefID: scheduleRefID)));
        }else{

          simpleAudioPlayer.stop();
          //if (Durations.questionTimerBased > 0) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        HoldQuestionProcessing(scheduleRefID: scheduleRefID)));
          /*} else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        QuestionViewUiPage(scheduleRefID: scheduleRefID,questionId: '',)));
          }*/
        }


      //});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    //_animationController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    final percentage = _animationController.value * 15;
    return WillPopScope(
        onWillPop: () async {

      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
     // drawer: const CustomDrawer(),

      appBar:  CustomAppBarWrongAnswer(
        height: 120,
        child: Stack(
          children: [

          ],
        ),
        photo: Constants.photo,
        page:widget.page
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            // Main Contetn Start Here
            SizedBox(height: 75.0,),
          /*Align(alignment:Alignment.center,child:Text("$displayName",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),),
            Text("QPLAY COUNT:$qPlayCount"),
            Text("QTOTAL COUNT:$qTotalCount"),
            Text("QUES REF ID:$questionRefID"),
            Text("widget.qPlayCount:"+widget.qPlayCount),
            Text("widget.qTotalCount:"+widget.qTotalCount),*/
            SizedBox(height: 10.0),
            Center(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  <Widget>[
                    (questionRefID!=""  && istaticdisplay==false)?Text("Question",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color:Color(0xff000000)),):SizedBox(),
                    SizedBox(width: 5.0),
                    (questionRefID!=""  && istaticdisplay==false )?Column(
                      children:  <Widget>[
                        Row(
                          children:  <Widget>[
                            Text(qPlayCount.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Color(0xff5A2DBC)),),
                            Text(" / "+qTotalCount.toString(),style: TextStyle(fontSize: 14,color:Color(0xff5A2DBC)),),
                          ],
                        )
                        //Text('Asik Mohamed'),
                      ],
                    ):SizedBox(),
                    SizedBox(width: 5.0),
                    (questionRefID=="" && istaticdisplay==false)?Text(quizwillendtext,style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color:Color(0xff000000)),):Text(willstartintext,style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color:Color(0xff000000)),),
                    //(qPlayCount==qTotalCount && questionRefID=="" && istaticdisplay==true)?Text("Quiz Will End",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color:Color(0xff000000)),):Text("Next quiz will start in. ...",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color:Color(0xff000000)),),
                  ],
                )),//:SizedBox(),
            SizedBox(height: 10),


            // (Durations.mobileLogDisplay==0)?Text("QuestionSynBody:"+QuestionSynBody,style: TextStyle(color: Colors.black)):SizedBox(),
            // (Durations.mobileLogDisplay==0)?Text("QuestionSynBody  Response Code:"+QuestionSyncResponseCode,style: TextStyle(color: Colors.black)):SizedBox(),
            // (Durations.mobileLogDisplay==0)?Text("QuestionSynBody  Response Description:"+QuestionSyncResponseDescription,style: TextStyle(color: Colors.black)):SizedBox(),
            //
            //
            // (Durations.mobileLogDisplay==0)?Text("Winners Body:"+WinnersBody,style: TextStyle(color: Colors.black)):SizedBox(),
            // (Durations.mobileLogDisplay==0)?Text("Winners  Response Code:"+WinnersResponseCode,style: TextStyle(color: Colors.black)):SizedBox(),
            // (Durations.mobileLogDisplay==0)?Text("Winners  Response Description:"+WinnersResponseDescription,style: TextStyle(color: Colors.black)):SizedBox(),


            (widget.page=='correct')?Center(
                child:Container(
                    padding: EdgeInsets.all(10),
                    height: 80,
                    decoration: BoxDecoration(
                        color: _colorFromHex(Constants.baseThemeColor),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(13),
                          bottomRight: Radius.circular(13),
                          topLeft: Radius.circular(13),
                          bottomLeft: Radius.circular(13),
                        )
                    ),
                    child:Container(
                        width: 366.0,
                        padding: EdgeInsets.only(left:35.0,right: 35.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  <Widget>[
                            Image.asset("assets/mingcute_currency-rupee-line.png"),
                            SizedBox(width: 5.0,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  <Widget>[
                                Text("Victory",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                Text(IndivitualUserPrice,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),

                              ],
                            ),
                            Expanded(child: Image.asset("assets/white-vertical-line.png")),
                            Image.asset("assets/statistics.png"),
                            SizedBox(width: 5.0,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  <Widget>[

                                Text('Rank',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                Text(IndivitualUserWinnersRank+"",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),

                              ],
                            ),


                          ],
                        )))):SizedBox(),

            (widget.page=='wrong' || widget.page=='timesup')?Center(

                child:Container(
                    padding: EdgeInsets.all(10),
                    height: 80,
                    //width: 90,
                    decoration: BoxDecoration(
                        color:  (widget.page=='timesup')?Color(0xffEC008B):Color(0xffFE5959),

                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(13),
                          bottomRight: Radius.circular(13),
                          topLeft: Radius.circular(13),
                          bottomLeft: Radius.circular(13),
                        )
                    ),
                    child:Container(
                        width: 366.0,
                        padding: EdgeInsets.only(left:35.0,right: 35.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  <Widget>[
                            Text("Don't worry, you can still \nwin.",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],
                        )))):SizedBox(),



            (widget.page=='almost')?Center(

                child:Container(
                    padding: EdgeInsets.all(10),
                    height: 80,
                    //width: 90,
                    decoration: BoxDecoration(
                        color:  Color(0xff1D5997),

                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(13),
                          bottomRight: Radius.circular(13),
                          topLeft: Radius.circular(13),
                          bottomLeft: Radius.circular(13),
                        )
                    ),
                    child:Container(
                        width: 366.0,
                        padding: EdgeInsets.only(left:35.0,right: 35.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  <Widget>[
                            Text("Correct Answer , but you can be \nfaster next time.",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],
                        )))):SizedBox(),


            SizedBox(height: 25.0),


            // Circle Count Down Timer
            CircularCountDownTimer(
              // Countdown duration in Seconds.
              duration: _duration,

              // Countdown initial elapsed Duration in Seconds.
              initialDuration: 0,

              // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
              controller: _controller,

              // Width of the Countdown Widget.
              width: MediaQuery.of(context).size.width / 10,

              // Height of the Countdown Widget.
              height: MediaQuery.of(context).size.height / 10,

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
            ),
/*
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity-10,
                  height: 25.0,
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: LiquidLinearProgressIndicator(
                    value: _animationController.value,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Color(0xff10CEE8)),
                    borderRadius: 12.0,
                    center: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: EdgeInsets.only(left: 5.0),
                            child:Text(
                              "${percentage.toStringAsFixed(0)} Sec",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),textAlign: TextAlign.left,
                            ))),
                  ),
                ),
                Align(alignment: Alignment.centerRight,child:Padding(padding:EdgeInsets.only(right: 25),child:Image.asset("assets/ri_timer-line.png"))), // Front image
              ],
            ),
*/
            SizedBox(height: 25.0),
            (responseCode=="1")?Align(alignment: Alignment.center,child:Text(responseDescription,style: TextStyle(fontSize: 20,color: Colors.red),)):SizedBox(),


            SizedBox(height: 25.0),
            (questionwisewinnerdata.length>0)?SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questionwisewinnerdata == null ? 0 : questionwisewinnerdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    var ind=index+1;
                    var yr=2023;
                    var mn=02;
                    var dt=07;
                    var hr=16;
                    var mi=00;
                    var ampm="PM";

                    var startTime = DateTime(yr, mn, dt, hr, mi);
                    if (index == 0) {
                      var yr=2023;
                      var mn=02;
                      var dt=07;
                      var hr=10;
                      var mi=50;
                      startTime = DateTime(yr, mn, dt, hr, mi);
                      ampm="AM";
                    }
                    if (index == 1) {
                      var yr=2023;
                      var mn=02;
                      var dt=07;
                      var hr=11;
                      var mi=00;
                      startTime = DateTime(yr, mn, dt, hr, mi);
                      ampm="AM";
                    }

                    if (index == 2) {
                      var yr=2023;
                      var mn=02;
                      var dt=07;
                      var hr=11;
                      var mi=59;
                      startTime = DateTime(yr, mn, dt, hr, mi);
                      ampm="AM";
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 0,left: 0,right: 0),
                      child: Column(
                        children: [
                          // First Question Started
                          Padding(
                              padding:
                              EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, top: 5.0, right: 5.0,bottom: 5.0),
                                        child: Row(
                                          textDirection: TextDirection.ltr,
                                          children: <Widget>[


                                           Text(questionwisewinnerdata[index]['winnersRank'],style: TextStyle(fontSize: 20),),
                                            SizedBox(width: 15.0,),
                                            CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage:
                                              NetworkImage(questionwisewinnerdata[index]['imgURL']),
                                              backgroundColor: Colors.transparent,
                                            ),
                                            SizedBox(width: 5.0,),
                                            SizedBox(width: 125.0,child:Text(questionwisewinnerdata[index]['displayName'])),
                                            SizedBox(width: 35.0,),

                                            Container(
                                                padding:EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: (index==0)?Color(0xff003DB5):Color(0xffF2F2F2),
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(24),
                                                      bottomRight: Radius.circular(24),
                                                      topLeft: Radius.circular(24),
                                                      bottomLeft: Radius.circular(24),
                                                    )
                                                ),

                                                child:Row(
                                                  children:  <Widget>[
                                                    //Icon(Icons.timer,color: (index==0)?Color(0xffFFFFFF):Color(0xFF808080),),
                                                    Text("₹"+questionwisewinnerdata[index]['winningPrice'],style: TextStyle(fontSize: 14,color:(index==0)?Color(0xffFFFFFF):Color(0xFF808080)),),
                                                  ],
                                                ))

                                          ],
                                        )),

                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: (index==0)?Color(0xff11E5DD):Color(0xFFffffff),
                                        border: Border.all(
                                          color: Color(0xFFe5e5e5),
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(0),
                                          bottomLeft: Radius.circular(0),
                                        )),
                                  ),

                                ],
                              )),
                          // First Question Ended

                        ],
                      ),
                      //)
                    );
                  },
                )): Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                    )),
                child:Center(

                    child:CircularProgressIndicator())
            ),
            // Main Contetn End Here
          ],
        ),
      ),

    ));
  }
}