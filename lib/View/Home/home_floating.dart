import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:superstate/View/Create%20Post/create_post.dart';
import 'package:superstate/View/Widgets/navigator.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, //60
      width: 150, //200
      child: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {
            //open create post screen
            ScreenNavigator.openScreen(context, const CreatePostScreen(), 'BottomToTop');
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          label: const Text(
            'Create Post',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          icon: const Icon(
              MingCute.classify_add_2_fill,//Icons.post_add_rounded classify_add_2_fill
          ),
        ),
      ),
    );
  }
}
