import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:gesture_voice_control_app/screens/music_library_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  Future<void> _pickAudioFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        List<String> filePaths = result.paths.where((path) => path != null).cast<String>().toList();
        await _saveSongPaths(filePaths);
        print('Selected files: ${filePaths.length}');
        // TODO: Optionally show a confirmation message
      } else {
        // User canceled the picker
        print('File picking canceled.');
      }
    } catch (e) {
      print('Error picking files: $e');
      // TODO: Handle errors more gracefully
    }
  }

  Future<void> _saveSongPaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve existing paths, add new ones, and save
    List<String> existingPaths = prefs.getStringList('songPaths') ?? [];
    existingPaths.addAll(paths);
    await prefs.setStringList('songPaths', existingPaths);
    print('Saved ${existingPaths.length} song paths.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Music Player'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons horizontally
            children: [
              // App Title/Logo Placeholder
              Text(
                'Your Personal AI Music Player',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  _pickAudioFiles();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Upload Songs'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MusicLibraryScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                   textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Listen Songs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 