# Flutter Video Streaming App

<p align="center">
  <img src="assets/images/app_icon.png" alt="App Logo" width="120" />
</p>

<h3 align="center">A Powerful Cross-Platform Video Entertainment Platform</h3>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-3.x-blue.svg" alt="Flutter Version">
  </a>
  <a href="https://github.com/your-username/cool-flutter-app/stargazers">
    <img src="https://img.shields.io/github/stars/your-username/cool-flutter-app.svg" alt="GitHub Stars">
  </a>
  <a href="https://github.com/your-username/cool-flutter-app/network/members">
    <img src="https://img.shields.io/github/forks/your-username/cool-flutter-app.svg" alt="GitHub Forks">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/your-username/cool-flutter-app.svg" alt="License">
  </a>
</p>

## 📱 Overview

This is a modern video entertainment platform built with Flutter, offering rich video content and premium user experience. The application adopts Clean Architecture pattern with well-organized code structure and excellent maintainability.

### 🎯 Key Features

- 🚀 **High Performance**: Built on Flutter framework for smooth user experience
- 📱 **Cross-Platform**: Single codebase supporting both Android and iOS
- 🔧 **Modular Design**: Clear architecture for easy maintenance and extension
- 💾 **Offline Support**: Local caching mechanism for improved access speed
- 🌐 **Internationalization**: Multi-language support

## 🌟 Core Features

### 🎬 Content Features

| Feature | Description |
|---------|-------------|
| **Video Categories** | Browse movies, TV shows, variety shows, and animations |
| **Smart Recommendation** | Personalized content recommendation based on user behavior |
| **Popular Rankings** | Real-time updated video rankings |
| **Advanced Search** | Multi-dimensional search by keywords, actors, directors |
| **Filter System** | Precise filtering by region, year, genre |

### ▶️ Playback Experience

- **Multi-Quality Support**: 720P, 1080P, 4K ultra-high definition options
- **Smooth Playback**: Optimized video loading and buffering mechanism
- **Resume Playback**: Automatic progress recording for continuous watching
- **Playback Speed**: Support for 0.5x-2x playback speeds
- **Cast Functionality**: Support for Chromecast and other devices
- **Danmaku System**: Real-time bullet comments interaction

### 👤 User System

- **Account System**: Phone/email registration and login
- **Personal Center**: Watch history, favorites, profile management
- **Preference Settings**: Personalized themes and playback settings
- **VIP Services**: Premium features and exclusive content
- **Points System**: Earn points through watching and check-ins

### 🤝 Social Interaction

- **Rating System**: Five-star rating and detailed reviews
- **Comment Community**: User discussion and exchange platform
- **Sharing Function**: One-click sharing to social platforms
- **Following System**: Follow favorite creators
- **Notification System**: System messages and personal interaction alerts

## 🛠 Technical Architecture

### 🏗 Overall Architecture

This project adopts **Clean Architecture** + **MVVM** pattern:

```
lib/
├── core/                   # Core module
│   ├── constants/          # Constant definitions
│   ├── exceptions/         # Exception handling
│   ├── extensions/         # Extension methods
│   ├── router/             # Route management
│   ├── theme/              # Theme configuration
│   └── utils/              # Utility classes
├── data/                   # Data layer
│   ├── datasources/        # Data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                 # Domain layer
│   ├── entities/           # Entity classes
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
├── presentation/           # Presentation layer
│   ├── controllers/        # Controllers
│   ├── pages/              # Page components
│   ├── widgets/            # Common components
│   └── routes/             # Route configuration
└── main.dart               # Application entry
```

### 🔧 Technology Stack

| Category | Technology/Library | Version | Purpose |
|----------|-------------------|---------|---------|
| **Core Framework** | Flutter | 3.x | Cross-platform development |
| **State Management** | GetX | ^4.6.5 | State management and routing |
| **Network** | Dio | ^4.0.6 | HTTP client |
| **JSON Serialization** | json_serializable | ^6.5.4 | JSON serialization |
| **Database** | Hive | ^2.2.3 | Local data storage |
| **Video Player** | video_player | ^2.4.7 | Core video playback |
| **Player UI** | chewie | ^1.3.4 | Video player component |
| **Image Loading** | cached_network_image | ^3.2.1 | Cached image loading |
| **UI Components** | flutter_svg | ^1.1.6 | SVG icon support |
| **Pull Refresh** | pull_to_refresh | ^2.0.0 | Pull-to-refresh component |
| **Ad Integration** | google_mobile_ads | ^2.3.0 | Ad serving |

### 📊 Performance Optimization

- **Lazy Loading**: On-demand loading for lists and images
- **Memory Management**: Timely release of unused resources
- **Caching Strategy**: Multi-level caching for improved access speed
- **Code Splitting**: On-demand loading to reduce initial package size
- **Native Integration**: Native implementation for critical functions

## 🚀 Quick Start

### Requirements

- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development)

### Installation Steps

1. **Clone the Repository**
```bash
git clone https://github.com/your-username/cool-flutter-app.git
cd cool-flutter-app
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Generate Code**
```bash
flutter pub run build_runner build
```

4. **Run the Application**
```bash
# Android
dart run build_runner build && flutter run

# iOS (requires macOS)
flutter run -d iphone
```

### Environment Configuration

Create `lib/core/constants/env.dart` file:

```dart
class Env {
  static const String baseUrl = 'https://api.yourdomain.com';
  static const String apiKey = 'your_api_key';
  static const bool isDebug = true;
}
```

## 📖 Usage Guide

### Basic Operations

1. **Home Browsing**: Swipe to view recommended content
2. **Category Filtering**: Tap bottom navigation to switch categories
3. **Search Function**: Tap top search bar to search
4. **Video Playback**: Tap video cover to start playing
5. **Personal Center**: Tap avatar to enter personal page

### Advanced Features

- **Offline Caching**: Automatically cache popular content in WiFi environment
- **Night Mode**: Enable dark theme in settings
- **Playback Records**: Automatic sync of viewing progress
- **Danmaku Settings**: Adjust danmaku transparency and size

## 🤝 Contribution Guidelines

We welcome contributions of all kinds!

### Contribution Process

1. Fork this repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Code Standards

- Follow Flutter official coding conventions
- Use dartfmt to format code
- Add necessary comments and documentation
- Write unit tests covering core functionality

## 📱 Screenshots

<div style="display: flex; justify-content: space-around;">
  <img src="screenshots/home.png" width="200" alt="Home">
  <img src="screenshots/detail.png" width="200" alt="Detail">
  <img src="screenshots/player.png" width="200" alt="Player">
  <img src="screenshots/profile.png" width="200" alt="Profile">
</div>

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev/) - Powerful cross-platform development framework
- [GetX](https://pub.dev/packages/get) - Excellent state management solution
- [Dio](https://pub.dev/packages/dio) - Powerful HTTP client
- All open-source contributors and supporters

## 📞 Contact

- **Author**: Your Name
- **Email**: your.email@example.com
- **GitHub**: [@your-username](https://github.com/your-username)

---

<p align="center">Made with ❤️ using Flutter</p>
