import 'package:flutter/material.dart';
class LoaderDialog {

  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    var wid = MediaQuery.of(context).size.width / 2;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  Dialog(
            key: key,
            backgroundColor:  Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color:Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
              width:60,
              height: 130,
              child:  ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ), // Image border
                  // Image radius
                  child:Image.asset(
                    'assets/loader-white.gif',
                    height: 360,
                    width: 60,
                  )),
            )
        );
      },
    );
  }
}