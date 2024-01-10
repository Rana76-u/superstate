import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/Blocs/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:superstate/Blocs/Bottom%20Navigation%20Bloc/bottom_navigation_events.dart';
import 'package:superstate/View/Widgets/bottom_nav_bar.dart';
import 'package:superstate/View/Widgets/navigator.dart';
import 'package:superstate/ViewModel/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _checkAndSaveUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;

    final userData = await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    if (!userData.exists) {
      // Save user data if the user is new
      await FirebaseFirestore.instance.collection('userData').doc(uid).set({
        'name' : FirebaseAuth.instance.currentUser!.displayName,
        'imageURL' : FirebaseAuth.instance.currentUser!.photoURL,
        'email': FirebaseAuth.instance.currentUser!.email,
        'phoneNumber': FirebaseAuth.instance.currentUser!.phoneNumber,
        'gender': 'not selected',
        'posts': FieldValue.arrayUnion([])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height*0.4)); //rect.width rect.height
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/world-map-dotted.jpg',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height*0.5,
                  width: double.infinity,
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).size.height*0.32,
                left: 30,
                child: const Text(
                  'SuperState',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),

            ],
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {
                //Firebase Login
                AuthService().signInWithGoogle().then((_) {
                  _checkAndSaveUser();
                  BlocProvider.of<BottomBarBloc>(context)
                      .add(IndexChange(currentIndex: 0));
                  ScreenNavigator.openScreen(
                      context,
                      const BottomBar(),
                    'RightToLeft'
                  );
                });
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login / Signup',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

        ],
      ),
    );
  }
}
