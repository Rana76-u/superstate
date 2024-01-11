import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superstate/View/Widgets/profile_image.dart';
import 'package:superstate/ViewModel/time_modifier.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('notifications').get(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {

                String uid = snapshot.data!.docs[index].get('uid');

                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: FutureBuilder(
                    future: FirebaseFirestore
                        .instance
                        .collection('userData')
                        .doc(uid).get(),
                    builder: (context, userSnapshot) {
                      if(userSnapshot.hasData){

                        //String userName = userSnapshot.data!.get('name');
                        String title = snapshot.data!.docs[index].get('title');
                        String description = snapshot.data!.docs[index].get('description');
                        Timestamp timestamp = snapshot.data!.docs[index].get('timestamp');

                        return ListTile(
                          tileColor: Colors.blue.shade400.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          leading: profileImage(userSnapshot.data!.get('imageURL'), 45, 45),
                          title: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Urbanist'
                                ),
                                children: <TextSpan>[
                                  //TextSpan(text: userName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)),
                                  //const TextSpan(text: ' posted ', style: TextStyle(color: Colors.black)),
                                  TextSpan(text: title, style: const TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold,))
                                ],
                              ),
                            ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                TimeModifier().calculator(timestamp),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            return const Center(
              child: Text('Error Loading Data'),
            );
          }
        },
      ),
    );
  }
}
