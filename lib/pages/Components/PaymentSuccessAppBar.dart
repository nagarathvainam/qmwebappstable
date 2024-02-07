import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
class PaymentSuccessAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  PaymentSuccessAppBar({
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


        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   child:GifView.asset(
        //     'assets/gif/transaction.gif',
        //     height: 500,
        //     width: 500,
        //     frameRate: 30, // default is 15 FPS
        //   ),
          // decoration: BoxDecoration(
          //
          //   // image: DecorationImage(
          //   //   image: AssetImage("assets/winner-start-stack.png"),
          //   //   //fit: BoxFit.cover,
          //   // ),
          //   color: Color(0xFFffffff),
          //   borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(20),
          //       topRight: Radius.circular(20)),
          //
          // ),
       // ),
        Positioned(
          top:20,
          child: SizedBox(
            height: 285,
            width:285,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
              GifView.asset(
                'assets/gif/transaction.gif',
                height: 950,
                width: 950,
                frameRate: 30, // default is 15 FPS
              ),

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