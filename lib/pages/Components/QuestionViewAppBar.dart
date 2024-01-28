import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/editprofile.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
import 'package:quizmaster/pages/ui/addmoney.dart';
class QuestionViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final Widget child;
  final double height;
  final String amount;

  QuestionViewAppBar({
    required this.child,
    this.height = kToolbarHeight,
    required this.amount
  });

  @override
  Size get preferredSize => Size.fromHeight(height);
  showCloseAppConfirm(BuildContext context)
  {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(Size(
          MediaQuery.of(context).size.width,
          fem * 280)),
      context: context,
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration (
              color: Color(0xfffcfcfc),
              borderRadius: BorderRadius.only (
                topLeft: Radius.circular(24*fem),
                topRight: Radius.circular(24*fem),
              ),
            ),
            padding:EdgeInsets.all(8),child:Column(
            children: <Widget>[
              Row(
                children:  const <Widget>[

                  Text('Close',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                ],
              ),
              SizedBox(height: 20,),
              Row(
                children:  <Widget>[
                  Expanded(child: Text('Are you sure you wish to close your quiz?',style: TextStyle(fontSize: 14*fem,fontWeight: FontWeight.w600),)),

                ],
              ),

              SizedBox(height: 20,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: _colorFromHex(Constants.buttonColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // <-- Radius
                        ) // foreground
                    ),
                    onPressed: () async{
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionDynamicUiPage()),
                              (e) => false);
                    },
                    child: const Text(
                      'Confirm Close',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,
                          fontSize: 14.0),
                    ),
                  )),
              SizedBox(height: 10,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(
                              12), // <-- Radius
                        ) // foreground
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,
                          fontSize: 14.0),
                    ),
                  )),

            ]));
      },
    );
  }
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


            color:Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.white,
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
        ),

        // Body of Text Start
        Container(child:Row(
          children:  <Widget>[
            SizedBox(width: 25,),
            Padding(padding: EdgeInsets.only(top: 20.0),child:GestureDetector(
                onTap: () {
                    // Toggle light when tapped.
                    showCloseAppConfirm(context);
                },
                child:Image.asset(
              'assets/icons/home.png', // Replace with your image asset path
              height: 27,
              width: 28,
              // Adjust the height as needed
            ))),
            SizedBox(width: 50,),
            Padding(padding: EdgeInsets.only(top: 10.0),child:Image.asset(
              'assets/icons/logo-WqF.png', // Replace with your image asset path
              height: 50,
              width: 227,
              // Adjust the height as needed
            ))
          ],
        ))
       /* ListTile(
          leading:IconButton(
            // icon: Container(
            //   width: 160, // Adjust the width as needed
            //   height: 160, // Adjust the height as needed
            //   child: Icon(Icons.home_outlined,color: Colors.black,),
            // ),
            icon:  Icon(Icons.home_outlined,color: Colors.black,weight: 450,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddMoney(transactionMsg: "",transactionAmount: "",)),
                      (e) => false);
            },

          ),
          title: Image.asset(
            'assets/icons/logo-WqF.png', // Replace with your image asset path
            height: 50,
            width: 100,
            // Adjust the height as needed
          ),
         // centerTitle: true,

        )*/
        // Body of Text End
      ],
    );
  }
}