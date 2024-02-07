import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizmaster/pages/ui/myperformance-screen-two.dart';
import 'package:quizmaster/utils.dart';
import 'dart:convert';
import 'package:quizmaster/pages/ui/profilequizcorrectwronglist.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/constants.dart';
import '../webview/rateus.dart';
import 'login.dart';
import 'myperformance-screen-one.dart';
class ProfilePreviousQuizDetail extends StatefulWidget {
  const ProfilePreviousQuizDetail({Key? key}) : super(key: key);

  @override
  State<ProfilePreviousQuizDetail> createState() => _ProfilePreviousQuizDetailState();
}

class _ProfilePreviousQuizDetailState extends State<ProfilePreviousQuizDetail> {
  late StreamSubscription<ConnectivityResult> subscription;
  Transactions databaseTransaction = new Transactions();
  User databaseUser = new User();
  List previousquizdata = [];
  bool comingsoon=true;

  getpreviousquizdata() async {



    databaseTransaction
        .getpreviousquizdata()
        .whenComplete(() async{
      setState(() {


        previousquizdata=databaseTransaction.previousquizdata as List;
        print(previousquizdata.length);


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
    //deviceAuthCheck();
    getpreviousquizdata();
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
    return Container(
          color: Color(0xffffffff),

          child: (comingsoon==true) ?
       // child:
          ListView(
            children: <Widget>[
            // Start Loop Here
              (previousquizdata.length>0)?SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics:  NeverScrollableScrollPhysics(),
                    itemCount: previousquizdata == null ? 0 : previousquizdata.length,//data.length
                    itemBuilder: (BuildContext context, int index) {
                      return  Column(
                          children:  <Widget>[

                            // Remove position here 1
                             Container(
                          padding: EdgeInsets.fromLTRB(1.44*fem, 10*fem, 10*fem, 10*fem),
                          width: 485*fem,
                          height: 157*fem,
                          decoration: BoxDecoration (

                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(12*fem),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4.56*fem, 31.27*fem),
                                width: 105*fem,
                                height: 74.73*fem,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0.5592041016*fem,
                                      top: 4*fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 104.31*fem,
                                          height: 70.73*fem,
                                          child: Container(
                                            decoration: BoxDecoration (
                                              borderRadius: BorderRadius.circular(15*fem),
                                              //  color: Color(0xffd9d9d9),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  //  SizedBox(height: 5,),

                                    SingleChildScrollView(child:Column(
                                      children:  <Widget>[
                                       Row(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                          children:  <Widget>[
                                            Expanded(
                                              child:Container(

                                                  decoration: BoxDecoration (
                                                    color:Color(0xffEF6957 ),
                                                    borderRadius: BorderRadius.only(
                                                      bottomRight: Radius.circular(0),
                                                      bottomLeft: Radius.circular(0),
                                                      topLeft: Radius.circular(15*ffem),
                                                      topRight: Radius.circular(0),
                                                    ),),
                                                  //color:Color(0xffEF6957 ),
                                                  child:Padding(padding:EdgeInsets.only(left:3.0,top: 3.0),child:Text(previousquizdata[index]["month"]+" "+previousquizdata[index]["day"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:Colors.white),))
                                              )  ),
                                            Expanded(
                                              child:Container(
                                               //   padding: EdgeInsets.only(left: ffem*15.5,right: ffem*5.0,top: ffem*5.0,bottom: ffem*6.0),
                                                  decoration: BoxDecoration (
                                                    color:Color(0xffD8443F ),
                                                    borderRadius: BorderRadius.only(
                                                      bottomRight: Radius.circular(0),
                                                      bottomLeft: Radius.circular(0),
                                                      topLeft: Radius.circular(0),
                                                      topRight: Radius.circular(15*ffem),
                                                    ),),
                                                  child:Padding(padding:EdgeInsets.only(left:3.0,top: 3.0),child:Text(previousquizdata[index]["year"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:Colors.white),))
                                              )
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 2,),

                                        Container(
                                            //padding: EdgeInsets.only(left: ffem*10.0,right: ffem*5.0,top: ffem*0.0,bottom: ffem*0.0),
                                          decoration: BoxDecoration (
                                            color:Color(0xffA90164),
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(15*ffem),
                                                bottomLeft: Radius.circular(15*ffem),
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(0),
                                              ),),

                                        child:Row(
                                          children:  <Widget>[
                                            Expanded(
                                                child:Image.asset("assets/calendar.png",height: 45,)
                                            ),
                                            Expanded(
                                                   child:Text(previousquizdata[index]["quizName"],textAlign:TextAlign.center,style: TextStyle(fontSize:  14*ffem,fontWeight: FontWeight.bold,color:Colors.white),)
                                            )
                                          ],
                                        )
                                        ),
                                      ],
                                    )),

                                    Positioned(
                                      left: 19.5592041016*fem,
                                      top: 49*fem,
                                      child: Container(
                                        width: 24*fem,
                                        height: 24*fem,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                width: 228*fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 6*fem),
                                      width: double.infinity,
                                      height: 85*fem,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0*fem,
                                            top: 14*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 228*fem,
                                                height: 71*fem,
                                                child: Container(
                                                  decoration: BoxDecoration (
                                                    borderRadius: BorderRadius.circular(16*fem),
                                                    color: Color(0x28e70d93),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 136*fem,
                                            top: 34*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 14*fem,
                                                height: 14*fem,
                                                child: Image.asset(
                                                  'assets/icons/icon-park-solid-check-correct.png',
                                                  width: 14*fem,
                                                  height: 14*fem,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 45*fem,
                                            top: 36*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 40*fem,
                                                height: 18*fem,
                                                child: Text(
                      previousquizdata[index]["winnersRank"]+ordinal( int.parse(previousquizdata[index]["winnersRank"])),

                                                  textAlign: TextAlign.center,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 14*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2857142857*ffem/fem,
                                                    color: Color(0xff242424),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 22.5*fem,
                                            top: 54*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 65*fem,
                                                height: 16*fem,
                                                child: Text(
                                                  'Game Rank',
                                                  textAlign: TextAlign.center,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 12*ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.3333333333*ffem/fem,
                                                    color: Color(0xff484848),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      Positioned(
                                        left: 100*fem,
                                        top: 23*fem,
                                        child:Image.asset("assets/vertical-line-separator.png")),
                                          Positioned(
                                            left: 157*fem,
                                            top: 32*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 30*fem,
                                                height: 18*fem,
                                                child: Text(
                                                  previousquizdata[index]["winningCount"]+"/"+previousquizdata[index]["questionCount"],

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
                                          ),
                                          Positioned(
                                            left: 123*fem,
                                            top: 52*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 92*fem,
                                                height: 16*fem,
                                                child: Text(
                                                  'Correct Answers',
                                                  textAlign: TextAlign.center,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 12*ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.3333333333*ffem/fem,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 190*fem,
                                            top: 0*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 32*fem,
                                                height: 32*fem,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      print('clicked here $index');
                                                      Constants.scheduleRefID=previousquizdata[index]["scheduleRefID"];

                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => MyPerformanceScreenTwo(scheduleRefID:Constants.scheduleRefID ,fromscreen:'previous')),
                                                              (e) => false);
                                                     /* Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileQuizCorrectWrongList(
                                                                      list: previousquizdata,
                                                                      index:1,
                                                                      scheduleRefID:previousquizdata[index]["scheduleRefID"]
                                                                  )
                                                          ),
                                                              (e) => false);*/

                                                    });
                                                  },
                                                  child:Image.asset(
                                                  'assets/icons/frame-762363.png',
                                                  width: 32*fem,
                                                  height: 32*fem,
                                                )),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 27*fem,
                                            top: 36*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 15*fem,
                                                height: 14*fem,
                                                child: Image.asset(
                                                  'assets/icons/icon-park-ranking-ZJn.png',
                                                  width: 15*fem,
                                                  height: 14*fem,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(5*fem, 0*fem, 3*fem, 0*fem),
                                      width: double.infinity,
                                      height: 29*fem,
                                      decoration: BoxDecoration (
                                        color: Color(0xff77319e),
                                        borderRadius: BorderRadius.circular(10*fem),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 61*fem,
                                            top: 5*fem,
                                            child: Container(
                                              width: 20*fem,
                                              height: 20*fem,
                                            ),
                                          ),
                                          Positioned(
                                            left: 63*fem,
                                            top: 6*fem,
                                            child: Container(
                                              width: 73*fem,
                                              height: 18*fem,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10.87*fem, 0*fem),
                                                    width: 17.13*fem,
                                                    height: 18*fem,
                                                    child: Image.asset(
                                                      'assets/icons/rupee.png',
                                                      width: 17.13*fem,
                                                      height: 18*fem,
                                                    ),
                                                  ),
                                                  Text(
                                                    previousquizdata[index]["winningAmount"],

                                                    textAlign: TextAlign.center,
                                                    style: SafeGoogleFont (
                                                      'Open Sans',
                                                      fontSize: 14*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.2857142857*ffem/fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                  ],
                                ),
                              ),

                            ],

                          ),

                        ),

                      SizedBox(height: 10,) ]
                      );
                    },
                  )):  Center(

                  child:CircularProgressIndicator()),
            ],
          )
            :Text("Coming Soon..."),

    );
  }
}

