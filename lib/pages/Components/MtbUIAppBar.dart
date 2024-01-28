import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:quizmaster/utils.dart';
import 'package:quizmaster/constant/constants.dart';
import '../question/schedule.dart';
class MtbUIAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  //final String mainBalance;
  MtbUIAppBar({
   // required this.mainBalance,
    required this.child,
    this.height = kToolbarHeight,

  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Color _colorFromHex(String hexColor) {
      final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20*fem, 30.72*fem, 20*fem, 0*fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 3.0,),
                  ListTile(
                    leading:IconButton(
                      icon: const Icon(Icons.arrow_back,color: Colors.white,),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionDynamicUiPage()),
                                (e) => false);

                      },
                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    ) ,
                    title: Text("Withdraw Money",style: TextStyle(color: Colors.white),),
                  ),


                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF44228F),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12)
                        ),
                      ),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  <Widget>[
                          Expanded(child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              Text('Withdraw Day Limit',style: TextStyle(color: Colors.white),),
                              Text('₹ 4,200/5000',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),

                            ],
                          )),
                          Image.asset(
                            'assets/icons/mtbwallet.png',
                          )
                        ],
                      ))
                  ,

                  SizedBox(height:20)
/*
                  Container(

                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  <Widget>[
                          Expanded(
                            child:Container(
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 343.51*fem),
                              width: double.infinity,
                              height: 127.49*fem,
                              child: Stack(
                                children: [

                                   Container(
                                      padding: EdgeInsets.fromLTRB(19*fem, 22.49*fem, 80.5*fem, 23.51*fem),
                                      width: 377*fem,
                                      height: 105*fem,
                                      decoration: BoxDecoration (
                                        color: Color(0xff4E1E73),
                                        borderRadius: BorderRadius.circular(13*fem),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            textAlign: TextAlign.left,
                                            text: const TextSpan(
                                              text: 'Wallet Balannce',
                                              style: TextStyle(color: Colors.white,fontSize: 12),
                                              children: <TextSpan>[
                                                TextSpan(text: '\n₹ 5,432', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,)),

                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child:SizedBox(width: 2000,),
                                          ),
                                          Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    'assets/icons/mingcute_wallet-fill.png',
                                                    //width: 31*fem,
                                                    //height: 31*fem,
                                                  ),


                                              ],
                                            ),

                                        ],
                                      ),
                                    ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
*/
                ],
              ),
            ),
          ],
        ));
  }
}