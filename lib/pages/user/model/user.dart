import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:quizmaster/constant/constants.dart';
import 'dart:io' show Platform, exit;
import 'package:http_status_code/http_status_code.dart';
import 'package:dio/dio.dart';

class User {
  //var uuid = Uuid();
  // Generate a v4 (random) id
  //var v4 = uuid.v4();
  var responseCode;
  var responseDescription;

  //var passUpdated;
  bool passUpdated = false;
  var loginType;
  var deviceid = "";
  var displayName = "";
  var surName = "";
  var userRefID = "";
  var mobileNumber = "";
  var photo = "";
  var mailID = "";
  var dob = "";
  var genderName = "";
  var createdDate = "";
  var stateName = "";
  var stateRefID = "";
  var name = "";
  var pan = "";
  var aadhar = "";
  var kycStatus = "";
  bool firstLoginUpdated = false;
  var qsid;
  String otp = "";
  String mobileNo = "";
  String userTypeRefID = "";
  var kycStatusRefID = "";
  var aadharURL = "";
  var aadharNumber = "";
  var panurl = "";
  var bankURL = "";
  var bank = "";
  var approveRefID = "";
  var qiCoinBalance = "";
  var debitFrom = "";
  var mainBalance = "";
  var walletBalance = "";
  var coinValue = "";
  var depositBalance = "";
  var withdrawnBalance = "";
  var winningBalance1 = "";
  var approveBalance = "";
  List statedata = [];
  var overAllWinningAmount = "";
  var overAllQuizCount = "";
  var headers = {
    'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
    'Content-Type': 'application/json'
  };

  deviceAuth() async {
    /*
    final prefs = await SharedPreferences.getInstance();
    final version=await prefs.getString('version');
    var deviceId=await prefs.getString('deviceId');
    final platform=Constants.platform;
    final ipv4=Constants.ipv4;
    final lat=Constants.lat;
    final lon=Constants.lon;
    var qsid=prefs.getString('qsid');
    var userRefID=prefs.getString('userRefID');
    final fcmtoken=Constants.fcmtoken;
    // if (Platform.isIOS) {
    //   deviceId=uuid.v1();
    // }


    deviceId=(deviceId!=null)?deviceId:'';
    if(deviceId==''){
      deviceid="";
    }
    //deviceId="11111kannanios";
    Map<String,String> headers = {
      'VersionId': (Platform.isIOS)?Constants.iosappversion:'$version',
      'ServiceID': '1',
      'DeviceID': '$deviceId',
      'Platform': '$platform',
      'ip':'$ipv4',
      'fcmtoken':'$fcmtoken',
      'UserTypeID': '5',
      'Location': '$lat,$lon',
      'ssid': '',
      'Content-Type': 'application/json',
      'UserRefID':"$userRefID",
      'LanguageID':'en',
      'QSID':'$qsid'
    };
    final body = jsonEncode({
    });
    String myUrl = (Constants.staging_production>0)?Constants.https+Constants.auth+"."+Constants.API_BASE_URL+"/api/s1/QI/AuthCheck":"https://uat.quizmaster.world:5001/api/s1/QI/AuthCheck";
    Constants.printMsg(myUrl);
    var response =await http.post(Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    responseCode=data['status']['responseCode'];
    responseDescription=data['status']['responseDescription'];
    qsid=data['data']['qsid'].toString();
    //passUpdated=data['data']['passUpdated'];
    loginType=data['data']['loginType'].toString();
    deviceid=deviceId;
    Constants.printMsg("Response of AuthCheck:$data");
    Constants.printMsg("body of AuthCheck:$body");
    Constants.printMsg("headers of AuthCheck:$headers");*/
  }

  userKycinfo() async {
    final prefs = await SharedPreferences.getInstance();
    userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({"UserRefID": "$userRefID", "UserTypeRefID": "5"});
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.upload +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/Docs/Docs"
        : "https://uat.quizmaster.world:5001/api/s1/Docs/Docs";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );

    Constants.printMsg("/api/s1/Docs/Docs:$myUrl");
    var data = json.decode(response.body);
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
    aadharURL = data['data']['aadharURL'];
    aadharNumber = data['data']['aadharNumber'];
    pan = data['data']['pan'];
    panurl = data['data']['panurl'];
    bank = data['data']['bank'];
    bankURL = data['data']['bankURL'];
    Constants.printMsg("KYC Docs/Docs" + body);
    Constants.printMsg("aadharURL:$aadharURL");
    Constants.printMsg("panurl:$panurl");
    Constants.printMsg("bankURL:$bankURL");
  }

  balanceinfo() async {
    var headers = {
      'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
      'Content-Type': 'application/json'
    };
    var data = json.encode({
      "qsid": "tlLlU+89NAO4y3u7wKhuPQ==",
      "UserRefID": "285",
      "UserTypeRefID": "5"
    });
    Constants.printMsg("Data");
    Constants.printMsg(data);
    Constants.printMsg("Dio Headers");
    Constants.printMsg(headers);
    var dio = Dio();
    var response = await dio.request(
      'https://uat.quizmaster.world:5001/api/s1/UI/GetUsersInfo',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    Constants.printMsg(response.statusCode);
    if (response.statusCode == 200) {
      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
    var result;
    var isdeo = 0;
    if (isdeo == 0) {
      var prefix = (Constants.prefix != '') ? Constants.prefix : "BAL";
      final prefs = await SharedPreferences.getInstance();
      userRefID = (prefs.getString('userRefID') ?? "");
      //userRefID="19710";//TEST:5514 GOH//19710
      Map<String, String> headers = {
        'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
        'Content-Type': 'application/json'
      };
      final body =
          jsonEncode({"UserRefID": "$userRefID", "UserTypeRefID": "5"});
      Constants.printMsg("Balance Info Body: $body");
      String myUrl = (Constants.staging_production > 0)
          ? Constants.https +
              Constants.balance +
              "." +
              Constants.API_BASE_URL +
              "/api/s1/$prefix/Balance"
          : "https://uat.quizmaster.world:5001/api/s1/$prefix/Balance";
      var response = await http.post(
        Uri.parse(myUrl),
        headers: headers,
        body: body,
      );
      result = json.decode(response.body);
    } else {
      var headers = {
        'qsid': 'tlLlU+89NAO4y3u7wKhuPQ==',
        'Content-Type': 'application/json'
      };
      var data = json.encode({
        "qsid": "tlLlU+89NAO4y3u7wKhuPQ==",
        "UserRefID": "285",
        "UserTypeRefID": "5"
      });
      Constants.printMsg("Balance Info headers For Dio: $headers");
      Constants.printMsg("Balance Info Body For Dio: $data");
      var dio = Dio();
      var response = await dio.request(
        'https://uat.quizmaster.world:5001/api/s1/UI/GetUsersInfo',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
        result = json.decode(response.toString());
      } else {
        print(response.statusMessage);
      }
    }
    //
    Constants.printMsg("Balance Info Result : $result");
    qiCoinBalance = result['data']['qiCoinBalance'];

    mainBalance = result['data']['mainBalance'];
    walletBalance = result['data']['walletBalance'];
    coinValue = result['data']['coinValue'];
    withdrawnBalance = result['data']['withdrawnBalance'];
    depositBalance = result['data']['depositBalance'];
    winningBalance1 = result['data']['winningBalance1'];
    approveBalance = result['data']['approveBalance'];
    (Constants.prefix == '') ? debitFrom = result['data']['debitFrom'] : '';
    Constants.qiCoinBalance = qiCoinBalance;
    Constants.mainBalance = mainBalance;
    Constants.withdrawnBalance = withdrawnBalance;
    Constants.depositBalance = depositBalance;
    Constants.winningBalance1 = winningBalance1;
    Constants.walletBalance = walletBalance;
    Constants.coinValue = coinValue;
    responseCode = result['status']['responseCode'];
    responseDescription = result['status']['responseDescription'];
  }

  userinfo(qsid) async {
    var prefix = (Constants.prefix != '') ? Constants.prefix : "UI";
    if (qsid != '') {
      final prefs = await SharedPreferences.getInstance();
      qsid = await prefs.getString('qsid');
     // Map<String, String> headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "qsid": "$qsid",
        "UserRefID": "285", //TEST:5514 GOH//19710
        "UserTypeRefID": "5"
      });
      Constants.printMsg("Body of GetUSERINo:$body");
      String myUrl = (Constants.staging_production > 0)
          ? Constants.https +
              Constants.master +
              "." +
              Constants.API_BASE_URL +
              "/api/s1/$prefix/GetUsersInfo"
          : "https://uat.quizmaster.world:5001/api/s1/$prefix/GetUsersInfo"; // QC OK
      Constants.printMsg("MYURL:$myUrl");
      var response = await http.post(
        Uri.parse(myUrl),
        headers: headers,
        body: body,
      );
      Constants.printMsg("Body GetUsersInfo :$body");

      var result = json.decode(response.body);
      Constants.printMsg("Result GetUsersInfo :$result");
      Constants.displayName = result['data']['displayName'];
      Constants.surName = result['data']['surName'];
      Constants.userRefID = result['data']['userRefID'];
      await prefs.setString('userRefID', result['data']['userRefID']);
      Constants.mobileNumber = result['data']['mobileNumber'];
      Constants.photo = result['data']['imgURL'];
      Constants.mailID = result['data']['mailID'];
      Constants.dob = result['data']['dob'];
      Constants.genderName = result['data']['genderName'];
      Constants.createdDate = result['data']['createdDate'];
      Constants.stateName = result['data']['stateName'];
      Constants.stateRefID = result['data']['stateRefID'];
      userRefID = result['data']['userRefID'];
      await prefs.setString('userRefID', result['data']['userRefID']);
      Constants.name = result['data']['name'];
      Constants.pan = result['data']['pan'];
      Constants.aadhar = result['data']['aadhar'];
      Constants.kycStatus = result['data']['kycStatus'];
      Constants.kyCcomment = result['data']['kyCcomment'];
      Constants.KycapprovedCommentcomment = result['data']['approvedComment'];
      Constants.printMsg("Response of GetUsersInfo:$result");
      Constants.printMsg("body of GetUsersInfo:$body");
      Constants.printMsg("body of GetUsersInfo headers:$headers");
    }
  }

  //var mobileNo="";
  passwordupdate(mobile, password) async {
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode(
        {"MobileNo": "$mobile", "UserTypeRefID": "5", "Password": "$password"});
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.auth +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/QI/PasswordUpdate"
        : "https://uat.quizmaster.world:5001/api/s1/QI/PasswordUpdate";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );

    var data = json.decode(response.body);
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
    mobileNo = data['data']['mobileNo'];
    userRefID = data['data']['userRefID'];
    //Constants.userRefID=data['data']['userRefID'];
    //final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('qsid',qsid.toString());
  }

  fileUpload(ImageTypeRefID, fileType, base64string) async {
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "UserRefID": "$userRefID",
      "UserTypeRefID": "5",
      "ImageTypeRefID": "$ImageTypeRefID",
      "FileType": "$fileType",
      "ImageString": "$base64string"
    });
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.upload +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/Docs/Upload"
        : "https://uat.quizmaster.world:5001/api/s1/Docs/Upload";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("Upload Body:" + body);
    var data = json.decode(response.body);
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
    photo = data['data']['imageURL'];

    Constants.printMsg("Upload responseCode:" + responseCode);
    Constants.printMsg("UploadresponseDescription:" + responseDescription);
  }

  login(mobile, password, logintype) async {
    print('login calling...');
    final prefs = await SharedPreferences.getInstance();
    final version = await prefs.getString('version');
    var deviceId = await prefs.getString('deviceId');
    final platform = Constants.platform;
    final ipv4 = Constants.ipv4;
    final lat = Constants.lat;
    final lon = Constants.lon;
    final fcmtoken = Constants.fcmtoken;

    // if (Platform.isIOS) {
    //   deviceId=uuid.v1();
    // }
    deviceId = (deviceId != null) ? deviceId : '';

    if (deviceId == '') {
      deviceid = "";
    }
    password = (password != null) ? password : '';
    //deviceId="11111kannanios";
    Map<String, String> headers = {
      'VersionId': (Platform.isIOS) ? Constants.iosappversion : '$version',
      'ServiceID': '1',
      'DeviceID': '$deviceId',
      'Platform': '$platform',
      'ip': '$ipv4',
      'fcmtoken': '$fcmtoken',
      'UserTypeID': '5',
      'Location': '$lat,$lon',
      'ssid': '',
      'Content-Type': 'application/json',
      'UserRefID': '',
      'LanguageID': 'en'
    };
    final body = jsonEncode({
      "UserMobileNo": "$mobile",
      "password": "$password",
      "UserType": "5",
      "PasswordType": "1",
      "LoginType": "$logintype"
    });
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.auth +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/QI/AuthUser"
        : "https://uat.quizmaster.world:5001/api/s1/QI/AuthUser"; // QC OK
    Constants.printMsg("Login AuthUser:" + myUrl);
    Constants.printMsg("Login AuthUser Body:$body");
    Constants.printMsg("Login AuthUser Header:$headers");
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("statusCode");
    Constants.printMsg(response.statusCode);
    Constants.printMsg("statusMessage");
    Constants.printMsg(getStatusMessage(response.statusCode));
    // if (response.statusCode == StatusCode.OK) {
    //   final statusMessage = getStatusMessage(res.statusCode);
    //
    //   return {
    //     'statusCode': response.statusCode,
    //     'statusMessage': statusMessage,
    //     'data': response.body
    //   };
    // }

    var data = json.decode(response.body);
    Constants.printMsg("data:$data");
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
    qsid = data['data']['qsid'].toString();
    passUpdated = data['data']['passUpdated'];
    loginType = data['data']['loginType'].toString();
    firstLoginUpdated = data['data']['firstLoginUpdated'];
    deviceid = deviceId;
    await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
    //await prefs.setString('qsid',qsid);
    if (data['data']['userRefID'] != Null ||
        data['data']['userRefID'] != 'Null' ||
        data['data']['userRefID'] != '') {
      await prefs.setString('userRefID', data['data']['userRefID']);
    }
    Constants.printMsg("Response of AuthUser:$data");
    Constants.printMsg("body of AuthUser:$body");
    Constants.printMsg("body of headers:$headers");
  }

  sendOTPLogin(mobile, otptype) async {
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "OTPType": "$otptype",
      "mobileNo": "$mobile",
      "UserTypeRefID": "5",
    });
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.master +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/Master/SendOTP"
        : "https://uat.quizmaster.world:5001/api/s1/Master/SendOTP";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("myUrl of SendOTP:$myUrl");
    Constants.printMsg("Body of SendOTP:$body");
    var data = json.decode(response.body);
    Constants.printMsg("Response of SendOTP:$data");
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
    otp = data['data']['otp'];
    mobileNo = data['data']['mobileNo'];
    userTypeRefID = data['data']['userTypeRefID'];
  }

  Future<String> getStateData() async {
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({});
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.master +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/Master/State"
        : "https://uat.quizmaster.world:5001/api/s1/master/State";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var result = json.decode(response.body);
    statedata = result['data'];
    Constants.printMsg("State Data:");
    print(statedata);
    return "Success!";
  }

  profileupdatecreate(surName, displayName, Name, dob, GenderType, mailID,
      ReferBy, stateRefID, pan, aadhar, profilephoto) async {
    //var userRefID=Constants.userRefID;
    var prefix = (Constants.prefix != '') ? Constants.prefix : "UI";
    if (profilephoto == "-1") {
      profilephoto = "100";
    }
    final prefs = await SharedPreferences.getInstance();
    userRefID = (prefs.getString('userRefID') ?? "");
    Constants.printMsg("profileupdatecreate - A :$userRefID");
    if (userRefID == "") {
      userRefID = Constants.userRefID;
    }
    Constants.printMsg("profileupdatecreate -B :$userRefID");
    if (stateRefID == null) {
      stateRefID = "29";
    }
    if (GenderType == 'Male') {
      GenderType = "1";
    }
    if (GenderType == 'Female') {
      GenderType = "2";
    }
    if (GenderType == 'Other') {
      GenderType = "3";
    }
    if (surName == "Mr") {
      surName = "1";
    }
    if (surName == "Miss") {
      surName = "2";
    }
    if (surName == "Mrs") {
      surName = "3";
    }
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    if (dob.toString().length > 9) {
      dob = dob.toString().substring(0, 10);
    } else {
      dob = dob.toString();
    }
    final body = jsonEncode({
      "userRefID": "$userRefID",
      "surName": "$surName",
      "displayName": "$displayName",
      "Name": "$Name",
      "dob": "$dob",
      "stateRefID": "$stateRefID",
      "GenderType": "$GenderType",
      "mailID": "$mailID",
      "pan": "$pan",
      "aadhar": "$aadhar",
      "profilePhoto": '$profilephoto'
    });
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.master +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/$prefix/UpdateUserInfo"
        : "https://uat.quizmaster.world:5001/api/s1/$prefix/UpdateUserInfo";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    Constants.printMsg("Response of UpdateUserInfo:$data");
    Constants.printMsg("Body of UpdateUserInfo:$body");
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
  }

  verifyOTPLogin(mobile, otp) async {
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "OTP": "$otp",
      "MobileNo": "$mobile",
      "UserTypeRefID": "5",
    });
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.master +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/Master/OTPValidate"
        : "https://uat.quizmaster.world:5001/api/s1/Master/OTPValidate";
    Constants.printMsg("/api/s1/Master/OTPValidate:$body");
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      responseCode = data['status']['responseCode'];
      responseDescription = data['status']['responseDescription'];
    } else {
      responseCode = "1";
      responseDescription = "Verification OTP entered is Wrong";
    }
  }

  forgotPin(mobile, password) async {
    var prefix = (Constants.prefix != '') ? Constants.prefix : "UI";
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode(
        {"userTypeRefID": "5", "password": "$password", "mobileNo": "$mobile"});
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.auth +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/$prefix/PasswordUpdate"
        : "https://uat.quizmaster.world:5001/api/s1/$prefix/PasswordUpdate";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
  }

  getScheduleOverallHistory() async {
    var currentFormatDate = new DateFormat('yyyy-MM-dd');
    var now = new DateTime.now();
    String currentDate = currentFormatDate.format(now);
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body =
        jsonEncode({"UserRefID": "$userRefID", "Date": "$currentDate"});
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.report +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/win/OverAllWinningQuizCount"
        : "https://uat.quizmaster.world:5001/api/s1/win/OverAllWinningQuizCount";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
    overAllWinningAmount = data['data']['overAllWinningAmount'];
    overAllQuizCount = data['data']['overAllQuizCount'];
  }

  var blockname = "";
  var blockdisplayName = "";
  var blockcomments = "";

  blockdetailinfo(MobileNo) async {
    var prefix = (Constants.prefix != '') ? Constants.prefix : "UI";
    //userRefID="19710";//TEST:5514 GOH//19710
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({"MobileNo": "$MobileNo", "UserTypeRefID": "5"});

    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.master +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/$prefix/BlockStatus"
        : "https://uat.quizmaster.world:5001/api/s1/$prefix/BlockStatus";
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    Constants.printMsg("BlockStatus myUrl:$myUrl");
    Constants.printMsg("BlockStatus Body:$body");
    var result = json.decode(response.body);
    Constants.printMsg("BlockStatus Info Body: $body");
    Constants.printMsg("BlockStatus Info Result : $result");
    blockname = result['data']['name'];
    blockdisplayName = result['data']['displayName'];
    blockcomments = result['data']['comments'];
    Constants.printMsg("blockname:$blockname");
    Constants.printMsg("blockdisplayName:$blockdisplayName");
    Constants.printMsg("blockcomments:$blockcomments");
  }

  userRedeem(referalCode) async {
    final prefs = await SharedPreferences.getInstance();
    var userRefID = (prefs.getString('userRefID') ?? "");
    var surName = Constants.surName;
    var displayName = Constants.displayName;
    var Name = Constants.name;
    var GenderType = Constants.genderName;
    var dob = Constants.dob;
    var mailID = Constants.mailID;

    if (GenderType == 'Male') {
      GenderType = "1";
    }
    if (GenderType == 'Female') {
      GenderType = "2";
    }
    if (GenderType == 'Other') {
      GenderType = "3";
    }
    if (surName == "Mr") {
      surName = "1";
    }
    if (surName == "Miss") {
      surName = "2";
    }
    if (surName == "Mrs") {
      surName = "3";
    }
    /*Map<String,String> headers = {
      'Content-Type': 'application/json'
    };*/
    final body = jsonEncode({
      "userRefID": "$userRefID",
      "surName": "$surName",
      "displayName": "$displayName",
      "Name": "$Name",
      "dob": "$dob",
      "GenderType": "$GenderType",
      "mailID": "$mailID",
      "ReferBy": "1",
      "referalCode": "$referalCode"
    });
    String myUrl = (Constants.staging_production > 0)
        ? Constants.https +
            Constants.master +
            "." +
            Constants.API_BASE_URL +
            "/api/s1/QI/UpdateUserInfo"
        : "https://uat.quizmaster.world:5001/api/s1/QI/UpdateUserInfo";
    Constants.printMsg("myUrl:$myUrl");
    var response = await http.post(
      Uri.parse(myUrl),
      headers: headers,
      body: body,
    );
    var data = json.decode(response.body);
    Constants.printMsg("Response of UpdateUser Referral Info:$data");
    Constants.printMsg("Body of UpdateUser Referral Info:$body");
    responseCode = data['status']['responseCode'];
    responseDescription = data['status']['responseDescription'];
  }
}
