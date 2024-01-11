import 'package:cloud_firestore/cloud_firestore.dart';

class TimeModifier {
  String calculator(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    String twoDigits(int n) => n.abs().toString().padLeft(2, '0');
    int inHours = difference.inHours;

    if (inHours < 1) {
      int inMinutes = difference.inMinutes.remainder(60);
      return '$inMinutes minute${inMinutes == 1 ? '' : 's'} ago';
    } else if (inHours < 24) {
      int inMinutes = difference.inMinutes.remainder(60);
      return '$inHours hour${inHours == 1 ? '' : 's'} $twoDigits(inMinutes) minute${inMinutes == 1 ? '' : 's'} ago';
    } else if (inHours < 24 * 7) {
      int inDays = difference.inDays;
      return '$inDays day${inDays == 1 ? '' : 's'} ago';
    } else if (inHours < 24 * 7 * 3) {
      int inWeeks = (difference.inDays / 7).floor();
      return '$inWeeks week${inWeeks == 1 ? '' : 's'} ago';
    } else {
      // If it's over 3 weeks, show the post's original datetime
      // Adjust the format according to your needs
      return 'Posted on ${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
    }
  }
}