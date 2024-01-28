import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/editprofile.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/addmoney.dart';
class AddMoneyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final Widget child;
  final double height;
  final String amount;

  AddMoneyAppBar({
    required this.child,
    this.height = kToolbarHeight,
    required this.amount
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [


        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(


            color:_colorFromHex(Constants.baseThemeColor),
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

        // Body of Text Start

        ListTile(
          leading:IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddMoney(transactionMsg: "",transactionAmount: "",)),
                      (e) => false);
            },
          ),
          title: Text('Add Money',style: TextStyle(color: Colors.white,fontSize: 16),),
          tileColor: Colors.red,

        )
        // Body of Text End
      ],
    );
  }
}