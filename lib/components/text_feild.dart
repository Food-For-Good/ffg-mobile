import 'package:flutter/material.dart';
import 'package:FoodForGood/constants.dart';

class CustomTextFeild extends StatelessWidget {
  final label;
  final kbType;
  final isPass;
  final prefixIcon;
  final textCap;
  final changed;
  final lines;
  CustomTextFeild({
    this.label = 'button',
    this.kbType = TextInputType.text,
    this.isPass = false,
    this.prefixIcon = Null,
    this.textCap = TextCapitalization.none,
    this.changed = Null,
    this.lines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: lines,
      onChanged: changed,
      cursorColor: kPrimaryColor,
      textCapitalization: textCap,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 15.0,
          color: kSecondaryColor.withAlpha(150),
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
            width: 2.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
            width: 2.5,
          ),
        ),
      ),
      keyboardType: kbType,
      obscureText: isPass,
    );
  }
}
