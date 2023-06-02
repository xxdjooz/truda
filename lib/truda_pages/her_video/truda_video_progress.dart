import 'package:flutter/material.dart';

class TrudaTikTokVideoProgress extends StatelessWidget {
  double progress;
  double progressBuff;
  int index;
  int step;

  TrudaTikTokVideoProgress({
    Key? key,
    required this.progress,
    required this.progressBuff,
    required this.index,
    required this.step,
  }) : super(key: key);
//
//   @override
//   State<NewHitaTikTokVideoProgress> createState() => _NewHitaTikTokVideoProgressState();
// }
//
// class _NewHitaTikTokVideoProgressState extends State<NewHitaTikTokVideoProgress> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    if (index > step) {
      return const LinearProgressIndicator(
        value: 0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
        backgroundColor: Colors.white54,
      );
    }
    if (index < step) {
      return const LinearProgressIndicator(
        value: 1,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: Colors.white54,
      );
    }
    return Stack(
      fit: StackFit.passthrough,
      children: [
        LinearProgressIndicator(
          value: progressBuff,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
          backgroundColor: Colors.white54,
        ),
        LinearProgressIndicator(
          value: progress,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
