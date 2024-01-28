import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizmaster/utils.dart';

import '../ui/redeemcode.dart';

class TermsandCondition extends StatefulWidget {
  @override
  State<TermsandCondition> createState() => _TermsandConditionState();
}

class _TermsandConditionState extends State<TermsandCondition> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // signupsigninARf (1:211)
        padding: EdgeInsets.fromLTRB(18*fem, 55.67*fem, 12.19*fem, 0*fem),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
        ),
        child: SingleChildScrollView(child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // statusbargQ1 (1:212)
              margin: EdgeInsets.fromLTRB(13.07*fem, 0*fem, 0*fem, 73.33*fem),
              width: 370.74*fem,
              height: 13*fem,
              child: SizedBox(),
            ),
            Container(
              // logonC9 (1:234)
              margin: EdgeInsets.fromLTRB(12*fem, 0*fem, 0*fem, 9*fem),
              width: 227*fem,
              height: 50*fem,
              child: Image.asset(
                'assets/icons/logo-WqF.png',
                width: 227*fem,
                height: 50*fem,
              ),
            ),
            Container(
              // termsconditionsWdw (1:276)
              margin: EdgeInsets.fromLTRB(12*fem, 0*fem, 0*fem, 13*fem),
              constraints: BoxConstraints (
                maxWidth: 172*fem,
              ),
              child: Text(
                'Terms & \nConditions',
                style: SafeGoogleFont (
                  'Open Sans',
                  fontSize: 32*ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.046875*ffem/fem,
                  color: Color(0xff0d0d0d),
                ),
              ),
            ),
            Container(
              // autogroupcdb7p8q (QEiKFjrNjhRR2XCb5pcdb7)
              width: 377*fem,
              height: 1759*fem,
              child: Stack(
                children: [
                  Positioned(
                    // itemsKLV (1:231)
                    left: 121.583984375*fem,
                    top: 929*fem,
                    child: Align(
                      child: SizedBox(
                        width: 146.83*fem,
                        height: 5*fem,
                        child: Image.asset(
                          'assets/page-1/images/items-Xg5.png',
                          width: 146.83*fem,
                          height: 5*fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // frame762384pHF (1:277)
                    left: 0*fem,
                    top: 0*fem,
                    child: Container(
                      width: 377*fem,
                      height: 1759*fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // autogroup9hkukgh (QEi7nenuoWuWKv8tY59hku)
                            left: 0*fem,
                            top: 0*fem,
                            child: Align(
                              child: SizedBox(
                                width: 358*fem,
                                height: 1759*fem,
                                child: Image.asset(
                                  'assets/icons/auto-group-9hku.png',
                                  width: 358*fem,
                                  height: 1759*fem,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // frame1SpR (1:284)
                            left: 11*fem,
                            top: 1639*fem,
                            child: GestureDetector(
                              onTap: () {
                                Navigator
                                    .pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) =>
                                            RedeemUiPage()),
                                        (e) => false);
                              },
                              child:Container(
                              width: 366*fem,
                              height: 44*fem,
                              decoration: BoxDecoration (
                                color: Color(0xffffb400),
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              child: Center(
                                child: Text(
                                  'Continue',
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
                            )),
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
          ));
  }
}