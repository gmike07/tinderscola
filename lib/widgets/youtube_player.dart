// ignore: import_of_legacy_library_into_null_safe
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomYoutubePlayer extends StatefulWidget {
  final String url;

  const CustomYoutubePlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false, loop: true),
    );
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      //videoProgressIndicatorColor: Colors.amber,
      // progressColors: ProgressColors(
      //     playedColor: Colors.amber,
      //     handleColor: Colors.amberAccent,
      // ),
      // onReady () {
      //     _controller.addListener(listener);
      // },
    );
  }
}
