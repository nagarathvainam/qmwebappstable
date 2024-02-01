import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:quizmaster/pages/ui/addmoney.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/ui/transaction-successfull.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/constant/constants.dart';
import '../webview/rateus.dart';
import 'addmoneypaysuccess.dart';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
class CashFree extends StatefulWidget {
  // CashFree({Key? key}) : super(key: key);
  String orderId;
  String paymentSessionId;
  String created_at;
  String amount;
  String page;
   CashFree({required this.paymentSessionId,required this.orderId,required this.page,required this.created_at,required this.amount});

  @override
  State<CashFree> createState() => _CashFreeState();
}

class _CashFreeState extends State<CashFree> {
  User databaseUser = new User();
  var cfPaymentGatewayService = CFPaymentGatewayService();
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  Transactions databaseTransaction= new Transactions();
  @override
  void initState() {
    super.initState();

    cfPaymentGatewayService.setCallback(verifyPayment, onError,receivedEvent);
    pay();
    deviceAuthCheck();
  }

  void receivedEvent(String event_name, Map<dynamic, dynamic> meta_data) {
    print("EVT NAME:$event_name");
    print("META DATA: $meta_data");
  }
  deviceAuthCheck() async {
    databaseUser
        .deviceAuth()
        .whenComplete(() async{
      if(databaseUser.responseCode=='token_expired'){
        setState(() {
          showSnackBarSessionTimeOut(databaseUser.responseDescription);
        });
      }else if(databaseUser.responseCode=='107'){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginUiPage(title:'You are used Old Version. Please Check &  Update the Latest Version from the Google Play Store, Tab on the Information.',url: 'https://play.google.com/store/apps/details?id=com.quizMaster.quiz_master',)),
                (e) => false);
      }else if(databaseUser.responseCode!='0'){
        setState(() {
          showSnackBarSessionTimeOut(databaseUser
              .responseDescription);
        });
      }
    });
  }

  showSnackBarSessionTimeOut(message) async {
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
    final prefs = await SharedPreferences.getInstance();

    await //prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
    await prefs.setString('userRefID', "");
    Constants.displayName="";
    Constants.surName="";
 // Replaced Constants.userRefID
    Constants.mobileNumber="";
    Constants.photo="";
    Constants.mailID="";
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginUiPage(title: '',url: '',)),
            (e) => false);
  }

  void verifyPayment(String orderId) {
          //Transaction Update Pay

          // Transaction Update Pay
          print("Verify Payment");
          if (widget.page == "questionpayment") {
              /*Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => HoldPaymentProcessing(),
              ),
              );*/
          }
          if (widget.page == "addmoneypayment") {
            databaseTransaction.PayinUpdate(widget.orderId,'2');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TranactionSuccessfull(page: 'payin',transactionid:widget.orderId,transactionamount:widget.amount,transactiondate:widget.created_at,transactionmessage:'QM Topup Completed  ',accountHolderName:databaseTransaction.accountHolderName,accountNumber:databaseTransaction.accountNumber,ifscCode:databaseTransaction.ifscCode)),
                    (e) => false);
            /*Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AddMoneyPaymentSuccessfull()),
                
                    (e) => false);*/
          }
  }

  void onError(CFErrorResponse errorResponse, String orderId) {

    print("A:");
    print(errorResponse.getMessage());
    print("B:Error while making payment");
    print("widget.page");
    print(widget.page);
    databaseTransaction.PayinUpdate(widget.orderId,'3');
    if (widget.page == "questionpayment") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionDynamicUiPage()),
          
              (e) => false);
    }

    if (widget.page == "addmoneypayment") {
      String transactionMsg="";
      transactionMsg=errorResponse.getMessage().toString();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AddMoney(transactionMsg: transactionMsg,transactionAmount:widget.amount)),
          
              (e) => false);
    }

  }

  @override
  Widget build(BuildContext context) {
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
                            Container(
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
                                          color: _colorFromHex(Constants.baseThemeColor), //<-- SEE HERE
                                          backgroundColor: Color(0xffE6DCEE),
                                          strokeWidth: 8,
                                        )), //<-- SEE HERE
                                  ],
                                )
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 16*fem),
                              child: Text(
                                'Hold On',
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
                              'We are verifying your Payment Status.',
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




  // String orderId = widget.orderId;
  // String paymentSessionId = widget.paymentSessionId;






  CFSession? createSession() {
    CFEnvironment environment;
    if(Constants.cashFreePayinSandLive>0) {
      environment = CFEnvironment.PRODUCTION;
    }else{
      environment = CFEnvironment.SANDBOX;
    }
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(widget.orderId).setPaymentSessionId(widget.paymentSessionId).build();

      print("Callback Success:$session");
      return session;
    } on CFException catch (e) {
      print("Callback Error1:");
      print(e.message);
    }
    return null;
  }

  pay() async {
    try {
      var session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#FF0000").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);

      print("Callback Error:$cfDropCheckoutPayment");
    } on CFException catch (e) {
      print("Callback Error2:");
      print(e.message);
    }

  }

  webCheckout() async {
    try {
      var session = createSession();
      print("Session rewssss A:$session");
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      print("e.message B");
      print(e.message);
    }

  }

}
