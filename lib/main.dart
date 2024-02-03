import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool myBlendMode = false;
  double width = 0;
  double height = 0;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    initVideo();
  }

  void initVideo() async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: (_) {
          setState(() {
            myBlendMode = true;
            height = MediaQuery.of(context).size.height;
            width = MediaQuery.of(context).size.width;
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            myBlendMode = false;
            height = 0;
            width = 0;
          });
        },
        onLongPressMoveUpdate: (details) {
          details.globalPosition;
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: Chewie(
                        controller: chewieController,
                      ),
                    )
                  : Container(),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1500),
                opacity: myBlendMode ? 0.0 : 1.0,
                child: BackdropFilter(
                  filter: ImageFilter.compose(
                    inner: ImageFilter.blur(
                      sigmaX: 0,
                      sigmaY: 0,
                    ),
                    outer: const ColorFilter.mode(
                        Colors.grey, BlendMode.saturation),
                  ),
                  // blendMode: BlendMode.color,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
