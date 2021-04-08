import 'package:FoodForGood/components/icon_button.dart';
import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class RequestCard extends StatefulWidget {
  final String title;
  final Function onAccept;
  final Function onDecline;
  final String requestState;
  final String myEmail, otherPersonEmail;

  RequestCard(
      {this.title,
      this.onAccept,
      this.onDecline,
      this.requestState,
      @required this.myEmail,
      @required this.otherPersonEmail});

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          // height: 60.0,
          width: MediaQuery.of(context).size.width * 0.90,
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: kSecondaryColor, width: 2.0)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // color: Colors.redAccent,
                    width: 180.0,
                    child: FittedBox(
                      child: Text(
                        widget.title,
                        style: kTextStyle,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      if (widget.requestState == requestStatePending)
                        CustomIconButton(
                          icon: Icons.clear_rounded,
                          onPressed: this.widget.onDecline,
                        ),
                      // if (requestState != requestStateAccepted)
                      //   SizedBox(
                      //     width: 10.0,
                      //   ),
                      if (widget.requestState != requestStateCompleted)
                        CustomIconButton(
                          icon: Icons.check_rounded,
                          onPressed: this.widget.onAccept,
                        ),
                      if (widget.requestState == requestStateCompleted)
                        Text('Food handed over',
                            style: kTextStyle.copyWith(
                                color: kPrimaryColor, fontSize: 12.0))
                    ],
                  ),
                ],
              ),
              if (isExpanded)
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Email: ',
                                  style: kTextStyle.copyWith(
                                    fontSize: 14.0,
                                    color: kSecondaryColor.withAlpha(950),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'abcdef',
                                  style: kTextStyle.copyWith(
                                    fontSize: 14.0,
                                    color: kSecondaryColor.withAlpha(950),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  'Rating: ',
                                  style: kTextStyle.copyWith(
                                    fontSize: 14.0,
                                    color: kSecondaryColor.withAlpha(950),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'abcdef',
                                  style: kTextStyle.copyWith(
                                    fontSize: 14.0,
                                    color: kSecondaryColor.withAlpha(950),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                      CustomIconButton(
                        icon: Icons.chat,
                        size: 30.0,
                        onPressed: () {
                          // Navigator.pushNamed(context, '/chat');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                myEmail: widget.myEmail,
                                otherPersonEmail: widget.otherPersonEmail,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
