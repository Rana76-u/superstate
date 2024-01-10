import 'package:flutter/material.dart';

class Loading{

  Widget centralLinearSized(BuildContext context, double size) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width*size,
        child: const LinearProgressIndicator(),
      ),
    );
  }

  Widget centralDefault(BuildContext context, String type) {
    return Center(
      child: type == 'linear' ? const LinearProgressIndicator() : const CircularProgressIndicator(),
    );
  }

}