import 'package:flutter/material.dart';
class BottomUserInfo extends StatelessWidget {
  final bool isCollapsed;
  const BottomUserInfo({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCollapsed ? 70 : 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCollapsed
          ? Center(
              child:
              Expanded(
        child:Row(
                children: const [
                  Spacer(),
                ],
              ),
            ))
          : SizedBox(),
    );
  }
}
