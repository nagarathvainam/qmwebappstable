import 'package:quizmaster/screens/home/components/drawer/custom_list_tile.dart';
import 'package:quizmaster/screens/home/components/drawer/header.dart';
import 'package:flutter/material.dart';
import 'package:quizmaster/constant/constants.dart';
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}
class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = true;
  String version='';
  String displayName="";
  String mobile="";
  String url="";
  @override


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 0, top: 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
          color: Color(0xFFFFFFFF),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: (_isCollapsed)?25:10),
          child:
    SingleChildScrollView(
    child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDrawerHeader(isColapsed: _isCollapsed,name:displayName,mobile:mobile,url:url),
              const Divider(
                color: Colors.grey,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: 'myprofile',
                title: 'My Profile',
                infoCount: 0,
                iscomment:'',
                isarrow:0
              ),
              const Divider(color: Colors.grey),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: 'transaction',
                title: 'Transaction',
                infoCount: 0,
                iscomment:'',
                isarrow:0
              ),
             // const Divider(color: Colors.grey),
             //  CustomListTile(
             //    isCollapsed: _isCollapsed,
             //    icon: 'myqmwallet',
             //    title: 'My QM Wallet',
             //    infoCount: 0,
             //    iscomment:'',
             //    isarrow:0
             //  ),
             //  const Divider(color: Colors.grey),
             //  CustomListTile(
             //    isCollapsed: _isCollapsed,
             //    icon: 'linkedbankaccounts',
             //    title: 'Linked Bank',
             //    infoCount: 0,
             //    iscomment:(Constants.bankCount>0)?'+ Add Bank':'Pending',
             //    isarrow:1
             //  ),
             // // const Divider(color: Colors.grey),
             //  CustomListTile(
             //    isCollapsed: _isCollapsed,
             //    icon: 'referralcode',
             //    title: 'Referral Code',
             //    infoCount: 0,
             //    iscomment:'',
             //    isarrow:0
             //  ),
              // const Divider(color: Colors.grey),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: 'kyc',
              //   title: 'KYC',
              //   infoCount: 0,
              //   iscomment:Constants.kyCcomment,
              //   isarrow:1
              // ),
            /*  const Divider(color: Colors.grey),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: 'gamepolocy',
                title: 'Game Policy',
                infoCount: 0,
                iscomment:'',
                isarrow:0
              ),

              const Divider(color: Colors.grey),
              CustomListTile(
                  isCollapsed: _isCollapsed,
                  icon: 'gamepolocy',
                  title: 'Privacy Policy',
                  infoCount: 0,
                  iscomment:'',
                  isarrow:0
              ),

              const Divider(color: Colors.grey),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: 'termsofuse',
                title: 'Terms Of Use',
                infoCount: 0,
                iscomment:'',
                isarrow:0
              ),

              const Divider(color: Colors.grey),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: 'helpdesk',
                title: 'Help Desk',
                infoCount: 0,
                iscomment:'',
                isarrow:0
              ),*/
              const Divider(color: Colors.grey),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: 'settings',
                title: 'Settings',
                infoCount: 0,
                iscomment:'',
                isarrow:0
              ),
              // const Divider(color: Colors.grey),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: 'rateus',
              //   title: 'Rate Us',
              //   infoCount: 0,
              //   iscomment:'',
              //   isarrow:0
              // ),
              const Divider(color: Colors.grey),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: 'logout',
                title: 'Logout',
                infoCount: 0,
                iscomment:'',
                isarrow:0
              ),
              const SizedBox(height: 10),
              Row(
                children:  <Widget>[
                  (_isCollapsed)? Expanded(
                    child: Text("Version - "+Constants.releaesversion),
                  ):SizedBox(),
                  Align(
                    alignment: _isCollapsed
                        ? Alignment.bottomRight
                        : Alignment.bottomCenter,
                    child:
                    IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(
                        _isCollapsed
                            ? Icons.arrow_back_ios
                            : Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 14,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCollapsed = !_isCollapsed;
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
