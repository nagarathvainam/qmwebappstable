import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/transaction-one-add-money.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/constant/constants.dart';

import '../question/schedule.dart';
class TranactionSuccessfull extends StatefulWidget {
   String page;
   String transactionid;
   String transactionamount;
   String transactionmessage;
   String transactiondate;
   String accountHolderName;
   String accountNumber;
   String ifscCode;
  TranactionSuccessfull({ required this.page,required this.transactionid,required this.transactionamount,required this.transactiondate,required this.transactionmessage,required this.accountHolderName,required this.accountNumber,required this.ifscCode});

  @override
  _TranactionSuccessfullState createState() => _TranactionSuccessfullState();
}

class _TranactionSuccessfullState extends State<TranactionSuccessfull>   with SingleTickerProviderStateMixin {
    String transactiondate="";
  // Loading counter value on start

  @override
  Widget build(BuildContext context) {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionDynamicUiPage()),
              (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child:Container(
      width: double.infinity,
      child: Container(
        // withdrawalhasbeensuccessfulYyc (887:311)
        padding: EdgeInsets.fromLTRB(23*fem, 20.9*fem, 12.19*fem, 7.96*fem),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              color: Color(0x28000000),
              offset: Offset(0*fem, 2*fem),
              blurRadius: 2*fem,
            ),
          ],
        ),
        child: SingleChildScrollView(child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // statusbarCoG (887:317)
              margin: EdgeInsets.fromLTRB(8.07*fem, 0*fem, 0*fem, 25.1*fem),
              width: 370.74*fem,
              height: 13*fem,
              child: SizedBox(),
            ),
      GestureDetector(
        onTap: () {
          setState(() {
            // Toggle light when tapped.
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionDynamicUiPage()),
                    (e) => false);
          });
        },
        child:Container(
              // vectorWox (887:386)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 340.81*fem, 32.35*fem),
              width: 22*fem,
              height: 19.65*fem,
              child: Image.asset(
                'assets/icons/home.png',
                width: 22*fem,
                height: 19.65*fem,
              ),
            )),


            // Container(
            //   // rectangle14qLS (887:382)
            //   margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 11.81*fem, 7*fem),
            //   width: 97*fem,
            //   height: 97*fem,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(48*fem),
            //     child: Image.network(photo),
            //   ),
            // ),


             Container(
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8.82*fem),
                width: 100.81*fem,
                height: 100.18*fem,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      Constants.photo),
                ),
              ),

            Container(
              // jennyLY6 (887:383)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 17.81*fem, 33*fem),
              child: Text(
                Constants.displayName,

                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:24*ffem,fontWeight:FontWeight.w600,height: 1.3333333333*ffem/fem,color: Color(0xff652696)   ),

              ),
            ),
            (widget.page=='request' || widget.page=='mmw')?Container(
              // frame762389EdU (887:343)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16.81*fem, 61*fem),
              padding: EdgeInsets.fromLTRB(49.5*fem, 57*fem, 49.5*fem, 95*fem),
              width: 362*fem,
              decoration: BoxDecoration (
                border: Border.all(color: Color(0xffd1d1d1)),
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(24*fem),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // Waz (887:338)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 5*fem, 25*fem),
                    child: Text(
                      ' د.إ'+widget.transactionamount,
                      style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:33*ffem,fontWeight:FontWeight.w700,height:  0.9696969697*ffem/fem,color: Color(0xff03c982)   ),

                    ),
                  ),

                  Container(
                    // line3E1C (887:341)
                    margin: EdgeInsets.fromLTRB(17.5*fem, 0*fem, 17.5*fem, 14*fem),
                    width: double.infinity,
                    height: 1*fem,
                    decoration: BoxDecoration (
                      color: Color(0x28000000),
                    ),
                  ),
                  Container(
                    // autogroupukduZJN (5fK8YDreV7Ma2RnYkcUkdU)
                    width: double.infinity,
                    height: 138*fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // layerx002016ZC (887:345)
                          left: 46.5*fem,
                          top: 14*fem,
                          child: Align(
                            child: SizedBox(
                              width: 169.94*fem,
                              height: 124*fem,
                              child: Image.asset(
                                'assets/icons/layerx00201-822.png',
                                width: 169.94*fem,
                                height: 124*fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // qmtransactionid315556852222zea (887:367)
                          left: 0*fem,
                          top: 50*fem,
                          child: Align(
                            child: SizedBox(
                              width: 300*fem,
                              height: 24*fem,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 15*ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.6*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'QM Transaction ID : ',
                                    ),
                                    TextSpan(
                                      text: widget.transactionid,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 17*ffem,
                                        fontWeight: FontWeight.w700,
                                        //height: 1.4117647059*ffem/fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   // jun2023hhmmss7ci (887:342)
                        //   left: 36*fem,
                        //   top: 80*fem,
                        //   child: Align(
                        //     child: SizedBox(
                        //       width: 194*fem,
                        //       height: 24*fem,
                        //       child: Text(
                        //         widget.transactionid,
                        //         textAlign: TextAlign.center,
                        //         style: SafeGoogleFont (
                        //           'Open Sans',
                        //           fontSize: 18*ffem,
                        //           fontWeight: FontWeight.w600,
                        //           height: 1.3333333333*ffem/fem,
                        //           color: Color(0xff000000),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),


                        Positioned(
                          // jun2023hhmmss7ci (887:342)
                          left: 36*fem,
                          top: 90*fem,
                          child: Align(
                            child: SizedBox(
                              width: 194*fem,
                              height: 24*fem,
                              child: Text(
                                widget.transactiondate,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:18*ffem,fontWeight:FontWeight.w600,height: 1.3333333333*ffem/fem,color: Color(0xff000000)   ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          // claimrequestcompletedp1L (887:339)
                          left: 60.5*fem,
                          top: 5*fem,
                          child: Align(
                            child: SizedBox(
                              width: 210*fem,
                              height: 24*fem,
                              child: Text(
                                widget.transactionmessage,
                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:16*ffem,fontWeight:FontWeight.w700,height: 1.5*ffem/fem*ffem/fem,color: Color(0xff424242)   ),

                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // vectoruHg (887:340)
                          left: 15.5*fem,
                          top: 0*fem,
                          child: Align(
                            child: SizedBox(
                              width: 22*fem,
                              height: 22*fem,
                              child: Icon(
                                Icons.check_circle,
                                color: Color(0xff1ACD54),
                                size: 32.0,

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ):SizedBox(),




            (widget.page=='payout')?Container(
              // 8A2 (869:1759)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 15*fem, 12*fem),
              child: RichText(
                text: TextSpan(
                  style: SafeGoogleFont (
                    'Open Sans',
                    fontSize: 48*ffem,
                    fontWeight: FontWeight.w800,
                    height: 0.6666666667*ffem/fem,
                    color: Color(0xff03c982),
                  ),
                  children: [
                    TextSpan(
                      text: ' ',
                      style: SafeGoogleFont (
                        'Open Sans',
                        fontSize: 40*ffem,
                        fontWeight: FontWeight.w400,
                        height: 0.8*ffem/fem,
                        color: Color(0xff03c982),
                      ),
                    ),
                    TextSpan(
                      text: 'د.إ',
                      style: SafeGoogleFont (
                        'Open Sans',
                        fontSize: 42*ffem,
                        fontWeight: FontWeight.w700,
                        height: 0.7619047619*ffem/fem,
                        color: Color(0xff03c982),
                      ),
                    ),
                    TextSpan(
                      text: widget.transactionamount,
                      style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:33*ffem,fontWeight:FontWeight.w700,height:  0.9696969697*ffem/fem,color: Color(0xff03c982)   ),

                    ),
                  ],
                ),
              ),
            ):SizedBox(),

            (widget.page=='payout')?Container(
              // autogroupr3fc4bQ (5fK76BSMA6bnMrzrGbr3fC)
              margin: EdgeInsets.fromLTRB(56*fem, 0*fem, 50*fem, 16*fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // vectorbbL (869:1762)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4*fem, 0*fem),
                    width: 22*fem,
                    height: 22*fem,
                    child: Icon(
                      Icons.check_circle,
                      color: Color(0xff1ACD54),
                      size: 22.0,

                    ),
                  ),
                  Text(
                    // completedvtW (869:1761)
                    widget.transactionmessage,
                    style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:16*ffem,fontWeight:FontWeight.w700,height: 1.5*ffem/fem*ffem/fem,color: Color(0xff424242)   ),

                  ),
                ],
              ),
            ):SizedBox(),


            (widget.page=='payout')?Container(
              // line3GhU (869:1763)
              margin: EdgeInsets.fromLTRB(10*fem, 0*fem, 0*fem, 7*fem),
              width: 209*fem,
              height: 1*fem,
              decoration: BoxDecoration (
                color: Color(0x28000000),
              ),
            ):SizedBox(),
            (widget.page=='payout')?Container(
              // jun2023hhmmssCb8 (869:1834)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 4*fem, 0*fem),
              child: Text(
                widget.transactiondate,
                textAlign: TextAlign.center,
                // style: SafeGoogleFont (
                //   'Open Sans',
                //   fontSize: 20*ffem,
                //   fontWeight: FontWeight.w600,
                //   height: 1.2*ffem/fem,
                //   color: Color(0xff000000),
                // ),

                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:20*ffem,fontWeight:FontWeight.w600,height: 1.2*ffem/fem,color: Color(0xff000000)   ),

              ),
            ):SizedBox(),

            (widget.page=='payout')?SizedBox(height: 20,):SizedBox(),

            (widget.page=='payout')?Container(
              // frame762389JeA (870:391)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 13.81*fem, 61*fem),
              padding: EdgeInsets.fromLTRB(49.5*fem, 46*fem, 49.5*fem, 122*fem),
              width: 362*fem,
              decoration: BoxDecoration (
                border: Border.all(color: Color(0xffd1d1d1)),
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(24*fem),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // qmtransactionid315556852222PQi (869:1840)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 41*fem),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: SafeGoogleFont (
                          'Open Sans',
                          fontSize: 15*ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.6*ffem/fem,
                          color: Color(0xff000000),
                        ),
                        children: [
                          TextSpan(
                            text: 'QM Transaction ID : ',
                          ),
                          TextSpan(
                            text: widget.transactionid,
                            style: SafeGoogleFont (
                              'Open Sans',
                              fontSize: 17*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.4117647059*ffem/fem,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // to33555021315jst (870:315)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 14*fem),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: SafeGoogleFont (
                          'Open Sans',
                          fontSize: 15*ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.6*ffem/fem,
                          color: Color(0xff000000),
                        ),
                        children: [
                          TextSpan(
                            text: 'To : ',
                          ),
                          TextSpan(
                            text: widget.accountNumber,
                            // style: SafeGoogleFont (
                            //   'Open Sans',
                            //   fontSize: 15*ffem,
                            //   fontWeight: FontWeight.w700,
                            //   height: 1.6*ffem/fem,
                            //   color: Color(0xff000000),
                            // ),
                            style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:15*ffem,fontWeight:FontWeight.w700,height:  1.6*ffem/fem,color: Color(0xff000000)   ),

                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // autogroupj84nXHx (5fK7cfZZ23mdWxyG9kJ84N)
                    margin: EdgeInsets.fromLTRB(35.5*fem, 0*fem, 57.56*fem, 5*fem),
                    width: double.infinity,
                    height: 131*fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // layerx00201Sfp (870:373)
                          left: 0*fem,
                          top: 0*fem,
                          child: Align(
                            child: SizedBox(
                              width: 169.94*fem,
                              height: 124*fem,
                              child: Image.asset(
                                'assets/icons/layerx00201-822.png',
                                width: 169.94*fem,
                                height: 124*fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // ifsccodekgW (870:345)
                          left: 69*fem,
                          top: 115*fem,
                          child: Align(
                            child: SizedBox(
                              width: 56*fem,
                              height: 16*fem,
                              child: Text(
                                'IFSC Code',
                                // style: SafeGoogleFont (
                                //   'Open Sans',
                                //   fontSize: 12*ffem,
                                //   fontWeight: FontWeight.w400,
                                //   height: 1.3333333333*ffem/fem,
                                //   color: Color(0xff000000),
                                // ),

                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:12*ffem,fontWeight:FontWeight.w400,height: 1.3333333333*ffem/fem,color: Color(0xff000000)   ),


                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // accountnumbervzJ (870:347)
                          left: 48*fem,
                          top: 70*fem,
                          child: Align(
                            child: SizedBox(
                              width: 95*fem,
                              height: 16*fem,
                              child: Text(
                                'Account Number',

                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:12*ffem,fontWeight:FontWeight.w400,height:  1.3333333333*ffem/fem,color: Color(0xff000000)   ),

                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // xxxxxxxxxx13152XY (870:348)
                          left: 0*fem,
                          top: 87*fem,
                          child: Align(
                            child: SizedBox(
                              width: 500*fem,
                              height: 16*fem,
                              child: Text(
                                'XXX XXX XXXX '+widget.accountNumber,
                                // style: SafeGoogleFont (
                                //   'Open Sans',
                                //   fontSize: 14*ffem,
                                //   fontWeight: FontWeight.w700,
                                //   height: 1.1428571429*ffem/fem,
                                //   color: Color(0xff000000),
                                // ),

                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:14*ffem,fontWeight:FontWeight.w700,height:   1.1428571429*ffem/fem,color: Color(0xff000000)   ),

                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // jennyjRx (870:388)
                          left: 40*fem,
                          top: 43*fem,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 100*fem,
                              height: 16*fem,
                              child: Text(
                                widget.accountHolderName,
                                // style: SafeGoogleFont (
                                //   'Open Sans',
                                //   fontSize: 14*ffem,
                                //   fontWeight: FontWeight.w700,
                                //   height: 1.1428571429*ffem/fem,
                                //   color: Color(0xff000000),
                                // ),
                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:14*ffem,fontWeight:FontWeight.w700,height:  1.1428571429*ffem/fem,color: Color(0xff000000)   ),

                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          // accountnameYeJ (870:349)
                          left: 52*fem,
                          top: 24*fem,
                          child: Align(
                            child: SizedBox(
                              width: 82*fem,
                              height: 16*fem,
                              child: Text(
                                'Account Name',
                                // style: SafeGoogleFont (
                                //   'Open Sans',
                                //   fontSize: 12*ffem,
                                //   fontWeight: FontWeight.w400,
                                //   height: 1.3333333333*ffem/fem,
                                //   color: Color(0xff000000),
                                // ),

                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:12*ffem,fontWeight:FontWeight.w400,height:  1.3333333333*ffem/fem,color: Color(0xff000000)   ),

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    // hdfc0000301TFU (870:346)
                    widget.ifscCode,
                    // style: SafeGoogleFont (
                    //   'Open Sans',
                    //   fontSize: 14*ffem,
                    //   fontWeight: FontWeight.w700,
                    //   height: 1.1428571429*ffem/fem,
                    //   color: Color(0xff000000),
                    // ),

                    style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:14*ffem,fontWeight:FontWeight.w700,height: 1.1428571429*ffem/fem,color: Color(0xff000000)   ),

                  ),
                ],
              ),
            ):SizedBox(),


            (widget.page=='payin')?Container(
              // frame762389P2v (942:407)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 13.81*fem, 192.07*fem),
              padding: EdgeInsets.fromLTRB(46.5*fem, 57*fem, 52.5*fem, 95*fem),
              width: 362*fem,
              decoration: BoxDecoration (
                border: Border.all(color: Color(0xffd1d1d1)),
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(24*fem),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (widget.page=='request' || widget.page=='payin'  || widget.page=='mmw')?Container(
                    // 4uk (942:425)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 5*fem, 25*fem),
                    child: Text(
                      ' د.إ'+widget.transactionamount,
                      style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:33*ffem,fontWeight:FontWeight.w700,height:  0.9696969697*ffem/fem,color: Color(0xff03c982)   ),

                    ),
                  ):SizedBox(),
                  Container(
                    // line3CFG (942:429)
                    margin: EdgeInsets.fromLTRB(17.5*fem, 0*fem, 17.5*fem, 14*fem),
                    width: double.infinity,
                    height: 1*fem,
                    decoration: BoxDecoration (
                      color: Color(0x28000000),
                    ),
                  ),
                  Container(
                    // autogroupb5jcKqg (5fK9x6ftSC7cGFzmEUb5jc)
                    width: double.infinity,
                    height: 138*fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // layerx00201sMQ (942:409)
                          left: 46.5*fem,
                          top: 14*fem,
                          child: Align(
                            child: SizedBox(
                              width: 169.94*fem,
                              height: 124*fem,
                              child: Image.asset(
                                'assets/icons/layerx00201-822.png',
                                width: 169.94*fem,
                                height: 124*fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // qmtransactionid315556852222zea (887:367)
                          left: 0*fem,
                          top: 50*fem,
                          child: Align(
                            child: SizedBox(
                              width: 250*fem,
                              height: 24*fem,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 15*ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.6*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'QM Transaction ID : ',
                                    ),
                                    TextSpan(
                                      text: widget.transactionid,
                                      // style: SafeGoogleFont (
                                      //   'Open Sans',
                                      //   fontSize: 17*ffem,
                                      //   fontWeight: FontWeight.w700,
                                      //   //height: 1.4117647059*ffem/fem,
                                      //   color: Color(0xff000000),
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          // jun2023hhmmssiFY (942:426)
                          left: 36*fem,
                          top: 100*fem,
                          child: Align(
                            child: SizedBox(
                              width: 194*fem,
                              height: 24*fem,
                              child: Text(
                                widget.transactiondate.toString().replaceAll("T", " "),
                                textAlign: TextAlign.center,
                                // style: SafeGoogleFont (
                                //   'Open Sans',
                                //   fontSize: 18*ffem,
                                //   fontWeight: FontWeight.w600,
                                //   height: 1.3333333333*ffem/fem,
                                //   color: Color(0xff000000),
                                // ),
                                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:18*ffem,fontWeight:FontWeight.w600,height: 1.3333333333*ffem/fem,color: Color(0xff000000)   ),

                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // qmtopupcompletedQeA (942:427)
                          left: 61.5*fem,
                          top: 1*fem,
                          child: Align(
                            child: SizedBox(
                              width: 178*fem,
                              height: 24*fem,
                              child: Text(
                                'QM Topup Completed ',
                                style: TextStyle(fontFamily:'Open Sans', decoration: TextDecoration.none,fontSize:16*ffem,fontWeight:FontWeight.w700,height: 1.5*ffem/fem*ffem/fem,color: Color(0xff424242)   ),

                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // vectorVfc (942:428)
                          left: 34.5*fem,
                          top: 0*fem,
                          child: Align(
                            child: SizedBox(
                              width: 22*fem,
                              height: 22*fem,
                              child: Icon(
                                Icons.check_circle,
                                color: Color(0xff1ACD54),
                                size: 22.0,

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ):SizedBox(),


            (widget.page!='payout' || widget.page!='mmw')?Container(
              // youwilreceiveanotificationonce (1:8381)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10.81*fem, 43.07*fem),
              constraints: BoxConstraints (
                maxWidth: 207*fem,
              ),
              child: Text(
                'You wil receive a notification \nonce its approved.',
                textAlign: TextAlign.center,
                // style: SafeGoogleFont (
                //   'Open Sans',
                //   fontSize: 14*ffem,
                //   fontWeight: FontWeight.w700,
                //   height: 1.1428571429*ffem/fem,
                //   color: Color(0xff000000),
                // ),
                style: TextStyle( fontFamily:'Open Sans',decoration: TextDecoration.none,fontSize:14*ffem,fontWeight:FontWeight.w700,height: 1.1428571429*ffem/fem,color: Color(0xff000000)   ),

              ),
            ):SizedBox(),

          ],
        ),
      ),
    )));
  }
}
