import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import '../question/schedule.dart';
import 'dart:ui';
import 'package:quizmaster/pages/ui/addbank.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
//import '../../model/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/transaction/model/transaction.dart';
import 'package:quizmaster/class/LoadingDialog.dart';
import 'package:quizmaster/pages/transaction/model/paymentgateway.dart';
import '../webview/rateus.dart';
import 'login.dart';
class LinkBankUI extends StatefulWidget {
  LinkBankUI({Key? key}) : super(key: key);

  @override
  _LinkBankUIState createState() => _LinkBankUIState();
}

class _LinkBankUIState extends State<LinkBankUI> {
  late StreamSubscription<ConnectivityResult> subscription;
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser=new User();
  Transactions databaseTransaction = new Transactions();
  PaymentGatewayModel PaymentGateway = new PaymentGatewayModel();
  String token ="";
  String benId="Prem";
  String signature="";
  String amount="1";
  String transferId="";
  late int selectedIndex = -1;
  String selectedBenId="";
  List bendata=[];


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
    //getAllLevelAPICalls();
    deviceAuthCheck();
    getBenData();
   // pggetsignature();
    //GenOTPKYC();
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
getAllLevelAPICalls(){
  PaymentGateway
      .pggetsignature()
      .whenComplete(() async{
    setState(() {
      PaymentGateway
          .cashFreeAuthorize(PaymentGateway.signature)
          .whenComplete(() async{
        setState(() {
              cashFreegetBeneficiary(databaseTransaction.token);
        });
      });
    });
  });
}


      GenOTPKYC(){
      PaymentGateway.pggetsignature()
      .whenComplete(() async {
        setState(() {
          PaymentGateway.generateOtpAadhaar(PaymentGateway.signature,'688872163162')
              .whenComplete(() async {

          });
        });
      });
      }

  pggetsignature(){
    PaymentGateway
        .pggetsignature()
        .whenComplete(() async{
      setState(() {
        print("PAGE GET Signature:");
        print(PaymentGateway.signature);
        pgauthorize(PaymentGateway.signature);
      });
    });
  }


  pgauthorize(signature){
    PaymentGateway
        .cashFreeAuthorize(signature)
        .whenComplete(() async{
      setState(() {

      });
    });
  }

  verifyToken(token){
    PaymentGateway
        .cashFreeVeryfyToken(token)
        .whenComplete(() async{
      setState(() {

      });
    });
  }





  cashFreegetBeneficiary(token){
    PaymentGateway
        .cashFreegetBeneficiary(token,benId)
        .whenComplete(() async{
      setState(() {

      });
    });
  }


  cashFreeRequestTransfer(token,benId,amount,transferId){
    PaymentGateway
        .cashFreeRequestTransfer(token,benId,amount,transferId)
        .whenComplete(() async{
      setState(() {

      });
    });
  }


  cashFreeDirectTransfer(token,benId,amount,transferId){
    PaymentGateway
        .cashFreeDirectTransfer(token)
        .whenComplete(() async{
      setState(() {

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
              builder: (context) => QuestionDynamicUiPage()),
              (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
        drawer: const CustomDrawer(),
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

          title: const Text('Linked Bank Accounts',style: TextStyle(color:Colors.white),),
          actions: <Widget>[
          ],
        ),
        body:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Container(
              padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0.2*fem),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration (
                color: _colorFromHex(Constants.baseThemeColor),
              ),
              child: SingleChildScrollView(child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only (
                        topLeft: Radius.circular(24*fem),
                        topRight: Radius.circular(24*fem),
                      ),
                    ),
                    child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15.0),

                        children: <Widget>[


                          (bendata.length>0)?SizedBox():Container(
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
                              child:Center(child: Text("No bank entries found",style: TextStyle(color: Colors.red),))
                          ),

                          // Main Contetn Start Here
                          (bendata.length>0)?Text(bendata.length.toString()+" Bank Accounts are linked",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 16),):Center(child:Text("No entries found",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w700, fontSize: 16))),
                          SizedBox(height: 20.0,),

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

                                            //Image.asset("assets/delete.png"),

                                            IconButton(
                                              icon:  (selectedIndex ==
                                                  index)
                                                  ?Icon(Icons.delete,color: _colorFromHex(Constants.baseThemeColor),):Icon(Icons.delete,color: _colorFromHex(Constants.baseThemeColor),size: fem*30,),
                                              tooltip: 'Increase volume by 10',
                                              onPressed: () {
                                                setState(() {



                                                    // set up the buttons
                                                    Widget cancelButton = TextButton(
                                                      child: Text("Cancel"),
                                                      onPressed:  () {
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                    Widget continueButton = TextButton(
                                                      child: Text("Ok"),
                                                      onPressed:  () {
                                                        print(bendata[index]['beneID']);
                                                        LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                                                        databaseTransaction
                                                            .internalApiRemoveBeneficiary(bendata[index]['beneRefID']);

                                                        PaymentGateway
                                                            .pggetsignature()
                                                            .whenComplete(() async{
                                                          setState(() {
                                                            PaymentGateway
                                                                .cashFreeAuthorize(PaymentGateway.signature)
                                                                .whenComplete(() async{
                                                              setState(() {
                                                                PaymentGateway
                                                                    .cashFreeRemoveBen(PaymentGateway.token,bendata[index]['beneID'])
                                                                    .whenComplete(() async{
                                                                  setState(() {

                                                                    var subcode=PaymentGateway.status;
                                                                    var message=PaymentGateway.message;



                                                                    showDialog<void>(
                                                                      context: context,
                                                                      barrierDismissible: false, // user must tap button!
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          title:  (subcode==200)?Text('Success'):Text('Warning/Info'),
                                                                          content: SingleChildScrollView(
                                                                            child: ListBody(
                                                                              children:  <Widget>[
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


                                                                  });
                                                                });
                                                              });
                                                            });
                                                          });



                                                        });
                                                      },
                                                    );
                                                    // set up the AlertDialog
                                                    AlertDialog alert = AlertDialog(
                                                      title: Text("Delete Confirm"),
                                                      content: Text("Are you sure want to delete?"),
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





                                                });
                                              },
                                            )


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
                              )): SizedBox(),

                        ]
                    ),
                  )
                ],
              ),
            ),
          ),
        ))
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
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => AddBank()),
                    (e) => false);
          },
          child: const Text(
            'Add Another Account',
            style: TextStyle(
                color: Colors.black,
                fontWeight:FontWeight.w600,
                fontSize: 16.0),
          ),
        ),)
          ]
      ),

    )
    ));
  }
}
