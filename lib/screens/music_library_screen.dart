import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gesture_voice_control_app/services/voice_service.dart'; // Assuming VoiceService will be used here
import 'package:gesture_voice_control_app/services/command_handler.dart'; // Assuming CommandHandler will be used here
import 'package:gesture_voice_control_app/screens/now_playing_screen.dart'; // Import when created
import 'package:share_plus/share_plus.dart'; // Import share_plus

class MusicLibraryScreen extends StatefulWidget {
  const MusicLibraryScreen({super.key});

  @override
  State<MusicLibraryScreen> createState() => _MusicLibraryScreenState();
}

class _MusicLibraryScreenState extends State<MusicLibraryScreen> {
  List<String> _songPaths = [];
  final VoiceService _voiceService = VoiceService(); // Instantiate VoiceService
  // late final CommandHandler _commandHandler; // Instantiate CommandHandler when MusicService is available

  bool _isListening = false;
  String _lastWords = ''; // To display recognized voice commands

  @override
  void initState() {
    super.initState();
    _loadSongPaths();
    _initializeVoiceService();
  }

  Future<void> _loadSongPaths() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _songPaths = prefs.getStringList('songPaths') ?? [];
    });
  }

   void _initializeVoiceService() {
    _voiceService.initialize();
    // TODO: Initialize CommandHandler with MusicService when MusicService is used here
    // _commandHandler = CommandHandler(onCommandProcessed: _processVoiceCommandResult, musicService: _musicService); // Assuming _musicService will be available
  }

  // Placeholder for processing voice command results
  void _processVoiceCommandResult(String command) {
     setState(() {
      _lastWords = command; // Update UI with recognized command
    });
    // TODO: Implement logic to handle commands like 'play song number X'
    print('Received command in library: $command');
    // Example: Parse command and find song
    if (command.startsWith('play song number ')) {
      final parts = command.split(' ');
      if (parts.length == 4) {
        final songNumber = int.tryParse(parts[3]);
        if (songNumber != null && songNumber > 0 && songNumber <= _songPaths.length) {
          _playSong(songNumber - 1); // Adjust for 0-based index
        }
      }
    }
  }

  Future<void> _startListening() async {
     // TODO: Handle permissions if not already done
    await _voiceService.startListening(_processVoiceCommandResult);
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

  // Placeholder for playing a song (will navigate to NowPlayingScreen)
  void _playSong(int index) {
    // Navigate to NowPlayingScreen and pass the playlist and the selected song's index
    print('Playing song at index: $index');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(playlist: _songPaths, startIndex: index), // Pass playlist and start index
      ),
    );
  }

  @override
  void dispose() {
    // _voiceService.dispose(); // Remove this line
    // TODO: Dispose CommandHandler and MusicService if they are instantiated here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Library'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display voice command status
           Padding(
            padding: const EdgeInsets.all(16.0), // Increased padding
            child: Text(
              _lastWords.isEmpty ? 'Tap mic to speak commands (e.g., play song number 1)' : 'Last Command: $_lastWords',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium, // Use a slightly larger text style
            ),
          ),
          // Voice control button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
            child: ElevatedButton.icon(
              onPressed: _isListening ? _stopListening : _startListening,
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic, size: 24.0), // Larger icon
              label: Text(
                _isListening ? 'Stop Listening' : 'Start Listening',
                style: const TextStyle(fontSize: 18.0), // Larger text
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Make button full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // List of uploaded songs
          Expanded(
            child: ListView.builder(
              itemCount: _songPaths.length,
              itemBuilder: (context, index) {
                final songPath = _songPaths[index];
                final songFileName = songPath.split('/').last; // Simple way to get file name
                // TODO: Get actual upload date if stored
                final uploadDate = 'Unknown Date';
                return Card(
                   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Card margins
                   elevation: 2.0, // Card elevation
                   child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary, // Colored avatar
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: Text((index + 1).toString()), // Song ID
                  ),
                  title: Text(
                    songFileName,
                    style: const TextStyle(fontWeight: FontWeight.bold), // Bold title
                    overflow: TextOverflow.ellipsis, // Handle long titles
                  ),
                  subtitle: Text('Uploaded: $uploadDate'),
                  onTap: () => _playSong(index), // Play song on tap
                  trailing: PopupMenuButton<String>( // Add PopupMenuButton
                    icon: Icon(Icons.more_vert), // Three dots icon
                    onSelected: (String result) async { // Handle menu item selection
                      if (result == 'delete') {
                        // Implement delete functionality
                        _songPaths.removeAt(index); // Remove from list
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setStringList('songPaths', _songPaths); // Update SharedPreferences
                        setState(() { // Update UI
                          // State is already updated by removing from _songPaths
                        });
                      } else if (result == 'share') {
                        // TODO: Implement share functionality
                        try {
                          await Share.shareFiles([songPath], text: 'Check out this song!');
                        } catch (e) {
                          print('Error sharing file: $e');
                          // TODO: Show error to user
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
                  ), // Replaced trailing icon with PopupMenuButton
                ),
              );
              },
            ),
          ),
        ],
      ),
    );
  }
} 