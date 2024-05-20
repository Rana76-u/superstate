import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Blocs/React Bloc/react_bloc.dart';
import '../../Blocs/React Bloc/react_events.dart';
import '../../Blocs/React Bloc/react_states.dart';
import '../Widgets/error.dart';
import '../Widgets/postcard.dart';
import '../Widgets/skeleton_postcard.dart';

class MyPosts extends StatelessWidget {
  final List posts;
  final ReactState state;
  const MyPosts({super.key, required this.posts, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: ListView.builder(
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
      ),
    );
  }
}
