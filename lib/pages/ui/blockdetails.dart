import 'package:flutter/material.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
//import 'package:quizmaster/pages/ui/scheme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_countdown_timer/index.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:quizmaster/pages/Components/EmptyAppBar.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../question/schedule.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';
class BlockDetailsPage extends StatefulWidget {
  String mobile;
  BlockDetailsPage({required this.mobile});
  @override
  _BlockDetailsPageState createState() => _BlockDetailsPageState();
}

class _BlockDetailsPageState extends State<BlockDetailsPage> {
  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  launchMailto(mail) async {
    final mailtoLink = Mailto(
      to: ['$mail'],
      // cc: ['cc1@example.com', 'cc2@example.com'],
      subject: '',
      body: '',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
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
    getBlockDetails(widget.mobile);
    Future.delayed(Duration(seconds: 40), () async{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginUiPage(title: '',url: '',)),
              (e) => false);
    });
  }
  String blockname="";
  String blockdisplayName="";
  String blockcomments="";
  getBlockDetails(MobileNo){
    databaseUser
        .blockdetailinfo(MobileNo)
        .whenComplete(() async{
      setState(() {
        blockname=databaseUser.blockname;
        blockdisplayName=databaseUser.blockdisplayName;
        blockcomments=databaseUser.blockcomments;
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


  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97
    return  WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QuestionDynamicUiPage()),
                  (e) => false);
         // showCloseAppConfirm(context);
          // await showDialog or Show add banners or whatever
          // return true if the route to be popped
          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            drawer: const CustomDrawer(),
            body: SafeArea(
                key: scaffoldKey,
                child:SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/background-blocked.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(

                      width: double.infinity,
                      height: 879*fem,
                      decoration: BoxDecoration (
                        color: Color(0x28f58585),
                      ),
                      child: Stack(
                        children: [
                          Positioned(

                            left: 0*fem,
                            top: 0*fem,
                            child: Container(
                              width: 631*fem,
                              height: 655*fem,
                              child: Stack(
                                children: [
                                  Positioned(
                                    // statusbarcHw (1600:977)
                                    left: 33.7584228516*fem,
                                    top: 19.4741210938*fem,
                                    child: Container(
                                      width: 355.47*fem,
                                      height: 41.4*fem,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            // layerx00201Kdb (1600:992)
                                            left: 150.2416992188*fem,
                                            top: 2.5258789062*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 52.99*fem,
                                                height: 38.87*fem,
                                                child: SizedBox(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // ellipse66822D (1600:1012)
                                    left: 0*fem,
                                    top: 0*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 631*fem,
                                        height: 567*fem,
                                        child: SizedBox(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // frame762427LHo (1600:1027)
                                    left: 37*fem,
                                    top: 333*fem,
                                    child: Container(
                                      width: 336*fem,
                                      height: 188*fem,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            // rectangle5302T7X (1600:1028)
                                            left: 0*fem,
                                            top: 16*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 336*fem,
                                                height: 172*fem,
                                                child: Container(
                                                  decoration: BoxDecoration (
                                                    borderRadius: BorderRadius.circular(22*fem),
                                                    border: Border.all(color: Color(0xffffffff)),
                                                    color: Color(0xfff33040),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0x3f000000),
                                                        offset: Offset(0*fem, 4*fem),
                                                        blurRadius: 2*fem,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            // frame7624287C5 (1600:1036)
                                            left: 7*fem,
                                            top: 0*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 39*fem,
                                                height: 39*fem,
                                                child: Image.asset(
                                                  'assets/icons/frame-762428-jS9.png',
                                                  width: 39*fem,
                                                  height: 39*fem,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            // ellipse669PvH (1600:1050)
                                            left: 114*fem,
                                            top: 128*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 5*fem,
                                                height: 5*fem,
                                                child: Container(
                                                  decoration: BoxDecoration (
                                                    borderRadius: BorderRadius.circular(2.5*fem),
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            // accountblockedJnM (1600:1090)
                                            left: 91.5*fem,
                                            top: 67*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 166*fem,
                                                height: 18*fem,
                                                child: Text(
                                                  'Account Blocked',
                                                  textAlign: TextAlign.center,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 20*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 0.9*ffem/fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            // z9P (1600:853)
                                            left: 117*fem,
                                            top: 96*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 108*fem,
                                                height: 16*fem,
                                                child: Text(
                                                  widget.mobile,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 18*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 0.8888888889*ffem/fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            // kycduplicateh3o (1600:908)
                                            left: 10.5*fem,
                                            top: 120*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 300*fem,
                                                height: 50*fem,
                                                child: Text(
                                                  blockcomments,
                                                  textAlign: TextAlign.justify,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 15*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2*ffem/fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            // akariconsfacesadPSR (1606:1945)
                                            left: 158*fem,
                                            top: 39*fem,
                                            child: Container(
                                              width: 24*fem,
                                              height: 24*fem,
                                            ),
                                          ),
                                          Positioned(
                                            // vectorXYd (1606:1954)
                                            left: 65*fem,
                                            top: 65*fem,
                                            child: Align(
                                              child: SizedBox(
                                                width: 19*fem,
                                                height: 24*fem,
                                                child: Image.asset(
                                                  'assets/icons/info.png',
                                                  width: 19*fem,
                                                  height: 24*fem,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // group762356ET3 (1600:1070)
                                    left: 24*fem,
                                    top: 19*fem,
                                    child: Container(
                                      width: 355.47*fem,
                                      height: 14*fem,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // MXf (1600:1082)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 263.47*fem, 0*fem),
                                            child: Text(
                                              '',
                                              style: SafeGoogleFont (
                                                'SF Pro Text',
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1*ffem/fem,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // statusiphone12miniU6V (1600:1071)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 2.29*fem),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // cellular16R (1600:1077)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 5.34*fem, 0*fem),
                                                  width: 17*fem,
                                                  height: 9.87*fem,
                                                  child: SizedBox(),
                                                ),
                                                Container(
                                                  // wifiXKf (1600:1073)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 5.39*fem, 0.35*fem),
                                                  width: 15.27*fem,
                                                  height: 10.14*fem,
                                                  child: SizedBox(),
                                                ),
                                                Container(
                                                  // batteryiphone12miniqLM (1600:1072)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0.01*fem, 0*fem, 0*fem),
                                                  width: 23*fem,
                                                  height: 10.48*fem,
                                                  child:SizedBox(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // quizgameXys (1600:833)
                                    left: 158*fem,
                                    top: 118*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 115*fem,
                                        height: 26*fem,
                                        child: Text(
                                          'Quiz Game',
                                          style: SafeGoogleFont (
                                            'Montserrat',
                                            fontSize: 20*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2690000534*ffem/fem,
                                            color: Color(0xffab0067),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // logod1K (1600:861)
                                    left: 99*fem,
                                    top: 61*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 241*fem,
                                        height: 53*fem,
                                        child: Image.asset(
                                          'assets/icons/logo-WqF.png',
                                          width: 241*fem,
                                          height: 53*fem,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // group7623748yf (1606:1864)
                                    left: 118*fem,
                                    top: 185*fem,
                                    child: Container(
                                      width: 158.07*fem,
                                      height: 94*fem,
                                      child: SingleChildScrollView(child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            // autogroupemfxSUZ (Ruqk8mrhV6x5NA3fMDEmfX)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3.07*fem, 7.51*fem),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // group762372mWq (1606:1822)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 10.84*fem, 16.94*fem, 0*fem),
                                                  width: 34.17*fem,
                                                  height: 34.23*fem,
                                                  child: Image.asset(
                                                    'assets/icons/group-762372.png',
                                                    width: 34.17*fem,
                                                    height: 34.23*fem,
                                                  ),
                                                ),
                                                Container(
                                                  // group762373URF (1606:1826)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 29.97*fem, 32.95*fem),
                                                  width: 31.03*fem,
                                                  height: 21.55*fem,
                                                  child: Image.asset(
                                                    'assets/icons/group-762373.png',
                                                    width: 31.03*fem,
                                                    height: 21.55*fem,
                                                  ),
                                                ),
                                                Container(
                                                  // group762370xrD (1606:1817)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 18*fem, 0*fem, 0*fem),
                                                  width: 25*fem,
                                                  height: 36.49*fem,
                                                  child: Image.asset(
                                                    'assets/icons/group-762370.png',
                                                    width: 25*fem,
                                                    height: 36.49*fem,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // group762371UZf (1606:1813)
                                            width: 158.07*fem,
                                            height: 32*fem,
                                            child: Image.asset(
                                              'assets/icons/group-762371.png',
                                              width: 158.07*fem,
                                              height: 32*fem,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                  Positioned(
                                    // group762375CkZ (1606:1940)
                                    left: 160*fem,
                                    top: 218*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 84*fem,
                                        height: 124.96*fem,
                                        child: Image.asset(
                                          'assets/icons/group-762375.png',
                                          width: 84*fem,
                                          height: 124.96*fem,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            // navigationbarGEd (1600:1007)
                            left: 0*fem,
                            top: 845*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(133.58*fem, 21*fem, 133.58*fem, 8*fem),
                              width: 414*fem,
                              height: 34*fem,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                              ),
                              child: Center(
                                // itemskfb (1600:1008)
                                child: SizedBox(
                                  width: 146.83*fem,
                                  height: 5*fem,
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // bycontinuingyouareacceptingour (1600:860)
                            left: 87*fem,
                            top: 783*fem,
                            child: Align(
                              child: SizedBox(
                                width: 244*fem,
                                height: 36*fem,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 14*ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2857142857*ffem/fem,
                                      color: Color(0xff000000),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'By Continuing, you are accepting our \n',
                                      ),
                                      TextSpan(
                                        text: 'Terms of Services',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2857142857*ffem/fem,
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff000000),
                                          decorationColor: Color(0xff000000),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' & ',
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 14*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.2857142857*ffem/fem,
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff000000),
                                          decorationColor: Color(0xff000000),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // helplinenumber4Lq (1600:951)
                            left: 149*fem,
                            top: 641*fem,
                            child: Align(
                              child: SizedBox(
                                width: 120*fem,
                                height: 18*fem,
                                child: Text(
                                  'Helpline Number',
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
                            // wvR (1600:952)
                            left: 147*fem,
                            top: 667*fem,
                            child: Align(
                              child: SizedBox(
                                width: 116*fem,
                                height: 18*fem,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _makePhoneCall("6364460708");
                                    });
                                  },
                                  child:Text(
                                  '+91 6364460708',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 15*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                )),
                              ),
                            ),
                          ),
                      Positioned(

                            left: 94*fem,
                            top: 691*fem,
                            child: Align(
                              child: SizedBox(
                                width: 220*fem,
                                height: 18*fem,
                                child:  GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      launchMailto('customercare@quizmaster.world');
                                    });
                                  },
                                  child:Text(
                                  'customercare@quizmaster.world',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 15*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2*ffem/fem,
                                    color: Color(0xff000000),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            )


        )
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
