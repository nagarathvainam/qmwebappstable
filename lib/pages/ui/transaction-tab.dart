import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:quizmaster/pages/ui/transaction-one-add-money.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/pages/ui/profilepreviousquiz.dart';
import '../Components/TransactionAppBar.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/ui/profilewinningdetails.dart';
import 'package:quizmaster/pages/Components/CustomeAppBarQuizDetail.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:quizmaster/constant/constants.dart';

import 'cointab.dart';
import 'maintab.dart';
class TransactionTab extends StatefulWidget {
  const TransactionTab({Key? key}) : super(key: key);
  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {

  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();
  String overAllWinningAmount="0.00";
  String overAllQuizCount="0";
  String selectedDate="";
  int initialindex=0;

  @override
  void initState() {
    initialindex=0;
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){

      }
      // Got a new connectivity status!
    });

    //getScheduleOverallHistory();
  }




  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    return WillPopScope(
        onWillPop: () async {
          // await showDialog or Show add banners or whatever
          // return true if the route to be popped
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionOneAddMoney()),
                  (e) => false);
          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
            appBar:  TransactionAppBar(
              height: 75,
              child: Stack(
                children: [

                ],
              ),
              page: "My Trasaction",
            ),
            body: Scaffold(
                backgroundColor: _colorFromHex(Constants.baseThemeColor),
                body:Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(


                    color: Color(0xFFffffff),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                          blurRadius: 1),
                    ],
                  ),
                  child: ListView(
                    children: <Widget>[
                      //SizedBox(height: 70,),





                      SizedBox(height: (0),),
                      Container(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                          SizedBox(height: 20.0),
                          DefaultTabController(
                              length: 2, // length of tabs
                              initialIndex: initialindex,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color(0xffA90164),
                                  ),
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12), // Creates border
                                        color: Colors.white),
                                    padding: EdgeInsets.all(4),
                                    unselectedLabelColor: Colors.white,
                                    labelColor: Colors.black,
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                    tabs: <Tab>[



                                      Tab(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset('assets/svg/moneybag.svg', width: 18, height: 18),

                                            const SizedBox(width: 8),
                                            Text('Main Wallet'),
                                          ],
                                        ),
                                      ),

                                      Tab(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            //Image.asset('assets/svg/coin.svg', width: 18, height: 18),
                                            SvgPicture.asset('assets/svg/coin.svg', width: 18, height: 18),
                                            const SizedBox(width: 8),
                                            Text('Coin Wallett'),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

SizedBox(height: 20,),

                                Container(
                                    padding: EdgeInsets.only(top: 15),
                                    height: MediaQuery.of(context).size.height, //height of TabBarView
                                    decoration: BoxDecoration(
                                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                                    ),
                                    child: TabBarView(children: <Widget>[
                                      MainTab(),CoinTab(),
                                      // ProfilePreviousQuizDetail()
                                    ],
                                    )
                                ),



                              ]
                              )
                          ),
                        ]
                        ),
                      ),
                    ],
                  ),
                )
            )));
  }
}

