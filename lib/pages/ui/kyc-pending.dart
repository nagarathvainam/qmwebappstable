import 'package:flutter/material.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'dart:ui';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
class KYCPending extends StatefulWidget {
  KYCPending({Key? key}) : super(key: key);

  @override
  _KYCPendingState createState() => _KYCPendingState();
}

class _KYCPendingState extends State<KYCPending> {
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
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {

      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
       // drawer: const CustomDrawer(),
        body:
            SingleChildScrollView(child:Column(
              children:  <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Color(0xFFffffff),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),

                      ),
                    ),
                    Positioned(
                      top:fem*350,
                      child: SizedBox(
                        height: 115,
                        width: 115,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                                radius: 5,
                                backgroundColor: Color(0xffEBD9C3),
                                child:Container(

                                  margin: EdgeInsets.fromLTRB(8.82*fem, 8.82*fem, 8.82*fem, 8.82*fem),
                                  width: 129.81*fem,
                                  height: 134.18*fem,
                                  // color: Colors.white,
                                  child:CircleAvatar(
                                    radius: 5,
                                    // backgroundColor: Color(0xffC6E074),
                                    child: Container(
                                      height: 150,
                                      width: 146,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:Color(0xffFC9700),
                                      ),
                                      child: Icon(Icons.check, color: Colors.white,size: 80,),
                                      alignment: Alignment.center,
                                    ),),
                                )),

                          ],
                        ),
                      ),
                    ),
                    // Body of Text Start
                    SizedBox(height: 50,),
                    Positioned(
                      top:fem*500,
                      child:Text("KYC Verification Pending",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 50,),
                    Positioned(
                      top:fem*530,
                      child:Text('You wil receive a notification once its completed.',style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),)),

                    // Body of Text End
                  ],
                ),


              ],
            )

    )));
  }
}
