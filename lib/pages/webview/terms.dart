import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../question/schedule.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class Terms extends StatefulWidget {
  Terms({Key? key}) : super(key: key);
  @override
  _TermsState createState() => _TermsState();
}
class _TermsState extends State<Terms> {


  late StreamSubscription<ConnectivityResult> subscription;
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

            title: const Text('Terms & Conditions',style: TextStyle(color:Colors.white),),
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
                    // color: Colors.green,
                    spreadRadius: 1,
                    blurRadius: 1),
              ],
            ),
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
                   Container(
                        padding: EdgeInsets.all(6),
                        width: double.infinity,
                        child:Column(
                          children:  <Widget>[
                            Row(
                              children:  <Widget>[

                                SizedBox(width: 10.0,),
                                Expanded(
                                  child: Text('Conditions of Use:', textAlign: TextAlign.left,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),



                   Container(
                        padding: EdgeInsets.all(6),
                        width: double.infinity,
                        child:Column(
                          children:  <Widget>[
                            Row(
                              children:  <Widget>[

                                SizedBox(width: 10.0,),
                                Expanded(
                                  child: Text('Quick Quiz PRIVATE LTD DOES NOT WARRANT THAT THIS PORTAL, IT’S SERVERS, OR EMAIL SENT BY US OR ON OUR BEHALF ARE VIRUS FREE. Quick Quiz PRIVATE LTD WILL NOT BE LIABLE FOR ANY DAMAGES OF ANY KIND ARISING FROM THE USE OF THIS PORTAL, INCLUDING, BUT NOT LIMITED TO COMPENSATORY, DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, SPECIAL AND CONSEQUENTIAL DAMAGES, LOSS OF DATA, GOODWILL, BUSINESS OPPORTUNITY, INCOME OR PROFIT, LOSS OF OR DAMAGE TO PROPERTY AND CLAIMS OF THIRD PARTIES. IN NO EVENT WILL Quick Quiz PRIVATE LTD BE LIABLE FOR ANY DAMAGES WHATSOEVER ', textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),
                                )
                              ],
                            ),

                          ],
                        ),
                      )
                  ,


                Container(
                        padding: EdgeInsets.all(6),
                        width: double.infinity,
                        child:Column(
                          children:  <Widget>[
                            Row(
                              children:  <Widget>[

                                SizedBox(width: 10.0,),
                                Expanded(
                                  child: Text('This game involves an element of financial Risk AND may be addictive please play RESPONSIBLY at ur own risk.', textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
                                )
                              ],
                            ),

                          ],
                        ),
                      )
                  ,






                  // you can add widget here as well

                ]

            ),
          ),


          //
        ));
  }

}
