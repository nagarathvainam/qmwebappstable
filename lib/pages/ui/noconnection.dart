import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quizmaster/utils.dart';
import '../question/schedule.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quizmaster/constant/constants.dart';
class NoConnectionUiPage extends StatefulWidget {
  NoConnectionUiPage({Key? key}) : super(key: key);

  @override
  _NoConnectionUiPageState createState() => _NoConnectionUiPageState();
}

class _NoConnectionUiPageState extends State<NoConnectionUiPage> {
  final MyConnectivity _connectivity = MyConnectivity.instance;
  late bool isconnected=false;
  @override
  void initState() {
    _connectivity.initialise();
    _connectivity.myStream.listen((_source) {
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          navigatemainscreen();
          break;
        case ConnectivityResult.wifi:
          navigatemainscreen();
          break;
        case ConnectivityResult.none:
        default:
      }
    });
  }

  navigatemainscreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>QuestionDynamicUiPage()),
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

      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
    body:  Container(
      width: double.infinity,
      child: Container(
        width: double.infinity,
        height: 896*fem,
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
        child: Stack(
          children: [
            (isconnected==true)?Positioned(
              left: 180.0004882812*fem,
              bottom: 375.0532226562*fem,
              child: Align(
                child: SizedBox(
                  width: 233*fem,
                  height: 426.88*fem,
                  child:Image.asset(
                    'assets/connected-signal.png',
                    width: 233*fem,
                    height: 426.88*fem,
                  ),
                ),
              ),
            ):SizedBox(),

            Positioned(
              left: 91.0004882812*fem,
              top: 80.0532226562*fem,
              child: Align(
                child: SizedBox(
                  width: 233*fem,
                  height: 426.88*fem,
                  child: (isconnected==false)?Image.asset(
                    'assets/icons/nosignal-1.png',
                    width: 233*fem,
                    height: 426.88*fem,
                  ):Image.asset(
                    'assets/connected-man.png',
                    width: 233*fem,
                    height: 426.88*fem,
                  ),
                ),
              ),
            ),
            (isconnected==false)?Positioned(
              left: 127*fem,
              top: 375*fem,
              child: Align(
                child: SizedBox(
                  width: 169*fem,
                  height: 60*fem,
                  child: Text(
                    'NO \nCONNECTION ',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Open Sans',
                      fontSize: 24*ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.25*ffem/fem,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ):SizedBox(),

            Positioned(
              left: 75*fem,
              top: 435*fem,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-140,
                  height: 45*fem,
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
                              builder: (context) =>QuestionDynamicUiPage()),
                              (e) => false);
                    },
                    child:  Text(
                      (isconnected==true)?'Connected':'Retry',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
      bottomNavigationBar: Container(
        height: 200*ffem,
    decoration: BoxDecoration(
      image: DecorationImage (
        fit: BoxFit.fill,
        image: AssetImage (
          'assets/no-connection-bottom-bg.png',
        ),
      ),
    color: Colors.white,
    boxShadow: [
    BoxShadow(
    color: Colors.white,
    ),
    ],
    ),
    child:Container(
        child: SizedBox(width: MediaQuery.of(context).size.width,height: 300,),
      ),
    )));
  }
}
class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}