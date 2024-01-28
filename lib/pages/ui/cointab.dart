import 'package:flutter/material.dart';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
//import '../../model/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../constant/constants.dart';
import '../transaction/model/transaction.dart';
import '../webview/rateus.dart';
import 'login.dart';
class CoinTab extends StatefulWidget {
  CoinTab({Key? key}) : super(key: key);
  @override
  _CoinTabState createState() => _CoinTabState();
}
class _CoinTabState extends State<CoinTab> {
  late StreamSubscription<ConnectivityResult> subscription;
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser = new User();
  Transactions databaseTransaction = new Transactions();
  int isserviceid=0;
  bool isDateSearch=true;
  String selectedFromDate="";
  String selectedToDate="";
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
    readSharedPrefs();
    deviceAuthCheck();
    getTransactionData(5,"","");

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

    await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
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
  String userRefID ="";
  void readSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRefID = (prefs.getString('userRefID') ?? "");

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
  List transactiondata = [];
  Future<String> getTransactionData(ServiceRefID,FromDate,ToDate) async {
    isserviceid=ServiceRefID;
    databaseTransaction
        .getTransactionData(ServiceRefID,FromDate,ToDate)
        .whenComplete(() async {
      setState(() {
        transactiondata = databaseTransaction.transactiondata as List;//........
        print("Tranaction Data Lenght:");
        print(transactiondata.length);
      });
    });
    return "";
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;


    return WillPopScope(
        onWillPop: () async {

          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
            body:SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      //SizedBox(height: 20,),

                      (isDateSearch)?Container(
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                        width: double.infinity,
                        height: 90.5*fem,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular(12*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20*fem, 0*fem, 16*fem, 0*fem),
                              width: 150*fem,
                              height: double.infinity,
                              decoration: BoxDecoration (
                                borderRadius: BorderRadius.circular(12*fem),
                              ),
                              //child: SingleChildScrollView(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    padding: EdgeInsets.fromLTRB(5*fem, 0*fem, 10*fem, 0*fem),
                                    width: double.infinity,
                                    decoration: BoxDecoration (
                                      border: Border.all(color: Color(0x28000000)),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(12*fem),
                                    ),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        FormBuilderDateTimePicker(
                                          name: 'fromdate',
                                          initialEntryMode: DatePickerEntryMode.calendar,
                                          initialValue: DateTime.now(),
                                          inputType: InputType.date,
                                          onChanged: (val) {
                                            selectedFromDate=val.toString().split(" ")[0];
                                            getTransactionData(isserviceid,selectedFromDate,selectedToDate);
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            suffixIcon: IconButton(
                                              icon:  Icon(Icons.calendar_month_outlined),
                                              onPressed: () {
                                                getTransactionData(isserviceid,selectedFromDate,selectedToDate);
                                              },
                                            ),
                                          ),
                                          // initialTime: const TimeOfDay(hour: 8, minute: 0),
                                          // locale: const Locale.fromSubtags(languageCode: 'fr'),
                                        ),


                                      ],
                                    ),

                                  ) ],
                              ),
                            ),
                            //SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(padding:EdgeInsets.only(top: 15) ,child:Image.asset('assets/icons/doublearrow.png',width: 30, height: 30 )),
                              ],
                            ),
                            // Image.asset('assets/icons/doublearrow.png',width: 30, height: 30 ),

                            SizedBox(width: 5,),
                            Container(
                              width: 150*fem,
                              height: double.infinity,
                              decoration: BoxDecoration (
                                borderRadius: BorderRadius.circular(12*fem),
                              ),

                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    padding: EdgeInsets.fromLTRB(5*fem, 0*fem, 10*fem, 0*fem),
                                    width: double.infinity,
                                    decoration: BoxDecoration (
                                      border: Border.all(color: Color(0x28000000)),
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(12*fem),
                                    ),

                                    // child:SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        FormBuilderDateTimePicker(
                                          name: 'todate',
                                          initialEntryMode: DatePickerEntryMode.calendar,
                                          initialValue: DateTime.now(),
                                          inputType: InputType.date,
                                          onChanged: (val) {
                                            selectedToDate=val.toString().split(" ")[0];
                                            getTransactionData(isserviceid,selectedFromDate,selectedToDate);
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            suffixIcon: IconButton(
                                              icon:  Icon(Icons.calendar_month_outlined),
                                              onPressed: () {
                                                getTransactionData(isserviceid,selectedFromDate,selectedToDate);
                                              },
                                            ),
                                          ),
                                          // initialTime: const TimeOfDay(hour: 8, minute: 0),
                                          // locale: const Locale.fromSubtags(languageCode: 'fr'),
                                        ),

                                      ],
                                    ),

                                  ) , ],
                              ),
                            )
                          ],
                        ),
                      ):SizedBox(),

                      SizedBox(height: 10,),
                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(40),
                          1: FlexColumnWidth(25),
                          2: FlexColumnWidth(27),
                          2: FlexColumnWidth(27),
                          3: FlexColumnWidth(50),
                          4: FlexColumnWidth(50),
                        },
                        border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid)),
                        children: [
                         TableRow( children: [
                            Column(children:[Padding(padding:  EdgeInsets.only(bottom: 5 ,top: 0), child:Text('Date &\n Time',
                                    style: SafeGoogleFont (
                                    'Open Sans',
                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w700,
                                    height: 1.1428571429*ffem/fem,
                                    color: Color(0xff000000),
                                          ),
                                          ))]),
                            Column(children:[Padding(padding:  EdgeInsets.only(bottom: 0 ,top: 8), child:Text('Type',
                              style: SafeGoogleFont (
                                      'Open Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w700,
                                      height: 1.1428571429*ffem/fem,
                                       color: Color(0xff000000),
                                    ),
                            ))]),
                            Column(children:[Padding(padding:  EdgeInsets.only(bottom: 0 ,top: 8), child:Text('Amout',
                              style: SafeGoogleFont (
                                                  'Open Sans',
                                fontSize: 16*ffem,
                                fontWeight: FontWeight.w700,
                                                  height: 1.1428571429*ffem/fem,
                                                  color: Color(0xffA90164),

                                                ), ))]),
                            Column(children:[Padding(padding:  EdgeInsets.only(bottom: 0 ,top: 8), child:Text('Previous ',
                              style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.1428571429*ffem/fem,
                                          color: Color(0xffA90164),
                                                      ),
                            ) )]),


                            Column(children:[
                              Padding(padding:  EdgeInsets.only(bottom: 0 ,top: 8), child:Text('Current ',
                              style: SafeGoogleFont (
                                                        'Open Sans',
                                                        fontSize: 16*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.1428571429*ffem/fem,
                                                        color: Color(0xffA90164),
                                                      ),))]),
                                                    ]),
                for(int index = 0; index<transactiondata.length;index++)...[
                          TableRow( children: [
                            Column(children:[Padding(padding:  EdgeInsets.only(bottom: 5 ,top: 5), child:Text(transactiondata[index]['createdDate']))]),
                            Column(children:[

                             Padding(padding:  EdgeInsets.only(bottom: 5 ,top: 15), child:Text(transactiondata[index]['crDrType'] ,
                              style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.1428571429*ffem/fem,
                                              color: Color(( transactiondata[index]['crDrType']=="CR")?0xff03c982:0xffc90000),
                                              ),
                            ))]),
                            Column(children:[Padding(padding:  EdgeInsets.only(bottom: 5 ,top: 15), child:Text('₹'+transactiondata[index]['crDrAmount'].toString(),
                              style: SafeGoogleFont (
                                'Open Sans',
                                fontSize: 14*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.1428571429*ffem/fem,
                                color: Color(( transactiondata[index]['crDrType']=="CR")?0xff03c982:0xffc90000),
                              ),

                            ))]),
                            Column(children:[Padding(padding:  EdgeInsets.only(bottom: 5 ,top: 15), child:Text('₹'+transactiondata[index]['previousBalance'].toString()))]),
                            Column(children:[
                                       Padding(padding:  EdgeInsets.only(bottom: 5 ,top: 15), child:Text('₹'+transactiondata[index]['currentBalance'].toString()))]),

                          ]),

                         ]


                        ],
                      ),



                    ],
                    //listview start



                  ),


                )
            )));
  }
}