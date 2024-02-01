import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quizmaster/pages/Components/CustomAppBarAddMoney.dart';
import 'package:quizmaster/pages/ui/transaction-one-add-money.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/addmoneyselect.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:quizmaster/pages/ui/payment.dart';

import '../webview/rateus.dart';
import 'cashfree.dart';
import 'hold-processing-payment.dart';
import 'package:quizmaster/class/LoadingDialog.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'dart:io' show Platform, exit;
import 'login.dart';
class AddMoney extends StatefulWidget {
  String transactionMsg;
  String transactionAmount;
  AddMoney({required this.transactionMsg,required this.transactionAmount});
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser = new User();
  Transactions databaseTransaction = new Transactions();
  late StreamSubscription<ConnectivityResult> subscription;
  final myController = TextEditingController();
  late String payamount="2000";
  final int ispayment=1;
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if(widget.transactionMsg!=''){
        TransactionFailedBottomSheet();
      }
    });

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
    myController.text="2000";
    getWithDrawData();
    deviceAuthCheck();
    getBalance();
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

    //await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
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
  String mainBalance="";
  String walletBalance="";
  getBalance(){
    databaseUser
        .balanceinfo()
        .whenComplete(() async{
      setState(() {
         mainBalance=databaseUser.mainBalance;
      });
    });
  }

  //String payamount="";
  String transactionID="";
  @override


  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }


  TransactionFailedBottomSheet() {

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
                                child: Text('Transaction Failed ',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 15),)
                            )
                        ),

                        Expanded(
                          child:  Align(alignment:Alignment.topRight,child: IconButton(
                            icon:  Icon(Icons.close, color: Colors.black, size: 30,),
                            // tooltip: 'Show Snackbar',

                            // leadingWidth: 400,

                            onPressed: () {
                              Navigator.of(context).pop();
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

                            child: Text('Any amount deducted will be refunded within 2-4\ndays. How would you like to proceed ?',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14), textAlign: TextAlign.center),
                          ),


                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(padding:EdgeInsets.only(left: 20.0),child:Text("Payment of ₹"+widget.transactionAmount,style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold, fontSize: 18))),
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
                                      builder: (context) => AddMoney(transactionMsg: "",transactionAmount: "",)),
                                      (e) => false);

                            },
                            child: Text(
                              'Try Other Payment Methods',
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
  Widget build(BuildContext context) {

    late BuildContext dialogContext;// global declaration
    final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
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
          appBar:  AddMoneyAppBar(
            mainBalance: (mainBalance!='')?mainBalance:"0.00",
            height: 165,
            child: Stack(
              children: [

              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFECECEC),
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
                shrinkWrap: true,
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  // Main Contetn Start Here
                  Text("Add Amount to QM Wallet", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),),
                  SizedBox(height: 5.0,),
                  FormBuilder(
                    key: _formKey,
                    onChanged: () {
                    },
                    autovalidateMode: AutovalidateMode.disabled,
                    initialValue: const {

                    },
                    skipDisabled: true,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Align( alignment:Alignment.topLeft,  child: Text("Enter Amount",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                        SizedBox(height: 20,),

                        SizedBox(
                            height: 45, // <-- TextField height
                            child:FormBuilderTextField(
                              name: 'mobile',
                              readOnly: false,
                              controller: myController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                      width: 3,
                                      color: Color(0xFFC8C8C8)),
                                ),
                                labelText: '',
                                hintText: "",
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                prefixText: "₹",
                              ),

                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                              ]),
                              // initialValue: '12',

                              onChanged: (val) {
                                setState(() {
                                  payamount=val.toString();
                                });
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.number,
                              //textInputAction: TextInputAction.next,
                            )),

                        SizedBox(height: 20,),
                        Align( alignment:Alignment.topLeft,  child: Text("Recommended",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                        SizedBox(height: 20,),


                        Row(
                          children:  <Widget>[
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    myController.text="2000";
                                    payamount="2000";
                                  });
                                },
                                child:Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 1),
                                    ],
                                  ),
                                  child: Padding(padding: EdgeInsets.all(8.0),child:Text(
                                      '₹ 2,000',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1*ffem/fem,
                                        color: Color(0xff000000),
                                      )),
                                  ),
                                )),
                            SizedBox(width: 10,),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    myController.text="1000";
                                    payamount="1000";
                                  });
                                },
                                child:Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 1),
                                    ],
                                  ),
                                  child: Padding(padding: EdgeInsets.all(8.0),child:Text(
                                      '₹ 1,000',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1*ffem/fem,
                                        color: Color(0xff000000),
                                      )),
                                  ),
                                )),
                            SizedBox(width: 10,),

                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    myController.text="500";
                                    payamount="500";
                                  });
                                },
                                child:Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 1),
                                    ],
                                  ),
                                  child: Padding(padding: EdgeInsets.all(8.0),child:Text(
                                      '₹ 500',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1*ffem/fem,
                                        color: Color(0xff000000),
                                      )),
                                  ),
                                )),
                            SizedBox(width: 10,),

                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    myController.text="100";
                                    payamount="100";
                                  });
                                },
                                child:Container(
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 1),
                                    ],
                                  ),
                                  child: Padding(padding: EdgeInsets.all(8.0),child:Text(
                                      '₹ 100',
                                      style: SafeGoogleFont (
                                        'Open Sans',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1*ffem/fem,
                                        color: Color(0xff000000),
                                      )),
                                  ),
                                )),
                            SizedBox(width: 10,),

                          ],
                        ),
                        (Platform.isIOS)?SizedBox(height: 100,):SizedBox(),
                        (Platform.isIOS)?Container(
                            color: Color(0xFFECECEC),
                            child:Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                   SizedBox(
                                    width: MediaQuery.of(context).size.width-100,
                                    //width: 265*ffem,
                                    height: 50.0,

                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: _colorFromHex(Constants.buttonColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // <-- Radius
                                          ) // foreground
                                      ),
                                      onPressed: () {



                                        LoaderDialog.showLoadingDialog(context, _LoaderDialog);


                                        if (_formKey.currentState
                                            ?.saveAndValidate() ??
                                            false) {

                                          if(ispayment==1) { databaseTransaction
                                              .payment( payamount,Constants.mobileNumber,Constants.mailID)
                                              .whenComplete(() {
                                            setState(() {



                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CashFree(
                                                              paymentSessionId:databaseTransaction.paymentSessionId,
                                                              orderId:databaseTransaction.orderId,
                                                              created_at:databaseTransaction.created_at,
                                                              amount:databaseTransaction.order_amount.toString(),
                                                              page:'addmoneypayment'

                                                          )),
                                                      (e) => false);


                                            });
                                          });
                                          }else{

                                          }

                                        } else {
                                          debugPrint(_formKey
                                              .currentState?.value
                                              .toString());
                                          debugPrint('validation failed');
                                        }






                                      },
                                      child:  Text(
                                        'Proceed to add  ₹$payamount',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:FontWeight.w600,
                                            fontSize: 16.0),
                                      ),
                                    ),


                                  )   ],
                              ),
                            )):SizedBox()


                      ],
                    ),
                  ),
                  SizedBox(height: 25.0,),
                ]

            ),
          ),

          bottomNavigationBar: (!Platform.isIOS)?Container(
              color: Color(0xFFECECEC),
              child:Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    new SizedBox(
                      width: MediaQuery.of(context).size.width-20,
                      height: 50.0,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: _colorFromHex(Constants.buttonColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // <-- Radius
                            ) // foreground
                        ),
                        onPressed: () {



                          LoaderDialog.showLoadingDialog(context, _LoaderDialog);


                          if (_formKey.currentState
                              ?.saveAndValidate() ??
                              false) {

                            if(ispayment==1) { databaseTransaction
                                .payment( payamount,Constants.mobileNumber,Constants.mailID)
                                .whenComplete(() {
                              setState(() {



                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CashFree(
                                                paymentSessionId:databaseTransaction.paymentSessionId,
                                                orderId:databaseTransaction.orderId,
                                                created_at:databaseTransaction.created_at,
                                                amount:databaseTransaction.order_amount.toString(),
                                                page:'addmoneypayment'

                                            )),
                                        (e) => false);


                              });
                            });
                            }else{

                            }

                          } else {
                            debugPrint(_formKey
                                .currentState?.value
                                .toString());
                            debugPrint('validation failed');
                          }






                        },
                        child:  Text(
                          'Proceed to add  ₹$payamount',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight:FontWeight.w600,
                              fontSize: 16.0),
                        ),
                      ),


                    )   ],
                ),
              )):SizedBox(),
          //
        ));
  }

}
