// audio_handler.dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  MyAudioHandler() {
    _audioPlayer.playerStateStream.listen((state) {
      playbackState.add(_transformEvent(state));
    });
  }

  Future<void> loadMediaItem(
    String url, [
    String title = "Music",
    String thumbnailUrl = "https://www.example.com/cover.jpg",
    String album = "No Album",
  ]) async {
    await _audioPlayer.setUrl(url);
    mediaItem.add(MediaItem(
      id: url,
      album: 'YouTube Audio',
      title: 'Audio Track',
      artUri: Uri.parse(thumbnailUrl), // Replace with your thumbnail
    ));
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    playbackState.add(playbackState.value
        .copyWith(processingState: AudioProcessingState.idle));
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  PlaybackState _transformEvent(PlayerState state) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        state.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: {MediaAction.seek},
      androidCompactActionIndices: const [0, 1, 3],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState]!,
      playing: state.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: null,
    );
  }
}

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.example.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );
}
