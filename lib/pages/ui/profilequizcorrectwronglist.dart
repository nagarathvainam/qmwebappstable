import 'package:flutter/material.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/Components/profilequizcorrectanswer.dart';
import 'package:quizmaster/pages/ui/edit-profile-tab.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../webview/rateus.dart';
import 'login.dart';
class ProfileQuizCorrectWrongList extends StatefulWidget {
  List list;
  int index;
  String scheduleRefID;
  ProfileQuizCorrectWrongList({required this.index, required this.list, required this.scheduleRefID});

  @override
  ProfileQuizCorrectWrongListState createState() => ProfileQuizCorrectWrongListState();
}

class ProfileQuizCorrectWrongListState extends State<ProfileQuizCorrectWrongList> {
  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();
  Question databaseQuestion = new Question();
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  List correctanswerdata=[];
  getCorrectAnswerData() async {
    databaseQuestion
        .getCorrectAnswerData(widget.scheduleRefID)
        .whenComplete(() async{
      setState(() {
        correctanswerdata=databaseQuestion.correctanswerdata as List;
        print("Correct Answer Data Length:-");
        print(correctanswerdata.length);
      });
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
    getCorrectAnswerData();
    //deviceAuthCheck();
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfileTab(initalindex:0)),
                  (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
      appBar:  ProfileQuizeCorrectAnswer(
        height: 70,
        child: Stack(
          children: [

          ],
        ),
      ),
        body:  SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 459*fem,
                  height: 887*fem,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0*fem,
                        top: 0*fem,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0*fem, 24*fem, 0*fem, 0*fem),
                          width: 414*fem,
                          height: 776*fem,
                          decoration: BoxDecoration (
                            color: Color(0xffffffff),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 24*fem, 670*fem),
                                padding: EdgeInsets.fromLTRB(4*fem, 4*fem, 4*fem, 4*fem),
                                width: double.infinity,
                                height: 48*fem,
                                decoration: BoxDecoration (
                                  color: Color(0xffFFB400),
                                  borderRadius: BorderRadius.circular(12*fem),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                    onTap: () {
                        setState(() {
                        // Toggle light when tapped.
                        print('previous quize');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileTab(initalindex:0)),
                                (e) => false);
                        });
                        },
                          child:Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4*fem, 0*fem),
                                      width: 177*fem,
                                      height: double.infinity,
                                      decoration: BoxDecoration (
                                        color: Color(0xffFFB400),
                                        borderRadius: BorderRadius.circular(12*fem),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xffFFB400),
                                            offset: Offset(0*fem, 0*fem),
                                            blurRadius: 2*fem,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Previous Quizzes',
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 12*ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3333333333*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    )),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // Toggle light when tapped.
                              print('my details');

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfileTab(initalindex:1)),
                                      (e) => false);
                            });
                          },
                          child:Container(
                                      width: 177*fem,
                                      height: double.infinity,
                                      decoration: BoxDecoration (
                                        borderRadius: BorderRadius.circular(12*fem),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xffffffff),
                                            offset: Offset(0*fem, 0*fem),
                                            blurRadius: 2*fem,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'My Details',
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 12*ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3333333333*ffem/fem,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24*fem,
                        top: 91*fem,
                        child: Container(
                          width: 435*fem,
                          height: 796*fem,
                          child: SingleChildScrollView(child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                for(int index = 0; index<correctanswerdata.length;index++)...[
                                    // Loop Start
                                    Container(
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
                                                            (index).toString()+"/"+correctanswerdata.length.toString(),
                                                            style: SafeGoogleFont (
                                                              'Open Sans',
                                                              fontSize: 12*ffem,
                                                              fontWeight: FontWeight.w600,
                                                              height: 1.3333333333*ffem/fem,
                                                              color: Color(0xff5a2dbc),
                                                            ),
                                                          ),
                                                        ),
                                                      )/*,
                                                      Text(
                                                        'Answered in 2s 500ms',
                                                        textAlign: TextAlign.right,
                                                        style: SafeGoogleFont (
                                                          'Open Sans',
                                                          fontSize: 12*ffem,
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.3333333333*ffem/fem,
                                                          color: Color(0xff000000),
                                                        ),
                                                      ),*/
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
                                            padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 16*fem, 12*fem),
                                            width: double.infinity,
                                            decoration: BoxDecoration (
                                              color: Color(0x2836c4bd),
                                              borderRadius: BorderRadius.only (
                                                bottomRight: Radius.circular(12*fem),
                                                bottomLeft: Radius.circular(12*fem),
                                              ),
                                            ),
                                            child: RichText(
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
                                                    text: '₹'+correctanswerdata[index]['winningPrice'],
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 24*fem,
                                    ),

                                    // Loop End
                            ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
