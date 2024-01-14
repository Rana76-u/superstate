import 'package:flutter/material.dart';

class ScreenNavigator {

  static void openScreen(BuildContext context, Widget screen, String transition) {

    double dx = 0;
    double dy = 1;

    Offset offset = Offset(dx, dy);

    if(transition == 'RightToLeft'){
      dx = 1;
      dy = 0;
      offset = Offset(dx, dy);
    }
    else if(transition == 'LeftToRight'){
      dx = -1;
      dy = 0;
      offset = Offset(dx, dy);
    }
    else if(transition == 'BottomToTop'){
      dx = 0;
      dy = 1;
      offset = Offset(dx, dy);
    }

    Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = offset; //0 1
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        )
    );
  }

  static void closeScreen(BuildContext context){
    Navigator.of(context).pop();
  }

}