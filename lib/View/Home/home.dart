import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/Blocs/React%20Bloc/react_bloc.dart';
import 'package:superstate/Blocs/React%20Bloc/react_states.dart';
import 'package:superstate/View/Home/home_appbar.dart';
import 'package:superstate/View/Home/home_floating.dart';
import 'package:superstate/View/Widgets/error.dart';
import 'package:superstate/View/Widgets/postcard.dart';
import 'package:superstate/View/Widgets/skeleton_postcard.dart';

import '../../Blocs/React Bloc/react_events.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReactBloc, ReactState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: const HomeAppBar(),
            floatingActionButton: const HomeFloatingActionButton(),
            body: SingleChildScrollView(
              child: postsWidget(state),
            ),
          ),
        );
      },
    );
  }

  Widget postsWidget(ReactState state) {
    return FutureBuilder(
        future: FirebaseFirestore
            .instance
            .collection('posts')
            .orderBy('creationTime', descending: true).get(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {


                return FutureBuilder(
                    future: FirebaseFirestore
                        .instance
                        .collection('posts')
                        .doc(snapshot.data!.docs[index].id)
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
                        } else if (reaction == 0) {
                          provider.add(NeutralEvent(index: index));
                        } else if (reaction == -1) {
                          provider.add(DislikeEvent(index: index));
                        }

                        return postCard(
                            snapshot.data!.docs[index].id,
                            snapshot.data!.docs[index].get('commentCount'),
                            snapshot.data!.docs[index].get('creationTime'),
                            snapshot.data!.docs[index].get('fileLinks'),
                            snapshot.data!.docs[index].get('postText'),
                            snapshot.data!.docs[index].get('uid'),
                            snapshot.data!.docs[index].get('likeCount'),
                            snapshot.data!.docs[index].get('dislikeCount'),
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

              },
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
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
  }
}
