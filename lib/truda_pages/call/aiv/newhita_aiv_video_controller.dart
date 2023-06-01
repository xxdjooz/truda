import 'package:video_player/video_player.dart';

class NewHitaAivVideoController {
  VideoPlayerController playerController;

  NewHitaAivVideoController.make(String url)
      : playerController = VideoPlayerController.network(url)..initialize();
}
