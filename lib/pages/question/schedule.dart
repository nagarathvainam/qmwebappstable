import 'package:flutter/material.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/constant/duration.dart';
import 'package:quizmaster/pages/ui/hold-processing-question.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:quizmaster/pages/ui/schemdetails.dart';
//import 'package:quizmaster/pages/ui/scheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_countdown_timer/index.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:quizmaster/pages/Components/CustomAppBarQuestionList.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../ui/schemedetailsnew.dart';
import '../webview/rateus.dart';
import 'model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:http/http.dart';
//import 'package:wakelock/wakelock.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
//final asset = "asset:///audios/times-up.mp3";
import 'package:simple_audio_player/simple_audio_player.dart';
final asset_start_enable = "asset:///audios/join_enable_sound.mp3";


class QuestionDynamicUiPage extends StatefulWidget {
  QuestionDynamicUiPage({Key? key}) : super(key: key);

  @override
  _QuestionDynamicUiPageState createState() => _QuestionDynamicUiPageState();
}

class _QuestionDynamicUiPageState extends State<QuestionDynamicUiPage>{//  with WidgetsBindingObserver
  bool? _jailbroken;
  bool? _developerMode;
  late StreamSubscription<ConnectivityResult> subscription;
  late CountdownTimerController controller;
  late SimpleAudioPlayer simpleAudioPlayer;
  double rateValue = 1.0;
  late bool isDaytime;
  late String location; // location name for UI
  late String time; // time in that location
  late String flag; // path to asset of flag icon

  bool isMainBalance=false;
  Question databaseQuestion = new Question();
  Transactions databaseTransaction = new Transactions();
  User databaseUser = new User();
  int enableseconds=15;
  int endTime = DateTime.now().millisecondsSinceEpoch +
      Duration(seconds: 30).inMilliseconds;

  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  List data=[];
  List bendata=[];

  getData() async {
    databaseQuestion
        .getScheduleData()
        .whenComplete(() async{
      //setState(() {
        data=databaseQuestion.scheduledata as List;
      //});
    });

  }


  getVideo(){
    databaseQuestion
        .playvideo()
        .whenComplete(() async{
      Constants.openURL=databaseQuestion.openURL;
      Constants.closeURL=databaseQuestion.closeURL;
      Constants.openDuration=databaseQuestion.openDuration;
      Constants.closeDuration=databaseQuestion.closeDuration;
    });
  }

  String scheduleRefID="";
  getUserIsPlayedOrPaid() async {
    final prefs = await SharedPreferences.getInstance();
    scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
    print("getUserIsPlayedOrPaid scheduleRefID:"+scheduleRefID);
    if(scheduleRefID!=''){
      databaseQuestion.QuestionSync(scheduleRefID)
          .whenComplete(() async{
        setState(() {
          if(databaseQuestion.responseCode=="0"){
            print("Enter");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HoldQuestionProcessing(scheduleRefID: scheduleRefID,)),
                    (e) => false);
          }
        });
      });
    }
  }

  Future<void> getTime(url) async {
    // Future is a placeholder value until function is complete
    try {
      // Make the request
      Response response =
      await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      // get properties from data
      String datetime = data['datetime'];
      String offset1 = data['utc_offset'].substring(1, 3);
      String offset2 = data['utc_offset'].substring(4, 6);
      // create datetime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(
          Duration(hours: int.parse(offset1), minutes: int.parse(offset2)));

      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      time = 'Could not fetch time data';
    }
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
              /*showSnackBarSessionTimeOut(databaseUser
                  .responseDescription);*/
            });
          }
    });
  }


  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }


  String qiCoinBalance="";
  String mainBalance="";
  String oneminreached="";
  // Loading counter value on start






  @override
  void initState() {
    //WidgetsBinding.instance.removeObserver(this);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
      }
      // Got a new connectivity status!
    });
    getUserIsPlayedOrPaid();
    this.getData(); // Question Scheduler calling api
    getVideo();
    // 2016-01-25

    deviceAuthCheck();
    userinfo();

//    IndianTime();
  }

  void closeAppUsingExit() {
    exit(0);
  }

  userinfo() async{
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    //prefs.setString('scheduleRefID','');
    databaseUser
        .userinfo(await prefs.getString('qsid'))
        .whenComplete(() async{
      setState(() {
        //Constants.userRefID=databaseUser.userRefID;
        getBalance();
        getBenData();
      });
    });
  }

  getBalance(){
    databaseUser
        .balanceinfo()
        .whenComplete(() async{
      setState(() {
        qiCoinBalance=databaseUser.qiCoinBalance;
        mainBalance=databaseUser.mainBalance;
      });
    });
  }

  getBenData() async {
    databaseTransaction
        .getBenData()
        .whenComplete(() async{
      setState(() {
        bendata=databaseTransaction.bendata1 as List;
        Constants.bankCount=bendata.length;
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
  onEnd(){

  }

  showCloseAppConfirm(BuildContext context)
  {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
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
                  Expanded(child: Text('Are you sure you wish to close your app?',style: TextStyle(fontSize: 14*fem,fontWeight: FontWeight.w600),)),

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
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97
    return  WillPopScope(
        onWillPop: () async {
          showCloseAppConfirm(context);
          // await showDialog or Show add banners or whatever
          // return true if the route to be popped
          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
            backgroundColor: _colorFromHex(Constants.baseThemeColor),
            drawer: const CustomDrawer(),

            appBar:  QuestionListAppBar(
              height: 90,
              child: Stack(
                children: [

                ],
              ),
              qiCoinBalance:qiCoinBalance,
              mainBalance:mainBalance,
              photo:Constants.photo,
              isnotification:false
            ),
            body: SafeArea(
                key: scaffoldKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(0),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),


                            Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "Hey  "+Constants.surName+" "+Constants.displayName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 24),
                                )),
                            const Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "Are you ready to win big!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 14),
                                )),

                            /*Padding(
                            padding:
                            EdgeInsets.only(left: 16.0, top: 16, right: 16),
                            child: Image.asset("assets/horizontal-line-bar.png")),*/
                            const Divider(
                              height: 20,
                              thickness: 1,
                              indent: 20,
                              endIndent: 25,
                              color: Color(0xffC8C8C8),
                            ),
                            (data.length>0)?SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data == null ? 0 : data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    bool isreschdule=false;
                                    // Dynamic Do not Delete
                                    var scheduleDate=data[index]['scheduleDate'];
                                    var splitDate=scheduleDate.toString().split(" ");

                                    var datestr=splitDate[0];
                                    //var timestr=splitDate[1];
                                    //var ampmstr=splitDate[2];
                                    var datestrsplit=datestr.split("/");
                                    //var timestrsplit=timestr.split(":");

                                    var questionStartTime=data[index]['questionStartTime'];
                                    var gameStartTime=data[index]['gameStartTime'];

                                    var now = new DateTime.now();
                                    var now_utc = DateTime.now().toUtc();




                                    var currentFormatDate = new DateFormat('yyyy-MM-dd');
                                    String currentDate = currentFormatDate.format(now);
                                    bool iscomingsoon=false;
                                    if(data[index]['status']==1){
                                      //iscomingsoon=true;
                                    }

                                    if(index==1){
                                      iscomingsoon=true;
                                    }if(index==2){
                                      iscomingsoon=true;
                                    }

                                    var ind=index+1;
                                    var questitle = "Express Quiz "+ind.toString();
                                    var titlecolor="0D8E96";
                                    var yr=int.parse(currentDate.split("-")[0]);
                                    var mn=int.parse(currentDate.split("-")[1]);
                                    var dt=int.parse(currentDate.split("-")[2]);
                                    var hr=int.parse(data[index]['startHour']);

                                    var hrdisplay=(int.parse(data[index]['startHour'])>12)?int.parse(data[index]['startHour'])-12:int.parse(data[index]['startHour']);
                                    var mi=int.parse(data[index]['startMinute']);
                                    var ampm=data[index]['meridiem'];
                                    var iscurvedtop=1;
                                    var hrdisplaylen=0;
                                    if(hrdisplay.toString().length==1){
                                      hrdisplaylen=1;
                                    }


                                    var tmdisplaylen=0;
                                    if(tmdisplaylen.toString().length==1){
                                      tmdisplaylen=1;
                                    }
                                    var hrstring="";
                                    var tmstring="";
                                   // var starttimelabel=hrdisplay.toString()+":"+mi.toString()+" "+ampm;
                                    if(hrdisplay.toString().length==1){
                                      hrstring="0"+hrdisplay.toString();
                                    }else{
                                      hrstring=hrdisplay.toString();
                                    }

                                    if(mi.toString().toString().length==1){
                                      tmstring="0"+mi.toString();
                                    }else{
                                      tmstring=mi.toString();
                                    }
                                    var starttimelabel=hrstring+":"+tmstring+" "+ampm;
                                    var startTime = DateTime(yr, mn, dt, hr, mi);

                                    // Static Removed Later
                                    // Reschedule Count Donw Script Loading - Start
                                    int reachsecond=0;
                                    String scheduleStartTime="";
                                    //String questionStartTime="";
                                    scheduleStartTime=data[index]['gameStartTime'];
                                    questionStartTime=data[index]['questionStartTime'];
                                    DateTime dt1 = DateTime.parse("$currentDate $scheduleStartTime");
                                    DateTime dt2 = DateTime.parse("$currentDate $questionStartTime");
                                    Duration diff = dt2.difference(dt1);
                                    reachsecond=diff.inSeconds;

                                    // Reschedule Count Donw Script Loading - End
                                    final currentTimeStr =data[index]['currentTime'];//DateTime.now();

                                    var currentDateTimeSplit=currentTimeStr.split(" ");
                                    var currentDateSplit=currentDateTimeSplit[0].split("-");
                                    var current_yr=currentDateSplit[2];
                                    var current_mn=currentDateSplit[1];
                                    var current_dt=currentDateSplit[0];
                                    var currentTimeSplit=currentDateTimeSplit[1].split(":");
                                    var current_hr=currentTimeSplit[0];
                                    var current_mi=currentTimeSplit[1];
                                    var current_ss=currentTimeSplit[2];
                                    //var currentTime = DateTime(int.parse(current_yr), int.parse(current_mn), int.parse(current_dt), int.parse(current_hr), int.parse(current_mi));

                                    var qst=data[index]['quizStartTime'];
                                    var dtstr=qst.split("T")[0];
                                    var tmstr=qst.split("T")[1];

                                    String quizstarttime="$dtstr $tmstr";
                                    DateTime QuizecurrentTime = DateTime.parse("$current_yr-$current_mn-$current_dt $current_hr:$current_mi:$current_ss");
                                    DateTime quizStartTime = DateTime.parse("$quizstarttime");

                                    Duration quizDifference = quizStartTime.difference(QuizecurrentTime);

                                    endTime = DateTime.now().millisecondsSinceEpoch +
                                        Duration(seconds: quizDifference.inSeconds).inMilliseconds;
                                    controller =
                                        CountdownTimerController(endTime: endTime, onEnd: onEnd);

/*if(Durations.alwaysenablejointhequiz==0) {
  Navigator
      .pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SchemeDetailNewPage(
                  title: data[index]['heading1'],
                  list: data,
                  index: 1,
                  QuizTypeRefID: data[index]['quizTypeRefID'],
                  starttimelabel: data[index]['questionStartTime'],
                  currentTime: data[index]['currentTime']
              )),
          (e) => false);
}*/
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5,left: 10,right: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                            width: double.infinity,
                                            height: 246*fem,
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Stack(
                                                children: [

                                                  Positioned(
                                                    left: 0*fem,
                                                    top:  (iscomingsoon==true)?185.9415283203:196.9415283203*fem,
                                                    child: Container(
                                                      padding: EdgeInsets.fromLTRB(8*fem, 16*fem, 19*fem, (iscomingsoon==true)?13.06:3.06*fem),
                                                      width: 390*fem,
                                                      height: 49.06*fem,
                                                      decoration: BoxDecoration (
                                                        border: Border.all(color: Color(0xffe2e2e2)),
                                                        color: Color(0xffffffff),
                                                        borderRadius: BorderRadius.only (
                                                          bottomRight: Radius.circular(8*fem),
                                                          bottomLeft: Radius.circular(8*fem),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(0x14000000),
                                                            offset: Offset(4*fem, 4*fem),
                                                            blurRadius: 4*fem,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          (iscomingsoon==true)?Text("Coming Soon"):SizedBox(),
                                                          (iscomingsoon==false)?Container(
                                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 109*fem, 0*fem),
                                                            padding: EdgeInsets.fromLTRB(8*fem, 6*fem, 8*fem, 6*fem),
                                                            height: double.infinity,
                                                            decoration: BoxDecoration (
                                                              color: Color(0xffffffff),
                                                              borderRadius: BorderRadius.circular(4*fem),
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 6*fem, 0*fem),
                                                                  width: 16*fem,
                                                                  height: 16*fem,
                                                                  child: Image.asset(
                                                                    'assets/icons/schedule-time.png',
                                                                    width: 16*fem,
                                                                    height: 16*fem,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  starttimelabel,
                                                                  style: SafeGoogleFont (
                                                                    'Open Sans',
                                                                    fontSize: 14*ffem,
                                                                    fontWeight: FontWeight.w400,
                                                                    height: 1.2857142857*ffem/fem,
                                                                    color: Color(0xff000000),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ):SizedBox(),

                                                          (iscomingsoon==false)?Container(
                                                            margin: EdgeInsets.fromLTRB(0*fem, 6*fem, 0*fem, 6*fem),
                                                            height: double.infinity,
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4*fem, 0*fem),
                                                                  child: Text(
                                                                    'Starts in ',
                                                                    style: SafeGoogleFont (
                                                                      'Open Sans',
                                                                      fontSize: 14*ffem,
                                                                      fontWeight: FontWeight.w400,
                                                                      height: 1.2857142857*ffem/fem,
                                                                      color: Color(0xff000000),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: double.infinity,
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                        height: double.infinity,
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            CountdownTimer(
                                                                                textStyle: const TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 14
                                                                                ),
                                                                                onEnd: onEnd,
                                                                                endTime: endTime,
                                                                                endWidget: const Text("00 : 00 : 00",
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 14),
                                                                                )
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ):SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // frame8ZJv (1:2044)
                                                    left: 0*fem,
                                                    top: 0*fem,
                                                    child: Container(
                                                      width: 390*fem,
                                                      height: 205.2*fem,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient (
                                                          begin: Alignment(-0.672, -1),
                                                          end: Alignment(1, 1.159),
                                                          colors: <Color>[_colorFromHex(Constants.baseThemeColor), Color(0xfff00991)],
                                                          stops: <double>[0.789, 1],
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          bottomRight: Radius.circular(8),
                                                          bottomLeft: Radius.circular(8),
                                                          topLeft: Radius.circular((iscurvedtop==1)?8:0),
                                                          topRight: Radius.circular((iscurvedtop==1)?8:0),
                                                        ),
                                                        image: DecorationImage(
                                                          image:NetworkImage(data[index]['imageURL1']), //(index==0)?AssetImage("assets/quiz-1.png"):AssetImage("assets/quiz-2.png"),//AssetImage("assets/quiz-1.png"),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [

                                                          Padding(
                                                              padding: EdgeInsets.only(left:16.0,top: 16.0),child:Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children:  <Widget>[
                                                              Text(data[index]['heading1'],style: TextStyle(color:_colorFromHex(titlecolor,),fontWeight: (index==3)?FontWeight.w400:FontWeight.w800,fontSize: (index==3)?14:24),),
                                                              SizedBox(height: (index==3)?10:0,),



                                                              Text(data[index]['heading2'],style: TextStyle(color: Color(0xff5A2DBC),fontSize: 14,fontWeight: FontWeight.w700),),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: data[index]['heading3'],
                                                                  style: DefaultTextStyle.of(context).style,
                                                                  children:  <TextSpan>[
                                                                    TextSpan(text: "\n"+data[index]['heading4'], style: TextStyle(fontWeight: FontWeight.bold,fontSize:24,color: (index==3)?Colors.white:Colors.black)),

                                                                  ],
                                                                ),
                                                              ),

                                                              // Text('$fourthtitle'),
                                                              SizedBox(height: 10,),
                                                              (isreschdule==false)?CountdownTimer(
                                                                controller: controller,
                                                                widgetBuilder: (_, CurrentRemainingTime? time) {


                                                                  // Reschedule Count Donw Script Timer - Start
                                                                  int reachsecond=0;
                                                                  var now = new DateTime.now();
                                                                  var currentFormatDate = new DateFormat('yyyy-MM-dd');
                                                                  String currentDate = currentFormatDate.format(now);
                                                                  String scheduleStartTime="";
                                                                  String questionStartTime="";
                                                                  scheduleStartTime=data[index]['gameStartTime'];
                                                                  questionStartTime=data[index]['questionStartTime'];
                                                                  DateTime dt1 = DateTime.parse("$currentDate $scheduleStartTime");
                                                                  DateTime dt2 = DateTime.parse("$currentDate $questionStartTime");
                                                                  Duration diff = dt2.difference(dt1);
                                                                  reachsecond=diff.inSeconds;
                                                                    if (time == null) {
                                                                        if(index==0) {
                                                                          simpleAudioPlayer = SimpleAudioPlayer();
                                                                          simpleAudioPlayer.songStateStream.listen((event) {

                                                                          });
                                                                          simpleAudioPlayer.prepare(uri: asset_start_enable);
                                                                          simpleAudioPlayer.setPlaybackRate(rate: rateValue);
                                                                          simpleAudioPlayer.play();
                                                                        }
                                                                      Future.delayed(Duration(seconds: enableseconds), () async {
                                                                         if(index==0) {
                                                                          simpleAudioPlayer.stop();
                                                                          Navigator
                                                                              .pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (
                                                                                      context) =>
                                                                                      SchemeDetailPage(
                                                                                          title: data[index]['heading1'],
                                                                                          list: data,
                                                                                          index: 1,
                                                                                          QuizTypeRefID: data[index]['quizTypeRefID'],
                                                                                          starttimelabel: data[index]['questionStartTime'],
                                                                                          currentTime: data[index]['currentTime']
                                                                                      )),
                                                                                  (
                                                                                  e) => false);
                                                                          getData();
                                                                        }
                                                                      });
                                                                    }
                                                                // Reschedule Count Donw Script Timer - End

                                                                 if (time == null) {
                                                                    return   GestureDetector(
                                                                        onTap: () {


                                                                          simpleAudioPlayer.stop();

                                                                          Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) =>
                                                                                      SchemeDetailPage(
                                                                                          title:data[index]['heading1'],
                                                                                          list: data,
                                                                                          index:1,
                                                                                          QuizTypeRefID:data[index]['quizTypeRefID'],
                                                                                          starttimelabel:data[index]['questionStartTime'],
                                                                                          currentTime:data[index]['currentTime']
                                                                                      )),
                                                                                  (e) => false);
                                                                        },
                                                                        child:(iscomingsoon==false)?Container(
                                                                          // frame12X1d (1:2054)
                                                                          width: 114*fem,
                                                                          height: 34*fem,
                                                                          decoration: BoxDecoration (
                                                                            color: _colorFromHex(Constants.buttonColor),
                                                                            borderRadius: BorderRadius.circular(8*fem),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Color(0xff000000),
                                                                                offset: Offset(2*fem, 2*fem),
                                                                                blurRadius: 0*fem,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              data[index]['button1'],
                                                                              style: SafeGoogleFont (
                                                                                'Open Sans',
                                                                                fontSize: 16*ffem,
                                                                                fontWeight: FontWeight.bold,
                                                                                height: 1.2857142857*ffem/fem,
                                                                                color: Color(0xff000000),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ):SizedBox());


                                                                 }

                                                                  return  (iscomingsoon==false)?Container(
                                                                    // frame12kDH (1:2023)
                                                                    width: 114*fem,
                                                                    height: 34*fem,
                                                                    decoration: BoxDecoration (
                                                                      color: Color(0xffffffff),
                                                                      borderRadius: BorderRadius.circular(8*fem),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Color(0xff000000),
                                                                          offset: Offset(2*fem, 2*fem),
                                                                          blurRadius: 0*fem,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Join the Quiz',
                                                                        style: SafeGoogleFont (
                                                                          'Open Sans',
                                                                          fontSize: 16*ffem,
                                                                          fontWeight: FontWeight.bold,
                                                                          height: 1.2857142857*ffem/fem,
                                                                          color: Color(0xff000000),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ):Text("Coming Soon...",style: TextStyle(color:Color(0xffFFE600),fontWeight: FontWeight.bold,fontSize: 20),);

                                                                },
                                                              ):SizedBox(),

                                                              // Reschedule
                                                              SizedBox(height: 10,),
                                                              (isreschdule==true)?CountdownTimer(
                                                                controller: controller,
                                                                widgetBuilder: (_, CurrentRemainingTime? time) {
                                                                  if (time == null) {
                                                                    return   (iscomingsoon==false)?Container(
                                                                          // frame12X1d (1:2054)
                                                                          width: 114*fem,
                                                                          height: 34*fem,
                                                                          decoration: BoxDecoration (
                                                                            color: _colorFromHex(Constants.buttonColor),
                                                                            borderRadius: BorderRadius.circular(8*fem),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Color(0xff000000),
                                                                                offset: Offset(2*fem, 2*fem),
                                                                                blurRadius: 0*fem,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              data[index]['button1'],
                                                                              style: SafeGoogleFont (
                                                                                'Open Sans',
                                                                                fontSize: 16*ffem,
                                                                                fontWeight: FontWeight.bold,
                                                                                height: 1.2857142857*ffem/fem,
                                                                                color: Color(0xff000000),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ):SizedBox();


                                                                  }
                                                                  return  (iscomingsoon==false)?Container(
                                                                    // frame12kDH (1:2023)
                                                                    width: 114*fem,
                                                                    height: 34*fem,
                                                                    decoration: BoxDecoration (
                                                                      color: Color(0xffffffff),
                                                                      borderRadius: BorderRadius.circular(8*fem),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Color(0xff000000),
                                                                          offset: Offset(2*fem, 2*fem),
                                                                          blurRadius: 0*fem,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Join the Quiz',
                                                                        style: SafeGoogleFont (
                                                                          'Open Sans',
                                                                          fontSize: 16*ffem,
                                                                          fontWeight: FontWeight.bold,
                                                                          height: 1.2857142857*ffem/fem,
                                                                          color: Color(0xff000000),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ):Text("Coming Soon...",style: TextStyle(color:Color(0xffFFE600),),textAlign: TextAlign.center,);

                                                                },
                                                              ):SizedBox(),
                                                              // Reschedule



                                                            ],
                                                          )),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          const Divider(
                                            height: 10,
                                            thickness: 1,
                                            indent: 5,
                                            endIndent: 5,
                                            color: Color(0xffC8C8C8),
                                          ),
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


                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      print("Applicaion Resumed");

      getData();
      // user returned to our app
    }else if(state == AppLifecycleState.inactive){
      closeAppUsingExit();
      print("Applicaion Inactive");
      getData();
      // app is inactive
    }else if(state == AppLifecycleState.paused){
      print("Applicaion Paused");
      getData();
      closeAppUsingExit();
      // user is about quit our app temporally
    }/*else if(state == AppLifecycleState.suspending){
      // app suspended (not used in iOS)
    }*/
  }
  @override
  void dispose() {
    subscription.cancel();
    //controller.dispose();
    super.dispose();
  }
}
