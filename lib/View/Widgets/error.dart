import 'package:flutter/material.dart';

class ShowErrorMessage {

  Widget central(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
            color: Colors.grey,
            fontSize: 12
        ),
      ),
    );
  }

}