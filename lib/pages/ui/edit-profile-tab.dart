import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/pages/ui/profilepreviousquiz.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/ui/profilewinningdetails.dart';
import 'package:quizmaster/pages/Components/CustomeAppBarQuizDetail.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/constant/constants.dart';

import '../webview/rateus.dart';
import 'login.dart';
class EditProfileTab extends StatefulWidget {
  //const EditProfileTab({Key? key}) : super(key: key);
  int initalindex;
  EditProfileTab({required this.initalindex});
  @override
  State<EditProfileTab> createState() => _EditProfileTabState();
}

class _EditProfileTabState extends State<EditProfileTab> {
  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();
  String overAllWinningAmount="0.00";
  String overAllQuizCount="0";
  int initialindex=0;

  @override
  void initState() {
    initialindex=widget.initalindex;
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });

    getScheduleOverallHistory();
    deviceAuthCheck();
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
          showSnackBarSessionTimeOut(databaseUser
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
  getScheduleOverallHistory() async{

    databaseUser
        .getScheduleOverallHistory()
        .whenComplete(() async{
      setState(() {
        overAllQuizCount=databaseUser.overAllQuizCount;
        overAllWinningAmount=(databaseUser.overAllWinningAmount!='')?databaseUser.overAllWinningAmount:"0.00";
      }
      );


    });
  }
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionDynamicUiPage()),
              (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        appBar:  CustomeAppBarQuizDetail(
          height: 120,
          child: Stack(
            children: [

            ],
          ),
          photo: Constants.photo,
        ),
        body: Scaffold(
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
        body:Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(


            color: Color(0xFFffffff),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 70,),
              Align(
                  child: SizedBox(
                    width: 400*fem,
                    height: 32*fem,
                    child: Text(
                      Constants.displayName,
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont (
                        'Open Sans',
                        fontSize: 24*ffem,
                        fontWeight: FontWeight.w800,
                        height: 1.3333333333*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),

               Align(
                  child: SizedBox(
                    width: 400*fem,
                    height: 18*fem,
                    child: Text(
                      Constants.mobileNumber,
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont (
                        'Open Sans',
                        fontSize: 14*ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2857142857*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 20,),
              Container(
                  padding: EdgeInsets.fromLTRB(20*fem, 13*fem, 23*fem, 19*fem),
                  width: 366*fem,
                  height: 106*fem,
                  decoration: BoxDecoration (
                    color: _colorFromHex(Constants.baseThemeColor),
                    borderRadius: BorderRadius.circular(12*fem),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 22*fem, 12*fem),
                        width: 141*fem,
                        height: 56*fem,
                        child: Stack(
                          children: [
                            Container(
                                width: 137*fem,
                                height: 56*fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 15*fem, 0*fem),
                                      width: 24*fem,
                                      height: 24*fem,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 14*fem, 0*fem, 0*fem),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                            child: Text(
                                              overAllQuizCount,
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 20*ffem,
                                                fontWeight: FontWeight.w800,
                                                height: 1.2*ffem/fem,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Quizzes Played',
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2857142857*ffem/fem,
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
                                width: 56*fem,
                                height: 56*fem,
                                child: Stack(
                                  children: [
                                     Align(
                                       alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 30*fem,
                                          height: 29*fem,
                                          child: Image.asset(
                                            'assets/icons/ellipse-293.png',
                                            width: 30*fem,
                                            height: 29*fem,
                                          ),
                                        ),
                                      ),

                                     Align(
                                       alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 11*fem,
                                          height: 12*fem,
                                          child: Image.asset(
                                            'assets/icons/ellipse-294.png',
                                            width: 11*fem,
                                            height: 12*fem,
                                          ),
                                        ),
                                      ),

                                     Align(
                                       alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 36*fem,
                                          height: 36*fem,
                                          child: Image.asset(
                                            'assets/icons/answer-1.png',
                                            fit: BoxFit.cover,
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
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 18*fem, 0*fem),
                        width: 1*fem,
                        height: 74*fem,
                        decoration: BoxDecoration (
                          color: Color(0x66ffffff),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                        width: 141*fem,
                        height: 56*fem,
                        child: Stack(
                          children: [
                             Container(
                                width: 136*fem,
                                height: 56*fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 14*fem, 0*fem),
                                      width: 24*fem,
                                      height: 24*fem,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 14*fem, 0*fem, 0*fem),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '₹ '+overAllWinningAmount,
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 20*ffem,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2*ffem/fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),



                                            Text(
                                              'Total Winnings',
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2*ffem/fem,
                                                color: Color(0xffffffff),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                            ),
                             Align(
                               alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 33*fem,
                                  height: 33*fem,
                                  child: Image.asset(
                                    'assets/icons/trophy-1-1.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),



              SizedBox(height: (10),),
              Container(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                  SizedBox(height: 20.0),
                  DefaultTabController(
                      length: 2, // length of tabs
                      initialIndex: initialindex,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffFFB400),
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(12), // Creates border
                                color: Colors.white),
                            padding: EdgeInsets.all(4),
                            unselectedLabelColor: Colors.white,
                            labelColor: Colors.black,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            tabs: [
                              Tab(text: 'Previous Quizzes'),
                              Tab(text: 'My Details'),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height, //height of TabBarView
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                            ),
                            child: TabBarView(children: <Widget>[
                              ProfilePreviousQuizDetail(), ProfileWinningDetails()],
                            )
                        )
                      ]
                      )
                  ),
                ]
                ),
              ),
            ],
          ),
        )
    )));
  }
}

