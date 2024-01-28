import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/editprofile.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
class TransactionAddMoneyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final Widget child;
  final double height;
  final String photo;

  TransactionAddMoneyAppBar({
    required this.child,
    this.height = kToolbarHeight,
    required this.photo,
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
        Positioned(
          top:35,
          right: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  <Widget>[


              IconButton(
                icon:  Icon(Icons.arrow_back,color: Colors.white,),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionDynamicUiPage()),
                          (e) => false);
                },
              ),
              SizedBox(width: 110,),
              Image.asset(
                'assets/icons/layerx00201.png', height: 37,
                width: 53,
              ),
              SizedBox(width: 20,),
            ],
          )/*SizedBox(
            height: 37,
            width: 53,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [

                Image.asset(
                  'assets/icons/layerx00201.png',
                )
              ],
            ),
          ),*/
        ),
        // Body of Text Start
//SizedBox(height: 50,),
//

        // Body of Text End
      ],
    );
  }
}