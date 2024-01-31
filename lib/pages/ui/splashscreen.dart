import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../constant/constants.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
  final String title;
}

class _SplashScreenState extends State<SplashScreen> {
  bool loginloading=false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.85;//0.97;
    return Scaffold(
        body:Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            child:  SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child:
                    Center(child:Column(
                        children: <Widget>[
                          Container(

                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/splash_bg.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: double.infinity,
                            height: 844*fem,

                            child: Stack(
                              children: [
                                // Align(
                                //     child: SizedBox(
                                //       width: 390*fem,
                                //       height: MediaQuery.of(context).size.height,
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           image: DecorationImage(
                                //             image: AssetImage("assets/splash_bg.png"),
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),

      Positioned(
        left: 175*fem,
        top: 425*fem,
        child:Align(
                                    child: SizedBox(
                                      width: 75*fem,
                                      height: 75*fem,
                                      child: LoadingIndicator(
                                          indicatorType: Indicator.circleStrokeSpin, /// Required, The loading type of the widget
                                          colors:  [Color(0xffFFCC00)],       /// Optional, The color collections
                                          strokeWidth: 10,
                                          /// Optional, The stroke of the line, only applicable to widget which contains line
                                         // backgroundColor: Colors.black,      /// Optional, Background of the widget
                                          pathBackgroundColor: Color(0xffD9D9D9)  /// Optional, the stroke backgroundColor
                                      ),
                                    ),
                               )),
                              ],
                            ),
                          ),

                        ])
            ))));
  }
}