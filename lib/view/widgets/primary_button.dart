import 'package:flutter/material.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrimaryButtion extends StatefulWidget {
  PrimaryButtion({super.key, this.onPressed, this.buttonText});
  final Function()? onPressed;
  String? buttonText;
  @override
  State<PrimaryButtion> createState() => _PrimaryButtionState();
}

class _PrimaryButtionState extends State<PrimaryButtion> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Adaptive.w(80),
      height: Adaptive.h(6),
      child: ElevatedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Text(widget.buttonText!,
                    style: TextStyle(
                        fontSize: Adaptive.px(14), color: kbackgroundColor)),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: Adaptive.px(20),
                  color: kbackgroundColor,
                )
              ],
            ),
          ),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(kprimaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ))),
          onPressed: widget.onPressed),
    );
  }
}
