import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quizmaster/pages/Components/CustomAppBarWalletMoneyWithdraw.dart';
import 'package:quizmaster/pages/ui/transaction-one-add-money.dart';
import 'package:quizmaster/pages/ui/transaction-successfull.dart';
import 'package:quizmaster/pages/ui/transaction-tab.dart';
import 'package:quizmaster/pages/ui/transaction-history.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/constant/constants.dart';
//import 'package:quizmaster/pages/ui/WalletMoneyWithdrawselect.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
//import 'package:quizmaster/model/databasehelper.dart';
import 'dart:ui';
//import 'package:quizmaster/pages/ui/payment.dart';
import 'package:quizmaster/class/LoadingDialog.dart';
import '../Components/TransactionWithDrawMoneyAppBar.dart';
import '../question/schedule.dart';
import '../webview/rateus.dart';
import 'addbank.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/transaction/model/paymentgateway.dart';
//import 'mtb.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:quizmaster/constant/duration.dart';
import 'login.dart';
class TransactionTwoWithdrawMoney extends StatefulWidget {
  String amount;
  String transactionID;
  TransactionTwoWithdrawMoney({required this.amount,required this.transactionID});


  @override
  _TransactionTwoWithdrawMoneyState createState() => _TransactionTwoWithdrawMoneyState();
}

class _TransactionTwoWithdrawMoneyState extends State<TransactionTwoWithdrawMoney> {
  final _formKey = GlobalKey<FormBuilderState>();
  late int selectedIndex = -1;
  String selectedBenId="";
  String otpdisplay="";
  Transactions databaseTransaction=new Transactions();
  User databaseUser=new User();
  PaymentGatewayModel PaymentGateway = new PaymentGatewayModel();
  late StreamSubscription<ConnectivityResult> subscription;
  final myController = TextEditingController();
  //void _onChanged(dynamic val) => debugPrint(val.toString());
  int ismoneytransfer=1;
  List bendata=[];
  String payamount="";
  getBenData() async {
    databaseTransaction
        .getBenData()
        .whenComplete(() async{
      setState(() {
        bendata=databaseTransaction.bendata1 as List;
        print("BenData Length:-");
        print(bendata.length);
      });
    });
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
  showSnackBar(message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
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
  @override
  void initState() {
    readSharedPrefs();
    //deviceAuthCheck();
    getBenData();

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
    Constants.mobileNumber="";
    Constants.photo="";
    Constants.mailID="";
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginUiPage(title: '',url: '',)),
            (e) => false);
  }
  void readSharedPrefs() async {

    setState(() {
      // getBalance();
      getWithDrawData();
    });
  }


  List approvewithdrawdata = [];
  Future<String> getWithDrawData() async {
    databaseTransaction
        .getWithDrawData()
        .whenComplete(() async {
      setState(() {
        approvewithdrawdata = databaseTransaction.approvewithdrawdata as List;
      });
    });
    return "";
  }
  String approveBalance="";
  String withdrawnBalance="";
  //String mainBalance="";
  // getBalance(){
  //   databaseUser
  //       .balanceinfo()
  //       .whenComplete(() async{
  //     setState(() {
  //       approveBalance=databaseUser.approveBalance;
  //       withdrawnBalance=databaseUser.withdrawnBalance;
  //      // mainBalance=databaseHelper.mainBalance;
  //     });
  //   });
  // }

  //String payamount="";
  //String transactionID="";



  TransactionFailedBottomSheet(message) {

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:  <Widget>[
                        Padding(padding: EdgeInsets.only(top: 13,left: 10),child:Image.asset(
                          'assets/icons/ep-circle-close-filled.png',
                          width: 21*fem,
                          height: 21*fem,
                        )),
                        Expanded(
                            child: Padding(padding: EdgeInsets.only(left: 15,top: 15,),
                                child: Text('Transaction Failed :',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 15),)
                            )
                        ),

                        Expanded(
                          child:  Align(alignment:Alignment.topRight,child: IconButton(
                            icon:  Icon(Icons.close, color: Colors.black, size: 30,),
                            // tooltip: 'Show Snackbar',

                            // leadingWidth: 400,

                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>TransactionTwoWithdrawMoney(amount: "0", transactionID: "")),
                                      (e) => false);
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

                            child: Text(message+"\n Please delete your bank details & Re-Update",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14), textAlign: TextAlign.center),
                          ),


                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(padding:EdgeInsets.only(left: 20.0),child:Text("Payment of ₹"+widget.amount,style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold, fontSize: 18))),
                    SizedBox(height: 10,),
                    new Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width-50,
                          height: 45.0,

                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Color(0xffffb400),

                              // foreground
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuestionDynamicUiPage()),
                                      (e) => false);

                            },
                            child: Text(
                              'Try Again Payouts',
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
  @override
  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  GetotpBottomSheet(mobile) {
    final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
    showModalBottomSheet<void>(

      context: context,
      builder: (BuildContext context) {
        double baseWidth = 414;
        double fem = MediaQuery.of(context).size.width / baseWidth;
        double ffem = fem * 0.97;
        return Container(

            height: fem*550,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:  <Widget>[

                        Padding(padding: EdgeInsets.only(left: 10),child: Text('Enter the 6-digit OTP ',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w800, fontSize: 20),),),
                        //(Durations.otpdisplay==0)?Text(otpdisplay,style: TextStyle(color: Colors.red,fontSize: 18.0),):SizedBox(),


                        Expanded(
                          child:  Align(alignment:Alignment.topRight,

                            child: IconButton(
                              icon:  Icon(Icons.close, color: Colors.black, size: 30,),

                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TransactionOneAddMoney()),
                                        (e) => false);

                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    //SizedBox(height: 10),

                    ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15.0),


                        children: <Widget>[




                          FormBuilder(
                            // key: _formKey,
                            // enabled: false,
                            onChanged: () {
                              // _formKey.currentState!.save();
                              //debugPrint(_formKey.currentState!.value.toString());
                            },
                            autovalidateMode: AutovalidateMode.disabled,
                            initialValue: const {

                            },
                            skipDisabled: true,
                            child: Column(
                              children: <Widget>[
                                // SizedBox(height: 20,),

                                Align( alignment:Alignment.topLeft,  child: Text("SMS sent to ",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 14),)),

                                SizedBox(height: 5,),
                                Align( alignment:Alignment.topLeft,  child: Text("+91"+Constants.mobileNumber,style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 20),)),


                                SizedBox(height: 20,),
                                Align( alignment:Alignment.topLeft,  child: Text("Enter the 6 Digit OTP below Textbox",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),

                                SizedBox(height: 10,),
                                OtpTextField(
                                  numberOfFields:6 ,
                                  borderColor: Color(0xFF512DA8),
                                  //set to true to show as box or false to show as dash
                                  //set to true to show as box or false to show as dash
                                  //set to true to show as box or false to show as dash
                                  showFieldAsBox: true,
                                  //runs when a code is typed in
                                  onCodeChanged: (String code) {
                                    //handle validation or checks here
                                  },
                                  //runs when every textfield is filled
                                  onSubmit: (String verificationCode){

                                    print("OTP Response");
                                    print(databaseUser.responseCode);
                                    databaseUser
                                        .verifyOTPLogin(
                                        mobile,verificationCode)
                                        .whenComplete(() {
                                      if (databaseUser.responseCode ==
                                          "0") {

                                        ////////////////////////////////////////////////////////
                                        print("selectedBenId:" + selectedBenId);
                                        print("selectedIndex:" + selectedIndex.toString());
                                        if (selectedBenId != "") {



                                          var transferId = selectedBenId + "_" +
                                              idGenerator();
                                          print("Transfer Id:" + transferId);


                                          // set up the buttons
                                          Widget cancelButton = TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              //Navigator.pop(context);

                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QuestionDynamicUiPage()),
                                                      (e) => false);
                                            },
                                          );
                                          Widget continueButton = TextButton(
                                            child: Text("Continue"),
                                            onPressed: () {
                                              LoaderDialog.showLoadingDialog(
                                                  context, _LoaderDialog);
                                              PaymentGateway
                                                  .pggetsignature()
                                                  .whenComplete(() async {
                                                setState(() {
                                                  PaymentGateway
                                                      .cashFreeAuthorize(
                                                      PaymentGateway.signature)
                                                      .whenComplete(() async {
                                                    setState(() {
                                                      if (ismoneytransfer > 0) {
                                                        databaseTransaction
                                                            .withDrawRequest(payamount)
                                                            .whenComplete(() {
                                                          if (databaseTransaction.responseCode ==
                                                              "0") {
                                                            databaseTransaction.PayOut(
                                                                databaseTransaction.transactionID,
                                                                selectedBenId)
                                                                .whenComplete(() async {
                                                              print("A");
                                                              if (databaseTransaction
                                                                  .responseCode == "0") {
                                                                print("B");
                                                                PaymentGateway
                                                                    .cashFreeRequestTransfer(
                                                                    PaymentGateway.token,
                                                                    selectedBenId, payamount,
                                                                    databaseTransaction
                                                                        .transactionIDS)
                                                                    .whenComplete(() async {
                                                                  setState(() {
                                                                    var subcode = PaymentGateway
                                                                        .status;
                                                                    var message = PaymentGateway
                                                                        .message;
                                                                    print("subcode:$subcode");
                                                                    print("message:$message");
                                                                    if (message ==
                                                                        "Transfer request pending at the bank") {
                                                                      databaseTransaction
                                                                          .PayOutUpdate(
                                                                          databaseTransaction
                                                                              .transactionIDS,
                                                                          '2', message);
                                                                      showDialog<void>(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        // user must tap button!
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: (subcode ==
                                                                                200) ? Text(
                                                                                'Success') : Text(
                                                                                'Warning/Info'),
                                                                            content: SingleChildScrollView(
                                                                              child: ListBody(
                                                                                children: <
                                                                                    Widget>[
                                                                                  Text(message),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: const Text(
                                                                                    'Ok'),
                                                                                onPressed: () {
                                                                                  Navigator
                                                                                      .pushAndRemoveUntil(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) =>
                                                                                              TranactionSuccessfull(
                                                                                                  page: 'payout',
                                                                                                  transactionid: databaseTransaction
                                                                                                      .transactionIDS,
                                                                                                  transactionamount: payamount,
                                                                                                  transactiondate: databaseTransaction
                                                                                                      .transactionDate,
                                                                                                  transactionmessage: 'Pay Out Process Completed ',
                                                                                                  accountHolderName: databaseTransaction
                                                                                                      .accountHolderName,
                                                                                                  accountNumber: databaseTransaction
                                                                                                      .accountNumber,
                                                                                                  ifscCode: databaseTransaction
                                                                                                      .ifscCode)),
                                                                                          (e) => false);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // userRefID,amount,transactionid,benid
                                                                      // databaseHelper
                                                                      //     .ApproveWithdraw(userRefID,  amount, transferId,selectedBenId)
                                                                      //     .whenComplete(() async {
                                                                      //       showSnackBar(databaseHelper.responseDescription);
                                                                      // });


                                                                      databaseTransaction
                                                                          .PayOutUpdate(
                                                                          databaseTransaction
                                                                              .transactionIDS,
                                                                          '3', message);
                                                                      TransactionFailedBottomSheet(message);
                                                                    }
                                                                  });
                                                                });
                                                              }
                                                            });
                                                          }else{
                                                            showSnackBar(databaseTransaction.responseDescription);
                                                            Navigator.pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        TransactionTwoWithdrawMoney(amount: "0", transactionID: "")),
                                                                    (e) => false);
                                                          }
                                                        });
                                                      }
                                                    });
                                                  });
                                                });
                                              });
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Proceed"),
                                            content: Text(
                                                "Are you sure want to proceed withdrawal?"),
                                            actions: [
                                              cancelButton,
                                              continueButton,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        } else {
                                          showSnackBar("Please select bank");
                                        }
                                      }
                                    });

                                  }, // end onSubmit
                                ),
                                SizedBox(height: 25,),
                                /* (resendtextdisplay==true)?GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle light when tapped.


                                        databaseUser
                                            .sendOTPLogin(Constants.mobileNumber)
                                            .whenComplete(() {
                                          if(databaseUser.responseCode=="0"){
                                            print("databaseHelper.mobileNo");
                                            print(databaseUser.mobileNo);
                                            //showBottomSheet(context: context, builder: builder)
                                            GetotpBottomSheet(mobile);
                                          }

                                        });


                                      });
                                    },
                                    child:SizedBox()):SizedBox(),*/
                                //Align( alignment:Alignment.center,  child: Text("The OTP Expires in  "+ timerText,style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 16),)),
                                SizedBox(height: 25,),
                                new SizedBox(
                                  width: MediaQuery.of(context).size.width-20,
                                  height: 50.0,
                                ),
                              ],
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ));
      },
    );

    SizedBox(height: 30);

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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionOneAddMoney()),
                  (e) => false);
          return false; // return false if you want to disable device back button click
        },
        child:Scaffold(
          backgroundColor: _colorFromHex(Constants.baseThemeColor),
            appBar:   TransactionWithDrawMoneyAppBar(
              height: 75,
              child: Stack(
                children: [

                ],
              ),
              photo: Constants.photo,
            ),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child:Container(
            width: double.infinity,
      height:  MediaQuery.of(context).size.height ,
            child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child:Container(
              // withdrawal8wT (2:3666)
              width: double.infinity,
              height: 1000*fem,
              decoration: BoxDecoration (
                color: Color(0xff5a2dbc),
              ),
              child: Stack(
                children: [
                  Positioned(
                    // frame14GGy (2:3667)
                    left: 0*fem,
                    top: 0*fem,
                    child: Container(
                      width: 417*fem,
                      height: 1158*fem,
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
                            // autogroupsrft95s (RW2CSSZNF9RNESmy6rSrfT)
                            left: 19*fem,
                            top: 8*fem,
                            child: Container(
                              width: 371*fem,
                              height: 36*fem,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // vectorSam (2:3675)
                                    margin: EdgeInsets.fromLTRB(0*fem, 16*fem, 12*fem, 0*fem),
                                    width: 18*fem,
                                    height: 20*fem,
                                    child: Image.asset(
                                      'assets/icons/vector-gyP.png',
                                      width: 18*fem,
                                      height: 20*fem,
                                    ),
                                  ),
                                  Container(
                                    // yourwinningsLw3 (2:3673)
                                    margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 8*fem, 0*fem),
                                    child: Text(
                                      'Your Winnings',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.1428571429*ffem/fem,
                                        color: Color(0xff2e2e2e),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // carbonaddfilledqN1 (2:3668)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 159*fem, 20*fem),
                                    width: 16*fem,
                                    height: 16*fem,
                                    child: Image.asset(
                                      'assets/icons/carbon-add-filled.png',
                                      width: 16*fem,
                                      height: 16*fem,
                                    ),
                                  ),
                                  Container(
                                    // autogroupyy2vkUy (RW2CdrQ281htX1HAaPyY2V)
                                    margin: EdgeInsets.fromLTRB(0*fem, 12*fem, 0*fem, 4*fem),
                                    width: 63*fem,
                                    height: double.infinity,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // akariconschevrondownt5P (2:3672)
                                          left: 47*fem,
                                          top: 4*fem,
                                          child: Container(
                                            width: 16*fem,
                                            height: 16*fem,
                                          ),
                                        ),
                                        Positioned(
                                          // R5K (2:3674)
                                          left: 0*fem,
                                          top: 0*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 61*fem,
                                              height: 16*fem,
                                              child: Text(
                                                '₹'+widget.amount,
                                                style: SafeGoogleFont (
                                                  'Open Sans',
                                                  fontSize: 16*ffem,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1*ffem/fem,
                                                  color: Color(0xff7e9728),
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
                            // frame2i4R (2:3676)
                            left: 75*fem,
                            top: 130*fem,
                            child: Container(
                              width: 275*fem,
                              height: 55*fem,
                              decoration: BoxDecoration (
                                border: Border.all(color: Color(0xff1acd53)),
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              child: Center(
                                child:FormBuilder(
                                  key: _formKey,
                                  // enabled: false,
                                  onChanged: () {
                                    _formKey.currentState!.save();
                                    debugPrint(_formKey.currentState!.value.toString());
                                  },
                                  autovalidateMode: AutovalidateMode.disabled,
                                  initialValue: const {

                                  },
                                  skipDisabled: true,
                                  child: FormBuilderTextField(
                                  name: 'amount',
                                  readOnly: false,
                                  controller: myController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: '',
                                    hintText: "",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    prefixText: "₹",
                                  ),

                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(),
                                    FormBuilderValidators.max(1000),
                                    FormBuilderValidators.min(50),
                                  ]),
                                  // initialValue: '12',
                                  autovalidateMode: AutovalidateMode.disabled,
                                  onChanged: (val) {
                                    setState(() {
                                      payamount=val.toString();
                                    });
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    //NumericRangeFormatter(min: 1, max: 100),
                                  ],
                                  keyboardType: TextInputType.number,
                                  //textInputAction: TextInputAction.next,

                                )) /*Text(
                                  '₹100',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                )*/,
                              ),
                            ),
                          ),



                          Positioned(
                            // autogroupaytvASD (RW2CtLysVrkfkqkwD5AytV)
                            left: 14*fem,
                            top: 378*fem,
                            child: Container(
                              width: 382*fem,
                              height: 350*fem,
                              child: Stack(
                                children: [
                                  (bendata.length>0)?SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: bendata == null ? 0 : bendata.length,
                                        itemBuilder: (BuildContext context, int index) {

                                          return Padding(
                                            padding: const EdgeInsets.only(top: 5,left: 10,right: 10),
                                            child: Column(
                                              children: [


                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:  <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      decoration: const BoxDecoration(
                                                          color: Color(0xffF1D6E6),
                                                          borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(3),
                                                            bottomRight: Radius.circular(3),
                                                            topLeft: Radius.circular(3),
                                                            bottomLeft: Radius.circular(3),
                                                          )),

                                                      child: Image.asset("assets/bank.png"),
                                                    ),

                                                    SizedBox(width: 20.0,),
                                                    Expanded(
                                                        child:Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children:  <Widget>[
                                                            // Text("State Bank of India",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 16),),
                                                            Text("Account Name",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),),
                                                            Text(bendata[index]['accountHolderName'],style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14),),
                                                            Text("Account Number",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),),
                                                            Text(bendata[index]['accountNumber'],style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14),),
                                                            Text("IFSC Code",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),),
                                                            Text(bendata[index]['ifscCode'],style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14),),
                                                          ],
                                                        )  ),
                                                    IconButton(
                                                      icon:  (selectedIndex ==
                                                          index)
                                                          ?Icon(Icons.check_circle,color: Color(0xff36C4BD),):Icon(Icons.circle_outlined,color: Color(0xff36C4BD),),
                                                      tooltip: 'Increase volume by 10',
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedIndex =
                                                              index;
                                                          selectedBenId=bendata[index]['beneID'];
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(height: 20.0,),
                                                // Image.asset("assets/horizanline.png"),
                                                // SizedBox(height: 20.0,),
                                                const Divider(
                                                  height: 10,
                                                  thickness: 1,
                                                  indent: 5,
                                                  endIndent: 5,
                                                  color: Color(0xffC8C8C8),
                                                ),
                                              ],
                                            ),
                                            //)
                                          );
                                        },
                                      )): Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(0),
                                          )),
                                      child:Center(

                                          child:CircularProgressIndicator())
                                  ),
                                ],
                              ),
                            ),
                          ),



                          Positioned(
                            // frame17Qd (2:3704)
                            left: 107*fem,
                            top: 250*fem,
                            child: GestureDetector(
                              onTap: () {
    if (_formKey.currentState
        ?.saveAndValidate() ??
    false) {
      setState(() {
    if (selectedBenId != "") {
      databaseUser.sendOTPLogin(Constants.mobileNumber,'6')
          .whenComplete(() {
        if (databaseUser.responseCode == "0") {
          otpdisplay=databaseUser.otp;
          GetotpBottomSheet(Constants.mobileNumber);
        }
      });
    }else{
      showSnackBar("Please select bank");
    }
      });
    }else{
      print('Validation failed');
    }
                              },
                              child:Container(
                              width: 208*fem,
                              height: 42*fem,
                              decoration: BoxDecoration (
                                color: Color(0xff85ad00),
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              child: Center(
                                child: Text(
                                  'Withdraw Now',
                                  textAlign: TextAlign.center,
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
                          )),
                          Positioned(
                            // min50max1000perdaylimitnmf (2:3706)
                            left: 117*fem,
                            top: 220*fem,
                            child: Align(
                              child: SizedBox(
                                width: 195*fem,
                                height: 16*fem,
                                child: RichText(
                                  text: TextSpan(
                                    style: SafeGoogleFont (
                                      'Open Sans',
                                      fontSize: 12*ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3333333333*ffem/fem,
                                      color: Color(0xfff49b33),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Min ₹50 - Max ₹1000',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 12*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.3333333333*ffem/fem,
                                          color: Color(0xfff06f27),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 12*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.3333333333*ffem/fem,
                                          color: Color(0xff5a5a5a),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Per Day limit ',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 12*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.3333333333*ffem/fem,
                                          color: Color(0xff1c1c1c),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // frame762434qJ1 (2:3712)
                            // left: 28*fem,
                            top: 300*fem,
                            child:
                            SvgPicture.asset('assets/icons/withdraw-separator-line.svg',),
                          ),
                          Positioned(
                            // senttoaccountT93 (2:3707)
                            left: 147*fem,
                            top: 342*fem,
                            child: Align(
                              child: SizedBox(
                                width: 114*fem,
                                height: 16*fem,
                                child: Text(
                                  'Sent to Account',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // frame21jsF (2:3708)
                            left: 27*fem,
                            top: 820*fem,
                            child:  GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TransactionHistory(page:'withdraw')),
                                          (e) => false);
                                },
                                child:Container(
                              padding: EdgeInsets.fromLTRB(18*fem, 14*fem, 28*fem, 14*fem),
                              width: 366*fem,
                              height: 44*fem,
                              decoration: BoxDecoration (
                                border: Border.all(color: Color(0xff000000)),
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                 Container(
                                    // withdrawhistory145 (2:3709)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 195*fem, 0*fem),
                                    child: Text(
                                      'Withdraw History',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.1428571429*ffem/fem,
                                        color: Color(0xff85ad00),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 25*fem,),
                                  Container(
                                    // vectorWmX (2:3710)
                                    margin: EdgeInsets.fromLTRB(0*fem, 4*fem, 0*fem, 0*fem),
                                    width: 6*fem,
                                    height: 12*fem,
                                    child: Image.asset(
                                      'assets/icons/vector-sHs.png',
                                      width: 6*fem,
                                      height: 12*fem,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          //withdraw-separator-line
                      Positioned(
                        // frame762434qJ1 (2:3712)
                        left: 28*fem,
                        top: 740*fem,
                        child:
                          SvgPicture.asset('assets/icons/withdraw-separator-line.svg',),
                      ),
                          Positioned(
                            // frame762434qJ1 (2:3712)
                            left: 28*fem,
                            top: 743*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(26*fem, 22*fem, 26*fem, 23*fem),
                              width: 366*fem,
                              height: 64*fem,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>AddBank()),
                                          (e) => false);

                                },

                                child:Container(
                                // autogroupt3538nu (RW2Ek3PRRCEKvf1HscT353)
                                width: 204*fem,
                                height: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text("Line"),
                                    //withdraw-separator-line

                                    Container(
                                      // vector4wT (2:3716)
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                      width: 19*fem,
                                      height: 19*fem,
                                      child: Image.asset(
                                        'assets/icons/vector-qbX.png',
                                        width: 19*fem,
                                        height: 19*fem,
                                      ),
                                    ),
                                    Text(
                                      // addnewbankaccountNhF (2:3713)
                                      'Add New Bank Account',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 15*ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.0666666667*ffem/fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ),

                          Positioned(
                            // frame762434qJ1 (2:3712)
                            left: 28*fem,
                            top: 800*fem,
                            child:
                            SvgPicture.asset('assets/icons/withdraw-separator-line.svg',),
                          ),
                          Positioned(
                            // navigationbariFK (2:3717)
                            left: 3*fem,
                            top: 1090.578125*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(133.58*fem, 24.84*fem, 133.58*fem, 9.46*fem),
                              width: 414*fem,
                              height: 40.22*fem,
                              decoration: BoxDecoration (
                                color: Color(0xffffffff),
                              ),
                              child: Center(
                                // itemsQdw (2:3718)
                                child: SizedBox(
                                  width: 146.83*fem,
                                  height: 5.91*fem,
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // line6YEM (2:3723)
                            left: 21*fem,
                            top: 597*fem,
                            child: Align(
                              child: SizedBox(
                                width: 366*fem,
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
                            // enteramountFeZ (2:3747)
                            left: 153*fem,
                            top: 108*fem,
                            child: Align(
                              child: SizedBox(
                                width: 108*fem,
                                height: 16*fem,
                                child: Text(
                                  'Enter Amount',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1*ffem/fem,
                                    color: Color(0xff000000),
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
                    // statusbarXMB (2:3725)
                    left: 24*fem,
                    top: 32.6590423584*fem,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionTwoWithdrawMoney(amount: widget.amount, transactionID: "")),
                                (e) => false);
                      },
                      child:SizedBox()),
                  ),

                ],
              ),
            ),
          ),


          //
        ))));
  }

}
