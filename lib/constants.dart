import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFFFEA848);
const Color kSecondaryColor = Color(0xFF353535);
const Color kBackgroundColor = Color(0xFFFFF7F1);

const kHeadingStyle = TextStyle(
  fontSize: 60.0,
  fontWeight: FontWeight.bold,
  color: kSecondaryColor,
);

const kTextStyle = TextStyle(
  fontSize: 16.0,
  color: kSecondaryColor,
  fontFamily: 'Proxima Nova',
);

const kTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: kBackgroundColor,
);

Widget kAppBar(
    {BuildContext context, Widget title, Icon icon, Function pressed}) {
  return AppBar(
    backgroundColor: kSecondaryColor,
    leading: IconButton(
      color: kBackgroundColor,
      icon: icon,
      onPressed: pressed,
    ),
    title: title,
    centerTitle: true,
  );
}

void kShowFlushBar(
    {String content, BuildContext context, bool customError = false}) {
  String message = 'UNKOWN ERROR';
  if (customError) {
    message = content;
  } else if (content.contains('ERROR_EMAIL_FIELD_EMPTY')) {
    message = 'Please enter your email.';
  } else if (content.contains('ERROR_PASSWORD_FIELD_EMPTY')) {
    message = 'Please enter your password.';
  } else if (content.contains('ERROR_ADDRESS_FIELD_EMPTY')) {
    message = 'Please add your location.';
  } else if (content.contains('ERROR_CONFIRM_PASSWORD_FIELD_EMPTY')) {
    message = 'Please confirm your password.';
  } else if (content.contains('ERROR_INVALID_EMAIL')) {
    message = 'Your email seems to be invalid.';
  } else if (content.contains('ERROR_WRONG_PASSWORD')) {
    message = 'Your password seems to be invalid.';
  } else if (content.contains('ERROR_TOO_MANY_REQUESTS')) {
    message = 'Too many invalid requests. Please try again later.';
  } else if (content.contains('ERROR_USER_NOT_FOUND')) {
    message = 'No user found with this email. Please SignUp first.';
  } else if (content.contains('ERROR_NAME_FIELD_EMPTY')) {
    message = 'Please enter your name.';
  } else if (content.contains('ERROR_WEAK_PASSWORD')) {
    message = 'Your password is weak. Please enter atleast 6 characters.';
  } else if (content.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
    message =
        'There is already an account with this email. Please SignIn instead.';
  } else if (content.contains('ERROR_PASSWORD_MISSMATCH')) {
    message = 'The passwords do not match.';
  } else if (content.contains('ERROR_ADDRESS_NOT_FOUND')) {
    message = 'Sorry, but we couldn\'t find the address. Please try again.';
  }
  Flushbar(
    borderRadius: 8.0,
    borderWidth: 2.0,
    borderColor: kSecondaryColor,
    margin: EdgeInsets.all(10.0),
    backgroundColor: kBackgroundColor,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    messageText: Text(
      message,
      style: kTextStyle.copyWith(
        color: kSecondaryColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    duration: Duration(seconds: 4),
  )..show(context);
}
//This is constant file
