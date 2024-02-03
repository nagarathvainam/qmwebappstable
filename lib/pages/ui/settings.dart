import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import '../question/schedule.dart';
import 'package:quizmaster/pages/ui/language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:quizmaster/class/LoadingDialog.dart';
class SettingsUi extends StatefulWidget {
  const SettingsUi({Key? key}) : super(key: key);

  @override
  State<SettingsUi> createState() => _SettingsUiState();
}

class _SettingsUiState extends State<SettingsUi> {
  late StreamSubscription<ConnectivityResult> subscription;
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
  double currentvol = 50;
  double currentsound = 50;
  bool light0 = true;
  bool light1 = true;
  bool light2 = true;
  late String  soundstatus="0";
  String selectedLangname = "English";
  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void initState(){
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result==ConnectivityResult.none){
        navigateofflinescreen();
      }
      if(result==ConnectivityResult.mobile){
        
      }
      // Got a new connectivity status!
    });
    _readLanguageName();
    PerfectVolumeControl.hideUI = false;
    Future.delayed(Duration.zero,() async {
      currentvol = await PerfectVolumeControl.getVolume();
      setState(() {
        //refresh UI
      });
    });
    PerfectVolumeControl.stream.listen((volume) {
      setState(() {
        currentvol = volume;
      });
    });


    PerfectVolumeControl.hideUI = false;
    Future.delayed(Duration.zero,() async {
      currentsound = await PerfectVolumeControl.getVolume();
      setState(() {
        //refresh UI
      });
    });
    PerfectVolumeControl.stream.listen((volume) {
      setState(() {
        currentsound = volume;
      });
    });
    super.initState();
  }

  // Loading counter value on start
  void _readLanguageName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLangname = (prefs.getString('lngname') ?? "");
    });
  }

  ColorSwatch? _tempMainColor;
  Color? _tempShadeColor;
  ColorSwatch? _mainColor = Colors.blue;
  Color? _shadeColor = Colors.blue[800];

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                print("Temp Main Color $_tempMainColor");
                print("Temp Shade Color $_tempShadeColor");
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        onBack: () => print("Back button pressed"),
      ),
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Main Color picker",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  void _openAccentColorPicker() async {
    _openDialog(
      "Accent Color picker",
      MaterialColorPicker(
        colors: accentColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        circleSize: 40.0,
        spacing: 10,
      ),
    );
  }

  void _openFullMaterialColorPicker() async {
    _openDialog(
      "Full Material Color picker",
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }
  Widget build(BuildContext context) {
    final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return
    WillPopScope(
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

            title: const Text('Settings',style: TextStyle(color:Colors.white),),
            actions: <Widget>[
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration (
                color: _colorFromHex(Constants.baseThemeColor),
              ),

              child:
              SingleChildScrollView
                (child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(24*fem, 24*fem, 24*fem, 152*fem),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration (
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only (
                        topLeft: Radius.circular(24*fem),
                        topRight: Radius.circular(24*fem),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x28000000),
                          offset: Offset(0*fem, -4*fem),
                          blurRadius: 2*fem,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 40*fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                child: Text(
                                  'Game Settings',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),




                             /* Row(
                                children:  <Widget>[
                                  Text(
                                    "App Theme Color",

                                  ),
                                  SizedBox(width: 50,),
                                  OutlinedButton(
                                    onPressed: _openFullMaterialColorPicker,
                                    child: const Text('Choose color picker'),
                                  ),
                                ],
                              ),*/


                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8*fem),
                                width: double.infinity,
                                height: 40*fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 4*fem, 16*fem, 12*fem),
                                      height: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 26*fem, 0*fem),
                                            child: Text(
                                              'Music',
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 16*ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1*ffem/fem,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),

                                          SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              trackHeight: 10.0,
                                              trackShape: RoundedRectSliderTrackShape(),
                                              activeTrackColor: Colors.purple.shade800,
                                              inactiveTrackColor: Colors.purple.shade100,
                                              thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 14.0,
                                                pressedElevation: 8.0,
                                              ),
                                              thumbColor: Colors.white,
                                              overlayColor: Colors.pink.withOpacity(0.2),
                                              overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
                                              tickMarkShape: RoundSliderTickMarkShape(),
                                              activeTickMarkColor: Colors.white,
                                              inactiveTickMarkColor: Colors.white,
                                              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                              valueIndicatorColor: Colors.deepPurple,
                                              valueIndicatorTextStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            child: Slider(
                                                value: currentvol,max: 100,divisions:10,label: currentvol.round().toString(),
                                                onChanged: (newvol)
                                                {
                                                  currentvol = newvol;
                                                  PerfectVolumeControl.setVolume(newvol);
                                                  setState(() {
                                                    if(newvol<1){
                                                      soundstatus = "1";
                                                    }
                                                    else{
                                                      soundstatus = "0";
                                                    }
                                                  });
                                                }
                                            ),
                                          ),
                                          Image.asset((soundstatus == '1')?"assets/mute.png":"assets/sound.png", width: 32, height: 32)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                width: double.infinity,
                                height: 1*fem,
                                decoration: BoxDecoration (
                                  color: Color(0x28000000),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 8*fem, 24*fem, 0*fem),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 19*fem, 0*fem),
                                            child: Text(
                                              'Sound',
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 16*ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1*ffem/fem,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),

                                          SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              trackHeight: 10.0,
                                              trackShape: RoundedRectSliderTrackShape(),
                                              activeTrackColor: Colors.purple.shade800,
                                              inactiveTrackColor: Colors.purple.shade100,
                                              thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 14.0,
                                                pressedElevation: 8.0,
                                              ),
                                              thumbColor: Colors.white,
                                              overlayColor: Colors.pink.withOpacity(0.2),
                                              overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
                                              tickMarkShape: RoundSliderTickMarkShape(),
                                              activeTickMarkColor: Colors.white,
                                              inactiveTickMarkColor: Colors.white,
                                              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                              valueIndicatorColor: Colors.deepPurple,
                                              valueIndicatorTextStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            child: Slider(
                                                value: currentsound,max: 100,divisions:10,label: currentsound.round().toString(),
                                                onChanged: (newvol)
                                                {
                                                  currentsound = newvol;
                                                  PerfectVolumeControl.setVolume(newvol);
                                                  setState(() {
                                                    if(newvol<1){
                                                      soundstatus = "1";
                                                    }
                                                    else{
                                                      soundstatus = "0";
                                                    }
                                                  });
                                                }
                                            ),
                                          ),
                                          Image.asset((soundstatus == '1')?"assets/mute.png":"assets/sound.png", width: 32, height: 32)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                width: double.infinity,
                                height: 1*fem,
                                decoration: BoxDecoration (
                                  color: Color(0x28000000),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                                width: double.infinity,
                                height: 24*fem,
                                decoration: BoxDecoration (
                                  borderRadius: BorderRadius.circular(32*fem),
                                ),
                                child:

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 235*fem, 0*fem),
                                      child: Text(
                                        'Vibration',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1*ffem/fem,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child:
                                      Switch(
                                        thumbIcon: thumbIcon,
                                        value: light0,

                                        onChanged: (bool value) {
                                          setState(() {
                                            light0 = value;
                                          });
                                        },
                                      ),
                                      //width: 1*ffem/fem,
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                width: double.infinity,
                                height: 1*fem,
                                decoration: BoxDecoration (
                                  color: Color(0x28000000),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0*fem, 2*fem, 9*fem, 2*fem),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                    onTap: () {
                                      LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                              Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                              builder: (context) =>LanguageUiPage()),
                              (e) => false);
                              },
                                child:Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 120*fem, 0*fem),
                                      child: Text(
                                        'Quiz Game Language',
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1*ffem/fem,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    )),
              Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 19*fem, 0*fem),
                                      child: GestureDetector(
                                        onTap: () {
                                          LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>LanguageUiPage()),
                                                  (e) => false);
                                        },
                                        child:Text(
                                        (selectedLangname=='')?'English':selectedLangname,
                                        style: SafeGoogleFont (
                                          'Open Sans',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.25*ffem/fem,
                                          color: Color(0x7f000000),
                                        ),
                                      )),
                                    ),
              GestureDetector(
                onTap: () {

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>LanguageUiPage()),
                          (e) => false);
                },
                child:Container(
                                      width: 6*fem,
                                      height: 12*fem,
                                      child:GestureDetector(
                                        onTap: () {
                                          LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>LanguageUiPage()),
                                                  (e) => false);
                                        },
                                        child: Image.asset(
                                        'assets/icons/akar-icons-chevron-down-EBM.png',
                                        width: 6*fem,
                                        height: 12*fem,
                                      )),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(32*fem),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 24*fem),
                                child: Text(
                                  'Account Settings',
                                  style: SafeGoogleFont (
                                    'Open Sans',
                                    fontSize: 16*ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration (
                                  borderRadius: BorderRadius.circular(32*fem),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                                      width: double.infinity,
                                      height: 24*fem,
                                      decoration: BoxDecoration (
                                        borderRadius: BorderRadius.circular(32*fem),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 175*fem, 0*fem),
                                            child: Text(
                                              'Push Notifications',
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 16*ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1*ffem/fem,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child:
                                            Switch(
                                              thumbIcon: thumbIcon,
                                              value: light1,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  light1 = value;
                                                });
                                              },
                                            ),

                                          ),

                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                      width: double.infinity,
                                      height: 1*fem,
                                      decoration: BoxDecoration (
                                        color: Color(0x28000000),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                                      width: double.infinity,
                                      decoration: BoxDecoration (
                                        borderRadius: BorderRadius.circular(32*fem),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                                            width: double.infinity,
                                            height: 24*fem,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 165*fem, 0*fem),
                                                  child: Text(
                                                    'Native Refresh Rate',
                                                    style: SafeGoogleFont (
                                                      'Open Sans',
                                                      fontSize: 16*ffem,
                                                      fontWeight: FontWeight.w400,
                                                      height: 1*ffem/fem,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ),
                                                Container(

                                                  child:
                                                  Switch(
                                                    thumbIcon: thumbIcon,
                                                    value: light2,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        light2 = value;
                                                      });
                                                    },
                                                  ),

                                                ),

                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Unlock your device’s native refresh rate for higher FPS.',
                                            style: SafeGoogleFont (
                                              'Open Sans',
                                              fontSize: 14*ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.4285714286*ffem/fem,
                                              color: Color(0x7f000000),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                                      width: double.infinity,
                                      height: 1*fem,
                                      decoration: BoxDecoration (
                                        color: Color(0x28000000),
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 16*fem),
                                            child: Text(
                                              'Delete Account',
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 16*ffem,
                                                fontWeight: FontWeight.w700,
                                                height: 1*ffem/fem,
                                                color: Color(0xffaa0064),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            constraints: BoxConstraints (
                                              maxWidth: 348*fem,
                                            ),
                                            child:
                                            Text (
                                              'Once your Quick Quiz account is deleted, it will no longer be accessible by you or anyone else. This action cannot be undone',textAlign: TextAlign.justify,
                                              style: SafeGoogleFont (
                                                'Open Sans',
                                                fontSize: 14*ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.4285714286*ffem/fem,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              ),

            ),
          ),
        )
    );

  }
}