import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quizmaster/pages/ui/otp.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:quizmaster/pages/user/model/user.dart';
import 'editprofile.dart';
class RedeemUiPage extends StatefulWidget {
  RedeemUiPage({Key? key}) : super(key: key);

  @override
  _RedeemUiPageState createState() => _RedeemUiPageState();
}

class _RedeemUiPageState extends State<RedeemUiPage> {
  bool newUserBlock=false;
  User databaseUser=new User();
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
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final _formKey = GlobalKey<FormBuilderState>();
  var genderOptions = ['Male', 'Female', 'Other'];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {

      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
        backgroundColor: _colorFromHex(Constants.baseThemeColor),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Go to the next page',
            onPressed: () {
              /*Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OtpUiPage()),
                  (e) => false);*/
            },
          ),
          backgroundColor: _colorFromHex(Constants.baseThemeColor),
          //title: const Text('AppBar Demo'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileUiPage()),
                                  (e) => false);
                        },
                        child: const Text(
                          "SKIP",
                          style: TextStyle(fontSize: 20.0),
                        ))))
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 47,
                  width: 246,
                  child: Image.asset(
                      "assets/loginqtitle.png")
                  ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Quiz Game",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                  child: Image.asset(
                      "assets/photo.png")
                  ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 470,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                    )),
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: FormBuilder(
                              key: _formKey,
                              onChanged: () {
                                _formKey.currentState!.save();
                                debugPrint(
                                    _formKey.currentState!.value.toString());
                              },
                              autovalidateMode: AutovalidateMode.disabled,
                              initialValue: const {
                                'movie_rating': 5,
                                'best_language': 'Dart',
                                'gender': 'Male',
                                'languages_filter': ['Dart']
                              },
                              skipDisabled: true,
                              child: Column(
                                children: <Widget>[
                                  const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Redeem Referral Code",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 15),
                                  RichText(
                                    text: const TextSpan(
                                      text:
                                          'You will receive QM coins worth upto  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '₹500',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                ' in your wallet, if you redeem a referral code.'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Enter Referral Code",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      )),
                                  const SizedBox(height: 15),
                                  FormBuilderTextField(
                                    //autovalidateMode: AutovalidateMode.always,
                                    name: 'referalCode',
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            width: 3, color: Color(0xFFC8C8C8)),
                                      ),
                                      labelText: '',

                                      hintText: "",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),

                                    onChanged: (val) {
                                      setState(() {

                                      });
                                    },

                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),

                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                      height: 44.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: _colorFromHex(Constants.buttonColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // <-- Radius
                                            ) // foreground
                                            ),
                                        onPressed: () {
                                          if (_formKey.currentState
                                                  ?.saveAndValidate() ??
                                              false) {
                                                    print(_formKey
                                                        .currentState?.value['referalCode'].toString().length);
                                                    int? textlen=_formKey
                                                        .currentState?.value['referalCode'].toString().length;
                                                    if(textlen!<4){
                                                      showSnackBar("Referral code length should be atleast 4 character");
                                                    }else{
                                                      Constants.printMsg("Its OK");
                                                      databaseUser.userRedeem(_formKey
                                                      .currentState?.value['referalCode'])
                                                      .whenComplete(() {

                                                                if (databaseUser.responseCode ==
                                                                "0") {
                                                                  showSnackBar(databaseUser.responseDescription);
                                                                }else{
                                                                  showSnackBar("Failed Try Again/Skip this Section");
                                                                }

                                                      });
                                                    }
                                          } else {
                                            debugPrint(_formKey
                                                .currentState?.value
                                                .toString());
                                            debugPrint('validation failed');
                                          }
                                        },
                                        child: const Text(
                                          'Redeem Code',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      )),
                                ),
                              ],
                            )),
                        Align(
                            alignment: Alignment.center,
                            //child: Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileUiPage()),
                                              (e) => false);
                                    },
                                    child:  Text(
                                      'Skip & Continue',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: _colorFromHex(Constants.baseThemeColor)),
                                    ))
                            //)
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/bottom-bar-line.png",
                          height: MediaQuery.of(context).size.width,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ))));
  }
}
