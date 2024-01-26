import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_bloc.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_events.dart';
import 'package:superstate/Blocs/FilePicker%20Bloc/filepicker_states.dart';
import 'package:superstate/View/Widgets/bottom_nav_bar.dart';
import 'package:superstate/View/Widgets/navigator.dart';
import 'package:superstate/View/Widgets/video_player.dart';
import 'package:superstate/ViewModel/crud_post.dart';
import 'package:superstate/ViewModel/pickfile.dart';

import '../../ViewModel/filetype_extractor.dart';
import '../Widgets/loading.dart';

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
                  final provider = BlocProvider.of<PickFileBloc>(context);
                  provider.add(
                      PickFileEvents(
                        isFilePicked: state.isFilePicked,
                        files: state.files,
                        isPosting: true
                      )
                  );

                  CRUDPost().create(textBoxController.text, state.files);
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
          body: state.isPosting == true ?
          Loading().centralLinearSized(context, 0.4)
          :
          SingleChildScrollView(
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
        Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  PickFile().usingImagePicker(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.image, color: Colors.green,),
                    SizedBox(width: 10,),
                    Icon(MingCute.video_fill, color: Colors.purple,) //video_file_rounded
                  ],
                )
            ),

            const SizedBox(width: 8,),

            ElevatedButton(
                onPressed: () async {
                  PickFile().usingFilePicker(context);
                },
                child: const Icon(MingCute.folder_fill, color: Colors.blueGrey,), //file_upload_fill
            ),
          ],
        ),

        Padding(
            padding: const EdgeInsets.only(top: 15),
            child: showPickedItem(context, state))
      ],
    );
  }
  
  Widget showPickedItem(BuildContext context, PickFileState state) {
    return state.files != [] ?
    SizedBox(
      height: 500, //170
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: state.files.length,
        itemBuilder: (context, index) {

          String fileType = fileTypeExtractor(state.files[index]);

          List<String> pathParts = state.files[index].path.split('/');
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
                width: 150,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: fileType == 'image' || fileType == 'gif' ?
                      Image.file(
                        state.files[index],
                        fit: BoxFit.cover,
                      )
                          :
                      fileType == 'video' ?
                      VideoPlayerScreen(videoPath: state.files[index],)
                          :
                      const Icon(Icons.insert_drive_file, size: 50, color: Colors.grey),
                    ),

                    Text(
                      pathParts.last,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: null,
                    )
                  ],
                )
            ),
          );

        },
      ),
    )
        :
    const SizedBox();
  }
}
