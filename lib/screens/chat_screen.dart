import 'package:FoodForGood/components/icon_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final database = FirestoreDatabase();
  String newMsg = '';
  final _textController = TextEditingController();

  Widget getChats() {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection(
                      '/users/pateldhruv0248@gmail.com/chats/dhruvpatel.ict.17@gmail.com/messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = snapshot.data.documents;
                return ListView.builder(
                  reverse: true,
                  itemCount: documents.length,
                  itemBuilder: (ctx, index) => MsgBubble(
                    msg: documents[index]['msg'],
                    isByMe: (documents[index]['msgBy'] ==
                        futureSnapshot.data.email),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: kAppBar(
          context: context,
          title: Text('Chat', style: kTitleStyle),
          icon: Icon(Icons.arrow_back_ios),
          pressed: () {
            Navigator.pop(context);
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: getChats(),
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              // color: kSecondaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    // width: 250.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomTextFeild(
                        editingController: _textController,
                        label: 'Message',
                        kbType: TextInputType.multiline,
                        lines: 2,
                        prefixIcon: Icon(
                          Icons.description,
                          color: kSecondaryColor,
                        ),
                        changed: (value) {
                          this.newMsg = value;
                        },
                        textCap: TextCapitalization.sentences,
                      ),
                    ),
                  ),
                  CustomIconButton(
                    icon: Icons.send,
                    size: 35.0,
                    onPressed: () async {
                      final user = await FirebaseAuth.instance.currentUser();
                      if (this.newMsg.trim().isNotEmpty) {
                        await Firestore.instance
                            .collection(
                                '/users/pateldhruv0248@gmail.com/chats/dhruvpatel.ict.17@gmail.com/messages')
                            .add({
                          'msg': this.newMsg,
                          'msgBy': user.email,
                          'createdAt': Timestamp.now(),
                        });
                        await Firestore.instance
                            .collection(
                                '/users/dhruvpatel.ict.17@gmail.com/chats/pateldhruv0248@gmail.com/messages')
                            .add({
                          'msg': this.newMsg,
                          'msgBy': user.email,
                          'createdAt': Timestamp.now(),
                        });
                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MsgBubble extends StatelessWidget {
  const MsgBubble({
    Key key,
    @required this.msg,
    this.isByMe,
  }) : super(key: key);

  final String msg;
  final bool isByMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: isByMe ? kSecondaryColor : kPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          width: MediaQuery.of(context).size.width * 0.7,
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(12.0),
          child: Text(
            msg,
            style: kTextStyle.copyWith(color: kBackgroundColor),
          ),
        ),
      ],
    );
  }
}
