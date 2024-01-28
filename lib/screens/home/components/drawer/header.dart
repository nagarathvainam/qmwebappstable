import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/redeemcode.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/noconnection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class CustomDrawerHeader extends StatefulWidget {
  final bool isColapsed;
  String name;
  String mobile;
  String url;
  CustomDrawerHeader({
    Key? key,
    required this.isColapsed,
    required this.name,
    required this.mobile,
    required this.url
  }) : super(key: key);
  @override
  _CustomDrawerHeaderState createState() => _CustomDrawerHeaderState();
}
class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
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
  Widget build(BuildContext context) {

    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    height: 150,
    width: double.infinity,
    padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),
    child: Row(
      children: [
        Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 8.82*fem),
              width: 100.81*fem,
              height: 100.18*fem,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    Constants.photo),
              ),
            ),),
        if (widget.isColapsed) const SizedBox(width: 10),
        if (widget.isColapsed)
          Expanded(
            flex:1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  <Widget>[
                SizedBox(height:50.0),
                Text(Constants.displayName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                Expanded(child:Text(Constants.mobileNumber,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.0),)),

              ],
            ),
          ),
      ],
    ),
  );
  }

}
