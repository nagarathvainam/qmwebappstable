import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_cashfree_pg_sdk/flutter_cashfree_pg_sdk_web.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quizmaster/pages/ui/linkbankui.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
//import '../../model/databasehelper.dart';
import '../webview/rateus.dart';
import 'login.dart';
import 'package:quizmaster/class/LoadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'package:quizmaster/pages/transaction/model/paymentgateway.dart';
import 'package:quizmaster/pages/user/model/user.dart';
class AddBank extends StatefulWidget {
  AddBank({Key? key}) : super(key: key);

  @override
  _AddBankState createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  late StreamSubscription<ConnectivityResult> subscription;
  Transactions databaseTransaction = new Transactions();
  PaymentGatewayModel PaymentGateway = new PaymentGatewayModel();
  User databaseUser = new User();
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _genderHasError = false;
  var genderOptions = ['iob', 'sbi', 'icici'];
  //String token ="";

  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
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
    //deviceAuthCheck();
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

   // await //prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
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



  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
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
  Widget build(BuildContext context) {
    final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LinkBankUI()),
              (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
      backgroundColor: _colorFromHex(Constants.baseThemeColor),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:_colorFromHex(Constants.baseThemeColor) ,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
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

        title: const Text('Add Bank Details',style: TextStyle(color:Colors.white),),
        actions: <Widget>[
        ],
      ),

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
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              // Main Contetn Start Here
              Text("Please fill in the following details", style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),),
              SizedBox(height: 25.0,),
              // Text("Select a Bank",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),),
              SizedBox(height: 0,),
              FormBuilder(

                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                //autovalidateMode: AutovalidateMode.disabled,
                initialValue: const {

                },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[


                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("Account Number",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(

                      // autovalidateMode: AutovalidateMode.always,
                      name: 'account_number',
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Account Number',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        //FormBuilderValidators.numeric(),
                        // FormBuilderValidators.max(16),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text(" Confirm Account Number",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(

                      // autovalidateMode: AutovalidateMode.always,
                      name: 'cfm_account_number',
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Confirm Account Number',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        //FormBuilderValidators.numeric(),
                        // FormBuilderValidators.max(16),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("Account Name",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(

                     // autovalidateMode: AutovalidateMode.always,
                      name: 'name',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Account Name',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      valueTransformer: (text) => num.tryParse(text!),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),

                       // FormBuilderValidators.numeric(),
                        //FormBuilderValidators.max(16),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("IFSC Code",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(
                      //autovalidateMode: AutovalidateMode.always,

                      name: 'ifsc',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'IFSC Code',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([

                        FormBuilderValidators.required(),
                       // FormBuilderValidators.numeric(),
                        //FormBuilderValidators.max(16),
                      ]),

                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                    ),


                  /*  SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("Email",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(
                     // autovalidateMode: AutovalidateMode.always,
                      name: 'email',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Email',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("Phone",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(
                     // autovalidateMode: AutovalidateMode.always,
                      name: 'phone',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Phone',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("Address",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(
                     // autovalidateMode: AutovalidateMode.always,
                      name: 'address',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Address',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("City",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(
                     // autovalidateMode: AutovalidateMode.always,
                      name: 'city',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'City',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("State",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(
                     // autovalidateMode: AutovalidateMode.always,
                      name: 'state',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'State',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20,),
                    Align( alignment:Alignment.topLeft,  child: Text("Pincode",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),
                    FormBuilderTextField(
                    //  autovalidateMode: AutovalidateMode.always,
                      name: 'pincode',

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Pincode',
                      ),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),

                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 25,),
*/
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(

                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(0x26000014),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )),

                child: Text("Please ensure the above bank details are accurate.",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 14,) ),

                //Please ensure the above bank details are accurate.
              ) ]

        ),
      ),

      bottomNavigationBar: Container(
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

                     // LoaderDialog.showLoadingDialog(context, _LoaderDialog);

                      if (_formKey.currentState
                          ?.saveAndValidate() ??
                          false) {
                        debugPrint(_formKey.currentState?.value
                            .toString());


    if(_formKey.currentState
        ?.value['account_number']!=_formKey.currentState
        ?.value['cfm_account_number']){
    // print('Confirm Password and Password sg');
    showSnackBar('Account Number and confirm Account Number should be same');
    }else {
      setState(() {
        // print(bendata[index]['beneId']);
        LoaderDialog.showLoadingDialog(context, _LoaderDialog);
        databaseTransaction.internalApiAddBeneficiary(
          _formKey
              .currentState?.value['name'], _formKey
            .currentState?.value['account_number'], _formKey
            .currentState?.value['ifsc'],
        );

        PaymentGateway.pggetsignature()
            .whenComplete(() async {
          setState(() {
            PaymentGateway.cashFreeAuthorize(PaymentGateway.signature)
                .whenComplete(() async {
              setState(() {
                PaymentGateway.cashFreeAddBankDetails(
                    PaymentGateway.token, _formKey
                    .currentState?.value['name'], _formKey
                //.currentState?.value['email'],_formKey
                //.currentState?.value['phone'],_formKey
                    .currentState?.value['account_number'], _formKey
                    .currentState?.value['ifsc'],
                    Constants.mailID,
                    databaseTransaction.beneID
                  //  _formKey.currentState?.value['address'],_formKey
                  // .currentState?.value['city'],_formKey
                  //.currentState?.value['state'],_formKey
                  //.currentState?.value['pincode']
                )
                    .whenComplete(() async {
                  setState(() {
                    var subcode = PaymentGateway.subCode;
                    var message = PaymentGateway.message;
                      print("cashFreeAddBankDetails Add:  message"+message);
                    print("cashFreeAddBankDetails Add: subcode"+subcode);
                    if(subcode=="200"){
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: (subcode == "200") ? Text('Success') : Text(
                              'Warning/Info'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(message),
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
                                            LinkBankUI()),
                                        (e) => false);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    }else{

                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:  Text(
                                'Warning/Info'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(message),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  print("databaseTransaction.UserBankRefId:");
                                  print(databaseTransaction.UserBankRefId);
                                  databaseTransaction
                                      .internalApiRemoveBeneficiary(databaseTransaction.beneRefID);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LinkBankUI()),
                                          (e) => false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    ///kANNAN

                  });
                });
              });
            });
          });
        });
      });
    }

                      } else {
                        debugPrint(_formKey.currentState?.value
                            .toString());
                        debugPrint('validation failed');
                      }




                    },
                    child: const Text(
                      'Add Bank Account',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w600,
                          fontSize: 16.0),
                    ),
                  ),
                )   ],
            ),
          )),
      //
    ));
  }
}
