import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superstate/Blocs/Youtube%20Video%20Player%20Bloc/youtube_player_bloc.dart';
import 'package:superstate/Blocs/Youtube%20Video%20Player%20Bloc/youtube_player_states.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


/// Creates [YoutubePlayerDemoApp] widget.
class YoutubePlayerDemoApp extends StatelessWidget {
  final String link;
  const YoutubePlayerDemoApp({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Player Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.blueAccent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
      home: MyHomePage(link: link,),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String link;
  String videoId = '';

  MyHomePage({super.key, required this.link}) {
    videoId = YoutubePlayer.convertUrlToId(link)!;
  }

  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(
      mute: false,
      autoPlay: true,
      disableDragSeek: false,
      loop: false,
      isLive: false,
      forceHD: false,
      enableCaption: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YoutubePlayerBloc, YoutubePlayerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return YoutubePlayerBuilder(
          onExitFullScreen: () {
            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _controller.metadata.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () {
                  log('Settings Tapped!');
                },
              ),
            ],
            onReady: () {
              //_isPlayerReady = true;
            },
            onEnded: (data) {

            },
          ),
          builder: (context, player) => SizedBox(
            height: 200,
              width: 200,
              child: player
          )/*Scaffold(
            body: ListView(
              children: [
                player,
              ],
            ),
          )*/,
        );
      },
    );
  }
}
