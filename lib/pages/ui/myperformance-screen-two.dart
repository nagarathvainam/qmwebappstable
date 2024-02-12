import 'package:flutter/material.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/pages/ui/myperformance-screen-one.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';

import '../webview/rateus.dart';
import 'edit-profile-tab.dart';
import 'login.dart';
class MyPerformanceScreenTwo extends StatefulWidget {
  //MyPerformanceScreenTwo({Key? key}) : super(key: key);
  String scheduleRefID;
  String fromscreen;
  MyPerformanceScreenTwo({required this.scheduleRefID,required this.fromscreen});
  @override
  _MyPerformanceScreenTwoState createState() => _MyPerformanceScreenTwoState();
}

class _MyPerformanceScreenTwoState extends State<MyPerformanceScreenTwo> {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  @override
  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();
  //String scheduleRefID="";
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  Question databaseQuestion = new Question();
  List correctanswerdata=[];

  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //scheduleRefID = Constants.scheduleRefID;
      Constants.printMsg("My Performance Screen One Shedule Ref ID:");
      Constants.printMsg(widget.scheduleRefID);
      getCorrectAnswerData(widget.scheduleRefID);
    });
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
    readSharedPrefs();
    //deviceAuthCheck();
   //userRefID,GroupRefID,scheduleRefID,Datekey

    Future.delayed(Duration(seconds: 30), () async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('scheduleRefID',"");
      if(widget.fromscreen!="") {
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfileTab(initalindex:0)),
                (e) => false);*/
      }else{
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyPerformanceScreenOne(
                      scheduleRefID: widget.scheduleRefID,)),
                (e) => false);*/
      }
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

    await //prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
    await prefs.setString('userRefID', "");
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
  getCorrectAnswerData(scheduleRefID) async {
    databaseQuestion
        .getCorrectAnswerData(scheduleRefID)
        .whenComplete(() async{
      setState(() {
        correctanswerdata=databaseQuestion.correctanswerdata as List;
        print("Correct Answer Data Length:-");
        print(correctanswerdata.length);
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
          if(widget.fromscreen!="") {

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfileTab(initalindex:0)),
                    (e) => false);
          }else{
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyPerformanceScreenOne(
                          scheduleRefID: widget.scheduleRefID,)),
                    (e) => false);
          }
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
      backgroundColor: _colorFromHex(Constants.baseThemeColor),
     // drawer: const CustomDrawer(),
      body: SingleChildScrollView(
          child:GestureDetector(
    onTap: () {
    },
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
                    left: 31.0668640137*fem,
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
                    child: Align(
                      child: SizedBox(
                        width: 414*fem,
                        height: 756*fem,
                        child:Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(0),
                              )),
                        ),
                      ),
                    ),
                  ),

              Positioned(
                left: 75*fem,
                top: 175*fem,
                child:GestureDetector(
                    onTap: () {
                      if(widget.fromscreen!="") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileTab(initalindex:0)),
                                (e) => false);
                      }else{
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyPerformanceScreenOne(
                                      scheduleRefID: widget.scheduleRefID,)),
                                (e) => false);

                      }
                    },
                    child:Container(
                  height: 32,
                    width: 32,
                    decoration: BoxDecoration (
                        color: _colorFromHex(Constants.baseThemeColor),
                      borderRadius: BorderRadius.circular(48*fem),
                    ),
                    child:Image.asset("assets/back-arrow-white.png")))
              ),
                  Positioned(
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
                    left: 81.0010015965*fem,
                    top: 0*fem,
                    child: Align(
                      child: SizedBox(
                        width: 253.96*fem,
                        height: 155.46*fem,
                        child: Image.asset(
                          'assets/background/group-762363.png',
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
                                 // final prefs = await SharedPreferences.getInstance();
                                 // prefs.setString('scheduleRefID',"");
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

                  //Loop Start
Positioned(
                    // frame1283ZRu (888:2506)
                    left: 5*fem,
                    right: 5*fem,

                    top: 306*fem,
                    child: Container(
                      width: 435*fem,
                      height: 800*fem,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [




                          Container(
                            padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 10*fem),
                            width: double.infinity,
                            height: 550*fem,
                            child: SingleChildScrollView(child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [




                                (correctanswerdata.length>0)?SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: correctanswerdata == null ? 0 : correctanswerdata.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          var sn=index+1;
                                          var ln=correctanswerdata.length;
                                          return (correctanswerdata[index]['correctAnswer']!=correctanswerdata[index]['answerPick'])?Container(
                                            width: 366*fem,
                                            decoration: BoxDecoration (
                                              border: Border.all(color: Color(0x28000000)),
                                              color: Color(0xffffffff),
                                              borderRadius: BorderRadius.circular(12*fem),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                                                        width: double.infinity,
                                                        height: 24*fem,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 159*fem, 0*fem),
                                                              width: 49*fem,
                                                              height: double.infinity,
                                                              decoration: BoxDecoration (
                                                                border: Border.all(color: Color(0x3d5a2dbc)),
                                                                color: Color(0x285a2dbc),
                                                                borderRadius: BorderRadius.circular(24*fem),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  sn.toString()+" / "+ln.toString(),
                                                                  style: SafeGoogleFont (
                                                                    'Open Sans',
                                                                    fontSize: 12*ffem,
                                                                    fontWeight: FontWeight.w600,
                                                                    height: 1.3333333333*ffem/fem,
                                                                    color: Color(0xff5a2dbc),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   'Answered in 2s 500ms',
                                                            //   textAlign: TextAlign.right,
                                                            //   style: SafeGoogleFont (
                                                            //     'Open Sans',
                                                            //     fontSize: 11*ffem,
                                                            //     fontWeight: FontWeight.w400,
                                                            //     height: 1.3333333333*ffem/fem,
                                                            //     color: Color(0xff000000),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 51*fem, 0*fem),
                                                        width: 283*fem,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              constraints: BoxConstraints (
                                                                maxWidth: 283*fem,
                                                              ),
                                                              child: Text(
                                                                correctanswerdata[index]['question'],
                                                                style: SafeGoogleFont (
                                                                  'Open Sans',
                                                                  fontSize: 14*ffem,
                                                                  fontWeight: FontWeight.w700,
                                                                  height: 1.2857142857*ffem/fem,
                                                                  color: Color(0xff000000),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0*fem, 12*fem, 0*fem, 0*fem),
                                                              width: double.infinity,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  (correctanswerdata[index]['answerPick']!='T')?Container(
                                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 195*fem, 12*fem),
                                                                    padding: EdgeInsets.fromLTRB(1.5*fem, 1.5*fem, 0*fem, 1.5*fem),
                                                                    width: double.infinity,
                                                                    child: Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 13.5*fem, 0*fem),
                                                                          width: 20*fem,
                                                                          height: 21*fem,
                                                                          child: Image.asset(
                                                                            'assets/icons/ep-circle-close-filled.png',
                                                                            width: 21*fem,
                                                                            height: 21*fem,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          correctanswerdata[index]['pickAns'],
                                                                          style: SafeGoogleFont (
                                                                            'Open Sans',
                                                                            fontSize: 12*ffem,
                                                                            fontWeight: FontWeight.w400,
                                                                            height: 1.2857142857*ffem/fem,
                                                                            color: Color(0xff000000),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ):SizedBox(),
                                                                  Container(
                                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 228*fem, 0*fem),
                                                                    padding: EdgeInsets.fromLTRB(1*fem, 1*fem, 0*fem, 1*fem),
                                                                    width: double.infinity,
                                                                    child: SingleChildScrollView(child:Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 13*fem, 0*fem),
                                                                          width: 22*fem,
                                                                          height: 22*fem,
                                                                          child: Image.asset(
                                                                            'assets/filled-tick.png',
                                                                            width: 21*fem,
                                                                            height: 21*fem,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          correctanswerdata[index]['corrctAns'],
                                                                          style: SafeGoogleFont (
                                                                            'Open Sans',
                                                                            fontSize: 11*ffem,
                                                                            fontWeight: FontWeight.w400,
                                                                            height: 1.2857142857*ffem/fem,
                                                                            color: Color(0xff000000),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )),
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
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                                                  width: double.infinity,
                                                  height: 40*fem,
                                                  decoration: BoxDecoration (
                                                    color: Color(0x28aa0064),
                                                    borderRadius: BorderRadius.only (
                                                      bottomRight: Radius.circular(12*fem),
                                                      bottomLeft: Radius.circular(12*fem),
                                                    ),
                                                  ),
                                                  child: Text(
                                                  (correctanswerdata[index]['answerPick']=='T')?'! Time’s up.':'Wrong Answer',
                                                    style: SafeGoogleFont (
                                                      'Open Sans',
                                                      fontSize: 14*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.1428571429*ffem/fem,
                                                      color: Color(0xffaa0064),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ):Container(
                                  width: 366*fem,
                                  decoration: BoxDecoration (
                                    border: Border.all(color: Color(0x28000000)),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(12*fem),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Container(
                                        padding: EdgeInsets.fromLTRB(16*fem, 12*fem, 16*fem, 12*fem),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                                              width: double.infinity,
                                              height: 24*fem,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 159*fem, 0*fem),
                                                    width: 49*fem,
                                                    height: double.infinity,
                                                    decoration: BoxDecoration (
                                                      border: Border.all(color: Color(0x3d5a2dbc)),
                                                      color: Color(0x285a2dbc),
                                                      borderRadius: BorderRadius.circular(24*fem),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        sn.toString()+" / "+ln.toString(),
                                                        style: SafeGoogleFont (
                                                          'Open Sans',
                                                          fontSize: 12*ffem,
                                                          fontWeight: FontWeight.w600,
                                                          height: 1.3333333333*ffem/fem,
                                                          color: Color(0xff5a2dbc),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   'Answered in 2s 500ms',
                                                  //   textAlign: TextAlign.right,
                                                  //   style: SafeGoogleFont (
                                                  //     'Open Sans',
                                                  //     fontSize: 11*ffem,
                                                  //     fontWeight: FontWeight.w400,
                                                  //     height: 1.3333333333*ffem/fem,
                                                  //     color: Color(0xff000000),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 51*fem, 0*fem),
                                              width: 283*fem,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                                                    constraints: BoxConstraints (
                                                      maxWidth: 283*fem,
                                                    ),
                                                    child: Text(
                                                      correctanswerdata[index]['question'],
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 14*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.2857142857*ffem/fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 228*fem, 0*fem),
                                                    padding: EdgeInsets.fromLTRB(1*fem, 1*fem, 0*fem, 1*fem),
                                                    width: double.infinity,
                                                    child: SingleChildScrollView(child:Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(20),
                                                                bottomRight: Radius.circular(20),
                                                                topLeft: Radius.circular(20),
                                                                bottomLeft: Radius.circular(20),
                                                              )),
                                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 13*fem, 0*fem),
                                                          width: 22*fem,
                                                          height: 22*fem,
                                                          child: Image.asset(
                                                            'assets/filled-tick.png',
                                                            width: 21*fem,
                                                            height: 21*fem,
                                                          ),
                                                        ),
                                                        Text(
                                                          correctanswerdata[index]['corrctAns'],
                                                          style: SafeGoogleFont (
                                                            'Open Sans',
                                                            fontSize: 11*ffem,
                                                            fontWeight: FontWeight.w400,
                                                            height: 1.2857142857*ffem/fem,
                                                            color: Color(0xff000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ))),

                                                ],
                                              ),
                                            ),


                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 12*fem),
                                        width: double.infinity,
                                        decoration: BoxDecoration (
                                          color: Color((correctanswerdata[index]['winningPrice']=="0.00")?0xff1D5997:0x2836c4bd),
                                          borderRadius: BorderRadius.only (
                                            bottomRight: Radius.circular(12*fem),
                                            bottomLeft: Radius.circular(12*fem),
                                          ),
                                        ),
                                        child: (correctanswerdata[index]['winningPrice']!="0.00")?RichText(
                                          text: TextSpan(
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(0xff00a29a),
                                            ),
                                            children: [

                                              TextSpan(
                                                text: 'Correct answer! You Won ',
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 14*ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.1428571429*ffem/fem,
                                                  color: Color(0xff00a29a),
                                                ),
                                              ),

                                              TextSpan(
                                                text: 'د.إ'+correctanswerdata[index]['winningPrice'],
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 14*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.1428571429*ffem/fem,
                                                  color: Color(0xff00a29a),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ):RichText(
                                          text: TextSpan(
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(0xff00a29a),
                                            ),
                                            children: [

                                              TextSpan(
                                                text: 'Correct Answer , but you can be faster next time.',
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
                                      ),



                                    ],
                                  ),
                                );

                                        })): Container(
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



                              ],
                            ),
                          ))



                        ],
                      ),
                    ))


                  // Loop End




                ],
              ),
            ),
          )),

    )));
  }
}
