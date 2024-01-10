import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkify/linkify.dart';

import '../Blocs/React Bloc/react_bloc.dart';
import '../Blocs/React Bloc/react_events.dart';

class CRUDPost {

  void create(String postText) async {
    //generate and unique Post ID
    Random random = Random();
    String postID = '';
    const String chars = "0123456789abcdefghijklmnopqrstuvwxyz";
    for (int i = 0; i < 20; i++) {
      postID += chars[random.nextInt(chars.length)];
    }

    //check if the text is there or not
    //if not then add " "
    List texts = [];
    List<LinkifyElement> linkifyItems = linkify(postText);
    for (int i = 1; i < linkifyItems.length; i = i + 2) {
      if (linkifyItems[i] is TextElement) {
        TextElement textElement = linkifyItems[i] as TextElement;
        texts.add(textElement.text);
      }
    }

    if(texts.isEmpty){
      postText = " $postText";
    }

    //Save Post items into PostID
    await FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postID)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'creationTime': DateTime.now(),
      'postText': postText,
      'dislikeCount': 0,
      'likeCount': 0,
      'comments': FieldValue.arrayUnion([]),
      'commentCount': 0,
      'fileLinks': FieldValue.arrayUnion([]),
    });

    //Save PostID at users Profile
    await FirebaseFirestore
        .instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'posts': FieldValue.arrayUnion([postID])
    });
  }

  Future<void> reactionManager(
      String postDocID,
      int reactionToAdd,
      int currentReaction,
      BuildContext context,
      int index
      ) async {
    final provider = BlocProvider.of<ReactBloc>(context);

    //current counting-------------------------------------
    DocumentSnapshot postSnapshot = await FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postDocID).get();
    int likeCount = postSnapshot.get('likeCount');
    int dislikeCount = postSnapshot.get('dislikeCount');
    //------------------------------------------------------

    //like button clicked
    if(reactionToAdd == 1){
      //Already Liked But Wanna Withdraw, then decrease like
      if (currentReaction == 1) {
        likeCount = likeCount - 1;

        changeReaction(postDocID, 0);

        updateLikeCount(postDocID, likeCount);

        provider.add(NeutralEvent(index: index));
      }
      //Already Disliked But Wanna Like, then decrease like and increase dislike
      else if(currentReaction == -1){
        likeCount = likeCount + 1;
        dislikeCount = dislikeCount - 1;

        changeReaction(postDocID, 1);

        updateLikeCount(postDocID, likeCount);
        updateDisLikeCount(postDocID, dislikeCount);

        provider.add(LikeEvent(index: index));
      }
      else if(currentReaction == 0) {
        likeCount = likeCount + 1;
        updateLikeCount(postDocID, likeCount);

        changeReaction(postDocID, 1);

        provider.add(LikeEvent(index: index));
      }
    }
    //dislike button clicked
    else if(reactionToAdd == -1){
      //Already DisLiked But Wanna Withdraw, then decrease DisLiked
      if (currentReaction == -1) {
        dislikeCount = dislikeCount - 1;

        changeReaction(postDocID, 0);

        updateDisLikeCount(postDocID, dislikeCount);
        provider.add(NeutralEvent(index: index));
      }
      //Already Liked But Wanna DisLike, then decrease DisLike and increase Like
      else if(currentReaction == 1){
        dislikeCount = dislikeCount + 1;
        likeCount = likeCount - 1;

        changeReaction(postDocID, -1);

        updateDisLikeCount(postDocID, dislikeCount);
        updateLikeCount(postDocID, likeCount);

        provider.add(DislikeEvent(index: index));
      }
      else if(currentReaction == 0) {
        dislikeCount = dislikeCount + 1;

        changeReaction(postDocID, -1);

        updateDisLikeCount(postDocID, dislikeCount);

        provider.add(DislikeEvent(index: index));
      }
    }

  }

  void changeReaction(String postDocID, int reactionToAdd) async {
    //Add Reaction
    await FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postDocID)
        .collection('reacts')
        .doc(FirebaseAuth.instance.currentUser!.uid).set({
      'react': reactionToAdd
    });
  }

  void updateLikeCount(String postDocID, int likeCount) {
    FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postDocID)
        .update({
      'likeCount': likeCount
    });
  }

  void updateDisLikeCount(String postDocID, int dislikeCount) {
    FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postDocID)
        .update({
      'dislikeCount': dislikeCount
    });
  }

  Future<void> addComment(String postDocID, String commentText, String uid) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postDocID)
        .collection('comments')
        .add({
      'text': commentText,
      'uid': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
    // Update comment count in the 'posts' collection
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postDocID)
        .update({'commentCount': FieldValue.increment(1)});
  }

  Future<void> addReply(String postDocID, String commentDocID, String replyText, String uid) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postDocID)
        .collection('comments')
        .doc(commentDocID)
        .collection('replies')
        .add({
      'text': replyText,
      'uid': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

}