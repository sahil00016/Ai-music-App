import 'package:flutter/material.dart';
import 'package:gesture_voice_control_app/services/music_service.dart';

class CommandHandler {
  final Function(String) onCommandProcessed;
  final Map<String, String> _gestureToCommand = {
    '👋 Wave': 'Play',
    '✌️ Peace': 'Pause',
    '👉 Pointing': 'Next',
  };

  final MusicService _musicService;

  CommandHandler({required this.onCommandProcessed, required MusicService musicService}) : _musicService = musicService;

  void processGesture(String gesture) {
    final command = _gestureToCommand[gesture] ?? 'Unknown Command';
    onCommandProcessed(command);
  }

  void processVoiceCommand(String command) {
    onCommandProcessed(command);
  }

  void executeCommand(String command) {
    switch (command) {
      case 'Play':
        _musicService.resume();
        debugPrint('Playing...');
        // Playback is initiated from NowPlayingScreen via _playSong method
        break;
      case 'Pause':
        _musicService.pause();
        debugPrint('Paused');
        break;
      case 'Next':
        _musicService.next();
        debugPrint('Next item');
        break;
      case 'Previous':
        _musicService.previous();
        debugPrint('Previous item');
        break;
      case 'Stop': // Add case for Stop command
        _musicService.stop();
        debugPrint('Stopped');
        break;
      case 'Volume Up':
        _volumeUp();
        break;
      case 'Volume Down':
        _volumeDown();
        break;
      case 'Mute':
        _mute();
        break;
      case 'Open Gallery':
        _openGallery();
        break;
      case 'Open Settings':
        _openSettings();
        break;
      case 'Open Camera':
        _openCamera();
        break;
      default:
        debugPrint('Unknown command: $command');
    }
  }

  // Command implementations
  // These are now handled by MusicService
  // void _play() { /* Redundant now, will be removed */ }
  // void _pause() { /* Redundant now, will be removed */ }
  // void _next() { /* Redundant now, will be removed */ }
  // void _previous() { /* Redundant now, will be removed */ }

  // Keep other command implementations for now
  void _volumeUp() {
    debugPrint('Volume up');
    // Implement volume up functionality
  }

  void _volumeDown() {
    debugPrint('Volume down');
    // Implement volume down functionality
  }

  void _mute() {
    debugPrint('Muted');
    // Implement mute functionality
  }

  void _openGallery() {
    debugPrint('Opening gallery');
    // Implement gallery opening functionality
  }

  void _openSettings() {
    debugPrint('Opening settings');
    // Implement settings opening functionality
  }

  void _openCamera() {
    debugPrint('Opening camera');
    // Implement camera opening functionality
  }
} 