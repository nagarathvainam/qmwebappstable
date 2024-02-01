import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/pages/ui/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import '../../constant/duration.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'dart:io' show Platform, exit;
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'dart:convert' show json;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:quizmaster/class/LoadingDialog.dart';
import '../webview/privacy-policy.dart';
import '../webview/rateus.dart';
import '../webview/terms.dart';
import 'blockdetails.dart';
import 'otp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_information/device_information.dart';
import 'dart:io' show Platform;
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
final Uri _url_termsandconditions = Uri.parse('https://quizmaster.world/terms-and-conditions.html');
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',

  clientId: "107216590461501707207",
  // If you need to authenticate to a backend server, specify its OAuth client. This is optional.
  //serverClientId: ...,

  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginUiPage extends StatefulWidget {
  //final plugin = FacebookLogin(debug: true);
  //LoginUiPage({Key? key}) : super(key: key);

  String title;
  String url;

  LoginUiPage({required this.title,required this.url});

  @override
  _LoginUiPageState createState() => _LoginUiPageState();
}

String DeviceID="";


Future<void> _launchUrl() async {
  if (!await launchUrl(_url_termsandconditions)) {
    throw Exception('Could not launch $_url_termsandconditions');
  }
}
showCloseAppConfirm(BuildContext context)
{
  double baseWidth = 414;
  double fem = MediaQuery.of(context).size.width / baseWidth;
  double ffem = fem * 0.85;//0.97;
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
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
              children:  const <Widget>[

                Text('Close',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              children:  <Widget>[
                Expanded(child: Text('Are you sure you wish to close your app?',style: TextStyle(fontSize: 14*fem,fontWeight: FontWeight.w600),)),

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
                    prefs.setString('scheduleRefID', "");
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  child: const Text(
                    'Confirm Close',
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
                        side: const BorderSide(
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
class _LoginUiPageState extends State<LoginUiPage> {


  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
  User databaseUser = new User();
  String loginstate = "0";
  late StreamSubscription<ConnectivityResult> subscription;

  String? _sdkVersion;
  //FacebookAccessToken? _token;
  //FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;

  GoogleSignInAccount? _currentUser;
  String _contactText = '';
  void  saveAuthInfo(DeviceID,fcmtoken,platform,appName,apiLevel,version,packageName,packageInfo,buildNumber,lat,lon,ipv4) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!Platform.isIOS) {
        var uuid = Uuid();
        DeviceID=uuid.v1();
        if(prefs.getString('deviceId')!=null || prefs.getString('deviceId')!='') {
          prefs.setString('deviceId', DeviceID);
        }
      }
      prefs.setString('version',version);
      Constants.platform=platform;
      Constants.ipv4=ipv4;
      Constants.lat=lat;
      Constants.lon=lon;
      Constants.fcmtoken=fcmtoken;
    });
  }


  Future<void> initPlatformState() async {

    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.
    try {
      platformVersion = await DeviceInformation.platformVersion;


print("Platform.isIOS");
print(Platform.isIOS);
      final prefs = await SharedPreferences.getInstance();
      if (Platform.isIOS) {
        var uuid = Uuid();
        DeviceID=uuid.v1();

        if(prefs.getString('deviceId')!=null || prefs.getString('deviceId')!=''){
          print("get device id for ios:$DeviceID");
          prefs.setString('deviceId',DeviceID);
        }
      }else{
        DeviceID = await DeviceInformation.deviceIMEINumber;
        print("Android Device Id:$DeviceID");
        prefs.setString('deviceId',DeviceID);
      }
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      apiLevel = await DeviceInformation.apiLevel;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
      cpuType = await DeviceInformation.cpuName;
      hardware = await DeviceInformation.hardware;


      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Constants.printMsg("packageInfo.appName:");
      Constants.printMsg(packageInfo.appName);
      Constants.appName = packageInfo.appName;
      Constants.packageName = packageInfo.packageName;
      String version = packageInfo.version;
      Constants.printMsg("version:");
      prefs.setString('version',packageInfo.version);
      Constants.printMsg(version);
      Constants.buildNumber = packageInfo.buildNumber;
     // PackageInfo packageInfo = await PackageInfo.fromPlatform();
      //String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      String platform="";

      final ipv4 = await Ipify.ipv4();

      if (kIsWeb) {

      } else {
        if (Platform.isAndroid) {

          platform='Android';
        } else if (Platform.isIOS) {

          platform='IOS';
        } else if (Platform.isLinux) {

          platform='Linux';
        } else if (Platform.isMacOS) {

          platform='MacOs';
        } else if (Platform.isWindows) {
          platform='Web';

        }
      }
      var lat ="";
      var lon="";
      if (!Platform.isIOS) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        lat = position.latitude.toString();
        lon = position.longitude.toString();
      }
      if(DeviceID==""){
        showSnackBar("Your mobile device and other configuration doesn't captured properly.try again with check all permission including notification required & re-install it.");
      }else{

        var fcmtoken ;
        // if (!Platform.isIOS && Durations.firebaseFunctional>0) {
        //   fcmtoken = await FirebaseMessaging.instance.getToken();
        // }else{
          fcmtoken ="";
        //}

        saveAuthInfo(DeviceID,fcmtoken,platform,Constants.appName,apiLevel,version,Constants.packageName,packageInfo,Constants.buildNumber,lat,lon,ipv4);
      }

    } on PlatformException catch (e) {
      platformVersion = 'Device info Error:${e.message}';
    }
  }
  @override
  void initState() {
      super.initState();
      //_getSdkVersion();

    initPlatformState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });

      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        setState(() {
          _currentUser = account;
        });
        if (_currentUser != null) {
          _handleGetContact(_currentUser!);
        }
      });
      _googleSignIn.signInSilently();

  }


  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
            (dynamic name) =>
        (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(" Google Signin error $error");
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_contactText),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: () => _handleGetContact(user),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  showSnackBar(message) {
    final snackBar = SnackBar(
      backgroundColor: _colorFromHex(Constants.baseThemeColor),
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  String otpdisplay="";
  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    //final isLogin = _token != null && _profile != null;
    return WillPopScope(
        onWillPop: () async {
      showCloseAppConfirm(context);
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
      return false; // return false if you want to disable device back button click
    },
    child:Scaffold(

    bottomNavigationBar:  Container(
    padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
          ),
        ],
      ),
      child:Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            (widget.title!='')?
            GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RateUs(title:Platform.isIOS?'Update Latest App from App Store':'Update Latest App from Play Store',url: Platform.isIOS?'https://appstoreconnect.apple.com/apps/6458100455/appstore/activity/ios/ratingsResponses?m=':'https://play.google.com/store/apps/details?id=com.quizMaster.quiz_master',)),
                          (e) => false);
                },
                child:Container(decoration: BoxDecoration (
        color: Colors.red,
        borderRadius: BorderRadius.all (
          Radius.circular(5*fem)
        ),
      ),
        padding:EdgeInsets.only(left:20,right: 20,top: 10,bottom: 10),child:Text(widget.title,style: TextStyle(color: Colors.white,fontSize: 14.0,),),)):SizedBox(),
            (widget.title!='')?SizedBox(height: ffem*35):SizedBox(),
            SizedBox(width: ffem*75),

            Text('By Continuing, you are accepting our \n', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal),
            ),

             Center(child:Row(
               mainAxisAlignment: MainAxisAlignment.center,
                  children:  <Widget>[
        GestureDetector(
        onTap: () {
          //_launchUrl();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => Terms()),
                  (e) => false);
    },
      child:Text('Terms of Services', style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                       decoration: TextDecoration.underline),
                    )),
                    SizedBox(width: ffem*5),
                    Text('&', style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline),
                    ),
                    SizedBox(width: ffem*5),




                 GestureDetector(
                 onTap: () {
    setState(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => PrivacyPolicy(mobile: '')),
              (e) => false);
    });
    },
      child:Text('Privacy Policy', style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline),
                    )),

                  ],
                )), /*Text.rich(TextSpan(
                    text: 'By Continuing, you are accepting our \n',
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Terms of Services',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.underline),
                      ),
                      TextSpan(
                        text: ' & ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ]))*/


            SizedBox(width: ffem*20,),
            (Platform.isIOS)?SizedBox(height: ffem*20,):SizedBox(),
          ]
      ),

    ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
          color: _colorFromHex(Constants.baseThemeColor),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              // Main Contetn Start Here
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  height: 47,
                  width: 246,
                  child: Image.asset("assets/loginqtitle.png")),

              SizedBox(
                  height: 47,
                  width: 246,
                  child: Image.asset("assets/loginsubtitle.png")),

              /*const Align(
                alignment: Alignment.center,
                child: Text(
                  "Quiz Game",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),*/
              Image.asset(
                "assets/photo.png",
                width: 339.0,
                height: 315,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                    )),

                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          initialValue: const {},
                          skipDisabled: true,
                          child: Column(
                            children: <Widget>[
                              (loginstate == "0")
                                  ? const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Your Mobile Number",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal),
                                      ))
                                  : const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Your Password",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal),
                                      )),
                              const SizedBox(height: 10),
                              (loginstate == "0")
                                  ? FormBuilderTextField(
                                      //autovalidateMode: AutovalidateMode.always,
                                      name: 'mobile',
                                      // controller: mobile,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFFC8C8C8)),
                                        ),
                                        labelText: '',
                                        hintText: "Your Mobile Number",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        prefixText: "+91",
                                      ),

                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.numeric(),
                                      ]),
                                      // initialValue: '12',
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly,
                                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                      ],
                                      maxLength: 10,
                                 //     keyboardType: TextInputType.number,
                                //keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                                //keyboardType: TextInputType.numberWithOptions(signed: true),

                               // textInputAction: TextInputAction.next,

                                keyboardType: Platform.isIOS?
                                TextInputType.numberWithOptions(signed: true, decimal: true)
                                    : TextInputType.number,
// This regex for only amount (price). you can create your own regex based on your requirement
                                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))],

                                    )
                                  : SizedBox(),
                              (loginstate == "1")
                                  ? FormBuilderTextField(
                                      name: 'password',
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFFC8C8C8)),
                                        ),
                                        labelText: '',
                                        hintText: "Your Password",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      obscureText: true,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                      ]),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                  child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: _colorFromHex(Constants.buttonColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                onPressed: () async {

                                  final prefs = await SharedPreferences
                                      .getInstance();
                                  await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QuestionDynamicUiPage()),
                                          (e) => false);
                                  /*
                                  if (Platform.isIOS) {
                                    var uuid = Uuid();
                                    DeviceID=uuid.v1();
                                  }
                                  if(DeviceID!='') {
                                    if (_formKey.currentState
                                        ?.saveAndValidate() ??
                                        false) {
                                      print(_formKey
                                          .currentState?.value['mobile'].toString().length);
                                      int? moblen=_formKey
                                          .currentState?.value['mobile'].toString().length;
                                      if(moblen!=null && moblen>9) {

                                        databaseUser
                                            .login(
                                            _formKey
                                                .currentState?.value['mobile'],
                                            _formKey.currentState
                                                ?.value['password'],
                                            loginstate)
                                            .whenComplete(() {
                                          setState(() {
                                            print(
                                                "databaseHelper.firstLoginUpdated");
                                            print(
                                                databaseUser.firstLoginUpdated);
                                            if (databaseUser.passUpdated ==
                                                false) {
                                              if (databaseUser.responseCode !=
                                                  "0") {

                                                          if (databaseUser.responseCode ==
                                                          "144") {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        BlockDetailsPage( mobile:  _formKey
                                                                            .currentState?.value['mobile'],)),
                                                                    (e) => false);
                                                          }
                                                if (databaseUser.responseCode ==
                                                    "502") {
                                                  databaseUser
                                                      .sendOTPLogin(
                                                      _formKey
                                                          .currentState
                                                          ?.value['mobile'],
                                                      '5')
                                                      .whenComplete(() {
                                                    if (databaseUser
                                                        .responseCode ==
                                                        "0") {
                                                      print(
                                                          "databaseHelper.mobileNo");
                                                      print(
                                                          databaseUser
                                                              .mobileNo);
                                                      otpdisplay=databaseUser.otp;
                                                      print(otpdisplay);
                                                      print(databaseUser.otp);
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  OtpUiPage(
                                                                      mobile: databaseUser
                                                                          .mobileNo,
                                                                      otp: databaseUser
                                                                          .otp,
                                                                      isnewdevice: 1
                                                                  )),
                                                              (e) => false);
                                                    }
                                                  });
                                                }
                                                print(databaseUser
                                                    .responseDescription);
                                                if (databaseUser.responseCode !="144") {
                                                  showSnackBar(databaseUser
                                                      .responseDescription);
                                                }
                                              } else {
                                                databaseUser
                                                    .sendOTPLogin(
                                                    _formKey
                                                        .currentState
                                                        ?.value['mobile'], '1')
                                                    .whenComplete(() {
                                                  if (databaseUser
                                                      .responseCode ==
                                                      "0") {
                                                    print(
                                                        "databaseHelper.mobileNo");
                                                    print(
                                                        databaseUser.mobileNo);
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                OtpUiPage(
                                                                    mobile: databaseUser
                                                                        .mobileNo,
                                                                    otp: databaseUser
                                                                        .otp,
                                                                    isnewdevice: 0
                                                                )),
                                                            (e) => false);
                                                  }
                                                });
                                              }
                                            } else {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PinUiPage(
                                                              mobile: _formKey
                                                                  .currentState
                                                                  ?.value['mobile'],
                                                              qsid: databaseUser
                                                                  .qsid
                                                          )),
                                                      (e) => false);
                                            }
                                          });
                                        });
                                        debugPrint(_formKey.currentState?.value
                                            .toString());
                                      }else{
                                        showSnackBar("Your mobile number should be 10 digit");
                                      }
                                    } else {
                                      debugPrint(_formKey.currentState?.value
                                          .toString());
                                      debugPrint('validation failed');
                                    }
                                  }else{
                                    showSnackBar("Your mobile device and other configuration doesn't captured properly.try again with check all permission including notification required & re-install it.");
                                  }*/
                                },
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              )),
                            ),
                          ],
                        )),
                    /*Padding(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Image.asset(
                                "assets/horizontal-line.png",
                              ),
                            ),
                            Expanded(
                              child: Text('Or continue with',
                                  textAlign: TextAlign.center),
                            ),
                            Expanded(
                              child: Image.asset(
                                "assets/horizontal-line.png",
                              ),
                            ),
                          ],
                        )),*/
                    SizedBox(
                      height: 30.0,
                    ),
                   /*Padding(
                        padding:
                            EdgeInsets.only(left: 50.0, right: 50.0, top: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[



                            Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                    width: 250,
                                    child: Row(
                                      children: <Widget>[

                                        // _buildBody(),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _handleSignIn();
                                                });
                                              },
                                          child:Image.asset("assets/google.png"),
                                        )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          /*child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _onPressedLogInButton();
                                              });
                                            },*/
                                            child:Image.asset(
                                              "assets/facebook.png")),

                                        SizedBox(
                                          width: 60,
                                        ),

                                      ],
                                    )))
                          ],
                        )),*/

                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Version - "+Constants.releaesversion,style: TextStyle(color: Colors.grey),),

                    SizedBox(
                      height: 10.0,
                    ),



                  ],
                ),
              ),
              // Main Contetn Start Here
            ],
          ),
        )
    ));
  }
}


