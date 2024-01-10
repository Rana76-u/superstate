import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:superstate/Blocs/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:superstate/Blocs/React%20Bloc/react_bloc.dart';
import 'package:superstate/View/Create%20Post/create_post.dart';
import 'package:superstate/View/Widgets/bottom_nav_bar.dart';
import 'package:superstate/View/login.dart';
import 'Blocs/Youtube Video Player Bloc/youtube_player_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<SharedMediaFile> _sharedFiles = [];
  String _sharedText = '';
  late StreamSubscription _intentMediaStreamSubscription;
  late StreamSubscription _intentTextStreamSubscription;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentMediaStreamSubscription = ReceiveSharingIntentPlus.getMediaStream().listen(
              (List<SharedMediaFile> value) {
            setState(() {
              _sharedFiles = value;
              debugPrint(
                'Shared:${_sharedFiles.map((f) => f.path).join(',')}',
              );
            });
          },
          onError: (err) {
            debugPrint('getIntentDataStream error: $err');
          },
        );

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialMedia().then(
          (List<SharedMediaFile> value) {
        setState(() {
          _sharedFiles = value;
          debugPrint(
            'Shared:${_sharedFiles.map((f) => f.path).join(',')}',
          );
        });
      },
    );

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentTextStreamSubscription =
        ReceiveSharingIntentPlus.getTextStream().listen(
              (String value) {
            setState(() {
              _sharedText = value;
              debugPrint('Shared: $_sharedText');
            });
          },
          onError: (err) {
            debugPrint('getLinkStream error: $err');
          },
        );

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value!;
        debugPrint('Shared: $_sharedText');
      });
    });
  }

  @override
  void dispose() {
    _intentMediaStreamSubscription.cancel();
    _intentTextStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BottomBarBloc(),),
          BlocProvider(create: (context) => ReactBloc(),),
          BlocProvider(create: (context) => YoutubePlayerBloc(),),
        ],
        child: MaterialApp(
          title: 'SuperState',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Urbanist',
          ),
          home: screenNavigator(),
          debugShowCheckedModeBanner: false,
        )
    );
  }

  Widget screenNavigator() {
    if(FirebaseAuth.instance.currentUser != null) {

      if(_sharedText.isNotEmpty || _sharedFiles.isNotEmpty){
        return CreatePostScreen(sharedText: _sharedText, sharedFiles: _sharedFiles,);
      }else{
        return const BottomBar();
      }

    }
    else{
      return const LoginPage();
    }
  }
}

