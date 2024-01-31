import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/question/schedule.dart';
import 'package:quizmaster/pages/ui/hold-processing-question.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:quizmaster/pages/ui/splashscreen.dart';
import 'package:video_player/video_player.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Question databaseQuestion = new Question();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    initConnectivity();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    //_controller = VideoPlayerController.network((Constants.staging_production>0)?"https://docs.quizmaster.world/UploadFiles/Video/AppOpen/QMLOGOvertical.mp4":"http://188.214.129.98:5002:2018/UploadFiles/Video/AppOpen/QMLOGOvertical.mp4");//"http://188.214.129.98:5002:2018/UploadFiles/QI/Vi/QILogi.mp4"

    Future.delayed(Duration(seconds: 12), () async {
      final prefs = await SharedPreferences.getInstance();
      final String? qsid =
          (prefs.getString('qsid') != null) ? prefs.getString('qsid') : '';
      final String? scheduleRefID = (prefs.getString('scheduleRefID') != null)
          ? prefs.getString('scheduleRefID')
          : '';
      initConnectivity();
      if (qsid != '') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => QuestionDynamicUiPage()),
            (e) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => QuestionDynamicUiPage()),
            (e) => false);

        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginUiPage(title: '',url: '',)),
                (e) => false);*/
      }
    });

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  String scheduleRefID = "";

  Future<void> initConnectivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
    //final prefs = await SharedPreferences.getInstance();
    // prefs.setString('scheduleRefID',"");

    late ConnectivityResult connectivityResult;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('You\'re not connected to a network')));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoConnectionUiPage()),
            (e) => false);
      }
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(connectivityResult);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            SplashScreen(title: '',),
          ],
        ),
      ),
    );
  }
}
