import 'package:video_player/video_player.dart';

class TrudaAivVideoController {
  VideoPlayerController playerController;

  TrudaAivVideoController.make(String url)
      : playerController = VideoPlayerController.network(url)..initialize();
}
