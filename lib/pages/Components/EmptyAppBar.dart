import 'package:flutter/material.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/question/schedule.dart';
import 'package:quizmaster/pages/ui/questionview.dart';
import 'package:quizmaster/pages/webview/privacy-policy.dart';

import '../ui/addmoney.dart';
import '../ui/transaction-one-add-money.dart';
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  final String title;
  EmptyAppBar({
    required this.child,
    this.height = kToolbarHeight,
    required this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [


        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(


            color: _colorFromHex(Constants.baseThemeColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: _colorFromHex(Constants.baseThemeColor),
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
        ),
        Positioned(
          top:125,
          child: SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [


              ],
            ),
          ),
        ),
        // Body of Text Start

        (title!='')?ListTile(
          leading:IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              if(title=='Transaction History'){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionOneAddMoney()),
                        (e) => false);
              }else if(title=='Privacy Policy'){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuestionDynamicUiPage()),
                        (e) => false);
              }else{
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMoney(transactionMsg: "",transactionAmount: "",)),
                        (e) => false);
              }

            },
          ),
          title: Text(title,style: TextStyle(color: Colors.white,fontSize: 16),),
          tileColor: Colors.red,

        ):SizedBox()
        // Body of Text End
      ],
    );
  }
}