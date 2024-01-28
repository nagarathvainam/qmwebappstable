import 'package:flutter/material.dart';
import 'package:quizmaster/constant/constants.dart';
class CustomAppBarWrongAnswer extends StatelessWidget implements PreferredSizeWidget {

  Color _colorFromHex(String hexColor) {
    final hexCode = (hexColor!=null)?hexColor.replaceAll('#', ''):'2A7ABC';
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  final Widget child;
  final double height;
  final String photo;
  final String page;
  CustomAppBarWrongAnswer({
    required this.child,
    this.height = kToolbarHeight,
    required this.photo,
    required this.page
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [

(page=='timesup')?
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFFEC008B),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.green,
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
        ):SizedBox(),
        (page=='timesup')?Positioned(
          top:125,
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
        ):SizedBox(),
        // Body of Text Start



        (page=='almost')?
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF1D5997),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Color(0xFF1D5997),
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
        ):SizedBox(),
        (page=='almost')?Positioned(
          top:125,
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
        ):SizedBox(),


        (page=='almost')?Container(
            padding: EdgeInsets.only(top: 35.0),

            child:
            Row(
              children:  <Widget>[
                SizedBox(width: 10.0,),
                Image.asset("assets/icons/almost-thumsup.png"),
                Expanded(child: Padding(padding: EdgeInsets.only(right: 75.0),
                    child:Text("Uh! Oh! \nAlmost there",textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize: 24,fontWeight: FontWeight.bold,),))),

              ],
            )):SizedBox(),
        // Body of Text End



        (page=='timesup')?Container(
padding: EdgeInsets.only(top: 35.0),

          child:
        Row(
          children:  <Widget>[
SizedBox(width: 10.0,),
            Image.asset("assets/times-up-sand-clock.png"),
           Expanded(child: Padding(padding: EdgeInsets.only(right: 75.0),
               child:Text("Uh! Oh! \nTime’s up",textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize: 24,fontWeight: FontWeight.bold,),))),

          ],
        )):SizedBox(),
        // Body of Text End





        (page=='correct')?Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/winner-start-stack.png"),
            ),
            color: _colorFromHex(Constants.baseThemeColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.green,
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
        ):SizedBox(),
        (page=='correct')?Positioned(
          top:125,
          child: SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children:  [
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
        ):SizedBox(),
        // Body of Text Start
        (page=='correct')?Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            Padding(padding:EdgeInsets.only(right: 20.0,top: 20.0),
                child: Image.asset("assets/congratulation-cup.png")),

            Padding(padding:EdgeInsets.only(right: 50.0,top: 30.0),
                child:Text("Congratulations!",style: TextStyle(color:Colors.white,fontSize: 24,fontWeight: FontWeight.bold),)),

          ],
        ):SizedBox(),
        // Body of Text End




        (page=='wrong')?Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFFBD0B00),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.green,
                  spreadRadius: 1,
                  blurRadius: 1),
            ],
          ),
        ):SizedBox(),
        (page=='wrong')?Positioned(
          top:125,
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
        ):SizedBox(),
        // Body of Text Start



        (page=='wrong')?Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            Padding(padding:EdgeInsets.only(right: 0.0,top: 20.0),
                child: SizedBox(width:100,child:Image.asset("assets/wrong.png"))),

            Padding(padding:EdgeInsets.only(right: 90.0,top: 30.0),
                child:Align(alignment:Alignment.center,child:Text("Uh! Oh! \nIncorrect Answer",textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize: 24,fontWeight: FontWeight.bold,),))),

          ],
        ):SizedBox()


      ],
    );
  }
}