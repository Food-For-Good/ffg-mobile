import 'package:flutter/material.dart';
import 'package:FoodForGood/constants.dart';

class CustomTextFeild extends StatefulWidget {
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
  _CustomTextFeildState createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.lines,
      onChanged: widget.changed,
      cursorColor: kPrimaryColor,
      textCapitalization: widget.textCap,
      controller: widget.editingController,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffix: widget.isPass
            ? Container(
                width: 45.0,
                height: 15.0,
                child: FlatButton(
                  child: Icon(
                    this.passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: kSecondaryColor.withAlpha(150),
                  ),
                  onPressed: () {
                    setState(() {
                      this.passwordVisible = !this.passwordVisible;
                    });
                  },
                  splashColor: Colors.transparent,
                ),
              )
            : null,
        labelText: widget.label,
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
      keyboardType: widget.kbType,
      obscureText: widget.isPass && !this.passwordVisible,
    );
  }
}
