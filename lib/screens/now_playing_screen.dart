import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers
import 'package:gesture_voice_control_app/services/gesture_service.dart'; // Import GestureService
import 'package:camera/camera.dart'; // Import camera
import 'package:gesture_voice_control_app/services/voice_service.dart'; // Import VoiceService
import 'package:gesture_voice_control_app/services/command_handler.dart'; // Import CommandHandler
import 'package:gesture_voice_control_app/services/music_service.dart'; // Import MusicService
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:share_plus/share_plus.dart'; // Import share_plus package

class NowPlayingScreen extends StatefulWidget {
  final List<String> playlist;
  final int startIndex;

  const NowPlayingScreen({Key? key, required this.playlist, required this.startIndex}) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  CameraController? _cameraController;
  final GestureService _gestureService = GestureService();
  String _currentGesture = 'No gesture detected';
  bool _isCameraEnabled = false;

  final VoiceService _voiceService = VoiceService();
  late final CommandHandler _commandHandler;
  bool _isListening = false;
  String _lastVoiceCommand = '';

  late final MusicService _musicService; // Instantiate MusicService

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _musicService = MusicService(); // Initialize MusicService
    _musicService.setPlaylist(widget.playlist, widget.startIndex);
    
    // Set the AudioPlayer instance in MusicService
    _musicService.setAudioPlayer(_audioPlayer);

    _initializeAudioListeners();
    _initializeVoiceService();

    // Set up listeners for player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if(mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if(mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if(mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if(mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
        // Play next song when current song completes
        _playNext();
      }
    });
  }

  void _initializeAudioListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if(mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if(mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if(mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if(mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
        _playNext();
      }
    });
  }

  void _initializeVoiceService() {
    _voiceService.initialize();
     // Initialize CommandHandler with the MusicService instance
    _commandHandler = CommandHandler(
      onCommandProcessed: _handleVoiceCommandResult,
      musicService: _musicService, // Pass the instantiated MusicService
      // Removed: Invalid named parameters playMusic, pauseMusic, etc.
    );
  }

   void _handleVoiceCommandResult(String command) {
     setState(() {
       _lastVoiceCommand = command;
     });
    
    switch (command.toLowerCase()) {
      case 'play':
        _playSong();
        break;
      case 'pause':
        _pauseSong();
        break;
      case 'stop':
        _stopSong();
        break;
      case 'next':
        _playNext();
        break;
      case 'previous':
        _playPrevious();
        break;
      default:
        print('Unknown command: $command');
    }
  }

   Future<void> _startListening() async {
     // TODO: Handle permissions if not already done
    await _voiceService.startListening(_handleVoiceCommandResult);
    setState(() {
      _isListening = true;
    });
  }

  Future<void> _stopListening() async {
    await _voiceService.stopListening();
    setState(() {
      _isListening = false;
    });
  }

  // Function to initialize camera for gesture detection
  Future<void> _initializeCamera() async {
    if (!_isCameraEnabled) return;
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium, // Use a lower resolution for gesture processing
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) {
      _cameraController!.startImageStream(_processCameraImage); // Start processing frames
      setState(() {});
    }
  }

  // Function to process camera images for gestures
  void _processCameraImage(CameraImage image) async {
    if (!_isCameraEnabled) return; // Only process if camera is enabled
    // TODO: If GestureService is updated to return bounding boxes, modify this.
    final gesture = await _gestureService.processImage(image);
    if (gesture != _currentGesture) {
      setState(() {
        _currentGesture = gesture;
      });
      _handleGestureCommand(gesture); // Handle gesture commands
    }
    // Removed logic that expected bounding box data from GestureService
  }

  // Function to handle gesture commands
  void _handleGestureCommand(String command) {
    print('Gesture command received: $command');
     // TODO: Map gestures to music controls (Play, Pause, Next, Previous)
    switch (command) {
       case 'Play':
        _resumeSong();
        break;
      case 'Pause':
        _pauseSong();
        break;
      case 'Next':
        _musicService.next();
        break;
      case 'Previous':
        _musicService.previous();
        break;
      default:
        break;
    }
    // TODO: Update UI to show which gesture command was executed
  }

  // Local playback methods (will now call MusicService)
  Future<void> _playSong() async {
    if (_musicService.currentIndex != -1) {
      await _musicService.play(_musicService.playlist[_musicService.currentIndex]);
      if(mounted) { 
        setState(() { 
          _isPlaying = true;
        }); 
      }
    }
  }

  Future<void> _pauseSong() async {
    await _musicService.pause();
    if(mounted) { 
      setState(() { 
        _isPlaying = false;
      }); 
    }
  }

  Future<void> _resumeSong() async {
    await _musicService.resume();
    if(mounted) { 
      setState(() { 
        _isPlaying = true;
      }); 
    }
  }

  Future<void> _stopSong() async {
    await _musicService.stop();
    if(mounted) { 
      setState(() { 
        _isPlaying = false;
        _position = Duration.zero;
      }); 
    }
  }

  Future<void> _playNext() async {
    await _musicService.next();
    if(mounted) { 
      setState(() { 
        _isPlaying = true;
        _position = Duration.zero;
      }); 
    }
  }

  Future<void> _playPrevious() async {
    await _musicService.previous();
    if(mounted) { 
      setState(() { 
        _isPlaying = true;
        _position = Duration.zero;
      }); 
    }
  }

  // Helper to format duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // TODO: Implement next and previous song logic here or in MusicService

  @override
  void dispose() {
    _audioPlayer.dispose();
    // _voiceService.dispose(); // Removed: VoiceService does not have dispose
    _cameraController?.dispose();
    _gestureService.dispose();
    _musicService.dispose(); // Dispose MusicService
    // TODO: Cancel camera image stream listener if it\'s a separate subscription
     // TODO: Dispose CommandHandler if it requires disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing'),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String result) async {
              if (result == 'delete') {
                if (_musicService.currentIndex != -1) {
                  final deletedIndex = _musicService.currentIndex;
                  final deletedSongPath = _musicService.playlist[deletedIndex];
                  
                  // Remove from playlist in MusicService
                  _musicService.playlist.removeAt(deletedIndex);
                  
                  // Save updated playlist to SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setStringList('playlist', _musicService.playlist);
                  
                  // Navigate back to library screen
                  Navigator.pop(context);
                }
              } else if (result == 'share') {
                if (_musicService.currentIndex != -1) {
                  final songPath = _musicService.playlist[_musicService.currentIndex];
                  await Share.share('Check out this song: $songPath');
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: Text('Share'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Music Player UI (positioned at the bottom or full screen behind camera)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Album Art Placeholder
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.music_note, size: 100, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),

                    // Song Title and Artist
                    Text(
                      // Use the public getter to access the current song path from the playlist
                      _musicService.playlist[_musicService.currentIndex].split('/').last,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unknown Artist',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 40),

                    // Progress Slider
                    Slider(
                      min: 0,
                      max: _duration.inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await _audioPlayer.seek(position);
                        if(mounted) {
                          setState(() {
                            _position = position;
                          });
                        }
                      },
                    ),

                    // Duration and Position Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(_position)),
                          Text(_formatDuration(_duration)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Playback Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.skip_previous),
                          onPressed: _playPrevious,
                          iconSize: 48,
                        ),
                        IconButton(
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: _isPlaying ? _pauseSong : _playSong,
                          iconSize: 64,
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next),
                          onPressed: _playNext,
                          iconSize: 48,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                     // Gesture button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCameraEnabled = !_isCameraEnabled;
                        });
                        if (_isCameraEnabled) {
                          _initializeCamera();
                        } else {
                          _cameraController?.stopImageStream();
                          _cameraController?.dispose();
                          _cameraController = null;
                           setState(() {
                            // _gestureDetectionResult = {'gesture': 'No gesture detected', 'boundingBox': null}; // Removed
                             _currentGesture = 'No gesture detected'; // Reset gesture text
                          });
                        }
                      },
                      child: Text(_isCameraEnabled ? 'Disable Gesture Camera' : 'Enable Gesture Camera'),
                    ),
                     // Current Gesture Status (visible only when camera is enabled)
              if (_isCameraEnabled)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0), // Adjusted padding
                  child: Text(
                    'Current Gesture: $_currentGesture',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
               // Voice control button on Now Playing screen
               Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // Add vertical padding
                  child: ElevatedButton.icon(
                    onPressed: _isListening ? _stopListening : _startListening,
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic, size: 24.0),
                    label: Text(
                      _isListening ? 'Stop Listening' : 'Start Listening',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                     style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Make button full width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                // Display recognized voice command
                 if (_lastVoiceCommand.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Last Voice Command: $_lastVoiceCommand',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),

          // Camera Preview (visible only when camera is enabled)
          if (_isCameraEnabled && (_cameraController?.value.isInitialized ?? false))
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            ),
        ],
      ),
    );
  }
}

// Removed: Custom Painter class for drawing gesture bounding box and text
// class GesturePainter extends CustomPainter {
//   final Map<String, dynamic> gestureResult;

//   GesturePainter({required this.gestureResult});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final boundingBox = gestureResult['boundingBox'];
//     final gesture = gestureResult['gesture'];

//     if (boundingBox != null) {
//       final paint = Paint()
//         ..color = Colors.blueAccent // Color of the bounding box
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 3.0;

//       // You might need to scale and translate the bounding box coordinates
//       // from the image coordinates to the widget coordinates.
//       // This is a simplified example assuming boundingBox is a Rect in widget coordinates.
//       canvas.drawRect(boundingBox, paint);

//       // Draw text
//       final textSpan = TextSpan(
//         text: gesture,
//         style: const TextStyle(
//           color: Colors.white, // Text color
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           backgroundColor: Colors.blueAccent, // Background for text
//         ),
//       );
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       );
//       textPainter.layout();
//       // Position the text above the bounding box
//       // You might need to adjust the position based on the bounding box and text size.
//       final textOffset = Offset(boundingBox.left, boundingBox.top - textPainter.height - 5);
//       textPainter.paint(canvas, textOffset);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // Repaint whenever the gesture result changes
//     return oldDelegate is GesturePainter && oldDelegate.gestureResult != gestureResult;
//   }
// } 