import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/transaction-tab.dart';
import 'package:quizmaster/pages/ui/transaction-two-withdraw-money.dart';
//import 'package:quizmaster/pages/ui/walletmoneywithdraw.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import '../Components/TransactionAddMoneyAppBar.dart';
import '../Components/TransactionAppBar.dart';
import '../Components/mmwAppBar.dart';
import '../question/schedule.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
//import 'package:quizmaster/pages/ui/transaction-history.dart';
import 'package:quizmaster/pages/ui/addmoney.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
//import '../../model/databasehelper.dart';
import 'kyc-verification.dart';

import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TransactionOneAddMoney extends StatefulWidget {
  TransactionOneAddMoney({Key? key}) : super(key: key);

  @override
  _TransactionOneAddMoneyState createState() => _TransactionOneAddMoneyState();
}
class _TransactionOneAddMoneyState extends State<TransactionOneAddMoney> {
  late StreamSubscription<ConnectivityResult> subscription;
  User databaseUser = new User();
  bool iswinningbalancetomainbalance=false;
  Transactions databaseTransaction=new Transactions();
  List mtbdata=[];
  String dailyLimit="";
  String dailyBalanceAmount="";
  String selectedDate="";
  String approvedStatusRefID="0";
  String withdrawHead1="";
  String minimumBalance="";
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  int milliseconds=0;
  final _formKey = GlobalKey<FormBuilderState>();

  showSnackBar(message) {
    final snackBar = SnackBar(
      closeIconColor: Colors.white,
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
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
    getMtbData(selectedDate,approvedStatusRefID);
  }
  getMtbData(date,approvedStatusRefID) async {
    databaseTransaction
        .getMtbData(date,approvedStatusRefID)
        .whenComplete(() async{
      setState(() {
        mtbdata=databaseTransaction.mtbdata as List;
        print("MtBData Length:-");
        print(mtbdata.length);
        minimumBalance=databaseTransaction.minimumBalance;
        dailyLimit=databaseTransaction.dailyLimit;
        dailyBalanceAmount=databaseTransaction.dailyBalanceAmount;
        withdrawHead1=databaseTransaction.withdrawHead1;

      });
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

  @override
  Widget build(BuildContext context) {




    FirstWithdrawBottomSheet() {

      showModalBottomSheet<void>(

        context: context,
        builder: (BuildContext context) {
          double baseWidth = 414;
          double fem = MediaQuery.of(context).size.width / baseWidth;
          double ffem = fem * 0.97;
          return Container(

              height: fem*255,
              color: Color(0xff666666),
              child: Center(
                child:Container(
                  // frame7531yY7 (1029:875)

                  width: double.infinity,
                  decoration: BoxDecoration (
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only (
                      topLeft: Radius.circular(12*fem),
                      topRight: Radius.circular(12*fem),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children:  <Widget>[
                          Expanded(
                              child: Padding(padding: EdgeInsets.only(left: 15,top: 15,),
                                  child: Text('First Withdrawal Request ',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 15),)
                              )
                          ),

                          Expanded(
                            child:  Align(alignment:Alignment.topRight,child: IconButton(
                              icon:  Icon(Icons.close, color: Colors.black, size: 30,),
                              // tooltip: 'Show Snackbar',

                              // leadingWidth: 400,

                              onPressed: () {
                                Navigator.pop(context);

                              },
                            ),
                            ),
                          ) ],
                      ),


                      SizedBox(height: 25,),


                      Container
                        (
                        padding: EdgeInsets.fromLTRB(0*fem, 20*fem, 0*fem, 20*fem),
                        decoration: BoxDecoration (
                          color: Color(0x1A808080),

                        ),
                        // color: Color(0xff666666),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  <Widget>[
                            Expanded(

                              child: Text('Please complete your KYC & add a bank account for\n the first timewithdrawal request.',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14), textAlign: TextAlign.center),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(height: 30,),


                      // Container(
                      //   margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                      //   width: 350*fem,
                      //   height: 44*fem,
                      //   decoration: BoxDecoration (
                      //     border: Border.all(color: Color(0xff808080)),
                      //     color: Color(0xffFFB400),
                      //     borderRadius: BorderRadius.circular(12*fem),
                      //   ),
                      //   child: Center(
                      //     child: Text(
                      //       'Continue',
                      //       textAlign: TextAlign.center,
                      //       style: SafeGoogleFont (
                      //         'Open Sans',
                      //         fontSize: 14*ffem,
                      //         fontWeight: FontWeight.w700,
                      //         height: 1.1428571429*ffem/fem,
                      //         color: Color(0xff000000),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      new Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width-50,
                            height: 45.0,

                            child: ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xffFFB400),

                                // foreground
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => KYCVerification()),
                                        (e) => false);

                              },
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),

                          ) )
                    ],
                  ),

                ),

              ));

        },
      );
    }

    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
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
                  builder: (context) => QuestionDynamicUiPage()),
                  (e) => false);
          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
          resizeToAvoidBottomInset : false,
          backgroundColor: _colorFromHex(Constants.baseThemeColor),
          drawer: const CustomDrawer(),
          appBar:   TransactionAddMoneyAppBar(
            height: 50,
            child: Stack(
              children: [

              ],
            ),
            photo: Constants.photo,
          ),/*AppBar(
            elevation: 0,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionDynamicUiPage()),
                            (e) => false);

                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),

            title: const Text('QM Wallet'),
            actions: const <Widget>[
            ],
          ),*/
          body:  SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:Container(
              width: double.infinity,
              child: Container(
                // addmoney4Ks (2:3589)
                padding: EdgeInsets.fromLTRB(0*fem, 21*fem, 0*fem, 0*fem),
                width: double.infinity,
                decoration: BoxDecoration (
                  color: Color(0xff5a2dbc),
                ),
                child: Column(
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
                child:SizedBox()),
                    Container(
                      // autogroupc8d7xi5 (RW2796PV7sGQs2h4b5C8D7)
                      width: double.infinity,
                      height: 792*fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // frame14uNR (2:3590)
                            left: 0*fem,
                            top: 0*fem,
                            child: Container(
                              width: 414*fem,
                              height: 774*fem,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.only (
                                  topLeft: Radius.circular(24*fem),
                                  topRight: Radius.circular(24*fem),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    // aDf (2:3591)
                                    left: 166*fem,
                                    top: 62*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 85*fem,
                                        height: 24*fem,
                                        child: Text(
                                          (Constants.mainBalance=="0")?"₹0.00":'₹'+Constants.mainBalance,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 24*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1*ffem/fem,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // totalbalanceJ3B (2:3592)
                                    left: 168*fem,
                                    top: 39*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 78*fem,
                                        height: 16*fem,
                                        child: Text(
                                          'Total Balance',
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 12*ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3333333333*ffem/fem,
                                            color: Color(0xff3d3d3d),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // frame1wrq (2:3593)
                                    left: 103*fem,
                                    top: 111*fem,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddMoney(transactionMsg: "",transactionAmount: "",)),
                                                (e) => false);
                                      },
                                      child:Container(
                                      width: 208*fem,
                                      height: 42*fem,
                                      decoration: BoxDecoration (
                                        color: Color(0xffffb400),
                                        borderRadius: BorderRadius.circular(12*fem),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Add Money',
                                          textAlign: TextAlign.center,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 14*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.1428571429*ffem/fem,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ),
                                  Positioned(
                                    // autogroupskkh1Lu (RW27R5vqbyPUnJBhqYSkkH)
                                    left: 52*fem,
                                    top: 298*fem,
                                    child: Container(
                                      width: 191*fem,
                                      height: 34*fem,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // subtracttvV (2:3595)
                                            margin: EdgeInsets.fromLTRB(0*fem, 6*fem, 14*fem, 0*fem),
                                            width: 19*fem,
                                            height: 20*fem,
                                            child: Image.asset(
                                              'assets/icons/subtract-jVj.png',
                                              width: 19*fem,
                                              height: 20*fem,
                                            ),
                                          ),
                                          Container(
                                            // autogroupys4donZ (RW27ZfWsqEkntpYovays4D)
                                            height: double.infinity,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  // amountaddedunutilisedMZB (2:3646)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 2*fem),
                                                  child: Text(
                                                    'Amount Added ( Unutilised )',
                                                    style: SafeGoogleFont (
                                                      'Open Sans',
                                                      fontSize: 12*ffem,
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.3333333333*ffem/fem,
                                                      color: Color(0xff212121),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  // 4Ch (2:3645)
                                                  '₹500',
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 16*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1*ffem/fem,
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
                                  Positioned(
                                    // line3byK (2:3596)
                                    left: 8*fem,
                                    top: 278*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 395*fem,
                                        height: 1*fem,
                                        child: Container(
                                          decoration: BoxDecoration (
                                            color: Color(0x28000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // line4tSd (2:3597)
                                    left: 8*fem,
                                    top: 353*fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 395*fem,
                                        height: 1*fem,
                                        child: Container(
                                          decoration: BoxDecoration (
                                            color: Color(0x28000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // autogroup8z8qbrq (RW27gzdzocts79jXAU8z8q)
                                    left: 53*fem,
                                    top: 374*fem,
                                    child: Container(
                                      width: 332*fem,
                                      height: 34*fem,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // vectorXEh (2:3598)
                                            margin: EdgeInsets.fromLTRB(0*fem, 6*fem, 14*fem, 0*fem),
                                            width: 18*fem,
                                            height: 20*fem,
                                            child: Image.asset(
                                              'assets/icons/vector-9Yu.png',
                                              width: 18*fem,
                                              height: 20*fem,
                                            ),
                                          ),
                                          Container(
                                            // group133Tw (2:3642)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 110*fem, 0*fem),
                                            height: double.infinity,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  // winningsycV (2:3644)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 2*fem),
                                                  child: Text(
                                                    'Winnings',
                                                    style: SafeGoogleFont (
                                                      'Open Sans',
                                                      fontSize: 12*ffem,
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.3333333333*ffem/fem,
                                                      color: Color(0xff2e2e2e),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  // 6SD (2:3643)
                                                  '₹'+Constants.mainBalance,
                                                  style: SafeGoogleFont (
                                                    'Open Sans',
                                                    fontSize: 16*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1*ffem/fem,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                // if(Constants.kycStatus!='2') {
                                                //   FirstWithdrawBottomSheet();
                                                // }else{
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>KYCVerification()),
                                                          (e) => false);
                                                //}
                                              },
                                              child:Container(
                                            // frame3eTj (2:3601)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 1*fem),
                                            width: 129*fem,
                                            height: 33*fem,
                                            decoration: BoxDecoration (
                                              border: Border.all(color: Color(0xff3ed769)),
                                              color: Color(0xffffffff),
                                              borderRadius: BorderRadius.circular(12*fem),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Verify to Withdraw ! ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 10*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.6*ffem/fem,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // frame2WF3 (2:3599)
                                    left: 104*fem,
                                    top: 169*fem,
                                    child: GestureDetector(
                                        onTap: () {
                                          if(Constants.kycStatus!='2') {
                                            FirstWithdrawBottomSheet();
                                          }else{
                                            if(int.parse(Constants.mainBalance)<=int.parse(minimumBalance)){
                                              showDialog(context: context,builder: (dialogContex){
                                                return Dialog(
                                                  child: Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    child: Form(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(withdrawHead1,style: TextStyle(color: Colors.red),),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: <Widget>[
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(dialogContex).pop();
                                                                  },
                                                                  child: Text("Ok")),

                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            }else {

                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TransactionTwoWithdrawMoney(
                                                            amount: Constants
                                                                .mainBalance,
                                                            transactionID: "",
                                                          )),
                                                      (e) => false);


                                            }
                                          }
                                        },
                                        child:Container(
                                      width: 207*fem,
                                      height: 42*fem,
                                      decoration: BoxDecoration (
                                        border: Border.all(color: Color(0xff3ed769)),
                                        color: Color(0xffffffff),
                                        borderRadius: BorderRadius.circular(12*fem),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Withdraw Instantly',
                                          textAlign: TextAlign.center,
                                          style: SafeGoogleFont (
                                            'Open Sans',
                                            fontSize: 12*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.3333333333*ffem/fem,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ),
                                  Positioned(
                                    // frame762415nCZ (2:3603)
                                    left: 8*fem,
                                    top: 433*fem,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(0*fem, 17*fem, 0*fem, 0*fem),
                                      width: 395*fem,
                                      height: 232*fem,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // autogroup9mbxfn9 (RW28NopzSxyAiVaUSZ9mBX)
                                            margin: EdgeInsets.fromLTRB(42*fem, 0*fem, 263*fem, 22*fem),
                                            width: double.infinity,
                                            height: 36*fem,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // vectorxmF (2:3608)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 5*fem, 12*fem, 0*fem),
                                                  width: 23*fem,
                                                  height: 17*fem,
                                                  child: Image.asset(
                                                    'assets/icons/vector-45P.png',
                                                    width: 23*fem,
                                                    height: 17*fem,
                                                  ),
                                                ),
                                                Container(
                                                  // autogroups7wh5L5 (RW28TUMtLfRPwcWk92S7WH)
                                                  height: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        // qmcoinspoT (2:3607)
                                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                                        child: Text(
                                                          'QM Coins',
                                                          style: SafeGoogleFont (
                                                            'Open Sans',
                                                            fontSize: 12*ffem,
                                                            fontWeight: FontWeight.w400,
                                                            height: 1.3333333333*ffem/fem,
                                                            color: Color(0xff3f3f3f),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        // L17 (2:3606)
                                                        Constants.qiCoinBalance,
                                                        style: SafeGoogleFont (
                                                          'Open Sans',
                                                          fontSize: 16*ffem,
                                                          fontWeight: FontWeight.w700,
                                                          height: 1*ffem/fem,
                                                          color: Color(0xff000000),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // line6sWq (2:3605)
                                            width: double.infinity,
                                            height: 1*fem,
                                            decoration: BoxDecoration (
                                              color: Color(0x28000000),
                                            ),
                                          ),
                                          Container(
                                            // autogroupkbm3pgy (RW28fPBhvHQ1negu9qKBm3)
                                            padding: EdgeInsets.fromLTRB(17*fem, 36*fem, 12*fem, 0*fem),
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => TransactionTab()),
                                          (e) => false);
                                          },
                                            child:Container(
                                                  // frame21kqX (2:3609)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 17*fem),
                                                  padding: EdgeInsets.fromLTRB(20*fem, 14*fem, 28*fem, 14*fem),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration (
                                                    border: Border.all(color: Color(0x7f000000)),
                                                    color: Color(0xffffffff),
                                                    borderRadius: BorderRadius.circular(12*fem),
                                                  ),
                                                  child: SingleChildScrollView(child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        // mytransactionsFXP (2:3610)
                                                        margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 167*fem, 0*fem),
                                                        child: Text(
                                                          'My Transactions ',
                                                          textAlign: TextAlign.center,
                                                          style: SafeGoogleFont (
                                                            'Open Sans',
                                                            fontSize: 14*ffem,
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.1428571429*ffem/fem,
                                                            color: Color(0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                    SizedBox(width: 25*fem,),
                                    Container(
                                                        // vectorZny (2:3611)
                                                        width: 6*fem,
                                                        height: 12*fem,
                                                        child: Image.asset(
                                                          'assets/icons/vector.png',
                                                          width: 6*fem,
                                                          height: 12*fem,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                )),
                                                Container(
                                                  // frame23iA5 (2:3612)
                                                  padding: EdgeInsets.fromLTRB(10*fem, 11*fem, 5*fem, 13*fem),
                                                  width: double.infinity,
                                                  height: 60*fem,
                                                  decoration: BoxDecoration (
                                                    border: Border.all(color: Color(0xffffb400)),
                                                    color: Color(0xffffffff),
                                                    borderRadius: BorderRadius.circular(12*fem),
                                                  ),

                                                    // asperthenewtdspolicybythegovt3 (2:3613)
                                                    child: SizedBox(
                                                      child: Container(
                                                        constraints: BoxConstraints (
                                                          maxWidth: 338*fem,
                                                        ),
                                                        child: Text(
                                                          'As per the new TDS policy by the Govt., 30% tax will apply on "Net Winning".',
                                                          style: SafeGoogleFont (
                                                            'Open Sans',
                                                            fontSize: 15*ffem,
                                                            fontWeight: FontWeight.w400,
                                                           // height: 1.3333333333*ffem/fem,
                                                            color: Color(0xff000000),
                                                          ),
                                                        ),
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
                                  Positioned(
                                    // materialsymbolsprivacytipV4M (2:3614)
                                    left: 56*fem,
                                    top: 408*fem,
                                    child: Container(
                                      width: 17*fem,
                                      height: 17*fem,
                                    ),
                                  ),
                                  Positioned(
                                    // group762369p6d (2:3663)
                                    left: 70*fem,
                                    top: 247*fem,
                                    child: Container(
                                      width: 267.5*fem,
                                      height: 16*fem,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // vector98u (2:3665)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0.17*fem, 7.17*fem, 0*fem),
                                            width: 11.33*fem,
                                            height: 14.17*fem,
                                            child: Image.asset(
                                              'assets/icons/vector-Fvq.png',
                                              width: 11.33*fem,
                                              height: 14.17*fem,
                                            ),
                                          ),
                                          Text(
                                            // theminimumwalletbalanceshouldb (2:3664)
                                            withdrawHead1,
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 12*ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.3333333333*ffem/fem,
                                              color: Color(0xff575757),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            // navigationbarXQM (2:3637)
                            left: 0*fem,
                            top: 758*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(133.58*fem, 21*fem, 133.58*fem, 8*fem),
                              width: 414*fem,
                              height: 34*fem,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                              ),
                              child: Center(
                                // itemscwb (2:3638)
                                child: SizedBox(
                                  width: 146.83*fem,
                                  height: 5*fem,
                                  child: SizedBox(height: 5*fem),
                                ),
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

          ),

        ));
  }
}
