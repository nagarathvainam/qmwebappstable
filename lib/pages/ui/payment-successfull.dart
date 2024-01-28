import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'dart:async';
import 'package:quizmaster/pages/ui/questionintro.dart';
import 'package:quizmaster/pages/Components/PaymentSuccessAppBar.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:quizmaster/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
final rank_list = "asset:///audios/transaction-music.mp3";
class PaymentSuccessfull extends StatefulWidget {
  //PaymentSuccessfull({Key? key}) : super(key: key);
  String scheduleRefID;
  PaymentSuccessfull({required this.scheduleRefID});
  @override
  _PaymentSuccessfullState createState() => _PaymentSuccessfullState();
}

class _PaymentSuccessfullState extends State<PaymentSuccessfull> {
  late SimpleAudioPlayer simpleAudioPlayer;
  double rateValue = 1.0;
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  late StreamSubscription<ConnectivityResult> subscription;
  int totalQuestion=0;
  int totalPayment=0;
  // navigateofflinescreen(){
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               NoConnectionUiPage()),
  //           (e) => false);
  // }
  @override
  void initState() {

    simpleAudioPlayer = SimpleAudioPlayer();
    simpleAudioPlayer.songStateStream.listen((event) {

    });
    simpleAudioPlayer.prepare(uri: rank_list);
    simpleAudioPlayer.setPlaybackRate(rate: rateValue);
    simpleAudioPlayer.play();
    //this.getData();
    Future.delayed(Duration(seconds: 8), () async{
      simpleAudioPlayer.stop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionIntroUiPage( scheduleRefID: widget.scheduleRefID,)), //MyPerformanceScreenOne()),
              (e) => false);
    }
    );
    readSharedPrefs();

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        //navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
    readSharedPrefs();

  }

  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      totalQuestion=(prefs.getInt('TOTALQUESTION') ?? 0); //Constants.total_question.toString();
      totalPayment= (prefs.getInt('TotalPayment') ?? 0);
    });
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
      backgroundColor: Color(0xFFFFFFFF),
        appBar:  PaymentSuccessAppBar(
          height: 220,

          child: Stack(
            children: [

            ],
          ),
        ),
      //drawer: const CustomDrawer(),


      body:
            // Main Contetn Start Here
            Container(
              width: double.infinity,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration (
                  color: Color(0xffffffff),
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // GifView.asset(
                    //   'assets/gif/transaction.gif',
                    //   height: 500,
                    //   width: 500,
                    //   frameRate: 30, // default is 15 FPS
                    // ),
                          SizedBox(height: 57*fem),
                          //////////
                          Container(
                            margin: EdgeInsets.fromLTRB(19.93*fem, 0*fem, 29.81*fem, 0*fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 7*fem, 0*fem, 33*fem),
                                  child: Text(
                                    'Payment was Successful!',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 24*ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1*ffem/fem,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///////////////


                    Container(
                      width: double.infinity,
                      //height: 756*fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0*fem,
                            top: 0*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(19*fem, 44*fem, 18*fem, 42*fem),
                              width: 414*fem,
                              // height: 756*fem,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration (
                                color:_colorFromHex(Constants.baseThemeColor),
                                borderRadius: BorderRadius.only (
                                  topLeft: Radius.circular(24*fem),
                                  topRight: Radius.circular(24*fem),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(123*fem, 0*fem, 124.19*fem, 8*fem),
                                    width: double.infinity,
                                    decoration: BoxDecoration (
                                      borderRadius: BorderRadius.circular(48*fem),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height:400*fem,
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
                                            child:CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Color(0xffffffff),
                                              child: CircleAvatar(
                                              radius: fem*60,
                                              backgroundImage: NetworkImage(
                                                  Constants.photo),
                                            )),
                                          ),
                                          Container(
                                            child: Text(
                                              Constants.displayName,
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 25*ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 0.64*ffem/fem,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                    ),


                                  ),


                                ],
                              ),
                            ),
                          ),
                           Container(
                               margin: EdgeInsets.only(top:210*fem,left: 20*fem),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                            children:  <Widget>[
                              Expanded(
                                child:Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 343.51*fem),
                                  width: double.infinity,
                                  height: 127.49*fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 336*fem,
                                        top: 103.4898681641*fem,
                                        child: Container(
                                          width: 24*fem,
                                          height: 24*fem,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0*fem,
                                        top: 20*fem,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(19*fem, 22.49*fem, 80.5*fem, 23.51*fem),
                                          width: 377*fem,
                                          height: 105*fem,
                                          decoration: BoxDecoration (
                                            color: _colorFromHex(Constants.buttonColor),
                                            borderRadius: BorderRadius.circular(13*fem),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              RichText(
                                          textAlign: TextAlign.center,
                                                text:  TextSpan(
                                                  text: 'Total Questions',
                                                  style: TextStyle(color: Colors.white,fontSize: 20),
                                                  children: <TextSpan>[
                                                    TextSpan(text: "\n$totalQuestion", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,)),

                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child:Image.asset("assets/vertical-line-separator.png"),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text:  TextSpan(
                                                  text: 'Paid',
                                                  style: TextStyle(color: Colors.white,fontSize: 20),
                                                  children: <TextSpan>[
                                                    TextSpan(text: '\n₹$totalPayment', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,)),

                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),


                    SizedBox(height: 25.0),
                  ],
                ),
              ),
            )
            // Main Contetn End Here
    )));
  }
}
