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

dynamic kAppBar(BuildContext context, String text) {
  return AppBar(
    leading: IconButton(
      color: kBackgroundColor,
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: Text(
      text,
      style: kTitleStyle,
    ),
    centerTitle: true,
  );
}

const kTitleStyle =
    TextStyle(fontWeight: FontWeight.bold, color: kBackgroundColor);

void kShowFlushBar(
    {String content, BuildContext context, bool customError = false}) {
  String message = 'UNKOWN ERROR';
  if (customError) {
    message = content;
  } else if (content.contains('email != null')) {
    message = 'Email field empty.';
  } else if (content.contains('password != null')) {
    message = 'Password feild empty.';
  } else if (content.contains('ERROR_INVALID_EMAIL')) {
    message = 'Invalid email.';
  } else if (content.contains('ERROR_WRONG_PASSWORD')) {
    message = 'Invalid password.';
  } else if (content.contains('ERROR_TOO_MANY_REQUESTS')) {
    message = 'Too many invalid requests. Try again later.';
  } else if (content.contains('ERROR_USER_NOT_FOUND')) {
    message = 'No user found with this email. Please SignUp first.';
  } else if (content.contains('ERROR_NAME_FIELD_EMPTY')) {
    message = 'Name field empty.';
  } else if (content.contains('ERROR_ADDRESS_FIELD_EMPTY')) {
    message = 'Address field empty.';
  } else if (content.contains('ERROR_WEAK_PASSWORD')) {
    message = 'Weak password. Must contain atleast 6 characters.';
  } else if (content.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
    message = 'Email already registered. Please SignIn.';
  }
  Flushbar(
    borderRadius: 8,
    borderWidth: 2,
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
