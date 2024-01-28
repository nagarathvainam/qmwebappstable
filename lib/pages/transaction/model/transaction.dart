import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/constant/constants.dart';
class Transactions {
  var responseCode;
  var responseDescription;
  var orderId;
  var paymentSessionId;
  var created_at;
  var order_amount;
  List approvewithdrawdata = [];
  List transactiondata = [];
  var beneID="";
  //var signature="";
  //List signaturedata=[];
  var token="";
  var status="";
  var subCode="";
  var message="";
  List mtbdata = [];
  var dailyLimit="";
  var dailyBalanceAmount="";
  List bendata1 = [];
  var trasactionAmount="";
  var transactionDate="";
  var accountHolderName="";
  var accountNumber="";
  var ifscCode="";
  var transactionIDS="";
  var transactionID="";
  var UserBankRefId="";
  List previousquizdata = [];

  var headers = {
    'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
    'Content-Type': 'application/json'
  };


  payschdule( coinAmount, checkedOverAllTotal, CrDr, scheduleRefID,
      QuizTypeRefID,
      coinvalueselected,mainvalueselected) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    print("isMainBalance:$mainvalueselected");
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };
    if(mainvalueselected==true){
      coinAmount=0;
      checkedOverAllTotal=checkedOverAllTotal;
    }else{
      coinAmount=checkedOverAllTotal;
      checkedOverAllTotal=0;
    }
    final body = jsonEncode({
      "UserRefID": "$userRefID",
      "Coins": "$coinAmount",
      "Amount": "$checkedOverAllTotal",
      "CrDr": "$CrDr",
      "ScheduleRefID": "$scheduleRefID",
      "GroupRefID": "$QuizTypeRefID"
    });

    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/PaySchedule":"http://uat.quizmaster.world/api/s1/$prefix/PaySchedule";
    Constants.printMsg("Body of PaySchedule:$body");

    var response = await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );

    var data = json.decode(response.body);
    Constants.printMsg("Response of PaySchedule:$data");
    responseCode = data['responseCode'];
    responseDescription = data['responseDescription'];

  }


  payment(amount,mobile,email) async{
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    Map<String,String>  headers = {
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({
      "transactionID": "",
      "request": "",
      "amount":"$amount",
      "commetns": Constants.name,
      "userRefID": "$userRefID",
      "userTypeRefID": "5",
      "encRequest": "",
      "transactionStatusRefID": "4",
      "createdBy": "100",
      "userMobileNo": "$mobile",
      "mail": "$email",
      "LinkMode":"Web"
    });
    print("PG Request Body:$body");
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.pg+"."+Constants.API_BASE_URL+"/api/S1/CashFreePG/PGRequest":"http://uat.quizmaster.world:2012/api/S1/CashFreePG/PGRequest";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    //responseCode=data['data']['ResponseCode'];
    //responseDescription=data['data']['ResponseDescription'];
    orderId=data['order_id'];
    paymentSessionId=data['payment_session_id'];
    created_at=data['created_at'];
    order_amount=data['order_amount'];

  }


  Future<String> getWithDrawData() async {
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");

    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode(
        {
          "UserRefID":"$userRefID",
          "UserTypeRefID":"5"
        }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/QI/ApproveWithdraw":"http://uat.quizmaster.world/api/s1/QI/ApproveWithdraw";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
    approvewithdrawdata=result['data'];
    return "Success!";
  }


  Future<String> getTransactionData(ServiceRefID,FromDate,ToDate) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"bal";
    var now = new DateTime.now();
    var currentFormatDate = new DateFormat('yyyy-MM-dd');
    if(FromDate==""){
      FromDate = currentFormatDate.format(now);
    }
    if(ToDate==""){
      ToDate = currentFormatDate.format(now);
    }
    //FromDate="2023-07-19";
    //ToDate="2023-07-19";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode(
        {
          "userRefID":"$userRefID",
          "UserTypeRefID":"5",
          "ServiceRefID":"$ServiceRefID"
          ,"FromDate":"$FromDate","ToDate":"$ToDate"
        }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/Transaction":"http://uat.quizmaster.world/api/s1/$prefix/Transaction";
    Constants.printMsg("Transaction Body:$body");
    Constants.printMsg("Transaction myUrl:$myUrl");
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);

    Constants.printMsg("Transaction result:$result");
    //responseCode=result['responseCode'];
    //responseDescription=result['responseDescription'];
    /*if(responseDescription.toString()!='null'){*/
    transactiondata=result['data'];
    Constants.printMsg("Transaction transactiondata:$transactiondata");
    /*}else{
    transactiondata=[];
    }*/

    return "Success!";
  }

 var beneRefID="";
  internalApiAddBeneficiary(name,bankaccount,ifsc) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID":"$userRefID",
      "UserTypeRefID":"5",


      "AccountHolderName": "$name",
      // "email": "$eamil",
      // "phone": "$phone",
      "AccountNumber": "$bankaccount",
      "IFSCCode": "$ifsc",
      "BankRefID":"1"

      // "address1": "$address1",
      // "city": "$city",
      // "state": "$state",
      // "pincode": "$pincode"
    });
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/AddBank":"http://uat.quizmaster.world/api/s1/$prefix/AddBank";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );

    var result = json.decode(response.body);
    Constants.printMsg("AddBank Result:$result");
    Constants.printMsg("AddBank response:$response");
    Constants.printMsg("AddBank Body:$body");
    beneRefID=result['data']['beneRefID'];
    beneID=result['data']['beneID'];
    //UserBankRefId=result['data']['UserBankRefId'];
  }



 var withdrawHead1="";
  var minimumBalance="";
  Future<String> getMtbData(date,approvedStatusRefID) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    var now = new DateTime.now();
    var currentFormatDate = new DateFormat('yyyy-MM-dd');
    String currentDate = currentFormatDate.format(now);
    if(date==""){
      date=currentDate;
    }
    final body = jsonEncode({
      "UserRefID": "$userRefID",
      "UserTypeRefID": "5",
      "ReqDate": "$date",
      "approvedStatusRefID":"$approvedStatusRefID"
    }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/mtb":"http://uat.quizmaster.world/api/s1/$prefix/mtb";
    Constants.printMsg("/api/s1/QI/mtb: $myUrl");
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
      print("/api/s1/QI/mtbBODY:$body");
      print("/api/s1/QI/Result:result");
    //responseCode=result['responseCode'];
    //responseDescription=result['responseDescription'];
    //if(responseDescription.toString()!='null'){
    mtbdata=result['data'];
    //}else{
    //transactiondata=[];
    //}
    dailyLimit=result['status']['dailyLimit'];
    dailyBalanceAmount=result['status']['dailyBalanceAmount'];
    withdrawHead1=result['status']['withdrawHead1'];
    minimumBalance=result['status']['minimumBalance'];
    return "Success!";
  }
  internalApiRemoveBeneficiary(BeneRefID) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID":"$userRefID",
      "UserTypeRefID":"5",
     // "UserBankRefId":"$UserBankRefId",
      "BeneRefID":"$BeneRefID"
    }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/AccountDelete":"http://uat.quizmaster.world/api/s1/$prefix/AccountDelete";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
   // beneID=result['data']['beneID'];
    Constants.printMsg("Internal AccountDelete Body :$body");
    Constants.printMsg("Internal AccountDelete Result:$result");
  }


  Future<String> getBenData() async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    //var userRefID=Constants.userRefID;
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID": "$userRefID",
      "UserTypeRefID": "5"
    }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/AccountInfo":"http://uat.quizmaster.world/api/s1/$prefix/AccountInfo";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("AccountInfo Body $body");
    var result = json.decode(response.body);

    //responseCode=result['responseCode'];
    //responseDescription=result['responseDescription'];
    //if(responseDescription.toString()!='null'){
    bendata1=result['data'];
    //}else{
    //transactiondata=[];
    //}


    Constants.printMsg("Bank AccountInfo $bendata1");
    return "Success!";
  }


  withDrawRequest(amount) async{
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID":"$userRefID",
      "UserTypeRefID":"5",
      "Amount":"$amount"
    });
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.balance+"."+Constants.API_BASE_URL+"/api/s1/$prefix/Withdraw":"http://uat.quizmaster.world/api/s1/$prefix/Withdraw";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    Constants.printMsg("Body of Withdraw:$body");
    Constants.printMsg("Response of Withdraw:$data");
    if(response.statusCode==200) {
      responseCode = data['status']['responseCode'];
      responseDescription = data['status']['responseDescription'];
      trasactionAmount = data['data']['amount'];
      transactionID = data['data']['transactionID'];
      transactionDate = data['data']['requestDateTime'];
    }else{
      responseCode = data['responseCode'];
      responseDescription = data['responseDescription'];
    }

  }



  PayOut(transactionID, selectedBenId) async{
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({

      "TransactionID":"$transactionID",
      "BeneID":"$selectedBenId",
      "Request":""


    });

    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.mtb+"."+Constants.API_BASE_URL+"/api/s1/PO/PayOut":"http://uat.quizmaster.world/api/s1/PO/PayOut";
    Constants.printMsg("myUrl /api/s1/PO/PayOut:$myUrl");
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("Body /api/s1/PO/PayOut:$body");
    var data = json.decode(response.body);
    Constants.printMsg("data /api/s1/PO/PayOut:$data");
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];
    transactionDate= data['data']['requestDateTime'];
    transactionIDS= data['data']['transactionID'];
    trasactionAmount=data['data']['approvedAmount'];
    accountHolderName=data['data']['accountHolderName'];
    accountNumber=data['data']['accountNumber'];
    ifscCode=data['data']['ifscCode'];

  }

  ApproveWithdraw(amount,transactionid,benid) async{
    final prefs = await SharedPreferences.getInstance();
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID":"$userRefID",
      "UserTypeRefID":"5",
      "Amount":"$amount",
      "TransactionID":"$transactionid",
      "BeneID":"$benid"
    });

    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/ApproveWithdraw":"http://uat.quizmaster.world/api/s1/$prefix/ApproveWithdraw";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];
  }


  PayOutUpdate(transactionID,statusCode,statusMessage) async{
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "transactionIDS": "$transactionID",
      "statusCode": "$statusCode",
      "statusMessage": "$statusMessage"
    });
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.mtb+"."+Constants.API_BASE_URL+"/api/s1/PO/PayOutUpdate":"http://uat.quizmaster.world/api/s1/PO/PayOutUpdate";
    Constants.printMsg("/api/s1/PO/PayOutUpdate:$myUrl");
    Constants.printMsg("/api/s1/PO/PayOutUpdate Body:$myUrl");
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];

  }


  PayinUpdate(transactionID,TransactionStatusRefID) async{

    //TransactionStatusRefID-2 ,TransactionStatusRefID-3
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "TransactionID":"$transactionID",
      "TransactionUpdatedStatus":"0",
      "EncResponse":"",
      "Response":"1",
      "ReferenceID":"1",
      "TransactionStatusRefID":"$TransactionStatusRefID",
      "UserTypeRefID":"5"
    }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.master+"."+Constants.API_BASE_URL+"/api/s1/PG/UpdatePGTransaction":"http://uat.quizmaster.world/api/s1/PG/UpdatePGTransaction";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    print("UpdatePGTransaction");
    print(body);
    print(myUrl);
    var data = json.decode(response.body);
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];
    print(responseDescription);
  }


  Future<String> getpreviousquizdata() async {
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    //userRefID="285";
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    var now = new DateTime.now();
    var currentFormatDate = new DateFormat('yyyy-MM-dd');
    String currentDate = currentFormatDate.format(now);
    //currentDate="2023-07-10";
    // if(date==""){
    //   date=currentDate;
    // }
    final body = jsonEncode({
      "UserRefID":"$userRefID",
      "Date":"$currentDate"
    }
    );
    print("Body OverallWinningAmountQuizCount:$body");

    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.report+"."+Constants.API_BASE_URL+"/api/s1/win/OverallWinningAmountQuizCount":"http://uat.quizmaster.world/api/s1/win/OverallWinningAmountQuizCount";
    Constants.printMsg("/api/s1/win/OverallWinningAmountQuizCount: $myUrl");
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
print("result of over all quiz data  ;$result");

    //responseCode=result['responseCode'];
    //responseDescription=result['responseDescription'];
    //if(responseDescription.toString()!='null'){
    previousquizdata=result['data'];
    //}else{
    //transactiondata=[];
    //}

    return "Success!";
  }


}