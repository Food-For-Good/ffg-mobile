import 'package:flutter/material.dart';
import 'package:FoodForGood/constants.dart';

class CustomTextFeild extends StatelessWidget {
  final Function changed;
  final bool isPass;
  final TextInputType kbType;
  final String label;
  final Icon prefixIcon;
  final TextCapitalization textCap;
  final TextEditingController editingController;

  final int lines;
  CustomTextFeild({
    this.changed,
    this.isPass = false,
    this.kbType = TextInputType.text,
    this.label = 'button',
    this.prefixIcon,
    this.textCap = TextCapitalization.none,
    this.lines = 1,
    this.editingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: lines,
      onChanged: changed,
      cursorColor: kPrimaryColor,
      textCapitalization: textCap,
      controller: editingController,
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
