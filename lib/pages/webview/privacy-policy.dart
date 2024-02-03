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
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/constant/common_utils.dart';
class PrivacyPolicy extends StatefulWidget {
  String mobile;
  PrivacyPolicy({required this.mobile});
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();
  Future<void> _makePhoneCall(String phoneNumber) async {


  }

  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
     
    
      // Got a new connectivity status!
    });
 
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
            backgroundColor: _colorFromHex(Constants.baseThemeColor),
            drawer: const CustomDrawer(),

            appBar:  EmptyAppBar(

              height: 50,
              child: Stack(
                children: [

                ],
              ),

              title: "Privacy Policy",
            ),
            body: SafeArea(
              ///
              key: scaffoldKey,
              child:SingleChildScrollView( child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // contentsGM (1:174)
                    margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 124*fem, 24*fem),
                    padding: EdgeInsets.fromLTRB(3*fem, 0*fem, 0*fem, 0*fem),
                    width: double.infinity,


                  ),
                  Container(
                    // addnewupiPP7 (1:149)
                    padding: EdgeInsets.fromLTRB(23*fem, 24*fem, 25*fem, 267*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only (
                        topLeft: Radius.circular(24*fem),
                        topRight: Radius.circular(24*fem),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x28000000),
                          offset: Offset(0*fem, -4*fem),
                          blurRadius: 2*fem,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // frame1297GSu (1:150)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 175*fem, 25*fem),
                          width: 189*fem,
                          height: 32*fem,
                          decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(16*fem),
                            gradient: LinearGradient (
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[Color(0x26652696), Color(0x26652696), Color(0x26652696), Color(0x26652696), Color(0x26652696), Color(0x26652696), Color(0x26652696)],
                              stops: <double>[0, 0.703, 0.771, 0.771, 0.771, 0.823, 1],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Last Updated : 24 Aug 2023',
                              style: SafeGoogleFont (
                                'Open Sans',
                                fontSize: 12*ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.3333333333*ffem/fem,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // group7621872Kb (1:152)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3*fem, 14*fem),
                          width: 363*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // frame7624548tR (1:154)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 18*fem, 18*fem),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // autogroupsc1oGjj (QEiJeg2UGWR2EiEjRkSc1o)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                      width: 32*fem,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // frame1296zfj (1:157)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 10*fem),
                                            width: double.infinity,
                                            height: 32*fem,
                                            decoration: BoxDecoration (
                                              color: Color(0xff5a2dbc),
                                              borderRadius: BorderRadius.circular(32*fem),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '1',
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 16*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // line11Huj (1:155)
                                            margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 12*fem, 0*fem),
                                            width: double.infinity,
                                            height: 26*fem,
                                            decoration: BoxDecoration (
                                              color: Color(0xff5a2dbc),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // quizmasterprivateltdrespectsth (1:156)
                                      margin: EdgeInsets.fromLTRB(0*fem, 4*fem, 0*fem, 0*fem),
                                      constraints: BoxConstraints (
                                        maxWidth: 305*fem,
                                      ),
                                      child: Text(
                                        'Quick Quiz Private Ltd respects the privacy of its Users and is committed to protect it in all respects',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // frame762456K5j (1:160)
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // autogroupzsir2kq (QEiJrqLshWEgrzFNDBzsiR)
                                      margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 8*fem, 0*fem),
                                      width: 32*fem,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // frame1296Ac9 (1:163)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 18*fem),
                                            width: double.infinity,
                                            height: 32*fem,
                                            decoration: BoxDecoration (
                                              color: Color(0xff5a2dbc),
                                              borderRadius: BorderRadius.circular(32*fem),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '2',
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 16*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // line12DqK (1:161)
                                            margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 12*fem, 0*fem),
                                            width: double.infinity,
                                            height: 112*fem,
                                            decoration: BoxDecoration (
                                              color: Color(0xff5a2dbc),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // incertaininstanceswecollectper (1:162)
                                      constraints: BoxConstraints (
                                        maxWidth: 323*fem,
                                      ),
                                      child: Text(
                                        'In certain instances, we collect personal information from you on the Quick Quiz app means such personal information which consists of information relating to your financial information, such as information regarding the payment instrument/modes used by you to make such payments, which may include cardholder name, credit/debit card number (in encrypted form) with expiration date, banking details, wallet details etc.',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5*ffem/fem,
                                          color: Color(0xff000000),
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
                          // autogroupnwnq7pD (QEiJ6c7a1qZComJd1GNwnq)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 31*fem),
                          width: double.infinity,
                          height: 264*fem,
                          child: Container(
                            // frame762452sHb (1:165)
                            width: 345*fem,
                            height: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroup9dkmDsF (QEiJJMH12YJTTyb8Az9DkM)
                                  margin: EdgeInsets.fromLTRB(0*fem, 2*fem, 8*fem, 0*fem),
                                  width: 32*fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // frame1297oKf (1:168)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                        width: double.infinity,
                                        height: 32*fem,
                                        decoration: BoxDecoration (
                                          color: Color(0xff5a2dbc),
                                          borderRadius: BorderRadius.circular(32*fem),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '3',
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 16*ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1*ffem/fem,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // line14JGR (1:166)
                                        margin: EdgeInsets.fromLTRB(14*fem, 0*fem, 14*fem, 0*fem),
                                        width: double.infinity,
                                        height: 185*fem,
                                        decoration: BoxDecoration (
                                          color: Color(0xff5a2dbc),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // thisinformationispresentedtoyo (1:167)
                                  constraints: BoxConstraints (
                                    maxWidth: 305*fem,
                                  ),
                                  child: Text(
                                    'This information is presented to you at the time of making a payment or withdrawal to enable you to complete your payment expeditiously. All information gathered on Quick Quiz is securely stored within the Quick Quiz-controlled database. The database is stored on servers secured behind a firewall; access to such servers being password-protected and strictly limited based on need-to-know basis.',
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5*ffem/fem,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle light when tapped.
                    SnackbarUtils.showSnackbar(context, "Read more content will appear coming soon");
                  });
                },
                child:Container(
                          // autogrouprk2hnqo (QEiJUbUvvyyRSkrkiurK2h)
                          margin: EdgeInsets.fromLTRB(44*fem, 0*fem, 40*fem, 0*fem),
                          width: double.infinity,
                          height: 39*fem,
                          decoration: BoxDecoration (
                            color: Color(0xfffeb205),
                            borderRadius: BorderRadius.circular(9*fem),
                          ),
                          child: Center(
                            child: Text(
                              'Read More',
                              style: SafeGoogleFont (
                                'Open Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.5*ffem/fem,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),


                ],
              ) ),
            )


        )
    );
  }

 
}
