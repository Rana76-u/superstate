import 'package:flutter/material.dart';
import 'package:superstate/View/Widgets/navigator.dart';
import 'package:superstate/View/login.dart';
import 'package:superstate/ViewModel/auth_service.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    AuthService().signOut();

                    ScreenNavigator.openScreen(context, const LoginPage(), 'BottomToTop');
                  },
                  child: const Text("Logout")
              )
            ],
          ),
        ),
      ),
    );
  }
}
