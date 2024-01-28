import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../question/schedule.dart';
import 'package:in_app_webview/in_app_webview.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
class RateUs extends StatefulWidget {
  String title;
  String url;
  RateUs({required this.title,required this.url});
  @override
  State<StatefulWidget> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  late StreamSubscription<ConnectivityResult> subscription;
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    //   SystemUiOverlay.bottom
    // ]);  // t
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

            title:  Text(widget.title,style: TextStyle(color:Colors.white,fontSize: 14),),
            actions: <Widget>[
            ],
          ),
          body: InAppWebView(
            widget.url,
            toolbarHeight: 0,
            btmSheetSize: 0,
          ),


        ));
  }
}
