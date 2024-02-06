import 'package:flutter/material.dart';
import 'package:quizmaster/constant/constants.dart';
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
//import 'dart:io' show Platform, exit;
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/ui/hold-processing-payment.dart';
//import '../../model/databaseQuestion.dart';
import '';
import 'package:quizmaster/pages/ui/cashfree.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'addmoney.dart';
import 'hold-processing-question.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SchemeDetailPage extends StatefulWidget {
  String title;
  String QuizTypeRefID;

  List list;
  int index;
  String starttimelabel;
  String currentTime;
  SchemeDetailPage({required this.title,required this.index, required this.list,required this.QuizTypeRefID,required this.starttimelabel,required this.currentTime});

  @override
  _SchemeDetailPageState createState() => _SchemeDetailPageState();
}

class _SchemeDetailPageState extends State<SchemeDetailPage> {
  late StreamSubscription<ConnectivityResult> subscription;


  bool _isChecked_One = false;
  int _isChecked_One_Value = 0;
  String scheduleRefID="";
  bool _isChecked_Two = false;
  int _isChecked_Two_Value = 0;
  bool isMainBalance=false;

  bool _isChecked_Three = false;
  int _isChecked_Three_Value = 0;
  int coinValue=0;
  bool coinvalueselected=false;
  bool mainvalueselected=false;
  int walletBalance=0;
  int total=0;
  int coinAmount=0;
  int checkedOverAllTotal=0;
  bool schemeTypeBox=false;
  Question databaseQuestion = new Question();
  User databaseUser= new User();
  Transactions databaseTransaction = new Transactions();
  int endTime = DateTime.now().millisecondsSinceEpoch +
      Duration(seconds: 30).inMilliseconds;



  List schmedata=[];
  String totalQuestionCount="";
  String totalAnswer="";
  int SchemeLength=0;
  getSchemeData(QuizTypeRefID) async {
    final prefs = await SharedPreferences.getInstance();
    databaseQuestion
        .getSchemeData(QuizTypeRefID)
        .whenComplete(() async{
      setState(() {
        schmedata=databaseQuestion.schemedata as List;
        //totalQuestionCount=schmedata['status']['totalQuestionCount'];
        totalQuestionCount=databaseQuestion.totalQuestionCount;

        prefs.setInt('TOTALQUESTION', int.parse(totalQuestionCount));
        print("TTTTTTTTT $totalQuestionCount");
        totalAnswer=databaseQuestion.totalAnswer;
        if(schmedata.length==0){
          _showMyDialog();
        }else{
          schemeTypeBox=true;
        }
        print("Scheme Length:-");
        print(schmedata.length);
        SchemeLength=schmedata.length;





      });
    });
  }


  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }


  // Sync calling...
  var qTotalCount="";
  var qWaitDuration="";
  var qPlayCount="";
  var qSchemeRefID="";
  var QuestionRefID="";
  String qiCoinBalance="0";
  String debitFrom="";
  String mainBalance="0";
  String qmWalletBalance="0";

  // Loading counter value on start
  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //prefs.setString('scheduleRefID', "");
      prefs.setString('scheduleStartTime', widget.starttimelabel);
      prefs.setString('currentTime', widget.currentTime);
      prefs.setInt('SchemeLength',SchemeLength);
      // prefs.setString('QuestionRefID',QuestionRefID);//Commented By Used Constatns.QuestionRefID


      getBalance();


      //getBalance(userRefID);
    });
  }
  getBalance(){
    databaseUser
        .balanceinfo()
        .whenComplete(() async{
      setState(() {
        qiCoinBalance=databaseUser.qiCoinBalance;
        debitFrom=databaseUser.debitFrom;
        Constants.printMsg("debitFrom:");
        Constants.printMsg(debitFrom);
        mainBalance=databaseUser.mainBalance;
        qmWalletBalance=databaseUser.walletBalance;
        checkedOverAllTotal=int.parse(totalAnswer);
        if(debitFrom=="C"){
          coinvalueselected=true;
          mainvalueselected=false;
        }
        if(debitFrom=="M"){
          coinvalueselected=false;
          mainvalueselected=true;
        }
        if(int.parse(qiCoinBalance)<int.parse(databaseQuestion.totalAnswer)){
          //showSnackBarWithoutExit('Insufficient Coin Wallet');
        }
        if(int.parse(mainBalance)<int.parse(databaseQuestion.totalAnswer)){
          //showSnackBarWithoutExit('Insufficient Main Wallet');
        }

        if(int.parse(qiCoinBalance)<int.parse(databaseQuestion.totalAnswer) && int.parse(mainBalance)<int.parse(databaseQuestion.totalAnswer)){
          showSnackBarWithoutExit('Insufficient Balance for Playing game,kindly TopUp');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddMoney(transactionMsg: "",transactionAmount: "",)),
                  (e) => false);
        }


        if(qiCoinBalance!='0'){
          coinValue=int.parse(databaseUser.coinValue);
          // isMainBalance=false;
        }else{
          coinValue=0;
          //isMainBalance=true;
        }

      });
    });
  }
  /* Future<void> readSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  String? displayName = prefs.getString('displayName');
  print("User info get from shared preferance:$displayName");
  setState(() {
    displayName=displayName;
  });
  }*/



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
    getSchemeData(widget.QuizTypeRefID); // Question Scheduler calling api

    // 2016-01-25


    readSharedPrefs();


    Future.delayed(Duration(seconds: 20), () async{

      //showSnackBarWithoutExit("This schedule completed / timeout");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  QuestionDynamicUiPage()),
              (e) => false);
    });



  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user.dart must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning/Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Schedule not available this time'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuestionDynamicUiPage()),
                        (e) => false);
              },
            ),
          ],
        );
      },
    );
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
  showSnackBarWithoutExit(message) async {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);


  }
  showCloseAppConfirm(BuildContext context)
  {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(Size(
          MediaQuery.of(context).size.width,
          fem * 280)),
      context: context,
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration (
              color: Color(0xfffcfcfc),
              borderRadius: BorderRadius.only (
                topLeft: Radius.circular(24*fem),
                topRight: Radius.circular(24*fem),
              ),
            ),

            padding:EdgeInsets.all(8),child:Column(
            children: <Widget>[
              Row(
                children:  const <Widget>[

                  Text('Close',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                ],
              ),
              SizedBox(height: 20,),
              Row(
                children:  <Widget>[
                  Expanded(child: Text('Are you sure you wish to close your app?',style: TextStyle(fontSize: 14*fem,fontWeight: FontWeight.w600),)),

                ],
              ),

              SizedBox(height: 20,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: _colorFromHex(Constants.buttonColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // <-- Radius
                        ) // foreground
                    ),
                    onPressed: () async{
                      // if (Platform.isAndroid) {
                      //   //SystemNavigator.pop();
                      //   Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               QuestionDynamicUiPage()),
                      //           (e) => false);
                      // } else if (Platform.isIOS) {
                      //   //exit(0);
                      // }
                    },
                    child: const Text(
                      'Confirm Close',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,
                          fontSize: 14.0),
                    ),
                  )),
              SizedBox(height: 10,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(
                              12), // <-- Radius
                        ) // foreground
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,
                          fontSize: 14.0),
                    ),
                  )),

            ]));
      },
    );
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
        //  showCloseAppConfirm(context);
          // await showDialog or Show add banners or whatever
          // return true if the route to be popped
          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
            backgroundColor: _colorFromHex(Constants.baseThemeColor),
            drawer: const CustomDrawer(),

            /*appBar:  EmptyAppBar(
              height: 50,
              child: Stack(
                children: [

                ],
              ),
              title: "",
            ),*/
            body: SafeArea(
                key: scaffoldKey,
                child:SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/background-schedule.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: double.infinity,
                    child: Container(
                      // paumentplayquickquizzCUR (1:1970)
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/background-schedule.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(

                            // autogroupsycm87B (RW29yWfXHhhx5zg6w9sycM)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 203*fem),
                            width: double.infinity,
                            height: 667*fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // statusbare5X (1:1971)
                                  left: 33.7583007812*fem,
                                  top: 19.4739227295*fem,
                                  child: Container(

                                    width: 355.47*fem,
                                    height: 41.4*fem,
                                    child: Stack(
                                      children: [

                                        Positioned(
                                          // layerx00201qhj (1:1986)
                                          left: 150.2416992188*fem,
                                          top: 2.5261230469*fem,
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
                                // Positioned(
                                //   // ellipse668jo7 (1:2006)
                                //   left: 0*fem,
                                //   top: 0*fem,
                                //   child: Align(
                                //     child: SizedBox(
                                //       width: 631*fem,
                                //       height: 567*fem,
                                //       child: Image.asset(
                                //         'assets/icons/ellipse-668.png',
                                //         width: 631*fem,
                                //         height: 567*fem,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Positioned(
                                  // frame762425FmT (1:2007)
                                  left: 22*fem,
                                  top: 182*fem,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20*fem, 9.5*fem, 25*fem, 17*fem),
                                    width: 377*fem,
                                    height: 103*fem,
                                    decoration: BoxDecoration (
                                      border: Border.all(color: Color(0xffa384e5)),
                                      color: Color(0xff804cf3),
                                      borderRadius: BorderRadius.circular(22*fem),
                                    ),
                                    child: (schemeTypeBox==true)?Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // subtractvch (1:2010)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 3.5*fem),
                                          width: 18*fem,
                                          height: 20*fem,
                                          child: Image.asset(
                                            'assets/icons/subtract-9pM.png',
                                            width: 18*fem,
                                            height: 20*fem,
                                          ),
                                        ),
                                        Container(
                                          // autogroupn5j12Qq (RW2ATv1s4BVjQn1rjhN5J1)
                                          margin: EdgeInsets.fromLTRB(0*fem, 21.5*fem, 0*fem, 16*fem),
                                          width: 85*fem,
                                          height: double.infinity,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                // mainwalletMT7 (1:2009)
                                                left: 1*fem,
                                                top: 0*fem,
                                                child: Align(
                                                  child: SizedBox(
                                                    width: 84*fem,
                                                    height: 16*fem,
                                                    child: Text(
                                                      'Main Wallet',
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 14*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.1428571429*ffem/fem,
                                                        color: Color(0xffffffff),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                // 3Kw (1:2014)
                                                left: 0*fem,
                                                top: 15*fem,
                                                child: Align(
                                                  child: SizedBox(
                                                    width: 65*fem,
                                                    height: 24*fem,
                                                    child: Text(
                                                    mainBalance.toString(),
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 28*ffem,
                                                        fontWeight: FontWeight.w800,
                                                        height: 1.2*ffem/fem,
                                                        color: Color(0xffffffff),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                 CustomCheckBox(
                                      value: mainvalueselected,
                                      shouldShowBorder: true,
                                      borderColor: Color(0xffffffff),
                                      checkedFillColor: Color(0xff31A979),
                                      borderRadius: 8,
                                      borderWidth: 3,
                                      checkBoxSize: 22,
                                      onChanged: (value) {
                                        //do your stuff here
                                        setState(() {
                                          mainvalueselected = true;
                                          coinvalueselected = false;
                                          print("Main Balance:$mainBalance");
                                          print("totalAnswer:$totalAnswer");
                                          if(int.parse(mainBalance)<int.parse(totalAnswer)){
                                           // showSnackBarWithoutExit('Insufficient Main Wallet');
                                            mainvalueselected = false;
                                            checkedOverAllTotal=0;
                                          }else{
                                              isMainBalance=true;
                                              _isChecked_One = value!;
                                              print("Value is: $value");
                                              if(value==true){
                                              _isChecked_One_Value=(widget.QuizTypeRefID == '1')?int.parse(totalAnswer):15;
                                              }else{
                                              _isChecked_One_Value=0;
                                              }
                                              checkedOverAllTotal=_isChecked_One_Value+_isChecked_Two_Value+_isChecked_Three_Value;
                                              coinAmount=coinValue;
                                              if(checkedOverAllTotal<0){
                                              checkedOverAllTotal=0;
                                              }
                                              print("Overall Total: $_isChecked_One_Value");
                                              scheduleRefID=scheduleRefID;
                                          }
                                        });
                                      },
                                    ),
                                        Container(
                                          // vectorFgu (1:2012)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0.5*fem, 9*fem, 0*fem),
                                          width: 21*fem,
                                          height: 16*fem,
                                          child: Image.asset(
                                            'assets/icons/vector-UDo.png',
                                            width: 21*fem,
                                            height: 16*fem,
                                          ),
                                        ),
                                        Container(
                                          // autogroupercmP2R (RW2AYaYkwswxdtx8SAeRcm)
                                          margin: EdgeInsets.fromLTRB(0*fem, 21.5*fem, 8*fem, 15*fem),
                                          height: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // coinwallet7UD (1:2011)
                                                'Coin Wallet',
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 14*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.1428571429*ffem/fem,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                              Container(
                                                // FaR (1:2015)
                                                margin: EdgeInsets.fromLTRB(8*fem, 0*fem, 0*fem, 0*fem),
                                                child: Text(
                                                  qiCoinBalance.toString(),
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 28*ffem,
                                                    fontWeight: FontWeight.w800,
                                                    height: 1.2*ffem/fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                 CustomCheckBox(
                                      value: coinvalueselected,
                                      shouldShowBorder: true,
                                      borderColor: Color(0xffffffff),
                                      checkedFillColor: Color(0xff31A979),
                                      borderRadius: 8,
                                      borderWidth: 3,
                                      checkBoxSize: 22,
                                      onChanged: (value) {
                                        //do your stuff here
                                        setState(() {
                                          coinvalueselected = true;
                                          mainvalueselected = false;
                                          print("Coin Balance:$qiCoinBalance");
                                          print("totalAnswer:$totalAnswer");
                                          if(int.parse(qiCoinBalance)<int.parse(totalAnswer)){
                                            //showSnackBarWithoutExit('Insufficient Coin Wallet');
                                            coinvalueselected = false;
                                            checkedOverAllTotal=0;
                                          }else{
                                            isMainBalance=false;
                                            _isChecked_One = value!;
                                            print("Value is: $value");
                                            if(value==true){
                                              _isChecked_One_Value=(widget.QuizTypeRefID == '1')?int.parse(totalAnswer):15;
                                            }else{
                                              _isChecked_One_Value=0;
                                            }
                                            checkedOverAllTotal=_isChecked_One_Value+_isChecked_Two_Value+_isChecked_Three_Value;
                                            coinAmount=coinValue;
                                            if(checkedOverAllTotal<0){
                                              checkedOverAllTotal=0;
                                            }
                                            print("Overall Total: $_isChecked_One_Value");
                                            scheduleRefID=scheduleRefID;
                                          }
                                        });
                                      },
                                    ),
                                      ],
                                    ):Center(child:Container(
                                        width: 75,
                                        height: 75,
                                        child:  CircularProgressIndicator(
                                          color: _colorFromHex(Constants.baseThemeColor), //<-- SEE HERE
                                          backgroundColor: Color(0xffE6DCEE),
                                          strokeWidth: 8,
                                        ))),
                                  ),
                                ),
                                Positioned(
                                  // playquickquizGkR (1:2019)
                                  left: 133*fem,
                                  top: 116*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 156*fem,
                                      height: 24*fem,
                                      child: Text(
                                        widget.title,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 20*ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2*ffem/fem,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // frame762427NYZ (1:2021)
                                  left: 34*fem,
                                  top: 333*fem,
                                  child: Container(
                                    width: 350*fem,
                                    height: 201*fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // rectangle53026jT (1:2022)
                                          left: 0*fem,
                                          top: 16*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 350*fem,
                                              height: 185*fem,
                                              child: Container(
                                                decoration: BoxDecoration (
                                                  borderRadius: BorderRadius.circular(22*fem),
                                                  color: Color(0xffffffff),
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
                                          // totalyYM (1:2023)
                                          left: 237*fem,
                                          top: 153*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 37*fem,
                                              height: 24*fem,
                                              child: Text(
                                                'Total',
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 14*ffem,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1.7142857143*ffem/fem,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // TyK (1:2024)
                                          left: 284*fem,
                                          top: 151*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 47*fem,
                                              height: 24*fem,
                                              child: Text(
                                                '₹'+totalAnswer,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 30*ffem,
                                                  fontWeight: FontWeight.w800,
                                                  height: 0.96*ffem/fem,
                                                  color: Color(0xff5a2dbc),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // questionfeekxR (1:2025)
                                          left: 44*fem,
                                          top: 52*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 130*fem,
                                              height: 24*fem,
                                              child: RichText(
                                                text: TextSpan(
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 18*ffem,
                                                    fontWeight: FontWeight.w800,
                                                    height: 1.3333333333*ffem/fem,
                                                    color: Color(0xff000000),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: totalQuestionCount+' Q',
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 18*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.3333333333*ffem/fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'uestion fee',
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 18*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.3333333333*ffem/fem,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      for(int x = 0; x<schmedata.length;x++)...[
                                        Positioned(
                                          // q2rupees6dHT (1:2026)
                                          left: 57*fem,
                                          top: (x==0)?83:111*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 129*fem,
                                              height: 18*fem,
                                              child: RichText(
                                                text: TextSpan(
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 14*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: (x==0)?1.0:1.9*ffem/fem,
                                                    color: Color(0xff797979),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: schmedata[x]['questionCount']+'Q',
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 18*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1*ffem/fem,
                                                        color: Color(0xff797979),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: ' × '+schmedata[x]['scheme']+' Rupees =  '+schmedata[x]['amount'],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],


                                        Positioned(
                                          // vectorcYh (1:2028)
                                          left: 277*fem,
                                          top: 61*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 45.7*fem,
                                              height: 61*fem,
                                              child: Image.asset(
                                                'assets/icons/vector-iEd.png',
                                                width: 45.7*fem,
                                                height: 61*fem,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // vectorX9s (1:2029)
                                          left: 288.4243164062*fem,
                                          top: 72*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 22.85*fem,
                                              height: 20*fem,
                                              child: Image.asset(
                                                'assets/icons/vector-LW5.png',
                                                width: 22.85*fem,
                                                height: 20*fem,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // frame76242838D (1:2030)
                                          left: 10*fem,
                                          top: 0*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 39*fem,
                                              height: 39*fem,
                                              child: SvgPicture.asset('assets/icons/Frame 762428.svg',height: 39*fem,width: 39*fem,),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // ellipse669Yam (1:2044)
                                          left: 46*fem,
                                          top: 90*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 5*fem,
                                              height: 5*fem,
                                              child: Container(
                                                decoration: BoxDecoration (
                                                  borderRadius: BorderRadius.circular(2.5*fem),
                                                  color: Color(0xff5a2dbc),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // ellipse670Fzy (1:2045)
                                          left: 46*fem,
                                          top: 120*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 5*fem,
                                              height: 5*fem,
                                              child: Container(
                                                decoration: BoxDecoration (
                                                  borderRadius: BorderRadius.circular(2.5*fem),
                                                  color: Color(0xff5a2dbc),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // backupofquizmasterlogo1kgq (1:2046)
                                  left: 172*fem,
                                  top: 43*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 77*fem,
                                      height: 55*fem,
                                      child: Image.asset(
                                        'assets/icons/backupofquiz-master-logo-1.png',
                                        width: 77*fem,
                                        height: 55*fem,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762356T5T (1:2064)
                                  left: 24*fem,
                                  top: 19*fem,
                                  child: Container(
                                    width: 355.47*fem,
                                    height: 14*fem,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // vector49AXb (1:2077)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 1*fem, 25*fem),
                            width: 414*fem,
                            height: 0*fem,
                            child: Image.asset(
                              'assets/icons/vector-49.png',
                              width: 414*fem,
                              height: 0*fem,
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                )
            )

            ,bottomNavigationBar:  Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
              ),
            ],
          ),
          child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Row(
                  children:  <Widget>[
                    SizedBox(height: 20,),
                    Expanded(
                      child: SizedBox(
                        // height: 44.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: (checkedOverAllTotal>0)?_colorFromHex(Constants.buttonColor):Color(0xffFFF0CC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // <-- Radius
                                ) // foreground
                            ),
                            onPressed: () {
                              scheduleRefID=schmedata[0]['scheduleRefID'];

                              // Check the Schedule is Available or reached time out
                              print("Shcedule Refids:$scheduleRefID");

                              databaseQuestion.QuestionSync(scheduleRefID)
                                  .whenComplete(() async{
                                qWaitDuration=databaseQuestion.qWaitDuration;
                                //setState(() {
                                if(qWaitDuration==""){
                                  showSnackBarWithoutExit(
                                      "This schedule unavailable this time try again later");
                                }else {
                                  qTotalCount = databaseQuestion
                                      .qTotalCount; //5 Total Question Count
                                  qPlayCount = databaseQuestion
                                      .qPlayCount; //1  Paly Count Question
                                  if (int.parse(qPlayCount) > 1) {
                                    showSnackBarWithoutExit(
                                        "This schedule completed / timeout");
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QuestionDynamicUiPage()),
                                            (e) => false);
                                  } else {
                                    qSchemeRefID = databaseQuestion
                                        .qSchemeRefID; // Scheme Id
                                    QuestionRefID =
                                        databaseQuestion.questionRefID;
                                    //});

                                    // Check the Schedule is Available or reached time out

                                    databaseTransaction
                                        .payschdule(
                                        coinAmount, checkedOverAllTotal, 'DR',
                                        scheduleRefID, widget.QuizTypeRefID,
                                        coinvalueselected,mainvalueselected)
                                        .whenComplete(() async {
                                      if (databaseTransaction.responseCode ==
                                          "1") {
                                        print(
                                            "databaseQuestion.responseCode>>>>>>>");
                                        print(databaseTransaction.responseCode);
                                        print(databaseTransaction
                                            .responseDescription);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            SnackBar(
                                              content: Text(databaseTransaction
                                                  .responseDescription),
                                              backgroundColor: Colors.red,
                                              closeIconColor: Colors.red,

                                            )
                                        );

                                        /* Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QuestionDynamicUiPage()),
                                                (e) => false);*/
                                      } else {
                                        if (checkedOverAllTotal > 0) {
                                          print(
                                              "After Pay Schedcule Schedule Refid:" +
                                                  scheduleRefID);
                                          //setState(() async{
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              'scheduleRefID', scheduleRefID);
                                          await prefs.setString('QuizTypeRefID',
                                              widget.QuizTypeRefID);
                                          await prefs.setString(
                                              'ScheduleName', widget.title);
                                          await prefs.setInt('TOTALQUESTION',
                                              int.parse(totalQuestionCount));
                                          await prefs.setInt('TotalPayment',
                                              checkedOverAllTotal);


                                          //final prefs = await SharedPreferences.getInstance();
                                          //scheduleRefID = scheduleRefID;


                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HoldPaymentProcessing( scheduleRefID: scheduleRefID,)),
                                                  (e) => false);
                                          //});


                                        }
                                      }
                                    });
                                  }
                                }
                                //kkkkkfdsfskfds
                              });//exit;
//kakakakak
                            },
                            child: Text(
                              "Pay ₹ "+checkedOverAllTotal.toString()+" & Play",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          )),
                    ),
                  ],
                ),

              ]
          ),

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
