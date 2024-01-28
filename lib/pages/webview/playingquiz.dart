import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import '../../constant/common_utils.dart';
import 'gamepolicy.dart';

class PlayingQuiz extends StatefulWidget {
  @override
  State<PlayingQuiz> createState() => _PlayingQuizState();
}

class _PlayingQuizState extends State<PlayingQuiz> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // gamepolicyqR3 (1:90)
        padding: EdgeInsets.fromLTRB(0*fem, 72*fem, 0*fem, 0*fem),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xff5a2dbc),
        ),
        child: SingleChildScrollView(child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // contentknu (1:126)
              margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 34*fem, 23*fem),
              width: double.infinity,
              height: 27*fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogroupghtv665 (QEiHqXiMenCeR3D4unGhtV)
                    padding: EdgeInsets.fromLTRB(3*fem, 2*fem, 38*fem, 1*fem),
                    height: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                        onTap: () {
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
      builder: (context) => GamePolicy()),
      (e) => false);
      },
        child:Container(
                          // evaarrowbackoutlineM21 (1:144)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 34.72*fem, 0*fem),
                          width: 18.28*fem,
                          height: 16*fem,
                          child: Image.asset(
                            'assets/icons/eva-arrow-back-outline-dr9.png',
                            width: 18.28*fem,
                            height: 16*fem,
                          ),
                        )),
                        Text(
                          // gamepolicyErV (1:146)
                          'Game Policy',
                          style: SafeGoogleFont (
                            'Open Sans',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.5*ffem/fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // autogroupjadfBFw (QEiHjnNw57kYUYz4DEjAdf)
                    width: 164*fem,
                    height: double.infinity,
                    decoration: BoxDecoration (
                      color: Color(0xffffb400),
                      borderRadius: BorderRadius.circular(10*fem),
                    ),
                    child: Center(
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
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // addnewupirN5 (1:91)
              padding: EdgeInsets.fromLTRB(23*fem, 24*fem, 24*fem, 103*fem),
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
                    // frame1297i9P (1:92)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 176*fem, 25*fem),
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
                    // group762187FYd (1:94)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3*fem, 29*fem),
                    width: 364*fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // autogroupnpz3xxq (QEiGQQSCSpDNH1pTaknPZ3)
                          padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 13*fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // frame762454WUZ (1:96)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 33*fem),
                                width: double.infinity,
                                height: 68*fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // autogroupnh3wSd7 (QEiGZefnwkW98qkB49nh3w)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                      width: 32*fem,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // frame1296BKo (1:99)
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
                                            // line11EYy (1:97)
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
                                      // everydaytherewillbequizessched (1:98)
                                      margin: EdgeInsets.fromLTRB(0*fem, 4*fem, 0*fem, 0*fem),
                                      constraints: BoxConstraints (
                                        maxWidth: 314*fem,
                                      ),
                                      child: Text(
                                        'Every day there will be Quizes scheduled from 10 AM – 10 PM',
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
                                // frame762455dLD (1:108)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3*fem, 0*fem),
                                width: double.infinity,
                                height: 67*fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // autogrouphmehKiq (QEiGnJyN5W1uKbRmNrhMeH)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 8*fem, 0*fem),
                                      width: 32*fem,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // frame1296S2m (1:111)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 10*fem),
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
                                            // line13X4D (1:109)
                                            margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 12*fem, 0*fem),
                                            width: double.infinity,
                                            height: 25*fem,
                                            decoration: BoxDecoration (
                                              color: Color(0xff5a2dbc),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // eachquizwillhavequestionsinanm (1:110)
                                      constraints: BoxConstraints (
                                        maxWidth: 321*fem,
                                      ),
                                      child: Text(
                                        'Each Quiz will have questions in an MCQ (Multiple Choice Questions) format.',
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
                          // frame762456khf (1:102)
                          width: double.infinity,
                          height: 144*fem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // autogrouph6evh77 (QEiHDJFjDAahKT1eL6H6EV)
                                margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 8*fem, 30*fem),
                                width: 32*fem,
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // frame1296pxR (1:105)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 18*fem),
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
                                      // line12VYm (1:103)
                                      margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 12*fem, 0*fem),
                                      width: double.infinity,
                                      height: 54*fem,
                                      decoration: BoxDecoration (
                                        color: Color(0xff5a2dbc),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // questionswillcoveradiverserang (1:104)
                                constraints: BoxConstraints (
                                  maxWidth: 324*fem,
                                ),
                                child: Text(
                                  'Questions will cover a diverse range of trivia based General knowledge categories which included but are not limited to current affairs, entertainment, sports, geography, travel, history, science, technology, arts and culture.',
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
                    // frame762452doP (1:113)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 49*fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // autogroupdnd7AYR (QEiHP3UVQrZZjkcKLkdnd7)
                          margin: EdgeInsets.fromLTRB(0*fem, 2*fem, 8*fem, 0*fem),
                          width: 32*fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // frame12974th (1:116)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                width: double.infinity,
                                height: 32*fem,
                                decoration: BoxDecoration (
                                  color: Color(0xff5a2dbc),
                                  borderRadius: BorderRadius.circular(32*fem),
                                ),
                                child: Center(
                                  child: Text(
                                    '4',
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
                                // line14xz5 (1:114)
                                margin: EdgeInsets.fromLTRB(14*fem, 0*fem, 14*fem, 0*fem),
                                width: double.infinity,
                                height: 54*fem,
                                decoration: BoxDecoration (
                                  color: Color(0xff5a2dbc),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // eachquestionwillappearforatota (1:115)
                          constraints: BoxConstraints (
                            maxWidth: 327*fem,
                          ),
                          child: Text(
                            'Each Question will appear for a total duration of 15 seconds with three options. After 10 seconds the “Submit Answer” will appear and the user has 5 seconds to click on the right option and lock their answer.',
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
                    // frame762457jtM (1:118)
                    margin: EdgeInsets.fromLTRB(40*fem, 0*fem, 45*fem, 26*fem),
                    width: double.infinity,
                    height: 39*fem,
                    decoration: BoxDecoration (
                      color: Color(0xffefe8f4),
                      borderRadius: BorderRadius.circular(9*fem),
                    ),
                    child: Center(
                      child: Text(
                        'User Conduct',
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
                    // ausershallnotregisteroroperate (1:121)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 24*fem),
                    constraints: BoxConstraints (
                      maxWidth: 317*fem,
                    ),
                    child: Text(
                      'A User shall not register or operate more than one User account (Aadhar and Pan Card) with Quiz Master.',
                      style: SafeGoogleFont (
                        'Open Sans',
                        fontSize: 16*ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.5*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    // personsbelowtheageofeighteen18 (1:122)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3*fem, 27*fem),
                    constraints: BoxConstraints (
                      maxWidth: 330*fem,
                    ),
                    child: Text(
                      'Persons below the age of eighteen (18) years are not allowed to participate in any of the Quiz Schedules on our Quiz Master App. The Users will have to disclose their real age at the time of getting access into the Quiz Master App.',
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
            setState(() {
              // Toggle light when tapped.
              SnackbarUtils.showSnackbar(context, "Read more content will appear coming soon");
            });
          },
          child:Container(
                    // autogroupgabbgKj (QEiG6VnNS9wbiFap6mgabb)
                    margin: EdgeInsets.fromLTRB(44*fem, 0*fem, 41*fem, 0*fem),
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