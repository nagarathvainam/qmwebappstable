import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:quizmaster/pages/ui/kyc-verification.dart';
import 'package:quizmaster/pages/ui/helpdesk.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:quizmaster/pages/ui/referralcodeui.dart';
import 'package:quizmaster/pages/ui/linkbankui.dart';
//import 'package:quizmaster/pages/ui/transactions.dart';
import 'package:quizmaster/pages/ui/settings.dart';
import 'package:quizmaster/pages/webview/gamepolicy.dart';
import 'package:quizmaster/pages/webview/rateus.dart';
import 'package:quizmaster/pages/webview/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:quizmaster/pages/ui/edit-profile-tab.dart';
import 'package:quizmaster/constant/constants.dart';
import 'dart:io' show Platform, exit;
//import '../../../../pages/ui/transaction-history.dart';
import '../../../../pages/ui/transaction-one-add-money.dart';
import '../../../../pages/ui/transaction-history.dart';
import '../../../../pages/webview/privacy-policy.dart';
class CustomListTile extends StatelessWidget {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final bool isCollapsed;
  final String icon;
  final String title;
  final IconData? doHaveMoreOptions;
  final int infoCount;
  final String iscomment;
  final int isarrow;
  const CustomListTile({
    Key? key,
    required this.isCollapsed,
    required this.icon,
    required this.title,
    this.doHaveMoreOptions,
    required this.infoCount,
    required this.iscomment,
    required this.isarrow,
  }) : super(key: key);
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ok"),
      onPressed:  () async{
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
        //await prefs.setString('qsid',"");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginUiPage(title: '',url: '',)),
                (e) => false);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure want to logged out user.dart"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLogoutBottomSheet(BuildContext context)
  {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(Size(
          MediaQuery.of(context).size.width,
          fem * 280)),
      context: context,
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration (
              color: Color(0xfffcfcfc),
              borderRadius: BorderRadius.only (
                topLeft: Radius.circular(24*fem),
                topRight: Radius.circular(24*fem),
              ),
            ),
            padding:EdgeInsets.all(8),child:Column(
            children: <Widget>[
              Row(
          children:  <Widget>[
            Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFf1d6e6),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    )),
                child:Padding(padding:EdgeInsets.all(8),child:SvgPicture.asset('assets/drawer/logout.svg',
                  colorFilter: ColorFilter.mode(_colorFromHex(Constants.baseThemeColor), BlendMode.srcIn),width: 40.0,height: 40.0,))),
            SizedBox(width: 20,),
            Text('Logout',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

          ],
        ),
              SizedBox(height: 20,),
               Row(
                children:  <Widget>[
        Expanded(child: Text('Are you sure you wish to logout of your account?',style: TextStyle(fontSize: 14*fem,fontWeight: FontWeight.w600),)),

                ],
              ),

              SizedBox(height: 20,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: _colorFromHex(Constants.buttonColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // <-- Radius
                    ) // foreground
                ),
                onPressed: () async{
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
                  await prefs.setString('userRefID', "");
                  Constants.displayName="";
                  Constants.surName="";
                 // Constants.userRefID="";
                  Constants.mobileNumber="";
                  Constants.photo="";
                  Constants.mailID="";
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginUiPage(title: '',url: '',)),
                          (e) => false);
                },
                child: const Text(
                  'Confirm Logout',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight:FontWeight.w700,
                      fontSize: 14.0),
                ),
              )),
        SizedBox(height: 10,),
        SizedBox(
        width: MediaQuery.of(context).size.width,
        child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.circular(
                          12), // <-- Radius
                    ) // foreground
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight:FontWeight.w700,
                      fontSize: 14.0),
                ),
              )),

            ]));
      },
    );
  }

  showKYCBottomSheet(BuildContext context)
  {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {

        return Scaffold(
          backgroundColor: Colors.white,
          // drawer: const CustomDrawer(),

          appBar: AppBar(
            elevation: 0,
            leadingWidth: 400,

            leading: Expanded(child:  Text('KYC Verification Failed',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 20,),maxLines: 1,softWrap: false,)),

            backgroundColor: Colors.white,
            actions: <Widget>[

              IconButton(
                icon: const Icon(Icons.close,color: Colors.black,),

                onPressed: () {
                  Navigator.pop(context);

                },
              ),

            ],
          ),
          body: Container(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
                  // Main Contetn Start Here
                  Padding(padding: EdgeInsets.all(10),child:Text('Following KYC details were not verified in your\nrequest ',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14),)),
                  SizedBox(height: 10.0,),
                  Padding(padding: EdgeInsets.all(10),child: Text('\u2022 Name registered on App is not matching your KYC\n\tdocuments',style: TextStyle(color:  Color(0xFFFF0000),fontWeight:FontWeight.w600, fontSize: 14),)),
                  Padding(padding: EdgeInsets.all(10),child:Text('please rise another request',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600, fontSize: 14),)),

                ],
              )),





          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: _colorFromHex(Constants.buttonColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // <-- Radius
                      ) // foreground
                  ),
                  onPressed: () {

                  },
                  child: const Text(
                    'Raise Another KYC Request',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0),
                  ),
                ),


              ],
            ),
          ),
        );
      },
    );
  }
  @override
  showKycAlertAlert(context){
          showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
          title: const Text('KYC Verification Info.'),
          content: const Text('Already verified you KYC details'),
          actions: <Widget>[
          TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Ok'),
          ),
          ],
          ));
  }
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () async {
        if(title=='Logout') {

          showLogoutBottomSheet(context);
        }
        if(title=='My Profile') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfileTab(initalindex:0)),
                  (e) => false);
        }
        if(title=='Referral Code') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => ReferralCodeUiPage()),
                  (e) => false);
        }
        if(title=='Game Policy') {

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => GamePolicy()),
                  (e) => false);
        }

        if(title=='Privacy Policy') {

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(mobile: '')),
                  (e) => false);
        }

        if(title=='Terms Of Use') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => Terms()),
                  (e) => false);
        }

        if(title=='Help Desk') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HelpDesk()),
                  (e) => false);
        }

        if(title=='Linked Bank') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LinkBankUI()),
                  (e) => false);
        }

        if(title=='Transaction') {
         /* Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionsUiPage()),
                  (e) => false);*/

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionHistory(page:'All')),
                  (e) => false);

        }
        if(title=='My QM Wallet') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionOneAddMoney()),
                  (e) => false);
        }

        if(title=='Rate Us'){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => RateUs(title:Platform.isIOS?'Update Latest App from App Store':'Update Latest App from Play Store',url: Platform.isIOS?'https://appstoreconnect.apple.com/apps/6458100455/appstore/activity/ios/ratingsResponses?m=':'https://play.google.com/store/apps/details?id=com.quizMaster.quiz_master',)),
                  (e) => false);
        }
        if(title=='KYC'){
          /*if(Constants.kycStatus=="2"){
            showKycAlertAlert(context);
          }else{*/
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => KYCVerification()),
                    (e) => false);
          //}
        }

        if(title=='My QM Wallet') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionOneAddMoney()),
                  (e) => false);
        }

        if(title=='Settings') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsUi()),
                  (e) => false);
        }

      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: isCollapsed ? 300 : 80,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                   /* Icon(
                      icon,
                      color: Colors.black,
                    ),*/
                   // Image.asset("assets/drawer/$icon.png",width: 40.0,height: 40.0,),
                    Container(
                        //color:Color(0xFFf1d6e6),
                      
                        decoration: const BoxDecoration(
                            color: Color(0xFFf1d6e6),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            )),
                        child:Padding(padding:EdgeInsets.all(8),child:SvgPicture.asset('assets/drawer/$icon.svg',
                      colorFilter: ColorFilter.mode(_colorFromHex(Constants.baseThemeColor), BlendMode.srcIn),width: 40.0,height: 40.0,))),
                    if (infoCount > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isCollapsed) const SizedBox(width: 10),
            if (isCollapsed)
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                   Expanded(
                      flex: 4,
                      child:  (iscomment!='')?Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child:Text(title, style: const TextStyle(
                      color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,fontFamily: "Opensans",
                      ),)),
                          (title=="Linked Bank")?Text(iscomment,style:  TextStyle(
                            color: (Constants.bankCount>0)?Color(0xff90BC00):Color(0xffFF3D00),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,fontFamily: "Opensans",
                             overflow: TextOverflow.ellipsis,
                          )):SizedBox(),

                          (title=="KYC")?Text(iscomment,style:  TextStyle(
                            color: (Constants.kycStatus=="2")?Color(0xff90BC00):Color(0xffFF3D00),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,fontFamily: "Opensans",
                            overflow: TextOverflow.ellipsis,
                          )):SizedBox(),

                        ],
                      ):Text(
                        title,
                        style:  TextStyle(
                          color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,fontFamily: "Opensans",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                   // if (title.toString()="Notifications")Text("4"):SizedBox(),

                    if(title.toString()=="Notifications") badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.circle,
                              badgeColor: _colorFromHex(Constants.buttonColor)),
                          badgeContent: Text(
                            '4',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,fontFamily: "Opensans"),
                          ),
                        ),
                    if (infoCount > 0)
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.purple[200],
                          ),
                          child: Center(
                            child: Text(
                              infoCount.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            if (isCollapsed) const Spacer(),
            if (isCollapsed)
              Expanded(
                flex: 1,
                child: doHaveMoreOptions != null
                    ? IconButton(
                        icon: Icon(
                          doHaveMoreOptions,
                          color: Colors.black,
                          size: 12,
                        ),
                        onPressed: () {
                          print('doHaveMoreOptions');
                        },
                      )
                    : const Center(),
              ),
            if (isCollapsed && isarrow==0)Image.asset('assets/drawer/arrow-right.png',),
            (isarrow>0 && Constants.kycStatus=="2"  && title=="KYC")?SvgPicture.asset('assets/drawer/completed.svg',):SizedBox(),
            (isarrow>0 && Constants.kycStatus!="2" && title=="KYC")?SvgPicture.asset('assets/drawer/processing.svg',):SizedBox(),

            (isarrow>0 && Constants.bankCount>0  && title=="Linked Bank")?SvgPicture.asset('assets/drawer/completed.svg',):SizedBox(),
            (isarrow>0 && Constants.bankCount==0 && title=="Linked Bank")?SvgPicture.asset('assets/drawer/processing.svg',):SizedBox(),

          ],
        ),
      ),
    );
  }
}
