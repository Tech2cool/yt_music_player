import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class PlayerPage extends StatelessWidget {
  final AudioHandler audioHandler;

  const PlayerPage(this.audioHandler, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Player")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final isPlaying = state?.playing ?? false;
                return IconButton(
                  iconSize: 64,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () =>
                      isPlaying ? audioHandler.pause() : audioHandler.play(),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () => audioHandler.stop(),
            ),
          ],
        ),
      ),
    );
  }
}
