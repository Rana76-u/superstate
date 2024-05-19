import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superstate/View/Widgets/profile_image.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        '#Repost',
        style: TextStyle(
          fontSize: 25,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
          fontFamily: 'Anurati'
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: profileImage(FirebaseAuth.instance.currentUser!.photoURL ?? '', 35, 35),
        ),
      ],
    );
  }
}
