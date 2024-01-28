import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../question/schedule.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';
class HelpDesk extends StatefulWidget {
  HelpDesk({Key? key}) : super(key: key);
  @override
  _HelpDeskState createState() => _HelpDeskState();
}
class _HelpDeskState extends State<HelpDesk> {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  launchMailto(mail) async {
    final mailtoLink = Mailto(
      to: ['$mail'],
      // cc: ['cc1@example.com', 'cc2@example.com'],
      subject: '',
      body: '',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
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

        title: const Text('Help Desk',style: TextStyle(color:Colors.white),),
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
              Row(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/phone.svg',height: 27,width: 35,
                          colorFilter: ColorFilter.mode(_colorFromHex(Constants.baseThemeColor), BlendMode.srcIn),
                        ),
                      ),
                    ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Helpline Number',style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(height: 5,),
                            Text('+91 6364460708'),SizedBox(height: 5,),
                            new SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: _colorFromHex(Constants.buttonColor),
                                      // foreground
                                  ),
                                  onPressed: () async {
                                    _makePhoneCall("6364460708");
                                  },
                                  child:  Text(
                                    'Call Now',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,),
                                  ),
                                ))
                          ],
                        )
                    )

                  ]
              ),
              Padding(padding: EdgeInsets.only(top: 20),
                  child: Row(
                      children: <Widget>[
   Container(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/email.svg',height: 27,width: 35,
                              colorFilter: ColorFilter.mode(_colorFromHex(Constants.baseThemeColor), BlendMode.srcIn),),
                          ),
                        ),
                           Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reach us out at',style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(height: 5,),
                                Text('customercare@quizmaster.world'),SizedBox(height: 5,),
                                new SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: _colorFromHex(Constants.buttonColor),
                                        // foreground
                                      ),
                                      onPressed: () async {
                                        launchMailto('customercare@quizmaster.world');
                                      },
                                      child:  Text(
                                        'Write an Email',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,),
                                      ),
                                    ))
                              ],
                            )
                        )

                      ]
                  )
              ),
              Padding(padding: EdgeInsets.only(top: 20),
                  child: Row(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/location.svg',height: 27,width: 35,
                              colorFilter: ColorFilter.mode(_colorFromHex(Constants.baseThemeColor), BlendMode.srcIn),),
                          ),
                        ),
                        Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address',style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(height: 5,),
                                Text('Queens Square,'),SizedBox(height: 5,),
                                Text('First Floor No 1, Jasma Bhavan road, '),SizedBox(height: 5,),
                                Text('Queens road junction, Vasanthnagar,  '),SizedBox(height: 5,),
                                Text('Bangalore 560052'),SizedBox(height: 5,),
                              ],
                            )
                        )

                      ]
                  )
              )
            ]

        ),
      ),


      //
    ));
  }

}
