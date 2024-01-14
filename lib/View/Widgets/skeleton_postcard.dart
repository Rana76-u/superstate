import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonPostCard extends StatelessWidget {
  const SkeletonPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //profile
            Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.shade200
                  ),
                )),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myContainer(10, 0.45, context),
                const SizedBox(height: 5,),
                myContainer(10, 0.25, context),
              ],
            )
          ],
        ),

            Padding(
              padding: const EdgeInsets.only(left: 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Post Text
                  const SizedBox(height: 5,),
                  myContainer(5, 0.70, context),
                  const SizedBox(height: 5,),
                  myContainer(5, 0.35, context),

                  //image
                  const SizedBox(height: 5,),
                  myContainer(150, 0.70, context),

                  //link title
                  const SizedBox(height: 5,),
                  myContainer(5, 0.55, context),

                  //Icons
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        // Comment
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(MingCute.chat_1_line, color: Colors.grey.shade200,),
                        ),

                        // Like
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(MingCute.thumb_up_2_line,  color: Colors.grey.shade200,),
                        ),

                        // Dislike
                        Icon(MingCute.thumb_down_2_line,  color: Colors.grey.shade200,)
                      ],
                    ),
                  ),

                  //counting
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Row(
                      children: [
                        // Comment
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: myContainer(5, 0.15, context),
                        ),

                        // Like
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: myContainer(5, 0.08, context),
                        ),

                        // Dislike
                        myContainer(5, 0.09, context),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            const Divider(),
        ]
      ),
    );
  }

  Widget myContainer(double height, double width, BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width*width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade200,
      ),
    );
  }
}
