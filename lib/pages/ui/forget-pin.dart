import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quizmaster/pages/ui/redeemcode.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'dart:io' show Platform, exit;
import 'login.dart';
import 'package:quizmaster/pages/user/model/user.dart';

class ForgetPinUi extends StatefulWidget {
  String mobile;

 // ForgetPinUi({Key? key}) : super(key: key);
  ForgetPinUi({required this.mobile});
  @override
  _ForgetPinUiState createState() => _ForgetPinUiState();
}
class _ForgetPinUiState extends State<ForgetPinUi> {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  User databaseUser=new User();
  final _formKey = GlobalKey<FormBuilderState>();
  var genderOptions = ['Male', 'Female', 'Other'];
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



  navigateofflinescreen(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NoConnectionUiPage()),
            (e) => false);
  }
  @override
  Widget build(BuildContext context)
  {

    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginUiPage(title: '',url: '',)),
                        (e) => false);
          return false; // return false if you want to disable device back button click
        },
        child: Scaffold(
            backgroundColor: _colorFromHex(Constants.baseThemeColor),
            body: SafeArea(
                child: SingleChildScrollView(

                  physics: NeverScrollableScrollPhysics(),
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
                      //SizedBox(height: 10,),
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
                               // padding: EdgeInsets.all(16.0),
                              padding: EdgeInsets.only(left: 16.0,right: 16,top: 16),
                                  //skipDisabled: true,
                                  child: Column(
                                    children: <Widget>[
                                      const Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Create New 4 Digit Login PIN",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    //  SizedBox(height: 10),

                                    ],
                                  ),
                                ),
                  Padding(
                    padding: EdgeInsets.only(left: 20,right: 20,),
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
                                   // Align(
                                   //    alignment: Alignment.bottomLeft,
                                   //    child: Text(
                                   //      "Your Mobile Number",
                                   //      style: TextStyle(
                                   //          fontSize: 12.0,
                                   //          fontWeight: FontWeight.normal),
                                   //    )),
                                      //   Align(
                                      // alignment: Alignment.bottomLeft,
                                      // child: Text(
                                      //   "Your Password",
                                      //   style: TextStyle(
                                      //       fontSize: 12.0,
                                      //       fontWeight: FontWeight.normal),
                                      // )),
                                  SizedBox(height: 15,),

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
                                      hintText: "Create New PIN ",
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                     // prefixText: "+91",
                                    ),
                                    obscureText: true,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.numeric(),
                                    ]),
                                    // initialValue: '12',
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                    ],
                                    //keyboardType: (Platform.isAndroid)?TextInputType.number:TextInputType.text,
                                    keyboardType: Platform.isIOS?
                                    TextInputType.numberWithOptions(signed: true, decimal: true)
                                        : TextInputType.number,
                                    //textInputAction: TextInputAction.next,
                                  ),

                           SizedBox(height: 15,),
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
                                      hintText: "Confirm PIN",
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
                                   // keyboardType: (Platform.isAndroid)?TextInputType.number:TextInputType.number,
                                         keyboardType: Platform.isIOS?
                                         TextInputType.numberWithOptions(signed: true, decimal: true)
                                             : TextInputType.number,
                                   // textInputActio keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),n: TextInputAction.done,
                                  ),

                                  SizedBox(height: 15,),

                                  // FormBuilderTextField(
                                  //   name: 'OTP',
                                  //   decoration: InputDecoration(
                                  //     border: OutlineInputBorder(
                                  //       borderRadius:
                                  //       BorderRadius.circular(10.0),
                                  //       borderSide: const BorderSide(
                                  //           width: 3,
                                  //           color: Color(0xFFC8C8C8)),
                                  //     ),
                                  //     labelText: '',
                                  //     hintText: "OTP",
                                  //     floatingLabelBehavior:
                                  //     FloatingLabelBehavior.always,
                                  //   ),
                                  //   obscureText: true,
                                  //   validator: FormBuilderValidators.compose([
                                  //     FormBuilderValidators.required(),
                                  //   ]),
                                  //   inputFormatters: [
                                  //     LengthLimitingTextInputFormatter(10),
                                  //   ],
                                  //   keyboardType: TextInputType.text,
                                  //   textInputAction: TextInputAction.next,
                                  // )
                                ],
                              ),
                            )

                  ),
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                            //   width: 366*fem,
                            //   height: 44*fem,
                            //   decoration: BoxDecoration (
                            //     border: Border.all(color: Color(0xff808080)),
                            //     color: Color(0xffffffff),
                            //     borderRadius: BorderRadius.circular(12*fem),
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       'Create New PIN ',
                            //       textAlign: TextAlign.center,
                            //       style: SafeGoogleFont (
                            //         'Open Sans',
                            //         fontSize: 12*ffem,
                            //         fontWeight: FontWeight.w400,
                            //         height: 1.1428571429*ffem/fem,
                            //         color: Color(0xff000000),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 20),
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                            //   width: 366*fem,
                            //   height: 44*fem,
                            //   decoration: BoxDecoration (
                            //     border: Border.all(color: Color(0xff808080)),
                            //     color: Color(0xffffffff),
                            //     borderRadius: BorderRadius.circular(12*fem),
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       'Conform PIN ',
                            //       textAlign: TextAlign.center,
                            //       style: SafeGoogleFont (
                            //         'Open Sans',
                            //         fontSize: 12*ffem,
                            //         fontWeight: FontWeight.w400,
                            //         height: 1.1428571429*ffem/fem,
                            //         color: Color(0xff000000),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 20),
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 0*fem),
                            //   width: 366*fem,
                            //   height: 44*fem,
                            //   decoration: BoxDecoration (
                            //     border: Border.all(color: Color(0xff808080)),
                            //     color: Color(0xffffffff),
                            //     borderRadius: BorderRadius.circular(12*fem),
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       'OTP ',
                            //       textAlign: TextAlign.center,
                            //       style: SafeGoogleFont (
                            //         'Open Sans',
                            //         fontSize: 12*ffem,
                            //         fontWeight: FontWeight.w400,
                            //         height: 1.1428571429*ffem/fem,
                            //         color: Color(0xff000000),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                           // SizedBox(height: 20),

                            Padding(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0,top: 25),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        height: 55,
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
                                              if (_formKey.currentState
                                                  ?.saveAndValidate() ??
                                                  false) {
                                                          if(_formKey.currentState
                                                          ?.value['password']!=_formKey.currentState
                                                          ?.value['cfmpassword']){



                                                              showDialog<String>(
                                                                  context: context,
                                                                  builder: (BuildContext context) => AlertDialog(
                                                                    title: const Text('Validation'),
                                                                    content: const Text('New pin & confirm pin should be same'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                        child: const Text('Ok'),
                                                                      ),
                                                                    ],
                                                                  ));





                                                          }else {
                                                          databaseUser
                                                          .forgotPin(
                                                          widget.mobile, _formKey.currentState
                                                          ?.value['password'])

                                                          .whenComplete(() {
                                                          if (databaseUser.responseCode ==
                                                          "0") {
                                                            const snackBar = SnackBar(
                                                              content: Text('password updated succesfully'),
                                                            );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                          Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                          builder: (context) =>
                                                            LoginUiPage(title: '',url: '',)),
                                                          (e) => false);
                                                          }
                                                          });
                                                          }

                                              } else {
                                                debugPrint(_formKey.currentState?.value
                                                    .toString());
                                                debugPrint('validation failed');
                                              }
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

                          ],
                        ),
                      ),
                    ],
                  ),

                ))));

  }
}
