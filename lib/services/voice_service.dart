import 'package:speech_to_text/speech_to_text.dart';
import 'dart:developer';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      log('VoiceService: Initializing speech_to_text...');
      _isInitialized = await _speechToText.initialize(
        onError: (val) => log('VoiceService Error: ${val.errorMsg}'),
        onStatus: (val) => log('VoiceService Status: $val'),
      );
      if (_isInitialized) {
        log('VoiceService: Initialization successful.');
      } else {
        log('VoiceService: Initialization failed.');
      }
    }
    return _isInitialized;
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_isInitialized) {
      log('VoiceService: Not initialized, attempting to initialize before listening.');
      final initialized = await initialize();
      if (!initialized) {
        log('VoiceService: Initialization failed, cannot start listening.');
        return;
      }
    }

    if (_speechToText.isListening) {
      log('VoiceService: Already listening.');
      return;
    }

    log('VoiceService: Starting listening...');
    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          final recognizedWords = result.recognizedWords.toLowerCase();
          log('VoiceService: Final result: $recognizedWords');
          _processCommand(recognizedWords, onResult);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: false,
      localeId: 'en_US',
    );
    log('VoiceService: listen() called.');
  }

  Future<void> stopListening() async {
    if (!_speechToText.isListening) {
      log('VoiceService: Not listening.');
      return;
    }
    log('VoiceService: Stopping listening...');
    await _speechToText.stop();
    log('VoiceService: Listening stopped.');
  }

  void _processCommand(String command, Function(String) onResult) {
    log('VoiceService: Processing command: $command');
    // Prioritize more specific commands
    if (command.contains('song number ')) {
      onResult(command); // e.g., "play song number 3"
    } else if (command.contains('play') || command.contains('resume')) { // Include 'resume'
      onResult('Play'); // Map 'play' or 'resume' to 'Play' command
    } else if (command.contains('pause')) {
      onResult('Pause');
    } else if (command.contains('next') || command.contains('skip')) { // Include 'skip'
      onResult('Next'); // Map 'next' or 'skip' to 'Next' command
    } else if (command.contains('previous') || command.contains('back')) { // Include 'back'
      onResult('Previous'); // Map 'previous' or 'back' to 'Previous' command
    } else if (command.contains('stop') || command.contains('halt')) { // Include 'halt'
       onResult('Stop'); // Map 'stop' or 'halt' to 'Stop' command
    } else {
      onResult('Unknown Command');
    }
  }

  bool get isListening => _speechToText.isListening;
}