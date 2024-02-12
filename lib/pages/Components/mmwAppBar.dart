import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';

import 'package:quizmaster/constant/constants.dart';
import '../question/schedule.dart';
import '../ui/transaction-one-add-money.dart';
class mmwAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  final String withdrawnBalance;
  final String dailyLimit;
  mmwAppBar({
    required this.withdrawnBalance,
    required this.dailyLimit,
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20*fem, 30.72*fem, 20*fem, 0*fem),
              width: double.infinity,
              height: MediaQuery.of(context).size.height ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(height: 3.0,),
                  ListTile(
                    leading:IconButton(
                      icon: const Icon(Icons.arrow_back,color: Colors.white,),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionOneAddMoney()),
                                (e) => false);

                      },
                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    ) ,
                    title: Text("Transfer Winning Balance to Main Balance",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w700 ),),
                  ),




                  // Align(
                  //   alignment: Alignment.topLeft,

                  //child:Text('Move To Bank',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold ),),
                  // ),
                  // SizedBox(height: 5,),

                  //
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //
                  //   child:Text('Max Withdrawable amount is ₹5000',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w400 ),), ),

                  SizedBox(height: 20,),

                  Container(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF44228F),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12)
                        ),
                      ),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,//#00F0FF
                        children:  <Widget>[

                          Image.asset(
                              'assets/icons/fluent-trophy-20-filled-nyh.png',
                              width: 18*fem,
                              height: 20*fem
                            //     height: 40*fem,
                          ),
                          SizedBox(width: 3,),
                          Expanded(child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              Text('Winning Amount',style: TextStyle(color: Colors.white),),
                              //Text('₹4200',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                              RichText(
                                // 4mk (869:1378)
                                text: TextSpan(
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 24*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1*ffem/fem,
                                    color: Color(0xffffffff),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'د.إ '+withdrawnBalance,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          )),

                          Container(
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 15*fem, 0*fem),
                            width: 1*fem,
                            height: 49*fem,
                            decoration: BoxDecoration (
                              color: Color(0xffffffff),
                            ),
                          ),
                          Image.asset(
                              'assets/icons/mmw-coins.png',
                              width: 18*fem,
                              height: 20*fem
                            //     height: 40*fem,
                          ),
SizedBox(width: 3,),

                          Expanded(child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              Text('Limit',style: TextStyle(color: Color(0xff00FFE0)),),
                              //Text('₹4200',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                              RichText(
                                // 4mk (869:1378)
                                text: TextSpan(
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 24*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1*ffem/fem,
                                    color: Color(0xffffffff),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'د.إ '+dailyLimit,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          )),

                        ],
                      ))
                  ,




                ],
              ),
            ),
          ],
        ));
  }
}