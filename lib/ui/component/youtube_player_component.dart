
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:tailwind_style/tailwind_style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class YoutubeVideoPlayer extends StatefulWidget {
  Map? section;

  YoutubeVideoPlayer({super.key, this.section
  });

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ContainerTailwind(
        extClass: widget.section?['class'] ?? '',
        // padding: EdgeInsets.symmetric(horizontal: Constants.spacing4,vertical: Constants.spacing3),
        // height: 200,
        child: YoutubePlayer(controller: YoutubePlayerController(
            initialVideoId:  YoutubePlayer.convertUrlToId(widget.section?['videoUrl']) ?? "https://www.youtube.com/watch?v=80hq30DgFUY",
            flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: true,
            ),
        )),
      ),
    );
  }
}
