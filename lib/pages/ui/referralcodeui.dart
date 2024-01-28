import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
class ReferralCodeUiPage extends StatefulWidget {
  ReferralCodeUiPage({Key? key}) : super(key: key);
  @override
  _ReferralCodeUiPageState createState() => _ReferralCodeUiPageState();
}

class _ReferralCodeUiPageState extends State<ReferralCodeUiPage> {
  late StreamSubscription<ConnectivityResult> subscription;
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }

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
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => QuestionDynamicUiPage()),
              (e) => false);
      return false; // return false if you want to disable device back button click
    },
    child: Scaffold(
      backgroundColor: _colorFromHex(Constants.baseThemeColor),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:_colorFromHex(Constants.baseThemeColor) ,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuestionDynamicUiPage()),
                        (e) => false);

              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        title: const Text('Referral Code',style: TextStyle(color:Colors.white),),
        actions: <Widget>[
        ],
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(8),
        decoration: const BoxDecoration(


          color: Color(0xFFECECEC),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0),
                // color: Colors.green,
                spreadRadius: 1,
                blurRadius: 1),
          ],
        ),
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              // Main Contetn Start Here
              Text("Invite Friends ,Get Rewards",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 17),),
              SizedBox(height: 20.0,),
              Container(
                  padding: EdgeInsets.only(top:10.0,left: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Color(0xffE70D93),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),
                  //child: SingleChildScrollView(
                  child:Column(
                    children:  <Widget>[
                      Row(
                        children: const <Widget>[
                          Expanded(child: Text("You will receive Qm coins worth upto ₹500 in your wallet, if someone uses your referral code.",style: TextStyle(color: Colors.white),)),
                        ],
                      ),

                      Row(
                        children:  <Widget>[
                          Image.asset("assets/small-gifts.png"),
                          SizedBox(width: 10.0,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              Text('Your Qm Referral Code',style: TextStyle(color: Colors.white),),
                              Row(
                                  children:  <Widget>[
                                    Text("2d8gu9h",style: TextStyle(color: Colors.white,fontWeight:FontWeight.w700, ),),
                                    SizedBox(width: 5.0,),
                                    Image.asset("assets/plusimg.png"),
                                  ]),

                            ],
                          )),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(12),
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ), // Image border
            // Image radius
              child:Image.asset("assets/giftbox.png")),
                        ],
                      )
                    ],
                  )),
              SizedBox(height: 20.0,),
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
                  'Share my Referral Code',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              SizedBox(height: 30.0,),
              Text("Redeem a Referral Code",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700, fontSize: 19),),

              SizedBox(height: 15.0,),
              //coLoum
              Container(
                  padding: EdgeInsets.only(top:10.0,left: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Color(0xff497ECE),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),

                  child:Column(
                      children:  <Widget>[
                        Row(
                          children: const <Widget>[
                            Expanded(child: Text("You will receive Qm coins worth upto ₹500 in your wallet, if you reedeem a  referral code.",style: TextStyle(color: Colors.white),)),
                          ],
                        ),

                        FormBuilder(

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
                              const SizedBox(height: 15),

                              Padding(
                                padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                                child:
                                Container(
                                    decoration:  BoxDecoration(
                                        color: _colorFromHex(Constants.buttonColor),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        )),
                                    child:FormBuilderTextField(
                                      name: 'mobile',
                                      decoration: const InputDecoration(
                                          filled: true,
                                          hintText: "Enter Referal Code",
                                          fillColor: Colors.white,
                                          focusColor: Colors.green

                                      ),

                                      validator: FormBuilderValidators.compose([

                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.numeric(),
                                        FormBuilderValidators.max(10),
                                        FormBuilderValidators.min(4),

                                      ]),

                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                    )),

                              )],
                          ),
                        ),
                        const SizedBox(height: 18),



                      ]
                  )) ,
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xFFDAF387),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // <-- Radius
                    ) // foreground
                ),
                onPressed: () {

                },
                child: const Text(
                  'Redeem Code',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
               ]

        ),
      ),


      //
    ));
  }

}
