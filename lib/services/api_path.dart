import 'package:flutter/material.dart';

class APIPath {
  static String listing() => 'Listings';
  static String user() => 'users';
  static String chat({@required String uid, @required String chatWith}) => '/users/$uid/chats/$chatWith/messages';
}
