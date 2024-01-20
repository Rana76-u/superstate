import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_bloc.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_states.dart';
import 'package:superstate/View/Widgets/bottom_nav_bar.dart';
import 'package:superstate/View/Widgets/navigator.dart';
import 'package:superstate/ViewModel/crud_post.dart';
import 'package:superstate/ViewModel/pickfile.dart';

class CreatePostScreen extends StatelessWidget {
  final String sharedText;
  final List<SharedMediaFile> sharedFiles;

  const CreatePostScreen({super.key, required this.sharedText, required this.sharedFiles});

  @override
  Widget build(BuildContext context) {

    TextEditingController textBoxController = TextEditingController();
    if(sharedText.isNotEmpty){
      textBoxController.text = sharedText;
      ReceiveSharingIntentPlus.reset();
    }

    return BlocConsumer<PickFileBloc, PickFileState>(
        listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                ScreenNavigator.closeScreen(context);
                ///Dispose file picker
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
                  ScreenNavigator.openScreen(context, const BottomBar(), 'LeftToRight');
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

                  pickFileWidget(context, state),

                ],
              ),
            ),
          ),
        );
      },
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

  Widget pickFileWidget(BuildContext context, PickFileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () async {
              PickFile().pickMultiple(context);
            },
            child: const Text('Pick Files')
        ),

        state.files != [] ?
        SizedBox(
          height: 150,
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: state.files.length,
            itemBuilder: (context, index) {
              String fileExtension = state.files[index].path.split('.').last.toLowerCase();
              String fileType = '';
              if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
                fileType = 'image';
              }else if (fileExtension == 'mp4' || fileExtension == 'avi' || fileExtension == 'mov'){
                fileType = 'video';
              }else if (fileExtension == 'pdf') {
                fileType = 'pdf';
              }else if (fileExtension == 'gif'){
                fileType = 'gif';
              }else if (fileExtension == 'mp3' || fileExtension == 'wav') {
                fileType = 'audio';
              }

              List<String> pathParts = state.files[index].path.split('/');
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      fileType == 'image' || fileType == 'gif' ?
                      Image.file(
                        state.files[index],
                        fit: BoxFit.cover,
                      )
                          :
                      const Icon(Icons.insert_drive_file, size: 50, color: Colors.grey),

                      Text(
                        pathParts.last,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis
                        ),
                      )
                    ],
                  )
                ),
              );

            },
          ),
        )
            :
        const SizedBox(),
      ],
    );
  }
}
