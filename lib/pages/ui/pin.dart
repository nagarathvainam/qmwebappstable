import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:quizmaster/pages/ui/editprofile.dart';
import 'package:quizmaster/pages/ui/forget-pin.dart';
import 'package:quizmaster/pages/ui/login.dart';
import 'package:quizmaster/pages/ui/redeemcode.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:quizmaster/class/LoadingDialog.dart';
//import 'package:quizmaster/model/databasehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/user/model/user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizmaster/constant/duration.dart';
class PinUiPage extends StatefulWidget {
  String mobile;
  String qsid;
  PinUiPage({required this.mobile,required this.qsid});

  @override
  _PinUiPageState createState() => _PinUiPageState();
}

bool resendtextdisplay=false;
bool button_enable=false;
class _PinUiPageState extends State<PinUiPage> {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser=new User();
  var genderOptions = ['Male', 'Female', 'Other'];
  bool isContinue=false;
  String otpdisplay="";
  late StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
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

  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  @override
  Widget build(BuildContext context) {
    otpBottomSheet(mobile,) {

      showModalBottomSheet<void>(

        context: context,
        builder: (BuildContext context) {
          double baseWidth = 414;
          double fem = MediaQuery.of(context).size.width / baseWidth;
          double ffem = fem * 0.97;
          return Container(

              height: fem*550,
              color: Color(0xff666666),
              child: Center(
                child:Container(
                  // frame7531yY7 (1029:875)

                  width: double.infinity,
                  decoration: BoxDecoration (
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only (
                      topLeft: Radius.circular(12*fem),
                      topRight: Radius.circular(12*fem),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children:  <Widget>[

                          Padding(padding: EdgeInsets.only(left: 10),child: Text('Enter the 6-digit OTP ',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w800, fontSize: 20),),),
                         // (Durations.otpdisplay==0)?Text(otpdisplay,style: TextStyle(color: Colors.red,fontSize: 18.0),):SizedBox(),
                          Expanded(
                            child:  Align(alignment:Alignment.topRight,

                              child: IconButton(
                                icon:  Icon(Icons.close, color: Colors.black, size: 30,),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginUiPage(title: '',url: '',)),
                                          (e) => false);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      //SizedBox(height: 10),

                      ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15.0),


                          children: <Widget>[




                            FormBuilder(
                              // key: _formKey,
                              // enabled: false,
                              onChanged: () {
                                // _formKey.currentState!.save();
                                //debugPrint(_formKey.currentState!.value.toString());
                              },
                              autovalidateMode: AutovalidateMode.disabled,
                              initialValue: const {

                              },
                              skipDisabled: true,
                              child: Column(
                                children: <Widget>[
                                  // SizedBox(height: 20,),

                                  Align( alignment:Alignment.topLeft,  child: Text("SMS sent to ",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 14),)),

                                  SizedBox(height: 5,),
                                  Align( alignment:Alignment.topLeft,  child: Text("+91 $mobile ",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 20),)),


                                  SizedBox(height: 20,),
                                  Align( alignment:Alignment.topLeft,  child: Text("Your Mobile Number ",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400, fontSize: 12),)),

                                  SizedBox(height: 10,),
                                  OtpTextField(
                                    numberOfFields:6 ,
                                    borderColor: Color(0xFF512DA8),
                                    //set to true to show as box or false to show as dash
                                    showFieldAsBox: true,
                                    //runs when a code is typed in
                                    onCodeChanged: (String code) {
                                      //handle validation or checks here
                                    },
                                    //runs when every textfield is filled
                                    onSubmit: (String verificationCode){


                                      databaseUser
                                          .verifyOTPLogin(
                                          mobile,verificationCode)
                                          .whenComplete(() {
                                        if (databaseUser.responseCode ==
                                            "0") {


                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgetPinUi(
                                                          mobile:mobile,

                                                      )),
                                                  (e) => false);

                                          // Navigator.pushAndRemoveUntil(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ForgetPinUi(mobile: mobile),
                                          //         (e) => false);


                                        }
                                      });

                                    }, // end onSubmit
                                  ),
                                  SizedBox(height: 25,),
                                  (resendtextdisplay==true)?GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Toggle light when tapped.


                                          databaseUser
                                              .sendOTPLogin(mobile,'2')
                                              .whenComplete(() {
                                            if(databaseUser.responseCode=="0"){
                                              otpdisplay=databaseUser.otp;
                                              print("databaseHelper.mobileNo");
                                              print("databaseUser.otp");
                                              print(otpdisplay);
                                              print(databaseUser.otp);
                                              //showBottomSheet(context: context, builder: builder)
                                              otpBottomSheet(mobile,);
                                            }

                                          });


                                        });
                                      },
                                      child:Text("Resend",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color(0xFF5A2DBC),
                                              fontWeight: FontWeight.bold))):SizedBox(),
                                //  Align( alignment:Alignment.center,  child: Text("The OTP Expires in  "+ timerText,style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 16),)),
                                  SizedBox(height: 25,),
                                  new SizedBox(
                                    width: MediaQuery.of(context).size.width-20,
                                    height: 50.0,

                                   
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
              ));
        },
      );

      SizedBox(height: 30);

    }
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginUiPage(title: '',url: '',)),
                  (e) => false);
      return false; // return false if you want to disable device back button click
    },

    child: Scaffold(
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
        body: SafeArea(
            child: SingleChildScrollView(

          //physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 47,
                  width: 246,
                  child: Image.asset(
                      "assets/loginqtitle.png")
                  ),

              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Quiz Game",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Image.asset(
                "assets/photo.png",
                width: 339.0,
                height: 315,
              ),
               Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                          onChanged: () {
                            _formKey.currentState!.save();
                            debugPrint(_formKey.currentState!.value.toString());
                          },
                          autovalidateMode: AutovalidateMode.disabled,
                          initialValue: const {
                            'movie_rating': 5,
                            'best_language': 'Dart',
                            'mobile': '9443976954',
                            'gender': 'Male',
                            'languages_filter': ['Dart']
                          },
                          skipDisabled: true,
                          child: Column(
                            children: <Widget>[
                              //Text("QSID"+widget.qsid),



                              const SizedBox(
                                height: 5,
                              ),
                              const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Enter Your 4 Digit Login Pin",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(height: 15),
                              OtpTextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                                numberOfFields: 4,
                                borderColor: _colorFromHex(Constants.buttonColor),
                                //set to true to show as box or false to show as dash
                                showFieldAsBox: true,
                                //runs when a code is typed in
                                onCodeChanged: (String code) {
                                },
                                //runs when every textfield is filled
                                onSubmit: (String verificationCode) {



                                  LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                                  databaseUser
                                      .login(widget.mobile,
                                      verificationCode,
                                      '1')
                                      .whenComplete(() {
                                    if (databaseUser.responseCode =="0" ) {

                                      // Device Id Checking
                                      if(databaseUser.deviceid==''){
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginUiPage(title: '',url: '',)),
                                                (e) => false);
                                      }
                                      // Device Id Checking

                                      databaseUser.login(widget.mobile,
                                          _formKey.currentState
                                              ?.value['pin'],
                                          '2')
                                          .whenComplete(() {
                                        print("databaseUser.firstLoginUpdated");
                                        print(databaseUser.firstLoginUpdated);
                                        if (databaseUser.firstLoginUpdated ==false) {
                                          databaseUser.userinfo(
                                              databaseUser.qsid)
                                              .whenComplete(() async {


                                            /* databaseHelper
                                            .internalApiGetProfile(databaseHelper.userRefID);*/


                                            final prefs = await SharedPreferences
                                                .getInstance();
                                            Constants.displayName=databaseUser.displayName;
                                            Constants.surName=databaseUser.surName;
                                            //Constants.userRefID=databaseUser.userRefID;
                                            Constants.mobileNumber=databaseUser.mobileNumber;
                                            Constants.photo=databaseUser.photo;
                                            Constants.mailID=databaseUser.mailID;
                                            Constants.stateRefID=databaseUser.stateRefID;
                                            Constants.dob=databaseUser.dob;
                                            Constants.photo=databaseUser.photo;
                                            Constants.name=databaseUser.name;
                                            await prefs.setString('qsid', "tlLlU+89NAO4y3u7wKhuPQ==");
                                            //await prefs.setString('qsid', databaseUser.qsid);
                                            await prefs.setString('userRefID', databaseUser.userRefID);

                                            //await prefs.setString('userid', token.toString());
                                          });
                                          Future.delayed(
                                              Duration(seconds: 5), () async {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfileUiPage()),
                                                    (e) => false);
                                          });


                                        }else {
                                          databaseUser.userinfo(
                                              databaseUser.qsid)
                                              .whenComplete(() async {


                                            /* databaseHelper
                                            .internalApiGetProfile(databaseHelper.userRefID);*/


                                            final prefs = await SharedPreferences
                                                .getInstance();
                                            await prefs.setString('qsid', databaseUser.qsid);
                                            Constants.displayName=databaseUser.displayName;
                                            Constants.surName=databaseUser.surName;
                                            //Constants.userRefID=databaseUser.userRefID;
                                            await prefs.setString('userRefID', databaseUser.userRefID);
                                            Constants.mobileNumber=databaseUser.mobileNumber;
                                            Constants.photo=databaseUser.photo;
                                            Constants.mailID=databaseUser.mailID;
                                            Constants.stateRefID=databaseUser.stateRefID;
                                            Constants.dob=databaseUser.dob;
                                            Constants.photo=databaseUser.photo;
                                            Constants.name=databaseUser.name;


                                            //await prefs.setString('userid', token.toString());
                                          });


                                          Future.delayed(
                                              Duration(seconds: 5), () async {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuestionDynamicUiPage()),
                                                    (e) => false);
                                          });
                                        }

                                      });


                                    }else{
                                      showSnackBar(databaseUser
                                          .responseDescription);

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PinUiPage(
                                                      mobile:widget.mobile,
                                                      qsid:''
                                                  )),
                                              (e) => false);

                                    }
                                  });


                                }, // end onSubmit
                              ),
                              const SizedBox(height: 15),

                              /*FormBuilderTextField(
                                //autovalidateMode: AutovalidateMode.always,
                                name: 'pin',
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          width: 3, color: Color(0xFFC8C8C8)),
                                    ),
                                    labelText: '',
                                  //  hintText: "XXXX",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always
                                    ),

                                onChanged: (val) {
                                  setState(() {
                                  });
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.min(5),
                                  // FormBuilderValidators.max(9),
                                ]),
                                // initialValue: '12',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(4),
                                ],

                              ),*/
                            ],
                          ),
                        )),
                    (isContinue)?Padding(
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
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ) // foreground
                                    ),
                                onPressed: () {
                                  LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                                  databaseUser
                                      .login(widget.mobile,
                                      _formKey.currentState
                                          ?.value['pin'],
                                      '1')
                                      .whenComplete(() {
                                      if (databaseUser.responseCode =="0" ) {

                                        // Device Id Checking
                                        if(databaseUser.deviceid==''){
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginUiPage(title: '',url: '',)),
                                                  (e) => false);
                                        }
                                        // Device Id Checking

                                        databaseUser.login(widget.mobile,
    _formKey.currentState
        ?.value['pin'],
    '2')
        .whenComplete(() {
          print("databaseUser.firstLoginUpdated");
print(databaseUser.firstLoginUpdated);
                                          if (databaseUser.firstLoginUpdated ==false) {
                                            databaseUser.userinfo(
                                                databaseUser.qsid)
                                                .whenComplete(() async {


                                              /* databaseHelper
                                            .internalApiGetProfile(databaseHelper.userRefID);*/


                                              final prefs = await SharedPreferences
                                                  .getInstance();
                                              Constants.displayName=databaseUser.displayName;
                                              Constants.surName=databaseUser.surName;
                                              //Constants.userRefID=databaseUser.userRefID;
                                              await prefs.setString('userRefID', databaseUser.userRefID);
                                              Constants.mobileNumber=databaseUser.mobileNumber;
                                              Constants.photo=databaseUser.photo;
                                              Constants.mailID=databaseUser.mailID;
                                              Constants.stateRefID=databaseUser.stateRefID;
                                              Constants.dob=databaseUser.dob;
                                              Constants.photo=databaseUser.photo;
                                              Constants.name=databaseUser.name;
                                              await prefs.setString('qsid', databaseUser.qsid);

                                              //await prefs.setString('userid', token.toString());
                                            });
                                            Future.delayed(
                                                Duration(seconds: 5), () async {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfileUiPage()),
                                                      (e) => false);
                                            });


                                          }else {
                                            databaseUser.userinfo(
                                                databaseUser.qsid)
                                                .whenComplete(() async {


                                              /* databaseHelper
                                            .internalApiGetProfile(databaseHelper.userRefID);*/


                                              final prefs = await SharedPreferences
                                                  .getInstance();
                                              await prefs.setString('qsid', databaseUser.qsid);
                                              Constants.displayName=databaseUser.displayName;
                                              Constants.surName=databaseUser.surName;
                                              //Constants.userRefID=databaseUser.userRefID;
                                              await prefs.setString('userRefID', databaseUser.userRefID);
                                              Constants.mobileNumber=databaseUser.mobileNumber;
                                              Constants.photo=databaseUser.photo;
                                              Constants.mailID=databaseUser.mailID;
                                              Constants.stateRefID=databaseUser.stateRefID;
                                              Constants.dob=databaseUser.dob;
                                              Constants.photo=databaseUser.photo;
                                              Constants.name=databaseUser.name;


                                              //await prefs.setString('userid', token.toString());
                                            });


                                            Future.delayed(
                                                Duration(seconds: 5), () async {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QuestionDynamicUiPage()),
                                                      (e) => false);
                                            });
                                          }

    });


                                    }else{
                                        showSnackBar(databaseUser
                                            .responseDescription);

                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PinUiPage(
                                                        mobile:widget.mobile,
                                                        qsid:''
                                                    )),
                                                (e) => false);

                                      }
                                  });

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
                        )):SizedBox(),
                    SizedBox(height: 15),
                    SvgPicture.asset('assets/icons/withdraw-separator-line.svg',),

                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.center,
                        child:GestureDetector(
                        onTap: () {
                        //  if (button_enable==true){

                            databaseUser.sendOTPLogin(widget.mobile,'3')
                                .whenComplete(() {
                              if(databaseUser.responseCode=="0"){
                                otpBottomSheet(widget.mobile);
                                otpdisplay=databaseUser.otp;
                              }


                            });

               },
                            child: Text(
                          "Forgot  PIN",
                          style: TextStyle(
                              fontSize: 14.0,color: Color(0xFFF38D14),
                              fontWeight: FontWeight.w700),
                        )
                    ),
                    ),



                  ],
                ),
              ),
            ],
          ),
        ))));
  }
}
