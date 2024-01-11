import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotification {
  //START FROM HERE---------------------------------------------------------------------------------------------------

  static Future<void> toSpecific(String title, String body, String token, String screen) async{
    try{
      await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=AAAAcStq8jc:APA91bHCAW_jCLAA82sLg0TqT5Xe7LVm1N7qjHJtcCw-1pfE-GJDoGhwnEV_hVOQboprR18CQPBY6W_jNA0NJwhOqujM6oDN-4oPqI22F2yg1ioOYYzpO353BUPqW021mRtIfAbpx1fI'
          },
          body: jsonEncode(
              <String, dynamic> {
                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'status': 'done',
                  'body': body,
                  'title': title,
                  'screen': screen,
                },
                'notification': <String, dynamic>{
                  'body': body,
                  'title': title,
                  'android_channel_id': 'superstate'
                },
                'to': token,
              }
          )
      );
    }catch(e) {
      if(kDebugMode) {
        print('Error in Push Notification');
      }
    }
  }

  static Future<void> toAll(String title, String body, String screen) async{
    CollectionReference collectionReference =
    FirebaseFirestore
        .instance
        .collection('/userData');

    final snapshot = await collectionReference.get();
    for (int i=0; i < snapshot.size; i++) {
      String token = snapshot.docs[i].get('token');
      toSpecific(title, body, token, screen);
    }
  }
//---------------------------------------------------------------------------------------------------
}