import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:superstate/View/Widgets/postcard.dart';
import 'package:superstate/View/Widgets/profile_image.dart';
import 'package:superstate/ViewModel/crud_post.dart';

import '../../Blocs/React Bloc/react_states.dart';
import '../Widgets/error.dart';
import '../Widgets/loading.dart';

class ViewPostScreen extends StatelessWidget {
  String postDocID;
  int commentCount;
  Timestamp creationTime;
  List<dynamic> fileLinks;
  String postText;
  String uid;
  int likeCount;
  int dislikeCount;
  int reaction;
  ReactState state;
  int index;
  ViewPostScreen({
    super.key, required this.postDocID, required this.commentCount,
    required this.creationTime, required this.fileLinks, required this.postText,
    required this.uid, required this.likeCount, required this.dislikeCount,
    required this.reaction, required this.state, required this.index,
  });

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Display Post Info
                  postCard(
                      postDocID, commentCount, creationTime,
                      fileLinks, postText, uid,
                      likeCount, dislikeCount,
                      reaction, context, state, index),

                  // Display Comments
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postDocID)
                        .collection('comments')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      var comments = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return commentWidget(comments[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          commentTextBox(context)
        ],
      ),
    );
  }

  // Comment Widget
  Widget commentWidget(DocumentSnapshot commentSnapshot) {
    DateTime dateTime = commentSnapshot['timestamp'].toDate();
    Duration difference = DateTime.now().difference(dateTime);

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.abs().toString().padLeft(2, '0');
      int inHours = duration.inHours;

      if (inHours < 1) {
        int inMinutes = duration.inMinutes.remainder(60);
        return '$inMinutes minute${inMinutes == 1 ? '' : 's'} ago';
      } else if (inHours < 24) {
        int inMinutes = duration.inMinutes.remainder(60);
        return '$inHours hour${inHours == 1 ? '' : 's'} $twoDigits(inMinutes) minute${inMinutes == 1 ? '' : 's'} ago';
      } else if (inHours < 24 * 7) {
        int inDays = duration.inDays;
        return '$inDays day${inDays == 1 ? '' : 's'} ago';
      } else if (inHours < 24 * 7 * 3) {
        int inWeeks = (duration.inDays / 7).floor();
        return '$inWeeks week${inWeeks == 1 ? '' : 's'} ago';
      } else {
        // If it's over 3 weeks, show the post's original datetime
        // Adjust the format according to your needs
        return 'Posted on ${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
      }
    }

    String comment = commentSnapshot['text'];

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('userData').doc(commentSnapshot['uid']).get(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user image
                Padding(
                  padding: const EdgeInsets.only(right: 5, top: 10),
                  child: profileImage(snapshot.data!.get('imageURL'), 30, 30),
                ),
                Expanded(
                  child: Column(
                    children: [
                      //comment
                      Container(
                        width: MediaQuery.of(context).size.width, //15 + 5 + 30 + 10 = 60
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.get('name'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                            ),
                            Text(
                              formatDuration(difference),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 9
                              ),
                            ),
                            Text(
                              comment,
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 11
                              ),
                            ),
                          ],
                        ),
                      ),
                      //replies
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postDocID)
                            .collection('comments')
                            .doc(commentSnapshot.id)
                            .collection('replies')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, replySnapshot) {
                          if (!replySnapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          var replies = replySnapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: replies.length,
                            itemBuilder: (context, index) {
                              return replyWidget(replies[index]);
                            },
                          );
                        },
                      ),
                      //textBox
                      replyTextBox(context, commentSnapshot.id)
                    ],
                  ),
                ),
                const Expanded(flex: 0,child: SizedBox()),
              ],
            ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return Loading().centralDefault(context, 'linear');
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

// Reply Widget
  Widget replyWidget(DocumentSnapshot replySnapshot) {
    DateTime dateTime = replySnapshot['timestamp'].toDate();
    Duration difference = DateTime.now().difference(dateTime);

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.abs().toString().padLeft(2, '0');
      int inHours = duration.inHours;

      if (inHours < 1) {
        int inMinutes = duration.inMinutes.remainder(60);
        return '$inMinutes minute${inMinutes == 1 ? '' : 's'} ago';
      } else if (inHours < 24) {
        int inMinutes = duration.inMinutes.remainder(60);
        return '$inHours hour${inHours == 1 ? '' : 's'} $twoDigits(inMinutes) minute${inMinutes == 1 ? '' : 's'} ago';
      } else if (inHours < 24 * 7) {
        int inDays = duration.inDays;
        return '$inDays day${inDays == 1 ? '' : 's'} ago';
      } else if (inHours < 24 * 7 * 3) {
        int inWeeks = (duration.inDays / 7).floor();
        return '$inWeeks week${inWeeks == 1 ? '' : 's'} ago';
      } else {
        // If it's over 3 weeks, show the post's original datetime
        // Adjust the format according to your needs
        return 'Posted on ${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
      }
    }

    String comment = replySnapshot['text'];

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('userData').doc(replySnapshot['uid']).get(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user image
                Padding(
                  padding: const EdgeInsets.only(right: 5, top: 10),
                  child: profileImage(snapshot.data!.get('imageURL'), 30, 30),
                ),
                //replies
                Container(
                  //width: MediaQuery.of(context).size.width, //15 + 5 + 30 + 10 = 60
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.get('name'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                      ),
                      Text(
                        formatDuration(difference),
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 9
                        ),
                      ),
                      Text(
                        comment,
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 11
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return Loading().centralDefault(context, 'linear');
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

  // Text box and button for commenting
  Widget commentTextBox(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 15, bottom: 8, top: 5),
        child: Row(
          children: [
            Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 55, // 10 + 15 + 25 + 5 = 55
                decoration: BoxDecoration(
                 color: Colors.grey.shade100,
                 borderRadius: BorderRadius.circular(20)
               ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                      child: profileImage(FirebaseAuth.instance.currentUser!.photoURL ?? '', 25, 25)),
                  //TextField
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        //minHeight: 35, //135
                          maxHeight: 300
                      ),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: commentController,
                        style: const TextStyle(
                            overflow: TextOverflow.clip,
                            fontSize: 12
                        ),
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          contentPadding: EdgeInsets.only(left: 10, top: 5, bottom: 5,),
                          hintText: 'Add Comment',
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Space
            const SizedBox(width: 5,),

            //Send Button
            GestureDetector(
              onTap: () {
                CRUDPost().addComment(postDocID, commentController.text, uid);
                commentController.clear();
              },
                child: const Icon(
                    MingCute.send_line,
                  size: 25,
                )
            )
          ],
        ),
      );
  }

  // Text box and button for commenting
  Widget replyTextBox(BuildContext context, String commentDocID) {

    TextEditingController replyController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15, bottom: 8, top: 5),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width - 140, // 10 + 15 + 25 + 5 = 55 + 65
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: profileImage(FirebaseAuth.instance.currentUser!.photoURL ?? '', 20, 20)),
                //TextField
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      //minHeight: 35, //135
                        maxHeight: 300
                    ),
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: replyController,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: 12
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        contentPadding: EdgeInsets.only(left: 10, top: 5, bottom: 5,),
                        hintText: 'Add Reply',
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Space
          const SizedBox(width: 5,),

          //Send Button
          GestureDetector(
              onTap: () {
                CRUDPost().addReply(postDocID, commentDocID, replyController.text, uid);
                replyController.clear();
              },
              child: const Icon(
                MingCute.send_line,
                size: 25,
              )
          )
        ],
      ),
    );
  }
}
