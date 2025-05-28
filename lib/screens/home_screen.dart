import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gesture_voice_control_app/services/gesture_service.dart';
import 'package:gesture_voice_control_app/services/voice_service.dart';
import 'package:gesture_voice_control_app/services/command_handler.dart';
import 'package:gesture_voice_control_app/services/music_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  final GestureService _gestureService = GestureService();
  final VoiceService _voiceService = VoiceService();
  late final CommandHandler _commandHandler;
  final MusicService _musicService = MusicService();
  
  bool _isListening = false;
  String _lastWords = '';
  String _currentGesture = 'No gesture detected';
  String _lastCommand = '';

  bool _isCameraEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeCamera() async {
    if (!_isCameraEnabled) return;
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) {
      _cameraController!.startImageStream(_processCameraImage);
      setState(() {});
    }
  }

  void _initializeServices() {
    _commandHandler = CommandHandler(
      onCommandProcessed: (command) {
        setState(() {
          _lastCommand = command;
        });
        _commandHandler.executeCommand(command);
      },
      musicService: _musicService,
    );

    _voiceService.initialize();
  }

  Future<void> _startListening() async {
    await _voiceService.startListening((command) {
      setState(() {
        _lastWords = command;
      });
      _commandHandler.processVoiceCommand(command);
    });
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

  void _processCameraImage(CameraImage image) async {
    final gesture = await _gestureService.processImage(image);
    if (gesture != _currentGesture) {
      setState(() {
        _currentGesture = gesture;
      });
      _commandHandler.processGesture(gesture);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _gestureService.dispose();
    _musicService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Camera Preview or Placeholder
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _isCameraEnabled && (_cameraController?.value.isInitialized ?? false)
                      ? CameraPreview(_cameraController!)
                      : Center(
                          child: _isCameraEnabled
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isCameraEnabled = true;
                                    });
                                    _initializeCamera();
                                  },
                                  child: const Text('Enable Camera'),
                                ),
                        ),
                ),
              ),
            ),

            // Add a button to disable the camera
            if (_isCameraEnabled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isCameraEnabled = false;
                      _cameraController?.stopImageStream();
                      _cameraController?.dispose();
                      _cameraController = null; // Set controller to null after disposing
                    });
                  },
                  child: const Text('Disable Camera'),
                ),
              ),

            // Gesture Status
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.gesture, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Gesture:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          _currentGesture,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Voice Command Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _lastWords.isEmpty ? 'No command detected' : _lastWords,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isListening ? _stopListening : _startListening,
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                    label: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                  ),
                ],
              ),
            ),

            // Last Command
            if (_lastCommand.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Text(
                      'Last Command: $_lastCommand',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 