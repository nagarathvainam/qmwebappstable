import 'package:flutter/material.dart';
class KYCPendingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  KYCPendingAppBar({
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [


        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFFffffff),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),

          ),
        ),
        Positioned(
          top:fem*350,
          child: SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xffEBD9C3),
                    child:Container(

                      margin: EdgeInsets.fromLTRB(8.82*fem, 8.82*fem, 8.82*fem, 8.82*fem),
                      width: 129.81*fem,
                      height: 134.18*fem,
                      // color: Colors.white,
                      child:CircleAvatar(
                        radius: 5,
                        // backgroundColor: Color(0xffC6E074),
                        child: Container(
                          height: 150,
                          width: 146,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:Color(0xffFC9700),
                          ),
                          child: Icon(Icons.check, color: Colors.white,size: 80,),
                          alignment: Alignment.center,
                        ),),
                    )),

              ],
            ),
          ),
        ),
        // Body of Text Start

        // Body of Text End
      ],
    );
  }
}