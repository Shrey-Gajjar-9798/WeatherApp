import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideo extends StatefulWidget {
  late final VideoPlayerController videoPlayerController;
  late final bool looping;

  ChewieVideo({
    required this.videoPlayerController,
    required this.looping,
  });

  @override
  _ChewieVideoState createState() => _ChewieVideoState();
}

class _ChewieVideoState extends State<ChewieVideo> {
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        // aspectRatio: 21 / 10,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false,
        // fullScreenByDefault: true,
        showControls: false,
        showControlsOnInitialize: false,
        showOptions: false,
        looping: widget.looping,
        errorBuilder: (context, errormessage) {
          return Center(
              child: Text(
            errormessage,
            style: TextStyle(color: Colors.white),
          ));
        }
        // showControlsOnInitialize: false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  void despose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
