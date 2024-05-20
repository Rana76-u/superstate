import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/View/Profile/ignored_ids.dart';
import 'package:superstate/View/Profile/my_posts.dart';
import 'package:superstate/View/Widgets/error.dart';
import 'package:superstate/View/Widgets/loading.dart';
import 'package:superstate/View/Widgets/navigator.dart';
import 'package:superstate/View/Widgets/profile_image.dart';
import 'package:superstate/View/login.dart';
import 'package:superstate/ViewModel/auth_service.dart';

import '../../Blocs/React Bloc/react_bloc.dart';
import '../../Blocs/React Bloc/react_states.dart';

class Profile extends StatelessWidget {
  final String uid;
  const Profile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReactBloc, ReactState>(
        listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Profile',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),
            actions: [
              if(uid == FirebaseAuth.instance.currentUser!.uid)...[
                logoutButton(context)
              ]
            ],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  FutureBuilder(
                    future: FirebaseFirestore
                        .instance
                        .collection('userData')
                        .doc(uid)
                        .get(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){

                        String name = snapshot.data!.get('name');
                        String email = snapshot.data!.get('email');
                        String phoneNumber = snapshot.data!.get('phoneNumber') ?? '';
                        String imageURL = snapshot.data!.get('imageURL');
                        List posts = snapshot.data!.get('posts') ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            info(imageURL, name, email, phoneNumber, context),

                            tabs(posts, state, context),
                          ],
                        );
                      }
                      else if(snapshot.connectionState == ConnectionState.waiting){
                        return Loading().centralDefault(context, 'Linear');
                      }
                      else{
                        return ShowErrorMessage().central(context, 'Error Occurred');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget info(String imageURL, String name, String email, String phoneNumber, BuildContext context){
    return Expanded(
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profileImage(
                  imageURL,
                  100,
                  100,
                ),

                if(uid == FirebaseAuth.instance.currentUser!.uid)...[
                  TextButton(
                  onPressed: (){},
                  child: const Text('Edit'),
                  )
                ]
                else...[
                  SizedBox(
                    height: 40,
                    width: 90,
                    child: StreamBuilder(
                      stream: FirebaseFirestore
                          .instance
                          .collection('userData')
                          .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                      builder: (context, snapshot) {
                        List<dynamic> myIgnoredIds = snapshot.data!.get('ignoredIds');

                        return TextButton(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);

                            if(myIgnoredIds.contains(uid)){
                              await FirebaseFirestore.instance
                                  .collection('userData')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({'ignoredIds': FieldValue.arrayRemove([uid])});

                              messenger.showSnackBar(
                                  const SnackBar(
                                      content: Text('ID Unblocked')
                                  )
                              );
                            }
                            else{
                              await FirebaseFirestore.instance
                                  .collection('userData')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({'ignoredIds': FieldValue.arrayUnion([uid])});

                              messenger.showSnackBar(
                                  const SnackBar(
                                      content: Text('ID Ignored')
                                  )
                              );
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: myIgnoredIds.contains(uid) ?
                              MaterialStateColor.resolveWith((states) => Colors.grey.shade100)
                                  : MaterialStateColor.resolveWith((states) => Colors.deepOrange)
                          ),
                          child: Text(
                            myIgnoredIds.contains(uid) ? 'Unblock' : "Ignore",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: myIgnoredIds.contains(uid) ? Colors.deepOrange : Colors.white
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ],
            ),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                ),
                Text(
                  email,
                ),
                Text(
                  phoneNumber,
                ),

              ],
            ),
          ),

          Divider(
            thickness: 0.5,
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
  }

  Widget tabs(List posts, ReactState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                ScreenNavigator.openScreen(context, MyPosts(posts: posts, state: state), "RightToLeft");
              },
              child: const Text('Posts',),
            ),
            if(uid == FirebaseAuth.instance.currentUser!.uid)...[
              TextButton(
                onPressed: () {
                  ScreenNavigator.openScreen(context, const IgnoredIdsPage(), 'RightToLeft');
                },
                child: const Text('Ignored IDs',),
              )
            ]
          ],
        ),
      ],
    );
  }

  Widget logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AuthService().signOut();

        ScreenNavigator.openScreen(context, const LoginPage(), 'BottomToTop');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(25)
            ),
            child: const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                child: Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                )
            )
        ),
      ),
    );
  }
}
