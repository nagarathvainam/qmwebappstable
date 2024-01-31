import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:quizmaster/constant/constants.dart';
class Question {
  var responseCode;
  var responseDescription;
  String serverUrl = Constants.API_BASE_URL;
  List correctanswerdata = [];
  String answerStatus="";
  String winningPrice="";
  String correctAnswer="";
  var totalQuestionCount="0";
  List winnerquestiondata = [];
  String totalAnswer="";
  var question;
  var questionRefID;
  var categoryRefID="1";
  List<String> option = [];
  var answer;
  var answeralphapet="";
  var optionA="";
  var optionB="";
  var optionC="";
  var optionD="";
  var percentageA="";
  var percentageB="";
  var percentageC="";
  var correctOption="";
  var questionWinCount="";
  var questionCount="";
  var quizCount="";
  var paid="";
  var tax="";
  List schemedata = [];
  List scheduledata = [];
  var qTotalCount="";
  var qWaitDuration="";
  var qPlayCount="";
  var qSchemeRefID="";
  var currentTime="";
  int openDuration=0;
  var openURL="";
  int closeDuration=0;
  var closeURL="";
  var qStartTime="";
  var QuestionBody="";
  var imageURl="";

  var QuestionResponseCode="";
  var QuestionResponseDescription="";
  var height="";
  var width="";
  var caption="";
  var headers = {
    'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
    'Content-Type': 'application/json'
  };
  getQuestioninfo(QuestionRefID) async{
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    var ScheduleRefID=prefs.getString('scheduleRefID');
    //var QuestionRefID=prefs.getString('QuestionRefID');//Commented By Used Constatns.QuestionRefID
    var  GroupRefID=prefs.getString('QuizTypeRefID');
    Map<String,String> headers = {'Content-Type':'application/json'};
    final body = jsonEncode({
      "ScheduleRefID":"$ScheduleRefID",
      "GroupRefID":"$GroupRefID",
      "QuestionRefID":"$QuestionRefID",
      "UserRefID":"$userRefID",
      "QuestionTypeRefID":"0",
      "LanguageRefID":"0"
    });
    Constants.printMsg("Question View Body:$body");
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.questions+"."+Constants.API_BASE_URL+"/api/s1/QI/Questions":"$serverUrl/s1/QI/Questions";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    question=data["data"]['question'];
    questionRefID=data["data"]['questionRefID'];
    option.add(data["data"]['optionA']);
    option.add(data["data"]['optionB']);
    option.add(data["data"]['optionC']);
    if(data["data"]['optionD']!='') {
      option.add(data["data"]['optionD']);

    }

    if(data["data"]['optionD']!='') {
      option.add(data["data"]['optionD']);

      if(data["data"]['answer']=='D'){
        answer=data["data"]['optionD'];
        answeralphapet="D";
      }

    }


    if(data["data"]['optionE']!='') {
      option.add(data["data"]['optionE']);

      if(data["data"]['answer']=='E'){
        answer=data["data"]['optionE'];
        answeralphapet="E";
      }

    }
    if(data["data"]['answer']=='A'){
      answer=data["data"]['optionA'];
      answeralphapet="A";
    }
    if(data["data"]['answer']=='B'){
      answer=data["data"]['optionB'];
      answeralphapet="B";
    }
    if(data["data"]['answer']=='C'){
      answer=data["data"]['optionC'];
      answeralphapet="C";
    }
    if(data["data"]['answer']=='D'){
      answer=data["data"]['optionD'];
      answeralphapet="D";
    }

    Constants.printMsg("Question View Correct Answer:");
    Constants.printMsg(answer);
    Constants.printMsg("Question View Response Code:");
    Constants.printMsg(data['status']['responseCode']);
    Constants.printMsg("Question View Response Description:");
    Constants.printMsg(data['status']['responseDescription']);

    QuestionResponseCode=data['status']['responseCode'];
    responseCode=data['status']['responseCode'];
    QuestionResponseDescription=data['status']['responseDescription'];
    responseDescription=data['status']['responseDescription'];
    QuestionBody=body;
    if(Constants.prefix=='') {
      categoryRefID = data["data"]['categoryRefID'];
      height = data["data"]['height'];
      width = data["data"]['width'];
      caption = data["data"]['caption'];
      imageURl=data["data"]['imageURL'];
      Constants.printMsg("imageURL Question:$imageURl");
    }


  }
  var WinnersBody="";
  var WinnersResponseCode="";
  var WinnersResponseDescription="";
  Future<String> getQuestionWiseWinnerData(QuestionRefID) async {
    //QuestionRefID=1;

    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode(
        {
          "QuestionRefID":"$QuestionRefID"
        }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.questions+"."+Constants.API_BASE_URL+"/api/s1/win/QuestionWinners":"http://188.214.129.98:5002/api/s1/win/QuestionWinners";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    WinnersBody=body;
    var result = json.decode(response.body);
    Constants.printMsg("QuestionWinners QuestionRefID: $QuestionRefID");

    Constants.printMsg("QuestionWinners responseCode:");
    Constants.printMsg(result['status']['responseCode']);
    Constants.printMsg("QuestionWinners responseDescription:");
    Constants.printMsg(result['status']['responseDescription']);
    Constants.printMsg(result);
    winnerquestiondata=result['data'];
    if(result['status']['responseCode']!='1') {
      //totalQuestionCount = result['status']['totalQuestionCount'];
      //totalAnswer = result['status']['totalAnswer'];
    }else{
      totalQuestionCount = "";
      totalAnswer = "";
    }

    responseCode=result['status']['responseCode'];
    WinnersResponseCode=result['status']['responseCode'];
    responseDescription=result['status']['responseDescription'];
    WinnersResponseDescription=result['status']['responseDescription'];

    return "Success!";
  }

  Future<String> getCorrectAnswerData(scheduleRefID) async {
    Constants.printMsg("getCorrectAnswerData scheduleRefID:"+scheduleRefID);
    //final prefs = await SharedPreferences.getInstance();
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
   // var ScheduleRefID=prefs.getString('scheduleRefID');
    var now = new DateTime.now();
    var currentFormatDate = new DateFormat('yyyy-MM-dd');
    String currentDate = currentFormatDate.format(now);

    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "ScheduleRefID":"$scheduleRefID",
      "UserRefID":"$userRefID",
      "Date":"$currentDate"
    }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.report+"."+Constants.API_BASE_URL+"/api/s1/QI/UserWiseAnswerQuestion":"http://188.214.129.98:5002/api/s1/QI/UserWiseAnswerQuestion";
    Constants.printMsg("UserWiseAnswerQuestion myUrl:$myUrl");
    Constants.printMsg("UserWiseAnswerQuestion body:$body");
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);

    //responseCode=result['responseCode'];
    //responseDescription=result['responseDescription'];
    //if(responseDescription.toString()!='null'){
    correctanswerdata=result['data'];
    //}else{
    //transactiondata=[];
    //}
    Constants.printMsg("UserWiseAnswerQuestion Body:$body");
    Constants.printMsg("UserWiseAnswerQuestion Result:$result");
    return "Success!";
  }

  Future<String> getAnswerPercentageData(questionRefID) async {

    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "QuestionRefID":"$questionRefID"
    });
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.questions+"."+Constants.API_BASE_URL+"/api/s1/QI/AnswersPer":"http://188.214.129.98:5002/api/s1/QI/AnswersPer";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
    optionA=result['data']['optionA'];
    optionB=result['data']['optionB'];
    optionC=result['data']['optionC'];
    optionD=result['data']['optionD'];
    percentageA=result['data']['percentageA'];
    percentageB=result['data']['percentageB'];
    percentageC=result['data']['percentageC'];
    correctOption=result['data']['correctOption'];


    return "Success!";
  }

  UserQuizPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID":"$userRefID",
    });
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.report+"."+Constants.API_BASE_URL+"/api/s1/win/UserQuizPlayed":"http://188.214.129.98:5002/api/s1/win/UserQuizPlayed";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    Constants.printMsg("UserQuizPlayed body:"+body);
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];
    questionWinCount=data['data']['questionWinCount'];
    questionCount=data['data']['questionCount'];
    quizCount=data['data']['quizCount'];
    paid=data['data']['paid'];
    tax=data['data']['tax'];

  }



  Future<String> getScheduleData() async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"SCH";
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({

    });
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.schedule+"."+Constants.API_BASE_URL+"/api/s1/$prefix/Schedule":"http://188.214.129.98:5002/api/s1/$prefix/Schedule";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("getScheduleData myUrl:"+myUrl);
    var result = json.decode(response.body);
    scheduledata=result['data'];

    Constants.printMsg("getScheduleData Result:$result");
    return "Success!";
  }



  Future<String> getSchemeData(QuizTypeRefID) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"SCH";
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode(
        {
          "QuizTypeRefID":"$QuizTypeRefID"
        }
    );


    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.schedule+"."+Constants.API_BASE_URL+"/api/s1/$prefix/GetGroup":"http://188.214.129.98:5002/api/s1/$prefix/GetGroup";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
    schemedata=result['data'];
    totalQuestionCount=result['status']['totalQuestionCount'];
    totalAnswer=result['status']['totalAnswer'];
    responseCode=result['status']['responseCode'];
    responseDescription=result['status']['responseDescription'];

    return "Success!";
  }

  var QuestionSynBody="";
  var QuestionSynResponseCode="";
  var QuestionSynResponseDescription="";
  QuestionSync(ScheduleRefID) async{
    var prefix=(Constants.prefix!='')?Constants.prefix:"SCH";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    //ScheduleRefID=prefs.getString('ScheduleRefID');
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID":"$userRefID",
      "ScheduleRefID":"$ScheduleRefID"
    });
    QuestionSynBody=body;
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/ScheduleSync":"http://188.214.129.98:5002/api/s1/$prefix/ScheduleSync";
    Constants.printMsg("/api/s1/qi/ScheduleSync URL:"+myUrl);
    Constants.printMsg("/api/s1/qi/ScheduleSync body:"+body);
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    //Constants.printMsg("/api/s1/qi/ScheduleSync data['status']['responseCode']:"+data['status']['responseCode']);
    //Constants.printMsg("/api/s1/qi/ScheduleSync data['status']['responseDescription']:"+data['status']['responseDescription']);
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];
    QuestionSynResponseCode=data['status']['responseCode'];
    QuestionSynResponseDescription=data['status']['responseDescription'];

    qTotalCount=data['data']['qTotalCount'];//5 Total Question Count
    qPlayCount=data['data']['qPlayCount'];//1  Paly Count Question
    qSchemeRefID=data['data']['qSchemeRefID'];// Scheme Id
    questionRefID=data['data']['questionRefID'];// Scheme Id
    currentTime=data['data']['currentTime'];
    qStartTime=data['data']['qStartTime'];
    //Constants.QuestionRefID=questionRefID;
    qWaitDuration=data['data']['qWaitDuration'];
    //prefs.setString('QuestionRefID',questionRefID);

  }



  playvideo() async{

    Map<String,String>  headers = {
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({
    });

    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.master+"."+Constants.API_BASE_URL+"/api/s1/master/PlayVideo":"http://188.214.129.98:5002/api/s1/master/PlayVideo";
    Constants.printMsg("Play Video:$myUrl");
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);

    openURL=result['data']['openURL'];
    openDuration=result['data']['openDuration'];
    closeURL=result['data']['closeURL'];
    closeDuration=result['data']['closeDuration'];

  }

  List winnerscheduledata = [];
  Future<String> getScheduleWiseWinnerData(ScheduleRefID) async {
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode(
        {
          "scheduleRefID":"$ScheduleRefID"
        }
    );
    Constants.printMsg("ScheduleWinners Body:"+body);
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.schedule+"."+Constants.API_BASE_URL+"/api/s1/win/ScheduleWinners":"http://188.214.129.98:5002/api/s1/win/ScheduleWinners";
    print("ScheduleWinners  myUrl:$myUrl");

    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );


    var result = json.decode(response.body);
    winnerscheduledata=result['data'];
    Constants.printMsg("Schedule Data:");
    Constants.printMsg(winnerscheduledata);

    //Constants.printMsg("ScheduleWinners Result:"+result);
    return "Success!";
  }

}