import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

                            tabs(posts, state),
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
    return Column(
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
            ] else...[
              StreamBuilder(
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
    );
  }

  Widget tabs(List posts, ReactState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('Posts',),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Connects',),
            ),
          ],
        ),

        ///no issue from bottom bar, but from home
        /*ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          reverse: true,
          itemBuilder: (context, index) {

            return FutureBuilder(
              future: FirebaseFirestore
                  .instance
                  .collection('posts')
                  .doc(posts[index]).get(),
              builder: (context, postSnapshot) {
                if(postSnapshot.hasData){

                  return FutureBuilder(
                    future: FirebaseFirestore
                        .instance
                        .collection('posts')
                        .doc(posts[index])
                        .collection('reacts')
                        .doc(FirebaseAuth.instance.currentUser!.uid).get(),
                    builder: (context, reactSnapshot) {

                      int reaction = 0;

                      final provider = BlocProvider.of<ReactBloc>(context);

                      if(reactSnapshot.connectionState == ConnectionState.waiting){
                        return const SkeletonPostCard();
                      }
                      else if (reactSnapshot.connectionState == ConnectionState.done) {
                        // Check if data has been loaded
                        if (reactSnapshot.hasData && reactSnapshot.data!.exists) {
                          reaction = reactSnapshot.data!.get('react') ?? 0;
                        }

                        if (reaction == 1) {
                          provider.add(LikeEvent(index: index));
                        }
                        else if (reaction == 0) {
                          provider.add(NeutralEvent(index: index));
                        }
                        else if (reaction == -1) {
                          provider.add(DislikeEvent(index: index));
                        }

                        return postCard(
                            posts[index], //id
                            postSnapshot.data!.get('commentCount'),
                            postSnapshot.data!.get('creationTime'),
                            postSnapshot.data!.get('fileLinks'),
                            postSnapshot.data!.get('postText'),
                            postSnapshot.data!.get('uid'),
                            postSnapshot.data!.get('likeCount'),
                            postSnapshot.data!.get('dislikeCount'),
                            reaction, //state.reactList[index]
                            context,
                            state,
                            index
                        );

                      }
                      else{
                        return ShowErrorMessage().central(context, 'Error Loading Data');
                      }

                    },
                  );
                }
                else if(postSnapshot.connectionState == ConnectionState.waiting){
                  return Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.35),
                      //Loading().centralLinearSized(context, 0.4)
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const SkeletonPostCard();
                        },
                      )
                  );
                }
                else {
                  return Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.35),
                      child: ShowErrorMessage().central(context, 'No New Post')
                  );
                }
              },
            );

          },
        ),*/

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
