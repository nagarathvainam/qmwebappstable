import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/question/model/question.dart';
import 'package:quizmaster/pages/question/schedule.dart';
import 'package:quizmaster/pages/ui/hold-processing-question.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:video_player/video_player.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

    //_controller = VideoPlayerController.network((Constants.staging_production>0)?"https://docs.quizmaster.world/UploadFiles/Video/AppOpen/QMLOGOvertical.mp4":"http://uat.quizmaster.world:2018/UploadFiles/Video/AppOpen/QMLOGOvertical.mp4");//"http://uat.quizmaster.world:2018/UploadFiles/QI/Vi/QILogi.mp4"
    _controller = VideoPlayerController.asset("assets/video/splash.mp4");
        _controller.initialize().then((_) {
      _controller.setLooping(false);
      Timer(Duration(milliseconds: 6), () {
        setState(() {

          _controller.play();
          _visible = true;
        });
      });
    });

    Future.delayed(Duration(seconds: 6), () async{
      final prefs = await SharedPreferences.getInstance();
      final String? qsid = (prefs.getString('qsid')!=null)?prefs.getString('qsid'):'';
      final String? scheduleRefID = (prefs.getString('scheduleRefID')!=null)?prefs.getString('scheduleRefID'):'';
      initConnectivity();
      if(qsid!=''){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>QuestionDynamicUiPage()),
                  (e) => false);
      }else {


        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>QuestionDynamicUiPage()),
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

          String scheduleRefID="";

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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
                'You\'re not connected to a network')
            ));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>NoConnectionUiPage()),
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
    if (_controller != null) {
      _controller.dispose();
    }
    _connectivitySubscription.cancel();
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
            //Text("Loading...")
          ],
        ),
      ),
    );
  }
}
