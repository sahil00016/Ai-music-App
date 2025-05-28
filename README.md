# Gesture and Voice-Controlled Smart Interaction App

A Flutter application that allows users to control app actions using either hand gestures or voice commands, enabling a touchless, intelligent interface.

## Features

- 🤚 Hand Gesture Recognition
  - Real-time gesture detection using camera
  - Support for multiple gestures (Wave, Peace, Pointing)
  - Customizable gesture-to-action mapping

- 🎤 Voice Command Control
  - Speech-to-text conversion
  - Natural language command processing
  - Multiple command support

- 🎨 Modern UI Design
  - Clean and intuitive interface
  - Real-time feedback
  - Smooth animations

## Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development)
- Camera access
- Microphone access

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/yourusername/gesture_voice_control_app.git
```

2. Navigate to the project directory:
```bash
cd gesture_voice_control_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Required Permissions

The app requires the following permissions:

- Camera access for gesture recognition
- Microphone access for voice commands
- Storage access (optional, for saving settings)

## Project Structure

```
lib/
├── constants/
│   └── theme.dart
├── screens/
│   └── home_screen.dart
├── services/
│   ├── gesture_service.dart
│   ├── voice_service.dart
│   └── command_handler.dart
├── widgets/
├── models/
└── main.dart
```

## Dependencies

- camera: ^0.10.5+5
- speech_to_text: ^6.5.1
- permission_handler: ^11.0.1
- google_mlkit_commons: ^0.6.1
- google_mlkit_pose_detection: ^0.9.0
- provider: ^6.1.1
- flutter_svg: ^2.0.9
- google_fonts: ^6.1.0
- flutter_animate: ^4.3.0

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Google ML Kit for pose detection
- Speech to Text package contributors 