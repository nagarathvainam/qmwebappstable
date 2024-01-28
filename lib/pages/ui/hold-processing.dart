import 'package:flutter/material.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class HoldProcessing extends StatefulWidget {
  String title;
  String message;
  bool isloading;
  String color;
  HoldProcessing({required this.title, required this.message, required this.isloading, required this.color});

  @override
  _HoldProcessingState createState() => _HoldProcessingState();
}

class _HoldProcessingState extends State<HoldProcessing> {

  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  late StreamSubscription<ConnectivityResult> subscription;
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

  }
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  @override@override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {
          // await showDialog or Show add banners or whatever
          // return true if the route to be popped
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QuestionDynamicUiPage()),
                  (e) => false);
          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            body: Container(
              color: Colors.white,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.fromLTRB(31.07*fem, 21*fem, 12.19*fem, 8*fem),
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
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 354*fem),
                        width: 370.74*fem,
                        height: 13*fem,
                        child: SizedBox(),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(41.93*fem, 0*fem, 60.81*fem, 279*fem),
                        width: double.infinity,
                        decoration: BoxDecoration (
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16*fem),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (widget.isloading)?Container(
                                margin: EdgeInsets.fromLTRB(74*fem, 0*fem, 74*fem, 40*fem),
                                padding: EdgeInsets.fromLTRB(0*fem, 0.27*fem, 0*fem, 0*fem),
                                width: double.infinity,
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width: 75,
                                        height: 75,

                                        child:  CircularProgressIndicator(
                                          color: _colorFromHex(widget.color), //<-- SEE HERE
                                          backgroundColor: Color(0xffE6DCEE),
                                          strokeWidth: 8,
                                        )),
                                  ],
                                )
                            ):SizedBox(
                              height: 115,
                              width: 115,
                              child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Color(0xffEBD9C3),
                                      child:Container(

                                        margin: EdgeInsets.fromLTRB(8.82*fem, 8.82*fem, 8.82*fem, 8.82*fem),
                                        width: 129.81*fem,
                                        height: 134.18*fem,
                                        // color: Colors.white,
                                        child:CircleAvatar(
                                          radius: 5,
                                          // backgroundColor: Color(0xffC6E074),
                                          child: Container(
                                            height: 150,
                                            width: 146,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _colorFromHex(widget.color),
                                            ),
                                            child: Icon(Icons.check, color: Colors.white,size: 80,),
                                            alignment: Alignment.center,
                                          ),),
                                      )),

                                ],
                              ),
                            ),
                            SizedBox(height: 25,),
                            Container(
                              margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 16*fem),
                              child: Text(
                                widget.title,
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
                            Text(
                              widget.message,
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont (
                                'Open Sans',
                                fontSize: 14*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.1428571429*ffem/fem,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ), bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
              ),
            ],
          ),
          child:Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 18.88*fem, 0*fem),
                  width: 146.83*fem,
                  height: 5*fem,
                  child: SizedBox(),
                ),
              ],
            ),
          ),)));
  }
}
