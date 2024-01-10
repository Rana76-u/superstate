import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superstate/View/Widgets/bottom_nav_bar.dart';
import 'package:superstate/View/Widgets/navigator.dart';
import 'package:superstate/ViewModel/crud_post.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController textBoxController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            ScreenNavigator.openScreen(context, const BottomBar(), 'LeftToRight');
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text(
            'Create Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              CRUDPost().create(textBoxController.text);
              ///if post complete then pop screen
              ScreenNavigator.closeScreen(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [

              profileRow(),

              textField(textBoxController),

            ],
          ),
        ),
      ),
    );
  }

  Widget profileRow() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                height: 35,
                width: 35,
                imageUrl: FirebaseAuth.instance.currentUser!.photoURL ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      //colorFilter: const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),

        Text(
          FirebaseAuth.instance.currentUser!.displayName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }

  Widget textField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        constraints: const BoxConstraints(
            minHeight: 135, //135
            maxHeight: 300
        ),
        child: TextField(
          autofocus: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: controller,
          style: const TextStyle(overflow: TextOverflow.clip),
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none
            ),
            prefixIcon: Icon(
              Icons.short_text_rounded,
              color: Colors.grey,
            ),
            filled: false,
            hintText: 'Express! freedom is here . . .',
          ),
          cursorColor: Colors.black,
        ),
      ),
    );
  }
}
