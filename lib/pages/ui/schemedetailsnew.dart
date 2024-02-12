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
import 'dart:io' show Platform, exit;
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
class SchemeDetailNewPage extends StatefulWidget {
  String title;
  String QuizTypeRefID;

  List list;
  int index;
  String starttimelabel;
  String currentTime;
  SchemeDetailNewPage({required this.title,required this.index, required this.list,required this.QuizTypeRefID,required this.starttimelabel,required this.currentTime});

  @override
  _SchemeDetailNewPageState createState() => _SchemeDetailNewPageState();
}

class _SchemeDetailNewPageState extends State<SchemeDetailNewPage> {
  late StreamSubscription<ConnectivityResult> subscription;


  bool _isChecked_One = false;
  bool selectAll = true;
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
      Constants.printMsg("Get Scheme Response Code:");
      Constants.printMsg(databaseQuestion.responseCode);
      if(databaseUser.responseCode!='0'){
        getSchemeData(QuizTypeRefID);
      }

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
        Constants.printMsg("Get Balance Response Code:");
        Constants.printMsg(databaseUser.responseCode);
        if(databaseUser.responseCode!='0'){
          getBalance();
        }
        qiCoinBalance=databaseUser.qiCoinBalance;
        mainBalance=databaseUser.mainBalance;
        qmWalletBalance=databaseUser.walletBalance;
        if(int.parse(qiCoinBalance)<int.parse(databaseQuestion.totalAnswer)){
          //showSnackBarWithoutExit('Insufficient Coin Wallet');
          coinvalueselected=false;
          mainvalueselected=true;
          checkedOverAllTotal=int.parse(totalAnswer);
        }
        if(int.parse(mainBalance)<int.parse(databaseQuestion.totalAnswer)){
          //showSnackBarWithoutExit('Insufficient Main Wallet');
          coinvalueselected=true;
          mainvalueselected=false;
          checkedOverAllTotal=int.parse(totalAnswer);
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
      showSnackBarWithoutExit("This schedule completed / timeout");
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
                      if (Platform.isAndroid) {
                        //SystemNavigator.pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QuestionDynamicUiPage()),
                                (e) => false);
                      } else if (Platform.isIOS) {
                        //exit(0);
                      }
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
          showCloseAppConfirm(context);
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
                    width: double.infinity,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/background-schedule.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      // paumentplayquickquizzhCM (0:40)
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
                            // autogrouptkl9QeV (8jRumu7gJG3sA2E3vsTkL9)
                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 48*fem),
                            width: double.infinity,
                            height: 875*fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // statusbarqzh (0:41)
                                  left: 33.7583770752*fem,
                                  top: 19.4739379883*fem,
                                  child: Container(
                                    width: 355.47*fem,
                                    height: 41.4*fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // layerx00201Eau (0:56)
                                          left: 150.24168396*fem,
                                          top: 2.5261230469*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 52.99*fem,
                                              height: 38.87*fem,
                                              child: Image.asset(
                                                'assets/icons/backupofquiz-master-logo-1.png',
                                                width: 52.99*fem,
                                                height: 38.87*fem,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


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
                                                        fontSize: 20*ffem,
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
                                                showSnackBarWithoutExit('Insufficient Main Wallet');
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
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                                          width: 1*fem,
                                          height: 80*fem,
                                          decoration: BoxDecoration (
                                            color: Color(0xffffffff),
                                          ),
                                        ),

                                        Container(
                                          // vectorFgu (1:2012)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0.5*fem, 4*fem, 0*fem),
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
                                          margin: EdgeInsets.fromLTRB(0*fem, 21.5*fem, 4*fem, 15*fem),
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
                                                    fontSize: 20*ffem,
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
                                                showSnackBarWithoutExit('Insufficient Coin Wallet');
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
                                /*Positioned(
                                  // frame762425TCm (0:77)
                                  left: 22*fem,
                                  top: 182*fem,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20*fem, 9.5*fem, 25*fem, 17*fem),
                                    width: 368*fem,
                                    height: 103*fem,
                                    decoration: BoxDecoration (
                                      border: Border.all(color: Color(0xffa384e5)),
                                      color: Color(0xff804cf3),
                                      borderRadius: BorderRadius.circular(22*fem),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // subtractuKf (0:80)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 3.5*fem),
                                          width: 18*fem,
                                          height: 20*fem,
                                          child: Image.asset(
                                            'assets/page-1/images/subtract.png',
                                            width: 18*fem,
                                            height: 20*fem,
                                          ),
                                        ),
                                        Container(
                                          // autogroupsobfxYq (8jRvf3K8Y1o1TWdNkxSobF)
                                          margin: EdgeInsets.fromLTRB(0*fem, 21.5*fem, 12*fem, 16*fem),
                                          width: 85*fem,
                                          height: double.infinity,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                // mainwalletsfo (0:79)
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
                                                // 8Lq (0:84)
                                                left: 0*fem,
                                                top: 15*fem,
                                                child: Align(
                                                  child: SizedBox(
                                                    width: 65*fem,
                                                    height: 24*fem,
                                                    child: Text(
                                                      '40,000',
                                                      style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 20*ffem,
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
                                        Container(
                                          // frame1459doP (0:86)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0.5*fem, 15.5*fem, 0*fem),
                                          width: 24*fem,
                                          height: 24*fem,
                                          child: Image.asset(
                                            'assets/page-1/images/frame-1459.png',
                                            width: 24*fem,
                                            height: 24*fem,
                                          ),
                                        ),
                                        Container(
                                          // vectorYvM (0:82)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0.5*fem, 9*fem, 0*fem),
                                          width: 21*fem,
                                          height: 16*fem,
                                          child: Image.asset(
                                            'assets/page-1/images/vector-vQH.png',
                                            width: 21*fem,
                                            height: 16*fem,
                                          ),
                                        ),
                                        Container(
                                          // autogroupsyyqFJy (8jRvkczAYm1kDAxjcQsYYq)
                                          margin: EdgeInsets.fromLTRB(0*fem, 21.5*fem, 8*fem, 15*fem),
                                          height: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // coinwalletxUH (0:81)
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
                                                // Vz1 (0:85)
                                                margin: EdgeInsets.fromLTRB(8*fem, 0*fem, 0*fem, 0*fem),
                                                child: Text(
                                                  '80',
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 20*ffem,
                                                    fontWeight: FontWeight.w800,
                                                    height: 1.2*ffem/fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // frame1460zfs (0:89)
                                          margin: EdgeInsets.fromLTRB(0*fem, 28.5*fem, 0*fem, 24*fem),
                                          width: 24*fem,
                                          height: double.infinity,
                                          decoration: BoxDecoration (
                                            color: Color(0xffffffff),
                                            borderRadius: BorderRadius.circular(4*fem),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),*/
                                Positioned(
                                  // playquickquizJwT (0:90)
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
                                  // totalDoX (0:91)
                                  left: 271*fem,
                                  top: 626*fem,
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
                                  // rectangle5302Aw3 (0:125)
                                  left: 34*fem,
                                  top: 349*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 350*fem,
                                      height: 393*fem,
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
                                  // questionfeepEu (0:126)
                                  left: 52*fem,
                                  top: 381*fem,
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
                                              text: '8 Q',
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
                                Positioned(
                                  // selectall16R (0:127)
                                  left: 328*fem,
                                  top: 355*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 34*fem,
                                      height: 24*fem,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Toggle light when tapped.
                                            //selectAll = !selectAll;
                                          });
                                        },
                                        child:Text(
                                        'Select All',
                                        style: SafeGoogleFont (
                                          'Oxygen',
                                          fontSize: 8*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 3*ffem/fem,
                                          color: Color(0xff000000),
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // frame762428tvu (0:128)
                                  left: 47*fem,
                                  top: 333*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 39*fem,
                                      height: 39*fem,
                                      child: Image.asset(
                                        'assets/icons/frame-762428-jS9.png',
                                        width: 39*fem,
                                        height: 39*fem,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // vector8aM (0:141)
                                  left: 332*fem,
                                  top: 376*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 26*fem,
                                      height: 25*fem,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Toggle light when tapped.
                                            //selectAll = !selectAll;
                                          });
                                        },
                                        child:Image.asset(
                                        (selectAll)?'assets/icons/selectall-green.png':'assets/icons/selectall-grey.png',
                                        width: 26*fem,
                                        height: 25*fem,
                                      ),
                                    )),
                                  ),
                                ),
                                Positioned(
                                  // totalMCD (0:142)
                                  left: 268*fem,
                                  top: 692*fem,
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
                                  // 3aq (0:143)
                                  left: 315*fem,
                                  top: 690*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 47*fem,
                                      height: 24*fem,
                                      child: Text(
                                        'د.إ' + totalAnswer,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 25*ffem,
                                          fontWeight: FontWeight.w800,
                                          height: 0.96*ffem/fem,
                                          color: Color(0xff5a2dbc),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // vectorMrR (0:144)
                                  left: 243*fem,
                                  top: 410*fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 51*fem,
                                      height: 68*fem,
                                      child: Image.asset(
                                        'assets/icons/vector-iEd.png',
                                        width: 51*fem,
                                        height: 68*fem,
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  // frame7624621vy (0:146)
                                  left: 56*fem,
                                  top: 416*fem,
                                  child: Container(
                                    width: 84*fem,
                                    height: 18*fem,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          // ellipse660kNm (0:148)
                                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 6*fem, 1*fem),
                                          width: 13*fem,
                                          height: 13*fem,
                                          decoration: BoxDecoration (
                                            borderRadius: BorderRadius.circular(6.5*fem),
                                            border: Border.all(color: Color(0xffffd75f)),
                                            color: Color(0xffffb400),
                                          ),
                                        ),


                                        Text(
                                          // groupaTny (0:147)
                                          'Group A ',
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 15*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2*ffem/fem,
                                            color: Color(0xff5a2dbc),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // frame762463naM (0:149)
                                  left: 57*fem,
                                  top: 501*fem,
                                  child: Container(
                                    width: 85*fem,
                                    height: 18*fem,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // ellipse661J2u (0:151)
                                          margin: EdgeInsets.fromLTRB(0*fem, 1*fem, 7*fem, 0*fem),
                                          width: 13*fem,
                                          height: 13*fem,
                                          decoration: BoxDecoration (
                                            borderRadius: BorderRadius.circular(6.5*fem),
                                            border: Border.all(color: Color(0xffffd75f)),
                                            color: Color(0xffffb400),
                                          ),
                                        ),
                                        Text(
                                          // groupbR7X (0:150)
                                          'Group B ',
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 15*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2*ffem/fem,
                                            color: Color(0xff5a2dbc),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762395mSH (0:152)
                                  left: 75.87890625*fem,
                                  top: 443.9998168945*fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 64.39*fem,
                                    height: 33.36*fem,
                                    child: Stack(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                              children:  <Widget>[
                                                SizedBox(width: 5,),
                                                Text("1",style: TextStyle(fontSize: 12),),
                                                SizedBox(width: 24,),
                                                Text("5",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black),),
                                                Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762396Vys (0:178)
                                  left: 75.8787841797*fem,
                                  top: 536.216796875*fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 65.37*fem,
                                    height: 33.36*fem,
                                    child: Stack(
                                      children: [
                                        //Text("2 10₹")

                                        Container(
                                          padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                          children:  <Widget>[
                                            SizedBox(width: 5,),
                                            Text("2",style: TextStyle(fontSize: 12),),
                                            SizedBox(width: 12,),
                                            Text("10",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black),),
                                            Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                          ],
                                        ))

                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762400BSh (0:204)
                                  left: 76*fem,
                                  top: 590.216796875*fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 65.37*fem,
                                    height: 33.36*fem,
                                    child: Stack(
                                      children: [
                                        //Text("2 10₹")

                                        Container(
                                            padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                              children:  <Widget>[
                                                SizedBox(width: 5,),
                                                Text("6",style: TextStyle(fontSize: 12),),
                                                SizedBox(width: 12,),
                                                Text("10",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black),),
                                                Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                              ],
                                            ))


                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762397ax1 (0:230)
                                  left: 149*fem,
                                  top: 536*fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 65.37*fem,
                                    height: 33.36*fem,
                                    child: Stack(
                                      children: [

                                        Container(
                                            padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                              children:  <Widget>[
                                                SizedBox(width: 5,),
                                                Text("3",style: TextStyle(fontSize: 12),),
                                                SizedBox(width: 12,),
                                                Text("10",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black),),
                                                Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                              ],
                                            ))


                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762401WAm (0:256)
                                  left: 149.1212158203*fem,
                                  top: 590*fem,
                                  child: Container(
                                    width: 65.37*fem,
                                    height: 33.36*fem,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                              children:  <Widget>[
                                                SizedBox(width: 5,),
                                                Text("7",style: TextStyle(fontSize: 12),),
                                                SizedBox(width: 12,),
                                                Text("10",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black),),
                                                Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                              ],
                                            ))

                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762398nzm (0:282)
                                  left: 223*fem,
                                  top: 536*fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 65.37*fem,
                                    height: 33.36*fem,
                                    child: Stack(
                                      children: [

                                        Container(
                                            padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                              children:  <Widget>[
                                                SizedBox(width: 5,),
                                                Text("4",style: TextStyle(fontSize: 12),),
                                                SizedBox(width: 12,),
                                                Text("10",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black),),
                                                Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                              ],
                                            ))


                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762402gw3 (0:308)
                                  left: 223.1212158203*fem,
                                  top: 590*fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 65.37*fem,
                                    height: 33.36*fem,
                                    child: Stack(
                                      children: [

                                        Container(
                                            padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                              children: <Widget>[
                                                SizedBox(width: 5,),
                                                Text("8",style: TextStyle(fontSize: 12),),
                                                SizedBox(width: 12,),
                                                Text("10",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black),),
                                                Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                              ],
                                            ))


                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group762399G5w (0:334)
                                  left: 296*fem,
                                  top: 535*fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage((selectAll)?'assets/icons/selected-green.png':'assets/icons/selected-grey.png'""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 65.37*fem,
                                    height: 33.36*fem,
                                    child: Stack(
                                      children: [

                                        Container(
                                            padding: EdgeInsets.only(top: 2),
                                            child:Row(
                                              children:  <Widget>[
                                                SizedBox(width: 5,),
                                                Text("5",style: TextStyle(fontSize: 12),),
                                                SizedBox(width: 12,),
                                                Text("10",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: (selectAll)?Colors.white:Colors.black)),
                                                Text("د.إ",style: TextStyle(fontSize: 18,color: (selectAll)?Colors.white:Colors.black))
                                              ],
                                            ))


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
                              "Pay د.إ "+checkedOverAllTotal.toString()+" & Play",
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
