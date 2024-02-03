import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import '../question/schedule.dart';
import 'playingquiz.dart';
import 'package:quizmaster/constant/common_utils.dart';

class GamePolicy extends StatefulWidget {
  @override
  State<GamePolicy> createState() => _GamePolicyState();
}

class _GamePolicyState extends State<GamePolicy> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // gamepolicyMGV (1:39)
        padding: EdgeInsets.fromLTRB(0*fem, 24.21*fem, 0*fem, 0*fem),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xff5a2dbc),
        ),
        child: SingleChildScrollView(child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // contentCpq (1:68)
              margin: EdgeInsets.fromLTRB(26*fem, 0*fem, 10.19*fem, 39.71*fem),
              padding: EdgeInsets.fromLTRB(3*fem, 0*fem, 0*fem, 0*fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // itemssAH (1:69)
                    margin: EdgeInsets.fromLTRB(4.07*fem, 0*fem, 0*fem, 18.09*fem),
                    width: 370.74*fem,
                    height: 13*fem,
                    child: Image.asset(
                      'assets/page-1/images/items-Qho.png',
                      width: 370.74*fem,
                      height: 13*fem,
                    ),
                  ),
                  Container(
                    // autogroupaaemkjs (QEiFU6fMRd6HRqVjfzaAeM)
                    height: 27*fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionDynamicUiPage()),
                                  (e) => false);
                  },
                    child:Container(
                          // evaarrowbackoutlinedof (1:86)
                          margin: EdgeInsets.fromLTRB(0*fem, 1*fem, 14.72*fem, 0*fem),
                          width: 18.28*fem,
                          height: 16*fem,
                          child: Image.asset(
                            'assets/icons/eva-arrow-back-outline-dr9.png',
                            width: 18.28*fem,
                            height: 16*fem,
                          ),
                        )),
                        Container(
                          // autogroupewcrWky (QEiFa1fAaCmkZ9cQDdEWCR)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 49*fem, 0*fem),
                          width: 140*fem,
                          height: double.infinity,
                          decoration: BoxDecoration (
                            color: Color(0xffffb400),
                            borderRadius: BorderRadius.circular(10*fem),
                          ),
                          child: Center(
                            child: Text(
                              'Game Policy',
                              style: SafeGoogleFont (
                                'Open Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.5*ffem/fem,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
        GestureDetector(
          onTap: () {

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlayingQuiz()),
                      (e) => false);

          },
          child:Container(
                          // playingquiz5Sh (1:89)
                          margin: EdgeInsets.fromLTRB(0*fem, 0.41*fem, 0*fem, 0*fem),
                          child: Text(
                            'Playing Quiz',
                            style: SafeGoogleFont (
                              'Open Sans',
                              fontSize: 16*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.5*ffem/fem,
                              color: Color(0xffffffff),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // addnewupinc1 (1:40)
              padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 8*fem, 23*fem),
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
                    // frame1297dcd (1:60)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 193*fem, 24*fem),
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
                    // group762187WZw (1:41)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 68*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(32*fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // group762181Chf (1:46)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                          padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 32*fem, 0*fem),
                          width: double.infinity,
                          decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(32*fem),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // frame12966Y9 (1:48)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                width: 32*fem,
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
                                // quizersshouldbeabovetheageof18 (1:47)
                                constraints: BoxConstraints (
                                  maxWidth: 294*fem,
                                ),
                                child: Text(
                                  'Quizers should be above the age of 18 years to participate and play the quiz.',
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
                          // autogroupd89wEXs (QEiEZhzyvz7uE9v1zkD89w)
                          width: 366*fem,
                          height: 509*fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // group762186Nty (1:42)
                                left: 16*fem,
                                top: 0*fem,
                                child: Container(
                                  width: 4*fem,
                                  height: 509*fem,
                                ),
                              ),
                              Positioned(
                                // group762183utu (1:50)
                                left: 0*fem,
                                top: 413*fem,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 1*fem, 0*fem),
                                  width: 356*fem,
                                  height: 96*fem,
                                  decoration: BoxDecoration (
                                    borderRadius: BorderRadius.circular(32*fem),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // frame1296A49 (1:52)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 12*fem, 0*fem),
                                        width: 32*fem,
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
                                        // oncethequizershaveenteredtheab (1:51)
                                        constraints: BoxConstraints (
                                          maxWidth: 311*fem,
                                        ),
                                        child: Text(
                                          'Once the Quizers have entered the above information and clicked on the "Create Profile" tab their account will be created instantly',
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
                              Positioned(
                                // ofullnameoemailaddressostateof (1:55)
                                left: 56*fem,
                                top: 187*fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 189*fem,
                                    height: 192*fem,
                                    child: Text(
                                      'o Full Name\no E-mail address\no State of Residence\no Gender\no Date of birth\no Aadhar Number\no Pan Number\no Bank Account Number',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5*ffem/fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // group762182gKK (1:56)
                                left: 0*fem,
                                top: 53*fem,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 4*fem, 0*fem),
                                  width: 366*fem,
                                  height: 120*fem,
                                  decoration: BoxDecoration (
                                    borderRadius: BorderRadius.circular(32*fem),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // frame1296mbf (1:58)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                        width: 32*fem,
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
                                        // inordertoregisterandparticipat (1:57)
                                        constraints: BoxConstraints (
                                          maxWidth: 322*fem,
                                        ),
                                        child: Text(
                                          'In order to register and participate in our Quick Quiz App you are required to accurately provide the following information in your Quizer profile as per your Aadhar Card.',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // autogroupvjroxpZ (QEiEH3p5BD5NZarmMvVJRo)
                    margin: EdgeInsets.fromLTRB(44*fem, 0*fem, 56*fem, 23*fem),
                    width: double.infinity,
                    height: 39*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffefe8f4),
                      borderRadius: BorderRadius.circular(9*fem),
                    ),
                    child: Center(
                      child: Text(
                        'Conditions of Participation',
                        style: SafeGoogleFont (
                          'Open Sans',
                          fontSize: 16*ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.5*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // winnersareinstantlydeclaredbyt (1:64)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 19*fem, 49*fem),
                    constraints: BoxConstraints (
                      maxWidth: 345*fem,
                    ),
                    child: Text(
                      'Winners are instantly declared by the computer intelligence programmed which is tamper proof and will capture even the micro and nano seconds clocked by a quizer to submit an answer and hence there is absolutely no human intervention',
                      style: SafeGoogleFont (
                        'Open Sans',
                        fontSize: 16*ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.5*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
        GestureDetector(
          onTap: () {
              // Toggle light when tapped.
              SnackbarUtils.showSnackbar(context, "Read more content will appear coming soon");

          },
          child:Container(
                    // autogroupeqwx2C9 (QEiENNzXLaT4Y1MeSkEqwX)
                    margin: EdgeInsets.fromLTRB(40*fem, 0*fem, 60*fem, 0*fem),
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
        ),
      ),
          ));
  }
}