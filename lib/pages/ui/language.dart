import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quizmaster/pages/ui/settings.dart';
import 'package:quizmaster/screens/home/components/drawer/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
class LanguageUiPage extends StatefulWidget {
  LanguageUiPage({Key? key}) : super(key: key);

  @override
  _LanguageUiPageState createState() => _LanguageUiPageState();
}

class _LanguageUiPageState extends State<LanguageUiPage> {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  List data = [];
  late int selectedindex=-1;




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
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // await showDialog or Show add banners or whatever
      // return true if the route to be popped
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SettingsUi()),
              (e) => false);
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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsUi()), //QuestionPage()),//QuestionPage() HomePage() LoginPage()
                  (e) => false);
            },
          ),
          backgroundColor: _colorFromHex(Constants.baseThemeColor),
          title: const Text('Choose a Language'),
        ),
        drawer: CustomDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    (data.length > 0)
                        ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data == null ? 0 : 12,
                              itemBuilder: (BuildContext context, int index) {
                                var langtitle = "";
                                var languageicon = "";
                                var smallboxbackground = "";
                                if (index == 0) {
                                  smallboxbackground = '1';
                                  langtitle = "English";
                                  languageicon = "assets/language-english.png";
                                }

                                if (index == 1) {
                                  langtitle = "Kannada";
                                  languageicon = "assets/language-kannada.png";
                                }
                                if (index == 2) {
                                  langtitle = "Malayalam";
                                  languageicon =
                                      "assets/language-malayalam.png";
                                }
                                if (index == 3) {
                                  langtitle = "Telugu";
                                  languageicon = "assets/language-telugu.png";
                                }
                                if (index == 4) {
                                  langtitle = "Tamil";
                                  languageicon = "assets/language-tamil.png";
                                }
                                if (index == 5) {
                                  langtitle = "Bengali";
                                  languageicon = "assets/language-bengali.png";
                                }
                                if (index == 6) {
                                  langtitle = "Marathi";
                                  languageicon = "assets/language-marathi.png";
                                }
                                if (index == 7) {
                                  langtitle = "Odia";
                                  languageicon = "assets/language-odia.png";
                                }
                                if (index == 8) {
                                  langtitle = "Gujarati";
                                  languageicon = "assets/language-gujarati.png";
                                }
                                if (index == 9) {
                                  langtitle = "Bhojpuri";
                                  languageicon = "assets/language-bhojpuri.png";
                                }

                                if (index == 10) {
                                  langtitle = "Hindi";
                                  languageicon = "assets/language-hindi.png";
                                }

                                return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 10, right: 10, bottom: 5),
                                    child: Container(
                                        height: 80,
                                        child: GestureDetector(
                                          child: Card(
                                            color: (selectedindex == index)
                                                ? Color(0xFFCCCCCC)
                                                : Color(0xFFFFFFFF),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: _colorFromHex(Constants.baseThemeColor),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            //elevation: 4,
                                            child: Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 10,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        (languageicon != '')
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    Container(
                                                                        height:
                                                                            48,
                                                                        width:
                                                                            48,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: (smallboxbackground == "1")
                                                                              ? Color(0xFFffffff)
                                                                              : Color(0xFFCCCCCC),
                                                                          border:
                                                                              Border.all(width: 1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10), //<-- SEE HERE
                                                                        ),
                                                                        child: Image
                                                                            .asset(
                                                                          languageicon,
                                                                          height:
                                                                              48.0,
                                                                          width:
                                                                              48.0,
                                                                        )),
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Expanded(
                                                          child: Text(langtitle,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineSmall!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                        ),

                                                      ],
                                                    )),

                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedindex=index;
                                            });
                                          },
                                        )));
                              },
                            ))
                        : Center(child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 17,
                    ),
                    Text(
                        "If You wish to change quiz game language later,\nGo to Settings > Game Settings > Quiz Game Language",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                )),


                  ],
                ),
              )
            ],
          ),
        ))

        ,bottomNavigationBar:  Container(
      padding: EdgeInsets.all(10.0),
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
            Row(
              children:  <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width-20,
                 child:ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: _colorFromHex(Constants.buttonColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ) // foreground
                                ),
                                onPressed: () {
                                  setState(() async{
                                    final prefs = await SharedPreferences.getInstance();
                                    if(selectedindex==0){
                                      await prefs.setString('lngname', "English");
                                    }else if(selectedindex==1){
                                      await prefs.setString('lngname', "Arabic");
                                    }else if(selectedindex==2){
                                      await prefs.setString('lngname', "Kannada");
                                    }else if(selectedindex==3){
                                      await prefs.setString('lngname', "Malayalam");
                                    }else if(selectedindex==4){
                                      await prefs.setString('lngname', "Telugu");
                                    }else if(selectedindex==5){
                                      await prefs.setString('lngname', "Tamil");
                                    }
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsUi()),
                                            (e) => false);
                                  });

                                },
                                child: const Text(
                                  'Save & Continue',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),

                    )),

              ],
            ),

          ]
      ),

    )

    ));
  }
}
