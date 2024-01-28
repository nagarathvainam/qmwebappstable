import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/constant/constants.dart';

import '../ui/transaction-one-add-money.dart';
class QuestionListAppBar extends StatelessWidget implements PreferredSizeWidget {

  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final Widget child;
  final double height;
  final String qiCoinBalance;
  final String mainBalance;
  final String photo;
  final bool isnotification;

  QuestionListAppBar({
    required this.child,
    this.height = kToolbarHeight,
    required this.qiCoinBalance,
  required this.mainBalance,
    required this.photo,
    required this.isnotification,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {

    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
        child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.fromLTRB(24*fem, 45.72*fem, 12*fem, 20*fem),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 2.0,),
              Container(
                width: double.infinity,
                height: 65*fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
              },
                child:Container(
                      margin: EdgeInsets.fromLTRB(0*fem, 9*fem, 35*fem, 8*fem),
                      width: 56*fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0*fem,
                            top: 0*fem,
                            child: Align(
                              child: SizedBox(
                                width: 48*fem,
                                height: 48*fem,
                                child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    photo),
                              ),
                              ),
                            ),
                          ),

                          /*Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8.82*fem),
                              width: 100.81*fem,
                              height: 100.18*fem,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    photo),
                              ),
                            ),),*/

                          (isnotification)?Positioned(
                            left: 32*fem,
                            top: 0*fem,
                            child: Container(
                              width: 24*fem,
                              height: 24*fem,
                              decoration: BoxDecoration (
                                color: _colorFromHex(Constants.buttonColor),
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              child: Center(
                                child: Text(
                                  '4',
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
                          ):SizedBox(),
                        ],
                      ),
                    )),
                    Container(
                      padding: EdgeInsets.fromLTRB(8*fem, 8*fem, 0*fem, 8*fem),
                      height: double.infinity,
                      decoration: BoxDecoration (
                        color: Color(0xff44228F),
                        borderRadius: BorderRadius.circular(8*fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0*fem, 3*fem, 25*fem, 0*fem),
                            height: 44*fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 3*fem, 8*fem, 0*fem),
                                  width: 22*fem,
                                  height: 17.14*fem,
                                  child: Image.asset(
                                    'assets/coins.png',
                                    width: 22*fem,
                                    height: 17.14*fem,
                                  ),
                                ),
                                Container(
                                  height: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 2*fem),
                                        child: Text(
                                          this.qiCoinBalance,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 18*ffem,
                                            fontWeight: FontWeight.w800,
                                            height: 1.2*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Coins',
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
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 15*fem, 0*fem),
                            width: 1*fem,
                            height: 49*fem,
                            decoration: BoxDecoration (
                              color: Color(0xffffffff),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0*fem, 3*fem, 39*fem, 0*fem),
                            height: 44*fem,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 3*fem, 8*fem, 0*fem),
                                  width: 15*fem,
                                  height: 17.14*fem,
                                  child: Image.asset(
                                    'assets/coins-bag.png',
                                    width: 15*fem,
                                    height: 17.14*fem,
                                  ),
                                ),
                                Container(
                                  height: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 2*fem),
                                        child: Text(
                                          this.mainBalance,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 18*ffem,
                                            fontWeight: FontWeight.w800,
                                            height: 1.2*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Main',
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
    GestureDetector(
    onTap: () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TransactionOneAddMoney()),
              (e) => false);

    },
    child:Container(
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 5*fem),
                            width: 24*fem,
                            height: 24*fem,
                            child: Image.asset(
                              'assets/icons/qi-add.png',
                              width: 24*fem,
                              height: 24*fem,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}