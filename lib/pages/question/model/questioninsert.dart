import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quizmaster/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class QuestionInsert {
  var responseCode;
  var responseDescription;
  String answerStatus="";
  String winningPrice="";
  String correctAnswer="";
  String questionRefID="";
  String answerinsertBody="";
  var headers = {
    'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
    'Content-Type': 'application/json'
  };
  answerinsert(QuizTypeRefID,scheduleRefID,questionRefID,AnswerPick) async{
   // questionRefID=Constants.QuestionRefID;
    //var userRefID=Constants.userRefID;
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "GroupRefID":"$QuizTypeRefID",
      "ScheduleRefID":"$scheduleRefID",
      "QuestionRefID":"$questionRefID",
      "UserTypeRefID":"5",
      "LanuageRefID":"0",
      "UserRefID":"$userRefID",
      "AnswerPick":"$AnswerPick"
    }
    );
    answerinsertBody=body;
    Constants.printMsg("Answer Insert Body:$body");
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.questions+"."+Constants.API_BASE_URL+"/api/s1/QI/Answers":"http://188.214.129.98:5002/api/s1/QI/Answers";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    //Constants.printMsg("Insert Answers Body:"+body);
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];
    answerStatus=data['data']['answerStatus'];
    winningPrice=data['data']['winningPrice'];
    correctAnswer=data['data']['correctAnswer'];
    questionRefID=data['data']['questionRefID'];


  }
  var responseCode1="";
  var responseDescription1="";
  var winningPrice1="";
  var answerStatus1="";
  var correctAnswer1="";
  var questionRefID1="";
  var answerinsertPoorNetworkBody="";
  answerresponsepoornetwork(scheduleRefID,questionRefID) async{
    //questionRefID=Constants.QuestionRefID;

    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "ScheduleRefID":"$scheduleRefID",
      "QuestionRefID":"$questionRefID",
      "UserRefID":"$userRefID",
    }
    );
    answerinsertPoorNetworkBody=body;
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/qi/GetPickAnswers":"http://188.214.129.98:5002/api/s1/qi/GetPickAnswers";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("GetPickAnswers  myUrl:$myUrl");
    Constants.printMsg("GetPickAnswers  Body:$body");
    var data = json.decode(response.body);
   // Constants.printMsg("GetPickAnswers  Data:"+data['data']);
    responseCode1=data['status']['responseCode'];
    responseDescription1=data['status']['responseDescription'];
    answerStatus1=data['data']['answerStatus'];
    winningPrice1=data['data']['winningPrice'];
    correctAnswer1=data['data']['correctAnswer'];
    questionRefID1=data['data']['questionRefID'];
    Constants.printMsg("GetPickAnswers  Data:"+data['data']);

  }

  
}