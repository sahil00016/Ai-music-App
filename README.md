# AI Music App

A Flutter application for managing and playing local music files with voice control, and planned gesture control.

# Over Look
![WhatsApp Image 2025-06-06 at 20 40 52_664bd817](https://github.com/user-attachments/assets/79f4b782-73c3-48af-a0db-7bee9e8ec159)
![WhatsApp Image 2025-06-06 at 20 40 52_c1b940cc](https://github.com/user-attachments/assets/6d2a9a91-f43e-433c-8904-60ef99b1cf95)
![WhatsApp Image 2025-06-06 at 20 40 51_e4b0c079](https://github.com/user-attachments/assets/467a2965-cb24-4078-a31d-32164a01dd9c)
![WhatsApp Image 2025-06-06 at 20 40 51_e9a62e0d](https://github.com/user-attachments/assets/e9988d34-838c-4533-a476-5ba6bf5f977f)
![WhatsApp Image 2025-06-06 at 20 40 51_fe9a5d56](https://github.com/user-attachments/assets/f43e234a-4e87-44fe-bc51-154528730723)

## Demonstration Video

Check out a video demonstration of the app's features and usage here: [AI Music App Demo](https://drive.google.com/file/d/1IZZOH6nYQtSKHqvwvhPrKlG-VtXExuaR/view?usp=drivesdk)

## Features

- **Music Library:** View and manage a list of uploaded songs.
- **Upload Songs:** Easily add local audio files (MP3, etc.) to your music library.
- **Play Songs:** Select and play any song from your library.
- **Playback Controls:** Intuitive on-screen buttons for Play, Pause, Stop, Next, and Previous.
- **Voice Commands:** Control music playback using voice. Say the trigger phrase "Hey buddy" followed by commands like "play", "pause", "stop", "next song", or "previous song". You can also play a specific song from the library by saying "play song number X" (replace X with the song's number in the list).
- **Song Management:** Three-dot menu on each song in the library offers options to Delete or Share the song file.
- **Now Playing Screen:** A dedicated screen showing the currently playing song's details, progress slider, and controls.
- **Progress Slider:** Seek to any point in the song by dragging the slider.

## How to Use

1.  **Launch the App:** Open the application on your compatible device.
2.  **View Library:** The initial screen displays your music library. If it's empty, proceed to upload.
3.  **Upload Music:** Tap the upload button (usually a plus or upload icon) and select audio files from your device storage.
4.  **Play a Song:** Tap on a song title in the library list to start playback and go to the Now Playing screen.
5.  **Manual Controls:** Use the buttons on the Now Playing screen to control playback (play/pause, next, previous).
6.  **Voice Control:** On the Now Playing screen, say "Hey buddy" to activate listening, then issue a command (e.g., "Hey buddy, pause"). From the Library screen, you can say "Hey buddy, play song number 3" to play the third song.
7.  **Manage Songs:** Tap the vertical three-dot icon next to a song in the library to access delete and share options.
8.  **Seek within Song:** On the Now Playing screen, drag the circular handle on the progress bar to seek to a different time.

## Future Scope

- **Gesture Controls:** Implement hand gesture recognition to control music playback and navigate the app without touch.
- Enhanced user interface and experience.
- Voice and gesture control for volume adjustment.
- Features for creating and managing playlists.
- Background playback.

## Prerequisites

- Flutter SDK (ensure you have a recent stable version)
- Android Studio or VS Code with Flutter and Dart plugins
- Android SDK (for Android development) or Xcode (for iOS development)
- A physical Android or iOS device, or an emulator/simulator
- Permissions enabled for Camera, Microphone, and Storage.

## Getting Started

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/sahil00016/Ai-music-App.git
    ```

2.  **Navigate to the project directory:**

    ```bash
    cd Ai-music-App
    ```

3.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

4.  **Connect a device or start an emulator/simulator.**

5.  **Run the app:**

    ```bash
    flutter run
    ```

## Required Permissions

The app requires your permission to access:

- **Microphone:** For voice command functionality.
- **Storage:** To access and upload local audio files.
- **Camera:** (For future gesture control implementation) Will be required when the gesture feature is enabled.

## Project Structure

```
ai-music-app/
├── android/
├── ios/
├── lib/
│   ├── constants/
│   ├── models/
│   ├── screens/
│   │   ├── music_library_screen.dart
│   │   └── now_playing_screen.dart
│   ├── services/
│   │   ├── command_handler.dart
│   │   ├── gesture_service.dart
│   │   ├── music_service.dart
│   │   └── voice_service.dart
│   ├── widgets/
│   └── main.dart
├── linux/
├── macos/
├── test/
├── web/
├── windows/
├── .gitignore
├── pubspec.yaml
├── pubspec.lock
└── README.md
```
*(This structure is a general representation and may vary slightly)*

## Dependencies

Key dependencies used in this project:

- `audioplayers`: For audio playback.
- `file_picker`: For selecting local audio files.
- `share_plus`: For sharing song files.
- `speech_to_text`: For converting speech to text.
- `camera`: For accessing camera for gesture recognition (future scope).
- `google_mlkit_pose_detection`: For pose detection (future scope for gestures).
- `shared_preferences`: For storing simple key-value data (like playlist). 

*(See `pubspec.yaml` for the complete list and versions)*

## Contributing

Contributions are welcome! Please follow these steps:

1.  Fork the repository.
2.  Create a new branch for your feature or bugfix (`git checkout -b feature/your-feature-name`).
3.  Make your changes and commit them with clear messages (`git commit -m 'feat: Add your feature'`).
4.  Push your branch to your fork (`git push origin feature/your-feature-name`).
5.  Create a Pull Request to the main repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- The Flutter community and documentation.
- Developers of the utilized Flutter packages.



