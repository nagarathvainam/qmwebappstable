import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'dart:ui';
import 'package:quizmaster/pages/ui/myperformance-screen-one.dart';
import 'package:quizmaster/pages/ui/schedule-complete.dart';
import 'package:quizmaster/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
//import '../../model/databasehelper.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';

import '../question/schedule.dart';
import '../webview/rateus.dart';
import 'login.dart';
final rank_list = "asset:///audios/rank-list.mp3";
class WinnerList extends StatefulWidget {
  //WinnerList({Key? key}) : super(key: key);
  String scheduleRefID;
  WinnerList({required this.scheduleRefID});
  @override
  _WinnerListState createState() => _WinnerListState();
}
class _WinnerListState extends State<WinnerList>   with SingleTickerProviderStateMixin {
  //List data = [];
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  Question databaseQuestion = new Question();
  User databaseUser = new User();
  late SimpleAudioPlayer simpleAudioPlayer;
  double rateValue = 1.0;
  List winnerscheduledata=[];
  late StreamSubscription<ConnectivityResult> subscription;



  //String scheduleRefID="";
  @override
  void initState() {
    Constants.printMsg("Winere List Wiget Schedule Ref ID");
    Constants.printMsg(widget.scheduleRefID);
    simpleAudioPlayer = SimpleAudioPlayer();
    simpleAudioPlayer.songStateStream.listen((event) {

    });
    simpleAudioPlayer.prepare(uri: rank_list);
    simpleAudioPlayer.setPlaybackRate(rate: rateValue);
    simpleAudioPlayer.play();
    //this.getData();
    Future.delayed(Duration(seconds: 30), () async{
      simpleAudioPlayer.stop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>ScheduleComplete(scheduleRefID: widget.scheduleRefID,)), //MyPerformanceScreenOne()),
              (e) => false);
    });


    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
    deviceAuthCheck();
    getScheduleWiseWinnerData();
    clearScheduleRefID();
    getVideo();
  }

  clearScheduleRefID() async {
    final prefs = await SharedPreferences.getInstance();
    Constants.scheduleRefID=widget.scheduleRefID;
    prefs.setString('scheduleRefID', "");
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

    //await //prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
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
  String ordinal(int number) {
    if(!(number >= 1 && number <= 100)) {//here you change the range
      throw Exception('Invalid number');
    }

    if(number >= 11 && number <= 13) {
      return 'th';
    }

    switch(number % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

 // String scheduleRefID="";
  String firstRankName="";
  String firstRankWinnerAmount="";
  String firstRankWinnerimgURL="";

  String secondRankName="";
  String secondRankWinnerAmount="";
  String secondRankWinnerimgURL="";

  String thirdRankName="";
  String thirdRankWinnerAmount="";
  String thirdRankWinnerimgURL="";


  String defaultRankName="";
  String defaultRankWinnerAmount="0.00";
  String defaultRankWinnerimgURL="";
  String displayName="";
  String defaultUserRank="0";
  bool isuserfirstrank=false;

  getScheduleWiseWinnerData() async {
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    Constants.printMsg("getScheduleWiseWinnerData:");
    Constants.printMsg(widget.scheduleRefID);
    databaseQuestion
        .getScheduleWiseWinnerData(widget.scheduleRefID)
        .whenComplete(() async{
      setState(() {
        winnerscheduledata=databaseQuestion.winnerscheduledata as List;

        for(int x = 0; x<winnerscheduledata.length;x++){

          firstRankName=winnerscheduledata[0]['displayName'];
          firstRankWinnerAmount= winnerscheduledata[0]['winningAmount'];
          firstRankWinnerimgURL= winnerscheduledata[0]['imgURL'];

          secondRankName=winnerscheduledata[1]['displayName'];
          secondRankWinnerAmount= winnerscheduledata[1]['winningAmount'];
          secondRankWinnerimgURL= winnerscheduledata[1]['imgURL'];

          thirdRankName=winnerscheduledata[2]['displayName'];
          thirdRankWinnerAmount= winnerscheduledata[2]['winningAmount'];
          thirdRankWinnerimgURL= winnerscheduledata[2]['imgURL'];




          if(userRefID==winnerscheduledata[x]['userRefID']) {
            defaultRankName = winnerscheduledata[x]['displayName'];
            defaultRankWinnerAmount =
            winnerscheduledata[x]['winningAmount'];
            defaultRankWinnerimgURL = winnerscheduledata[x]['imgURL'];
            defaultUserRank= winnerscheduledata[x]['winnersRank'];
            if(winnerscheduledata[x]['winnersRank']=='1'){
              isuserfirstrank=true;
            }
          }

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


  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {

          return false; // return false if you want to disable device back button click
        },
        child: Container(
            width: double.infinity,
            child: Container(
              width: double.infinity,
              decoration:  BoxDecoration (
                color: _colorFromHex(Constants.baseThemeColor),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      margin: EdgeInsets.fromLTRB(18*fem, 0*fem, 12.19*fem, 32*fem),
                      width: double.infinity,
                      height: 329.98*fem,
                      child: Stack(
                        children: [
                          GifView.asset(
                            'assets/gif/winners-list1.gif',
                            height: 500,
                            width: 500,
                            frameRate: 30, // default is 15 FPS
                          ),
                          Positioned(
                            left: 126*fem,
                            top: 96*fem,
                            child: Container(
                                width: 130*fem,
                                height: 250*fem,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Container(


                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 1.76*fem, 12.49*fem),
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle (
                                              fontSize: 44*ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 0.3636363636*ffem/fem,
                                              color: Color(0xffffffff),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '1',
                                                style:  TextStyle (
                                                fontSize: 44*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 0.3636363636*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'st',
                                                style:  TextStyle (
                                                fontSize: 44*ffem,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.3636363636*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0.19*fem, 8.33*fem),
                                        width: 129.81*fem,
                                        height: 134.18*fem,
                                        child:  CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              firstRankWinnerimgURL),
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0.98*fem, 10*fem),
                                        child: Text(
                                          firstRankName,
                                          textAlign: TextAlign.center,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 20*ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 0.8*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                                        padding: EdgeInsets.fromLTRB(20*fem, 6*fem, 24*fem, 6*fem),
                                        width: double.infinity,
                                        decoration: BoxDecoration (
                                          color: Color(0x28ffffff),
                                          borderRadius: BorderRadius.circular(24*fem),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8.97*fem, 0*fem),
                                              width: 14.03*fem,
                                              height: 16*fem,
                                              child: Image.asset(
                                                'assets/icons/fluent-trophy-20-filled-eD9.png',
                                                width: 14.03*fem,
                                                height: 16*fem,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 14*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.1428571429*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                                children: [
                                                  const TextSpan(
                                                    text: '₹',
                                                  ),
                                                  TextSpan(
                                                    text: firstRankWinnerAmount,
                                                    style: SafeGoogleFont (
                                                      'Open Sans',
                                                      fontSize: 18*ffem,
                                                      fontWeight: FontWeight.w600,
                                                      height: 0.8888888889*ffem/fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          Positioned(
                            left: 266*fem,
                            top: 120*fem,
                            child: Container(
                              width: 110*fem,
                              height: 203*fem,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0.02*fem, 8.22*fem),
                                    width: 109.98*fem,
                                    height: 111.2*fem,
                                    child:  CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          thirdRankWinnerimgURL),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3.04*fem, 12.57*fem),
                                    child: Text(
                                      thirdRankName,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 0.8*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(7*fem, 0*fem, 0*fem, 0*fem),
                                    padding: EdgeInsets.fromLTRB(15.5*fem, 5*fem, 13.5*fem, 5*fem),
                                    width: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0x28ffffff),
                                      borderRadius: BorderRadius.circular(24*fem),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8.97*fem, 0*fem),
                                          width: 14.03*fem,
                                          height: 16*fem,
                                          child: Image.asset(
                                            'assets/icons/fluent-trophy-20-filled-EVZ.png',
                                            width: 14.03*fem,
                                            height: 16*fem,
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(0xffffffff),
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: '₹',
                                              ),
                                              TextSpan(
                                                text: thirdRankWinnerAmount,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 18*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.8888888889*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                      Positioned(
                        left: 0*fem,
                        top: 50*fem,
                        child:GestureDetector(
                              onTap: () {
                                setState(()  {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>QuestionDynamicUiPage()),
                                          (e) => false);
                                });
                              },
                              child:Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 40.0,

                              ))),
                          Positioned(
                            left: 0*fem,
                            top: 120*fem,
                            child: Container(
                              width: 115*fem,
                              height: 204*fem,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 5.02*fem, 9.8*fem),
                                    width: 109.98*fem,
                                    height: 111.2*fem,
                                    child:CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          secondRankWinnerimgURL),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 5*fem, 12*fem),
                                    child: Text(
                                      secondRankName,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 0.8*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(9*fem, 0*fem, 0*fem, 0*fem),
                                    padding: EdgeInsets.fromLTRB(11*fem, 5*fem, 9*fem, 5*fem),
                                    width: double.infinity,
                                    decoration: BoxDecoration (
                                      color: Color(0x28ffffff),
                                      borderRadius: BorderRadius.circular(24*fem),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                          width: 16*fem,
                                          height: 16*fem,
                                          child: Image.asset(
                                            'assets/icons/fluent-trophy-20-filled-UT5.png',
                                            width: 16*fem,
                                            height: 16*fem,
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(0xffffffff),
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: '₹',
                                              ),
                                              TextSpan(
                                                text: secondRankWinnerAmount,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 18*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.8888888889*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13.0668945312*fem,
                            top: 1*fem,
                            child: Container(
                              width: 370.74*fem,
                              height: 30.95*fem,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 35*fem),
                        padding: EdgeInsets.fromLTRB(15*fem, 8*fem, 0*fem, 0*fem),
                        width: 416*fem,
                        height: 48*fem,
                        decoration: const BoxDecoration (
                          gradient: LinearGradient (
                            begin: Alignment(-0.606, -1.187),
                            end: Alignment(0.495, 1.188),
                            colors: <Color>[Color(0xff159fee), Color(0xff443ca0)],
                            stops: <double>[0, 1],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 8*fem),
                                height: 32*fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (isuserfirstrank)?Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 8*fem, 8*fem, 8*fem),
                                        padding: EdgeInsets.fromLTRB(0*fem, 1*fem, 0*fem, 1*fem),
                                        height: double.infinity,
                                        child: Center(
                                          child: SizedBox(
                                              width: 18.03*fem,
                                              height: 14*fem,
                                              child: Image.asset(
                                                'assets/icons/fa6-solid-crown.png',
                                                width: 18.03*fem,
                                                height: 14*fem,
                                              )
                                          ),
                                        )
                                    ):Text(defaultUserRank,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 18*ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1428571429*ffem/fem,
                                          color: Color(0xffffffff),
                                        )),
                                    Text("/"+winnerscheduledata.length.toString(),style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 20*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.1428571429*ffem/fem,
                                      color: Color(0xffffffff),
                                    )),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                      width: 32*fem,
                                      height: 32*fem,
                                      decoration: BoxDecoration (
                                        borderRadius: BorderRadius.circular(16*fem),
                                        image:  DecorationImage (
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            firstRankWinnerimgURL,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 180*fem, 0*fem),
                                      child: Text(
                                        (defaultRankName!='')?defaultRankName:displayName,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1428571429*ffem/fem,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(16*fem, 8*fem, 10*fem, 8*fem),
                                      height: double.infinity,
                                      decoration: BoxDecoration (
                                        color: Color(0xff159fef),
                                        borderRadius: BorderRadius.circular(24*fem),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10.97*fem, 0*fem),
                                              width: 11.03*fem,
                                              height: 20*fem,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/winners_game_icon.png'),
                                                  fit: BoxFit.fill,
                                                ),)
                                            // backgroundImage: AssetImage(
                                            //     "assets/images/winners_game_icon.png"),

                                          ),
                                          Text(
                                            '₹'+defaultRankWinnerAmount,
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 1*fem,
                                decoration: const BoxDecoration (
                                  color: Color(0x28000000),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                      width: double.infinity,
                      height: 563*fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0*fem,
                            top: 0*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                              width: 414*fem,
                              height: 563*fem,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.only (
                                  topLeft: Radius.circular(24*fem),
                                  topRight: Radius.circular(24*fem),
                                ),
                              ),
                              child: Container(
                                  width: 413*fem,
                                  height: double.infinity,
                                  child: (winnerscheduledata.length>0)?SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [


                                        (winnerscheduledata.length==0)?SizedBox(height: 25.0):SizedBox(),
                                        (winnerscheduledata.length==0)?Align(alignment: Alignment.center,child:Text("No Winner List",style: TextStyle(fontSize: 20,color: Colors.red),)):SizedBox(),


                                        SingleChildScrollView(

                                            child:ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: winnerscheduledata.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                      padding: EdgeInsets.fromLTRB(24 * fem, 8 * fem, 22 * fem, 0 * fem),
                                                      width: double.infinity,
                                                      height: 48 * fem,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 11 * fem, 8 * fem),
                                                              height: 32 * fem,
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.fromLTRB(
                                                                        0 * fem, 0 * fem, 7 * fem, 0 * fem),
                                                                    child: Text(
                                                                      winnerscheduledata[index]['winnersRank'],
                                                                      style: SafeGoogleFont(
                                                                        'Open Sans',
                                                                        fontSize: 16 * ffem,
                                                                        fontWeight: FontWeight.w700,
                                                                        height: 1 * ffem / fem,
                                                                        color: Color(0xff000000),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.fromLTRB(
                                                                        0 * fem, 0 * fem, 8 * fem, 0 * fem),
                                                                    width: 32 * fem,
                                                                    height: 32 * fem,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(16 * fem),
                                                                      image:  DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: NetworkImage(
                                                                          winnerscheduledata[index]['imgURL'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(child:Container(
                                                                    margin: EdgeInsets.fromLTRB(
                                                                        0 * fem, 0 * fem, 0 * fem, 0 * fem),
                                                                    child: Text(
                                                                      winnerscheduledata[index]['displayName'],
                                                                      style: SafeGoogleFont(
                                                                        'Open Sans',
                                                                        fontSize: 14 * ffem,
                                                                        fontWeight: FontWeight.w600,
                                                                        height: 1.1428571429 * ffem / fem,
                                                                        color: Color(0xff000000),
                                                                      ),
                                                                    ),
                                                                  )),
                                                                  Container(
                                                                    width: 100,
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        13 * fem, 8 * fem, 11 * fem, 8 * fem),
                                                                    height: double.infinity,
                                                                    decoration: BoxDecoration(
                                                                      color: Color(0x3dffb400),
                                                                      borderRadius: BorderRadius.circular(24 * fem),
                                                                    ),
                                                                    child: Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              0 * fem, 0 * fem, 8.97 * fem, 0 * fem),
                                                                          width: 14.03 * fem,
                                                                          height: 16 * fem,
                                                                          child: Image.asset(
                                                                            'assets/icons/fluent-trophy-20-filled-nyh.png',
                                                                            width: 14.03 * fem,
                                                                            height: 16 * fem,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '₹'+winnerscheduledata[index]['winningAmount'],
                                                                          style: SafeGoogleFont(
                                                                            'Open Sans',
                                                                            fontSize: 14 * ffem,
                                                                            fontWeight: FontWeight.w600,
                                                                            height: 1.1428571429 * ffem / fem,
                                                                            color: Color(0xff000000),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double.infinity,
                                                              height: 1 * fem,
                                                              decoration: BoxDecoration(
                                                                color: Color(0x28000000),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                }))



                                      ],
                                    ),
                                  ): Container(
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
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}