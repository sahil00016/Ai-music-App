import 'package:audioplayers/audioplayers.dart';

class MusicService {
  late AudioPlayer _audioPlayer;
  List<String> _playlist = [];
  int _currentIndex = -1;
  bool _isPlaying = false;

  MusicService() {
    _audioPlayer = AudioPlayer();
  }

  void setAudioPlayer(AudioPlayer player) {
    _audioPlayer = player;
  }

  void setPlaylist(List<String> playlist, int startIndex) {
    _playlist = playlist;
    _currentIndex = startIndex;
    play(_playlist[_currentIndex]);
  }

  Future<void> play(String audioPath) async {
    try {
      await _audioPlayer.stop(); // Stop any currently playing audio
      await _audioPlayer.play(DeviceFileSource(audioPath));
      _isPlaying = true;
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> playAtIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await play(_playlist[_currentIndex]);
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> resume() async {
    try {
      if (!_isPlaying) {
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> next() async {
    if (_playlist.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
      await playAtIndex(_currentIndex);
    }
  }

  Future<void> previous() async {
    if (_playlist.isNotEmpty) {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await playAtIndex(_currentIndex);
    }
  }

  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;
  List<String> get playlist => _playlist;

  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }
} 