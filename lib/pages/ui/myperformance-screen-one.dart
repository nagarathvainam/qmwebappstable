import 'package:flutter/material.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:quizmaster/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quizmaster/pages/ui/myperformance-screen-two.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
//import '../../model/databasehelper.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';

import '../webview/rateus.dart';
import 'login.dart';
class MyPerformanceScreenOne extends StatefulWidget {
  // MyPerformanceScreenOne({Key? key}) : super(key: key);
  String scheduleRefID;
  MyPerformanceScreenOne({required this.scheduleRefID});
  @override
  _MyPerformanceScreenOneState createState() => _MyPerformanceScreenOneState();
}
class BarChartModel {
  String days;
  int financial;
  final charts.Color color;

  BarChartModel({
    required this.days,
    required this.financial,
    required this.color,
  });
}
class _MyPerformanceScreenOneState extends State<MyPerformanceScreenOne> {
  User databaseUser = new User();
  Question databaseQuestion = new Question();
  late StreamSubscription<ConnectivityResult> subscription;
  int totalQuestion=0;
  int totalPayment=0;
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

    await //prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
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
    getScheduleWiseWinnerData(widget.scheduleRefID);
    readSharedPrefs();
    //deviceAuthCheck();


    Future.delayed(Duration(seconds: 30), () async{
      //final prefs = await SharedPreferences.getInstance();
      //prefs.setString('scheduleRefID',"");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>QuestionDynamicUiPage()), //MyPerformanceScreenOne()),
              (e) => false);
    });

  }



  String defaultRankName="";
  String defaultRankWinnerAmount="0.00";
  String defaultRankWinnerimgURL="";

  String defaultUserRank="0";
  bool isuserfirstrank=false;
  List winnerscheduledata=[];


  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalPayment= (prefs.getInt('TotalPayment') ??0);
      totalQuestion=(prefs.getInt('TOTALQUESTION') ??0);
      UserQuizPlayed();
    });
  }
  var questionWinCount="";
  var questionCount="";
  var quizCount="";
  var paid="";
  var tax="";
  UserQuizPlayed() async {
    databaseQuestion
        .UserQuizPlayed()
        .whenComplete(() async{
      setState(() {
        questionWinCount=databaseQuestion.questionWinCount;
        questionCount=databaseQuestion.questionCount;
        quizCount=databaseQuestion.quizCount;
        paid=databaseQuestion.paid;
        tax=databaseQuestion.tax;
      });
    });
  }


  getScheduleWiseWinnerData(schrefid) async {
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    Constants.printMsg("My Performance Screen One Shedule Ref ID:");
    Constants.printMsg(schrefid);
    databaseQuestion
        .getScheduleWiseWinnerData(schrefid)
        .whenComplete(() async{
      setState(() {
        winnerscheduledata=databaseQuestion.winnerscheduledata as List;
        for(int x = 0; x<winnerscheduledata.length;x++){
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
// Chart Data - Start
  List<BarChartModel> chart_data = [
    BarChartModel(
      days: "Sun",
      financial: 50,
      color: charts.ColorUtil.fromDartColor(Color(0xff003DB5)),
    ),
    BarChartModel(
      days: "Mon",
      financial: 300,
      color: charts.ColorUtil.fromDartColor(Color(0xff003DB5)),
    ),
    BarChartModel(
      days: "Tue",
      financial: 100,
      color: charts.ColorUtil.fromDartColor(Color(0xff003DB5)),
    ),
    BarChartModel(
      days: "Wed",
      financial: 450,
      color: charts.ColorUtil.fromDartColor(Color(0xff003DB5)),
    ),
    BarChartModel(
      days: "Thu",
      financial: 630,
      color: charts.ColorUtil.fromDartColor(Color(0xff003DB5)),
    ),
    BarChartModel(
      days: "Fri",
      financial: 350,
      color: charts.ColorUtil.fromDartColor(Color(0xff003DB5)),
    ),
    BarChartModel(
      days: "Sat",
      financial: 950,
      color: charts.ColorUtil.fromDartColor(Color(0xff11E3DE)),
    ),
  ];
// Chart Data - End



  @override
  Widget build(BuildContext context) {

    // Chart Declaration
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: "financial",
        data: chart_data,
        domainFn: (BarChartModel series, _) => series.days,
        measureFn: (BarChartModel series, _) => series.financial,
        colorFn: (BarChartModel series, _) => series.color,
      ),
    ];
    // Chart Declaration
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('scheduleRefID',"");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>QuestionDynamicUiPage()),
                  (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
      backgroundColor: _colorFromHex(Constants.baseThemeColor),
     // drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child:Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: 896*fem,
          decoration: BoxDecoration (
            color: _colorFromHex(Constants.baseThemeColor),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 31.0668945312*fem,
                top: 21*fem,
                child: Align(
                  child: SizedBox(
                    width: 370.74*fem,
                    height: 13*fem,
                    child: SizedBox(),
                  ),
                ),
              ),
              Positioned(
                left: 0*fem,
                top: 862*fem,
                child: Container(
                  padding: EdgeInsets.fromLTRB(133.58*fem, 21*fem, 133.58*fem, 8*fem),
                  width: 414*fem,
                  height: 34*fem,
                  decoration: BoxDecoration (
                    color: Color(0xffffffff),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 146.83*fem,
                      height: 5*fem,
                      child: SizedBox(),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0*fem,
                top: 150*fem,
                child: Container(
                  padding: EdgeInsets.fromLTRB(19*fem, 24*fem, 18*fem, 26*fem),
                  width: 414*fem,
                  height: 756*fem,
                  decoration: BoxDecoration (
                    color: Color(0xffedecfb),
                    borderRadius: BorderRadius.only (
                      topLeft: Radius.circular(24*fem),
                      topRight: Radius.circular(24*fem),
                    ),
                  ),
                  child: SingleChildScrollView(child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>MyPerformanceScreenTwo(scheduleRefID: widget.scheduleRefID,fromscreen: '',)),//MyPerformanceScreenTwo()
                                (e) => false);
                setState(() {

                });
                },
                  child:Container(

                        margin: EdgeInsets.fromLTRB(196*fem, 0*fem, 0*fem, 65*fem),
                        width: 32,
                        height:32,
                        child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration (
                              color: _colorFromHex(Constants.baseThemeColor),
                              borderRadius: BorderRadius.circular(48*fem),
                            ),


                            child:Row(
                              children:  <Widget>[
                                SizedBox(width: 5.0),
                                Image.asset("assets/timer.png"),
                                Image.asset("assets/forward.png")
                              ],
                            )
                        ),
                      )),



                      Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4*fem, 25.49*fem),
                        padding: EdgeInsets.fromLTRB(45*fem, 22*fem, 60*fem, 23.51*fem),
                        height: 105*fem,
                        decoration: BoxDecoration (
                          color: _colorFromHex(Constants.baseThemeColor),
                          borderRadius: BorderRadius.circular(13*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 1.49*fem, 0*fem, 0*fem),
                              width: 32*fem,
                              height: 32*fem,
                              child: Image.asset(
                                'assets/icons/mingcute-currency-rupee-line-Yz7.png',
                                width: 32*fem,
                                height: 32*fem,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 41*fem, 0.49*fem),
                              width: 71*fem,
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 3*fem,
                                    top: 30*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 65*fem,
                                        height: 32*fem,
                                        child: Text(
                                          defaultRankWinnerAmount,
                                          textAlign: TextAlign.center,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 20*ffem,
                                            fontWeight: FontWeight.w800,
                                            height: 1.6*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0*fem,
                                    top: 0*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 71*fem,
                                        height: 32*fem,
                                        child: Text(
                                          "Victory",
                                          textAlign: TextAlign.center,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 20*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.6*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 1.49*fem, 7*fem, 0*fem),
                              width: 27*fem,
                              height: 24*fem,
                              child: Image.asset(
                                'assets/icons/group-mzK.png',
                                width: 27*fem,
                                height: 24*fem,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0.49*fem),
                              constraints: BoxConstraints (
                                maxWidth: 51*fem,
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 20*ffem,
                                    fontWeight: FontWeight.w800,
                                    height: 1.025*ffem/fem,
                                    color: Color(0xffffffff),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Rank\n\n',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.025*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),

                                    TextSpan(
                                      text: defaultUserRank+"",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 2*fem, 12*fem),
                        width: double.infinity,
                        height: 122*fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 13*fem, 0*fem),
                              padding: EdgeInsets.fromLTRB(14*fem, 10.51*fem, 14*fem, 34.49*fem),
                              width: 181*fem,
                              height: double.infinity,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(13*fem),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 13*fem),
                                    width: double.infinity,
                                    child: Text(
                                      'Total Quiz',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 18*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.6*ffem/fem,
                                        color: _colorFromHex(Constants.baseThemeColor),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      quizCount.toString(),
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 25*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1*ffem/fem,
                                        color: Color(0xff858585),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 181*fem,
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 142*fem,
                                    top: 35*fem,
                                    child: Container(
                                      width: 24*fem,
                                      height: 24*fem,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0*fem,
                                    top: 0*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 181*fem,
                                        height: 122*fem,
                                        child: Container(
                                          decoration: BoxDecoration (
                                            borderRadius: BorderRadius.circular(13*fem),
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 35*fem,
                                    top: 55.5101318359*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 87*fem,
                                        height: 32*fem,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 32*ffem,
                                              fontWeight: FontWeight.w800,
                                              height: 1*ffem/fem,
                                              color: Color(0xff242424),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: questionWinCount,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 25*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1*ffem/fem,
                                                  color: Color(0xff4bae4f),
                                                ),

                                              ),
                                              TextSpan(
                                                text: '/'+questionCount,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 25*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1*ffem/fem,
                                                  color: Color(0xff898989),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 13*fem,
                                    top: 10.5101318359*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 133*fem,
                                        height: 32*fem,
                                        child: Text(
                                          'Winning Quiz',
                                          textAlign: TextAlign.center,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 20*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.6*ffem/fem,
                                            color: _colorFromHex(Constants.baseThemeColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 2*fem, 18.51*fem),
                        width: double.infinity,
                        height: 122*fem,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 13*fem, 0*fem),
                              padding: EdgeInsets.fromLTRB(12*fem, 13.51*fem, 12*fem, 33.49*fem),
                              width: 181*fem,
                              height: double.infinity,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(13*fem),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 11*fem),
                                    width: double.infinity,
                                    child: Text(
                                      'Paid',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.6*ffem/fem,
                                        color: _colorFromHex(Constants.baseThemeColor),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      '₹'+paid.toString()+".00",
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 25*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.0666666667*ffem/fem,
                                        color: Color(0xff858585),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(13*fem, 13.51*fem, 13*fem, 33.49*fem),
                              width: 181*fem,
                              height: double.infinity,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(13*fem),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 11*fem),
                                    width: double.infinity,
                                    child: Text(
                                      'Tax',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.6*ffem/fem,
                                        color: _colorFromHex(Constants.baseThemeColor),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      '₹'+tax,
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 25*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.0666666667*ffem/fem,
                                        color: Color(0xff858585),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    Text(
                              'Last 7 Days',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont (
                                'Open Sans',
                                fontSize: 20*ffem,
                                fontWeight: FontWeight.w800,
                                height: 1.6*ffem/fem,
                                color: Color(0xff696969),
                              )),
                       SizedBox(height: 20,),
                       Container(
                        width: double.infinity,
                        height: 172*fem,
                        decoration: BoxDecoration (
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(13*fem),
                        ),
                        child: Stack(
                          children: [

                            charts.BarChart(
                              series,
                              animate: true,
                            ),
                            // Positioned(
                            //   left: 0*fem,
                            //   top: 0*fem,
                            //   child: Align(
                            //     child: SizedBox(
                            //       width: 116*fem,
                            //       height: 32*fem,
                            //       child: Text(
                            //         'Last 7 Days',
                            //         textAlign: TextAlign.center,
                            //         style: SafeGoogleFont (
                            //           'Open Sans',
                            //           fontSize: 20*ffem,
                            //           fontWeight: FontWeight.w800,
                            //           height: 1.6*ffem/fem,
                            //           color: Color(0xff696969),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              Positioned(
                // group1246voD (888:1792)
                left: 135*fem,
                top: 114*fem,
                child: Container(
                  width: 145.81*fem,
                  height: 175*fem,
                  decoration: BoxDecoration (
                    borderRadius: BorderRadius.circular(48*fem),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(48*fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8.82*fem),
                          width: 129.81*fem,
                          height: 134.18*fem,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                Constants.photo),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.19*fem, 0*fem, 0*fem, 0*fem),
                          child: Text(
                            Constants.displayName,
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont (
                              'Open Sans',
                              fontSize: 20*ffem,
                              //fontWeight: FontWeight.w600,
                              height: 0.60*ffem/fem,
                              color: Color(0xff090909),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 89.0009765625*fem,
                top: 0*fem,
                child: Align(
                  child: SizedBox(
                    width: 253.96*fem,
                    height: 155.46*fem,
                    child: Image.asset(
                      'assets/background/group-762361.png',
                      width: 253.96*fem,
                      height: 155.46*fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20*fem,
                top: 68*fem,
                child: Align(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 32*fem,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  <Widget>[
                        GestureDetector(
                        onTap: () async {
                          //final prefs = await SharedPreferences.getInstance();
                          //prefs.setString('scheduleRefID',"");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>QuestionDynamicUiPage()),
                                  (e) => false);
                  },
                    child:Icon(Icons.home,color: Colors.white,size: 35,)),
                        SizedBox(width: 100*ffem,),
                        Expanded(child: Text(
                            'My Performance',
                            textAlign: TextAlign.left,
                            style: SafeGoogleFont (
                              'Open Sans',
                              fontSize: 24*ffem,
                              fontWeight: FontWeight.w800,
                              height: 1.3333333333*ffem/fem,
                              color: Color(0xffffffff),
                            ))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
