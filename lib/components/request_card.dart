import 'package:flutter/material.dart';
import '../constants.dart';

class RequestCard extends StatelessWidget {
  final String title;
  final Function onAccept;
  final Function onDecline;
  final bool requestIsAccepted;

  RequestCard(
      {this.title, this.onAccept, this.onDecline, this.requestIsAccepted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.90,
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: kSecondaryColor, width: 2.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kTextStyle,
              ),
              Row(
                children: [
                  SizedBox(width: 10.0),
                  IconButton(
                    splashColor: kSecondaryColor,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.clear_rounded,
                      color: kPrimaryColor,
                    ),
                    onPressed: this.onDecline,
                  ),
                  if (!requestIsAccepted)
                    SizedBox(
                      width: 10.0,
                    ),
                  if (!requestIsAccepted)
                    IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.check_rounded,
                        color: kPrimaryColor,
                      ),
                      onPressed: this.onAccept,
                    ),
                ],
              ),
            ],
          )),
    );
  }
}
