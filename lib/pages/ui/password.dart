import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/pages/ui/createprofile.dart';
import 'package:quizmaster/pages/ui/pin.dart';
import 'package:quizmaster/pages/ui/redeemcode.dart';
import 'package:quizmaster/pages/webview/termsandcondition.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:quizmaster/model/databasehelper.dart';
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

import 'package:http/http.dart' as http;
import 'package:quizmaster/pages/user/model/user.dart';


class PasswordUiPage extends StatefulWidget {
  String mobile;
  PasswordUiPage({required this.mobile});
  @override
  _PasswordUiPageState createState() => _PasswordUiPageState();
}
class _PasswordUiPageState extends State<PasswordUiPage> {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
 // DatabaseHelper databaseHelper = new DatabaseHelper();
  User databaseUser=new User();
  late StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
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


  @override
  Widget build(BuildContext context) {
    //final isLogin = _token != null && _profile != null;
    return WillPopScope(
        onWillPop: () async {
         // showCloseAppConfirm(context);
          // await showDialog or Show add banners or whatever
          // return true if the route to be popped
          return false; // return false if you want to disable device back button click
        },
        child:Scaffold(

            /*bottomNavigationBar:  Container(
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
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text.rich(TextSpan(
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
                            ]))

                    ),
                  ]
              ),

            ),*/
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
                              initialValue: const {},
                              skipDisabled: true,
                              child: Column(
                                children: <Widget>[
                                   const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Password / Pin",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal),
                                      )),

                                  const SizedBox(height: 10),
                                 FormBuilderTextField(
                                    //autovalidateMode: AutovalidateMode.always,
                                    name: 'password',
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
                                      hintText: "Enter 4 Digit pin for password",
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,


                                    ),

                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                   obscureText: true,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                    ],
                                    //keyboardType: TextInputType.number,
                                   keyboardType: Platform.isIOS?
                                   TextInputType.numberWithOptions(signed: true, decimal: true)
                                       : TextInputType.number,
                                   textInputAction: TextInputAction.next,
                                  ),

                                  const SizedBox(height: 10),
                                  const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Confirm Password / Pin",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal),
                                      )),

                                  const SizedBox(height: 10),
                                 FormBuilderTextField(
                                    name: 'cfmpassword',
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            width: 3,
                                            color: Color(0xFFC8C8C8)),
                                      ),
                                      labelText: '',
                                      hintText: "Enter your confirm password / pin",
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                    ),
                                    obscureText: true,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                    ],
                                   keyboardType: Platform.isIOS?
                                   TextInputType.numberWithOptions(signed: true, decimal: true)
                                       : TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                  )

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
                                        onPressed: () {


                                          if (_formKey.currentState
                                              ?.saveAndValidate() ??
                                              false) {

                                            if(_formKey.currentState
                                                ?.value['password']!=_formKey.currentState
                                                ?.value['cfmpassword']){
                                             // print('Confirm Password and Password sg');
                                              showSnackBar('Password and confirm password should be same');

                                            }else {
                                              databaseUser
                                                  .passwordupdate(
                                                  widget.mobile,
                                                  _formKey.currentState
                                                      ?.value['password'])
                                                  .whenComplete(() {
                                                    if(databaseUser.responseCode=="0"){
                                                      var isfirstuser=0;
                                                      //Constants.userRefID=databaseUser.userRefID;
                                                      if(isfirstuser==0){
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    TermsandCondition()),
                                                                (e) => false);
                                                      }else {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    CreateProfileUiPage()),
                                                                (e) => false);
                                                      }
                                                    }

                                              });
                                            }
                                            debugPrint(_formKey.currentState?.value
                                                .toString());
                                          } else {
                                            debugPrint(_formKey.currentState?.value
                                                .toString());
                                            debugPrint('validation failed');
                                          }

                                        },
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      )),
                                ),
                              ],
                            )),



                        const SizedBox(
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


