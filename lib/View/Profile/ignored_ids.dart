import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/error.dart';
import '../Widgets/loading.dart';
import '../Widgets/profile_image.dart';

class IgnoredIdsPage extends StatelessWidget {
  const IgnoredIdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ignored IDs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection('userData')
            .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          List<dynamic> myIgnoredIds = snapshot.data!.get('ignoredIds') ?? [];

          if(snapshot.hasData){
            return ListView.builder(
              itemCount: myIgnoredIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: FirebaseFirestore
                      .instance
                      .collection('userData')
                      .doc(myIgnoredIds[index])
                      .get(),
                  builder: (context, userSnapshot) {
                    if(userSnapshot.hasData){

                      String name = userSnapshot.data!.get('name');
                      String email = userSnapshot.data!.get('email');
                      String phoneNumber = userSnapshot.data!.get('phoneNumber') ?? '';
                      String imageURL = userSnapshot.data!.get('imageURL');

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileImage(
                              imageURL,
                              60,
                              60,
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21
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

                            const Spacer(),

                            TextButton(
                              onPressed: () async {
                                final messenger = ScaffoldMessenger.of(context);

                                await FirebaseFirestore.instance
                                    .collection('userData')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({'ignoredIds': FieldValue.arrayRemove([myIgnoredIds[index]])});

                                messenger.showSnackBar(
                                    const SnackBar(
                                        content: Text('ID Unblocked')
                                    )
                                );
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade100)
                              ),
                              child: const Text(
                                'Unblock',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:  Colors.deepOrange
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    else if(userSnapshot.connectionState == ConnectionState.waiting){
                      return Loading().centralDefault(context, 'Linear');
                    }
                    else{
                      return ShowErrorMessage().central(context, 'Error Occurred');
                    }
                  },
                );
              },
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
    );
  }
}
