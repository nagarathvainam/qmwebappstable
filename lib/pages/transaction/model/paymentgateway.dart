import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:quizmaster/constant/constants.dart';
class PaymentGatewayModel {
  var responseCode;
  var responseDescription;
  var orderId;
  var paymentSessionId;
  var created_at;
  var order_amount;
  List approvewithdrawdata = [];
  List transactiondata = [];
  var beneID="";
  var signature="";
  List signaturedata=[];
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
  List previousquizdata = [];

  var headers = {
    'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
    'Content-Type': 'application/json'
  };


  payschdule( coinAmount, checkedOverAllTotal, CrDr, scheduleRefID,
      QuizTypeRefID,isMainBalance) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    print("isMainBalance:$isMainBalance");
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };
    if(isMainBalance==true){
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


  /*payment(amount,mobile,email) async{
    var userRefID=Constants.userRefID;
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

  }*/


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


  Future<String> getTransactionData(ServiceRefID) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
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
          ,"FromDate":"2023-01-01","ToDate":"3023-12-31"
        }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/Transaction":"http://uat.quizmaster.world/api/s1/$prefix/Transaction";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);

    //responseCode=result['responseCode'];
    //responseDescription=result['responseDescription'];
    //if(responseDescription.toString()!='null'){
    transactiondata=result['data'];
    //}else{
    //transactiondata=[];
    //}

    return "Success!";
  }

  pggetsignature() async{
    var response = await http.get(
        Uri.parse("https://partners.paym.world/authorize.php"),
        headers: {"Accept": "application/json"});
    var result = json.decode(response.body);
    signature=result['signature'];

  }
  internalApiAddBeneficiary(name,bankaccount,ifsc) async {
    final prefs = await SharedPreferences.getInstance();
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
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
    beneID=result['data']['beneID'];
  }





  cashFreeAuthorize(signature) async{
    var headers;
    var url="";
    var host_url="";
      host_url="https://payout-api.cashfree.com";
        headers = {
          'X-Cf-Signature': '$signature',
          'X-Client-Id': Constants.cashfree_client_id,
          'X-Client-Secret': Constants.cashfree_client_secret
        };
      url="$host_url/payout/v1/authorize";//host_url : https://api.cashfree.com

    var request = http.Request('POST', Uri.parse('$url'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var responseString=await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    token=decodedMap['data']['token'];
    Constants.printMsg("Cash Free Auth headers:$headers");
    Constants.printMsg("Cash Free Auth URL:$host_url");
    Constants.printMsg("Cash Free Auth Token:$token");
    Constants.printMsg("Token:$token");
    Constants.printMsg("cashFreeAuthorize token $token");
  }


  cashFreeVeryfyToken(token) async{
    var headers = {
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('POST', Uri.parse('https://payout-api.cashfree.com/payout/v1/verifyToken'));
      print("https://payout-api.cashfree.com/payout/v1/verifyToken");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


  }
  //List responsedata = [];

  cashFreeAddBankDetails(token,name,bankaccount,ifsc,email,benid) async{
    var email=Constants.mailID;
    var phone=Constants.mobileNumber;
    var address1="QUIZ MASTER PVT LIMITED BANGALORE";
    var city="BANGALORE";
    var state="Ka";
    var pincode="530068";
    var string = name.toString().toUpperCase();
    //var benid = string.substring(0, 8);

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'text/plain'
    };
    var request = http.Request('POST', Uri.parse('https://payout-api.cashfree.com/payout/v1/addBeneficiary'));
    request.body = '''{\r\n  "beneId": "$benid",\r\n  "name": "$name",\r\n  "email": "$email",\r\n  "phone": "$phone",\r\n  "bankAccount": "$bankaccount",\r\n  "ifsc": "$ifsc",\r\n  "address1": "$address1",\r\n  "city": "$city",\r\n  "state": "$state",\r\n  "pincode": "$pincode"\r\n}''';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    Constants.printMsg("https://payout-api.cashfree.com/payout/v1/addBeneficiary");
    Constants.printMsg(request.body);
    Constants.printMsg("cashfree.com/payout/v1/addBeneficiary Headers:$headers");
    if (response.statusCode == 200) {

      var responseString=await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      subCode=decodedMap['subCode'];
      message=decodedMap['message'];
      Constants.printMsg("https://payout-api.cashfree.com/payout/v1/addBeneficiary subCode:$subCode");
      Constants.printMsg("https://payout-api.cashfree.com/payout/v1/addBeneficiary subCode:$message");

    }
    else {
      Constants.printMsg("https://payout-api.cashfree.com/payout/v1/addBeneficiary Error");
    }

  }


  cashFreegetBeneficiary(token,benid) async {
    var headers = {
      'Authorization': 'Bearer $token'
    };

    var request = http.Request('GET', Uri.parse(
        'https://payout-api.cashfree.com/payout/v1/getBeneficiary/$benid'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    }
    else {
    }
  }






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

    //responseCode=result['responseCode'];
    //responseDescription=result['responseDescription'];
    //if(responseDescription.toString()!='null'){
    mtbdata=result['data'];
    //}else{
    //transactiondata=[];
    //}
    dailyLimit=result['status']['dailyLimit'];
    dailyBalanceAmount=result['status']['dailyBalanceAmount'];
    return "Success!";
  }






  cashFreeRequestTransfer(token,benId,amount,transferId) async {
    //var benid=name.toString().substring(0,4);//JOHN18011343
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'text/plain'
    };
    var request = http.Request('POST', Uri.parse('https://payout-api.cashfree.com/payout/v1/requestTransfer'));
    request.body = '''{\r\n  "beneId": "$benId",\r\n  "amount": "$amount",\r\n  "transferId": "$transferId"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    Constants.printMsg("api.cashfree.com/payout/v1/requestTransfer headers:$headers");
    Constants.printMsg("api.cashfree.com/payout/v1/requestTransfer: statusCode");
    Constants.printMsg(response.statusCode);
    if (response.statusCode == 200) {
      var responseString=await response.stream.bytesToString();

      final decodedMap = json.decode(responseString);
      subCode=decodedMap['subCode'];
      message=decodedMap['message'];
    }else{

      Constants.printMsg("api.cashfree.com/payout/v1/requestTransfer Error");

    }
  }


  cashFreeDirectTransfer(token) async {
    //var benid=name.toString().substring(0,4);//JOHN18011343
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://payout-api.cashfree.com/payout/v1.2/directTransfer'));
    request.body = '''{
 "amount": "25000.00",
 "transferId": "MAYOB202305n029",
 "transferMode": "neft",
 "remarks": "Vignesh Advance Salary for Feb 2023",
 "beneDetails" : {
     "bankAccount": "071899500024831",
     "ifsc": "YESB0000718",
     "name": "VIGNESH S",
     "email": "vigneshrko1504@gmail.com",
     "phone": "8344620701",
     "address1": "99 New Colony T.V.Kovil Trichy - 620005Tamil Nadu"
 },
 "paymentInstrumentId": "YESB_CONNECTED"
 }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();


  }



  cashFreeRemoveBen(token,benId) async {
    //var benid=name.toString().substring(0,4);//JOHN18011343
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'text/plain'
    };
    var request = http.Request('POST', Uri.parse('https://payout-api.cashfree.com/payout/v1/removeBeneficiary'));
    request.body = '''{\r\n  "beneId": "$benId"\r\n}''';
    request.headers.addAll(headers);
    Constants.printMsg("cashfree.com/payout/v1/removeBeneficiary Headers:$headers");
    Constants.printMsg("https://payout-api.cashfree.com/payout/v1/removeBeneficiary request.body:"+request.body);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var responseString=await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      subCode=decodedMap['subCode'];
      message=decodedMap['message'];
      Constants.printMsg("https://payout-api.cashfree.com/payout/v1/removeBeneficiary decodedMap:$decodedMap");
      Constants.printMsg("https://payout-api.cashfree.com/payout/v1/removeBeneficiary subCode:$subCode");
      Constants.printMsg("https://payout-api.cashfree.com/payout/v1/removeBeneficiary message:$message");
    }else{
      Constants.printMsg("https://payout-api.cashfree.com/payout/v1/removeBeneficiary Error:");
    }
  }

  /// Cash Free Transfer - End




  internalApiRemoveBeneficiary(UserBankRefId) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID":"$userRefID",
      "UserTypeRefID":"5",
      "UserBankRefId":"$UserBankRefId"
    }
    );
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.trans+"."+Constants.API_BASE_URL+"/api/s1/$prefix/AccountDelete":"http://uat.quizmaster.world/api/s1/$prefix/AccountDelete";
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
    Constants.printMsg("Internal AccountDelete Body :$body");
    Constants.printMsg("Internal AccountDelete Result:$result");
  }


  Future<String> getBenData(userRefID) async {
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    //var userRefID=Constants.userRefID;
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
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
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
    var prefix=(Constants.prefix!='')?Constants.prefix:"BAL";
    final prefs = await SharedPreferences.getInstance();
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
    print("/api/s1/PO/PayOutUpdate:$body");
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
    //var userRefID=Constants.userRefID;
    //userRefID="285";
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
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

    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.report+"."+Constants.API_BASE_URL+"/api/s1/win/OverallWinningAmountQuizCount":"https://report.quizmaster.world/api/s1/win/OverallWinningAmountQuizCount";
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

  var ref_id="";
  generateOtpAadhaar(signature,aadhaar_number) async {
    var headers = {
      'x-client-id': Constants.cashfree_client_id,
      'x-client-secret': Constants.cashfree_client_secret,
      'x-cf-signature': '$signature',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api.cashfree.com/verification/offline-aadhaar/otp'));
    request.body = json.encode({
      "aadhaar_number": "$aadhaar_number"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     // print(await response.stream.bytesToString());

      var responseString=await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      ref_id=decodedMap['ref_id'];
      message=decodedMap['message'];
      status=decodedMap['status'];
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/otp ref_id:$ref_id");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/otp status:$status");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/otp message:$message");

    }
    else {
      print(response.reasonPhrase);
    }
  }


  var aadhar_status="";
  var aadhar_message="";
  var aadhar_ref_id="";
  var aadhar_care_of="";
  var aadhar_address="";
  var aadhar_dob="";
  var aadhar_email="";
  var aadhar_gender="";
  var aadhar_name="";
  var aadhar_photo_link="";//base64 encoded image
  var aadhar_mobile_hash="";
  var aadhar_split_address_country="";
  var aadhar_split_address_dist="";
  var aadhar_split_address_house="";
  var aadhar_split_address_landmark="";
  var aadhar_split_address_pincode="";
  var aadhar_split_address_postOffice="";
  var aadhar_split_address_state="";
  var aadhar_split_address_street="";
  var aadhar_split_address_subdist="";
  var aadhar_split_address_vtc="";
  var year_of_birth="";
  getAadhaarInfo(signature,ref_id,otp) async {
    var headers = {
      'x-client-id': Constants.cashfree_client_id,
      'x-client-secret': Constants.cashfree_client_secret,
      'x-cf-signature': '$signature',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://api.cashfree.com/verification/offline-aadhaar/verify'));
    request.body = json.encode({
      "otp":"$otp",
      "ref_id":"$ref_id"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());

      var responseString=await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      ref_id=decodedMap['ref_id'];
      message=decodedMap['message'];
      status=decodedMap['status'];

      aadhar_care_of=decodedMap['care_of'];
      aadhar_address=decodedMap['address'];
      aadhar_dob=decodedMap['dob'];
      aadhar_email=decodedMap['email'];
      aadhar_gender=decodedMap['gender'];
      aadhar_name=decodedMap['name'];
      Constants.name=decodedMap['name'];
      var split_hyphen=aadhar_dob.split("-");
      aadhar_dob=split_hyphen[2]+"-"+split_hyphen[1]+"-"+split_hyphen[0];
      if(aadhar_gender=="M"){
        Constants.genderName="Male";
      }
      if(aadhar_gender=="F"){
        Constants.genderName="Female";
      }
      aadhar_photo_link=decodedMap['photo_link'];//base64 encoded image
      aadhar_mobile_hash=decodedMap['mobile_hash'];
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify ref_id:$ref_id");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify status:$status");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify message:$message");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_care_of:$aadhar_care_of");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_address:$aadhar_address");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_dob:$aadhar_dob");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_email=$aadhar_email");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_gender=$aadhar_gender");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_name=$aadhar_name");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_photo_link=$aadhar_photo_link");//base64 encoded image
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_mobile_hash=$aadhar_mobile_hash");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify year_of_birth=$year_of_birth");
    }
    else {
      print(response.reasonPhrase);
    }
  }




  var name_provided="";
  getPanInfo(signature,name,pan) async {
    name="TEST";
    var headers = {
      'x-client-id': Constants.cashfree_client_id,
      'x-client-secret': Constants.cashfree_client_secret,
      'x-cf-signature': '$signature',
      'Content-Type': 'application/json'
    };
    Constants.printMsg("getPanInfo http://api.cashfree.com/verification/pan");
    var request = http.Request('POST', Uri.parse('https://api.cashfree.com/verification/pan'));
    request.body = json.encode({
      "name":"$name",
      "pan":"$pan"
    });
    Constants.printMsg("getPanInfo Body:");
    Constants.printMsg(request.body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    Constants.printMsg("getPanInfo response.statusCode");
    Constants.printMsg(response.statusCode);
    if (response.statusCode == 200) {

      var responseString=await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      ref_id=decodedMap['reference_id'];
      message=decodedMap['message'];
      status=decodedMap['pan_status'];
      name_provided=decodedMap['name_provided'];
      Constants.printMsg("https://api.cashfree.com/verification/pan ref_id:$ref_id");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify status:$status");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify message:$message");
      Constants.printMsg("https://api.cashfree.com/verification/offline-aadhaar/verify aadhar_name=$name_provided");
    }
    else {
      Constants.printMsg("Error");
    }
  }

}