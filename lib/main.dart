import 'dart:io' show Platform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/pages/question/schedule.dart';
import 'package:quizmaster/pages/splashweb.dart';
import 'package:quizmaster/pages/ui/cashfree.dart';
import 'package:quizmaster/pages/ui/congratulations.dart';
import 'package:quizmaster/pages/ui/gray.dart';
import 'package:quizmaster/pages/ui/green.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:quizmaster/pages/ui/editprofile.dart';
import 'package:quizmaster/pages/ui/createprofile.dart';
import 'package:quizmaster/pages/ui/helpdesk.dart';
import 'package:quizmaster/pages/ui/hold-processing-payment.dart';
import 'package:quizmaster/pages/ui/hold-processing-question.dart';
import 'package:quizmaster/pages/ui/language.dart';
import 'package:quizmaster/pages/ui/linkbankui.dart';
//import 'package:quizmaster/pages/ui/mtb.dart';
import 'package:quizmaster/pages/ui/myperformance-screen-one.dart';
import 'package:quizmaster/pages/ui/myperformance-screen-two.dart';
import 'package:quizmaster/pages/ui/overlayexample.dart';
import 'package:quizmaster/pages/ui/percentage.dart';
import 'package:quizmaster/pages/ui/permission.dart';
//import 'package:quizmaster/pages/ui/questionviewnew.dart';
import 'package:quizmaster/pages/ui/questionwinninglist.dart';
import 'package:quizmaster/pages/ui/schedule-complete.dart';
import 'package:quizmaster/pages/ui/schemdetails.dart';
//import 'package:quizmaster/pages/ui/transactions.dart';
import 'package:quizmaster/pages/ui/otp.dart';
import 'package:quizmaster/pages/ui/payment-successfull.dart';
//import 'package:quizmaster/pages/ui/correctanswerwinninglist.dart';
import 'package:quizmaster/pages/ui/addbank.dart';
import 'package:quizmaster/pages/ui/addmoney.dart';
import 'package:quizmaster/pages/ui/profilepreviousquiz.dart';
import 'package:quizmaster/pages/ui/schemedetailsnew.dart';
//import 'package:quizmaster/pages/ui/qmwallet.dart';
import 'package:quizmaster/pages/ui/settings.dart';
//import 'package:quizmaster/pages/ui/transaction-history.dart';
import 'package:quizmaster/pages/ui/winner-list.dart';
//import 'package:quizmaster/pages/ui/wronganswerwinninglist.dart';
import 'package:quizmaster/pages/webview/gamepolicy.dart';
import 'package:quizmaster/pages/webview/rateus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:quizmaster/pages/splash.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:quizmaster/pages/ui/pin.dart';
import 'package:quizmaster/pages/ui/profilewinningdetails.dart';
import 'package:quizmaster/pages/ui/questionintro.dart';
import 'package:quizmaster/pages/ui/questiontimer.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:quizmaster/pages/ui/redeemcode.dart';
import 'package:quizmaster/pages/ui/referralcodeui.dart';
import 'package:quizmaster/pages/ui/edit-profile-tab.dart';
import 'package:quizmaster/pages/ui/file_picker_demo.dart';
import 'package:quizmaster/pages/ui/kyc-verification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quizmaster/constant/constants.dart';
//import 'package:quizmaster/pages/ui/google-sign-in.dart';
import 'package:quizmaster/pages/ui/hold-processing.dart';
//import 'package:quizmaster/pages/ui/request-withdrawal-money.dart';
//import 'package:quizmaster/pages/ui/payment.dart';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quizmaster/pages/ui/transaction-successfull.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_background/flutter_background.dart';

//import 'package:flutter_facebook_sdk/flutter_facebook_sdk.dart';
import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:quizmaster/pages/question/model/question.dart';
//import 'package:flutter_logs/flutter_logs.dart';
User databaseUser = new User();
Question databaseQuestion = new Question();
void main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Color(0xff5924CE),
    // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Logging
  /*await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: ["device","network","errors"],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: "MyLogs",
      logsExportDirectoryName: "MyLogs/Exported",
      debugFileOperations: true,
      isDebuggable: true);*/


  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isAndroid) {
    await Firebase.initializeApp();
    requestFcmPermission();
  }
  runApp(MyApp());
}



Color _colorFromHex(String hexColor) {
  final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
  return Color(int.parse('FF$hexCode', radix: 16));
}
void requestFcmPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.provisional) {
  } else {
  }
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) =>
      Color.fromRGBO(
          tintValue(color.red, factor),
          tintValue(color.green, factor),
          tintValue(color.blue, factor),
          1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) =>
      Color.fromRGBO(
          shadeValue(color.red, factor),
          shadeValue(color.green, factor),
          shadeValue(color.blue, factor),
          1);

  String scheduleRefID="";
  String userRefID="";
  var qTotalCount="";
  var qPlayCount="";
  int isQuestionRedirect=0;
  @override
  void initState() {
  requestPermission();
  super.initState();
  //printKeyHash();
  //getAllPermission();
  //askPermission();
    //backgroundSleep();
    userinfo();


  }


  userinfo() async{
    final prefs = await SharedPreferences.getInstance();
    print("await prefs.getString('qsid')");
    print(await prefs.getString('qsid'));
    databaseUser
        .userinfo(await prefs.getString('qsid'))
        .whenComplete(() async{
      setState(() {
       // Constants.userRefID=databaseUser.userRefID;

        userRefID=databaseUser.userRefID;


        scheduleRefID = (prefs.getString('scheduleRefID') ?? "");
        if(scheduleRefID!=''){
          databaseQuestion.QuestionSync(scheduleRefID)
              .whenComplete(() async{
            setState(() {
              if(databaseQuestion.responseCode=="0"){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuestionDynamicUiPage()),
                        (e) => false);
              }
            });
          });
        }

      });
    });
    print("scheduleRefID:$scheduleRefID");
    print("userRefID:$userRefID");
    print("isQuestionRedirect:$isQuestionRedirect");
    print("await prefs.getString('qsid')");
    print(await prefs.getString('qsid'));
  }
  void printKeyHash() async{

    String? key=await FlutterFacebookKeyhash.getFaceBookKeyHash ??
        'Unknown platform version';
    print("HashKey for Manikandan:");
    print(key??"");

  }
/*
  void backgroundSleep() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "flutter_background example app",
      notificationText: "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    bool success = await FlutterBackground.initialize(
        androidConfig: androidConfig);
  }
*/

  void requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.phone,
      Permission.location,
      Permission.camera,
      Permission.storage,
    ].request();

    statuses.values.forEach((element) async {
      if (element.isDenied || element.isPermanentlyDenied) {
        await openAppSettings();
      }

    });

  }




  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

  return MaterialApp(
  title: 'Quick Quiz',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.
  primarySwatch: generateMaterialColor(_colorFromHex(Constants.baseThemeColor)),
  textTheme: Theme.of(context).textTheme.apply(
  fontFamily: 'Opensans',
  ),
  ),
  //home:  MyHomePage(title: 'Flutter Demo Home Page $scheduleRefID'),

  initialRoute: '/',
  routes: {
    '/': (context) =>/*QuestionViewUiPage(scheduleRefID: '457', questionId: '40')*//*SchemeDetailNewPage(title: "Daily Quick Quiz", index: 1, list: [
      {
        "scheduleRefID": "488",
        "scheduleName": "FullDayQuiz",
        "scheduleStartTime": "12:30:00",
        "groupRefID": "1",
        "scheduleDate": "19-07-2023 00:00:00",
        "scheme": "2",
        "questionCount": "3",
        "questionStartTime": "12:31:00",
        "amount": "6",
        "groupCount": "2",
        "heading1": "Daily Quick Quiz",
        "heading2": "(Level 1 to 2)",
        "heading3": "and win cash upto ",
        "heading4": "₹10,000*",
        "heading5": "",
        "imageURL": "https://docs.quizmaster.world/UploadFiles/QI/Home/photo1.png",
        "imageURL2": "",
        "imageURL3": "",
        "button1": "Join the Quiz",
        "button2": "",
        "button3": "",
        "button4": ""
      },
      {
        "scheduleRefID": "468",
        "scheduleName": "FullDayQuiz",
        "scheduleStartTime": "12:30:00",
        "groupRefID": "2",
        "scheduleDate": "19-07-2023 00:00:00",
        "scheme": "4",
        "questionCount": "2",
        "questionStartTime": "12:33:10",
        "amount": "8",
        "groupCount": "2",
        "heading1": "Daily Quick Quiz",
        "heading2": "(Level 1 to 2)",
        "heading3": "and win cash upto ",
        "heading4": "₹10,000*",
        "heading5": "",
        "imageURL": "https://docs.quizmaster.world/UploadFiles/QI/Home/photo1.png",
        "imageURL2": "",
        "imageURL3": "",
        "button1": "Join the Quiz",
        "button2": "",
        "button3": "",
        "button4": ""
      }
    ], QuizTypeRefID: "1", starttimelabel: "21:31:00", currentTime: "17-07-2023 21:27:47")*/SplashWebPage(),//QuestionViewUiPage(scheduleRefID: '', questionId: '6998')//HoldQuestionProcessing(scheduleRefID: '521'),//(scheduleRefID!='')?QuestionDynamicUiPage():SplashPage(),//Percentage(option: ['Nagarjuna', 'Kashyapa Matanga', 'Menander'], question: "Who among the following was associated with the formulation of the basic ideas of mahatma buddhism?", selectedQues: "A", answerstring: "Nagarjuna", questionRefID: "923", correctAnswer: "A", qPlayCount: '1', qTotalCount: '5', page: "timesup", winningPrice: '4'),//SplashPage(),//QuestionTimerIntroUiPage(currentTime: "2023-06-22 10:51:00",),//TranactionSuccessfull(page: 'payout',transactionid:'3646464646',transactionamount:'1450',transactiondate:'21-06-2023 14:35',transactionmessage:'Payin Process Completed ',accountHolderName:"Kannan.N",accountNumber:"4545364756564",ifscCode:"SBIN00028737"),//TranactionSuccessfull(page: 'withdrawalrequest',),//Percentage(option: ['Nagarjuna', 'Kashyapa Matanga', 'Menander'], question: "Who among the following was associated with the formulation of the basic ideas of mahatma buddhism?", selectedQues: "A", answerstring: "Nagarjuna", questionRefID: "7439", correctAnswer: "A", qPlayCount: '1', qTotalCount: '5', page: "timesup", winningPrice: '40'),//Percentage(option: ['Nagarjuna', 'Kashyapa Matanga', 'Menander'], question: "Who among the following was associated with the formulation of the basic ideas of mahatma buddhism?", selectedQues: "A", answerstring: "Nagarjuna", questionRefID: "7439", correctAnswer: "A", qPlayCount: '1', qTotalCount: '5', page: "wrong", winningPrice: '40'),//SplashPage(),//Percentage(option: ['Nagarjuna', 'Kashyapa Matanga', 'Menander'], question: "Who among the following was associated with the formulation of the basic ideas of mahatma buddhism?", selectedQues: "A", answerstring: "Nagarjuna", questionRefID: "7439", correctAnswer: "A", qPlayCount: '1', qTotalCount: '5', page: "correct", winningPrice: '40'),//Percentage(option: ['Nagarjuna', 'Kashyapa Matanga', 'Menander'], question: "Who among the following was associated with the formulation of the basic ideas of mahatma buddhism?", selectedQues: "A", answerstring: "Nagarjuna", questionRefID: "7439", correctAnswer: "A", qPlayCount: '1', qTotalCount: '5', page: "wrong", winningPrice: '40'),//SplashPage(),//PermissionHandlerWidget(),//QuestionWinningList(question: "Who among the following was associated with the formulation of the basic ideas of mahatma buddhism?", questionRefID: '7439', qPlayCount: '1', qTotalCount: '5', page: 'timesup'),//Percentage(option: ['Nagarjuna', 'Kashyapa Matanga', 'Menander'], question: "Who among the following was associated with the formulation of the basic ideas of mahatma buddhism?", selectedQues: "A", answerstring: "Nagarjuna", questionRefID: "7439", correctAnswer: "A", qPlayCount: '1', qTotalCount: '5', page: "correct", winningPrice: '40'),//OtpUiPage(mobile: "9443976954", otp: "") ,
   
  },
  );
  }

}


