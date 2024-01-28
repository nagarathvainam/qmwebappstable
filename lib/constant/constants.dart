import 'duration.dart';

const double kDefaultPadding = 20.0;
class Constants {
  static const String releaesversion="3.0.7.37";
  static const String iosappversion="3.0.7";
  static const int staging_production=0;// Live -1, Staging(Testing)-0
  static const String https="http://";
  static const String auth="auth";
  static const String balance="balance";
  static const String docs="docs";
  static const String master="master";
  static const String mtb="mtb";
  static const String pg="pg";
  static const String questions="questions";
  static const String report="report";
  static const String schedule="schedule";
  static const String trans="trans";
  static const String upload="upload";
  static const String API_BASE_URL =(Constants.staging_production>0)?"quizmaster.world":"http://uat.quizmaster.world/api";
  static const String API_SEPRATE_URL="/api/s1/QI/";
  static const String baseThemeColor="5A2DBC";//f00991,652696,B6E810,497ECE,E70D93
  static const String buttonColor="FFB400";
  static const int cashFreePayinSandLive=1;//Live -1, Staging(Testing)-0
  static  String scheduleRefID="";
  static String surName="";// Done
  static String stateRefID="";
  static String stateName="";
  static String appName=""; // Done
  static String packageName=""; // Done
  static String buildNumber=""; // Done
  static String fcmtoken="";// Done
  static String platform="";// Done
  static String ipv4="";// Done
  static String lat="";// Done
  static String lon="";// Done
  static String displayName="";// Done
  static String name="";
  static String dob="";
  static String mobileNumber="";// Done
  static String photo="";// Done
  static String mailID="";// Done
  static String genderName="";
  static String createdDate="";
  static String pan="";
  static String aadhar="";
  static String userRefID="";
  static String lngname="";
  static String openURL="http://docs.quizmaster.world/UploadFiles/Video/ep-2/OpeningM2.m4v";
  static int openDuration=19;
  static String closeURL="http://docs.quizmaster.world/UploadFiles/Video/ep-2/ClosingM2.m4v";
  static int closeDuration=14;
  static int SchemeLength=0;
  static String kycStatus="";
  static String kyCcomment="";
  static String KycapprovedCommentcomment="";
  static String qiCoinBalance="0.00";
  static String mainBalance="0.00";
  static String withdrawnBalance="0.00";
  static String depositBalance="0.00";
  static String winningBalance1="0.00";
  static String walletBalance="";
  static String coinValue="";
  //static int TotalPayment=0;
  //static int TOTALQUESTION=0;
  static int bankCount=0;
  static int kycAutoApprove=0;
  static String prefix=""; //
  static printMsg(message){
    if(Durations.isNeedPrintLog==0){
      print(message);
    }
  }
  static String cashfree_client_id="CF269323CHAUDP6H9MUU1FHVN4D0";
  static String cashfree_client_secret="0d5b8fd56fb26c276c017b060def5b62959d879b";
}