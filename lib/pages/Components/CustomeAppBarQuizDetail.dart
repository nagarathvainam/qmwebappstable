import 'package:flutter/material.dart';
import 'package:quizmaster/pages/ui/editprofile.dart';
import '../question/schedule.dart';
import 'package:quizmaster/constant/constants.dart';
class CustomeAppBarQuizDetail extends StatelessWidget implements PreferredSizeWidget {
  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final Widget child;
  final double height;
  final String photo;

  CustomeAppBarQuizDetail({
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
          top:100,
          child: SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 115,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 110,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            photo), //NetworkImage
                        radius: 55,
                      ), //CircleAvatar
                    )),

              ],
            ),
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
                      builder: (context) => QuestionDynamicUiPage()),
                      (e) => false);
            },
          ),
          title: Text('Edit Profile',style: TextStyle(color: Colors.white,fontSize: 16),),
          tileColor: Colors.red,
          trailing:IconButton(
            icon: Icon(Icons.edit,color: Colors.white,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfileUiPage()),
                      (e) => false);
            },
          ),// Icon(Icons.edit,color: Colors.white,),
        )
        // Body of Text End
      ],
    );
  }
}