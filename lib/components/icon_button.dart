import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double size;
  final Function onPressed;

  CustomIconButton({this.color, this.icon, this.size, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Icon(this.icon, color: this.color, size: this.size),
      ),
    );
  }
}
