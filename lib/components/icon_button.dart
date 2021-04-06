import 'package:flutter/material.dart';
import '../constants.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Function onPressed;

  CustomIconButton({
    @required this.icon,
    this.color = kPrimaryColor,
    this.size = 24.0,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x00FFFFFF),
      type: MaterialType.circle,
      child: IconButton(
        iconSize: this.size,
        splashColor: kPrimaryColor.withAlpha(150),
        splashRadius: size / 2 + 8.0,
        onPressed: this.onPressed,
        icon: Icon(
          this.icon,
          color: this.color,
        ),
      ),
    );
  }
}
