# flutter_gravatar

[![pub version][pub-badge]][pub-link]
[![license][license-badge]][license-link]

[pub-badge]: https://img.shields.io/pub/v/flutter_gravatar.svg
[pub-link]: https://pub.dev/packages/flutter_gravatar
[license-badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license-link]: ./LICENSE

A simple, pure Dart package for fetching user profiles and avatars from the Gravatar API.

This package is written in **100% Pure Dart** and can be used in Flutter, Dart (Server-side), or Dart (Command-line) projects.

## ✨ Features

* Fetch **public profile data** (as JSON) associated with an email address.
* Fetch the **avatar image** (`Uint8List`) for an email address.
* Supports Gravatar options like image size, default image (`identicon`, `mp`, etc.), and rating.
* Option to save the downloaded avatar directly to a file.

---

## 🚀 Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_gravatar: ^1.0.0 # Check pub.dev for the latest version
```

And install the packages:

```bash
flutter pub get
# or
dart pub get
```

---

## ⚙️ Usage

Simply import the package to use it:

```dart
import 'package:flutter_gravatar/flutter_gravatar.dart';
```

### 1. Getting an Avatar Image (`getGravatar`)

Fetches the user's profile picture as a `Uint8List`. This can be used directly with `Image.memory` in Flutter.

```dart
import 'dart:typed_data'; // For Uint8List

void main() async {
  const email = 'talha-_-0@hotmail.com';

  final Uint8List? imageData = await getGravatar(
    email,
    size: 200,
    defaultImage: 'identicon', // Generate an identicon if not found
    rating: 'g',
  );

  if (imageData != null) {
    print('Image fetched successfully. Size: ${imageData.lengthInBytes} bytes');
    // In Flutter:
    // return Image.memory(imageData);
  } else {
    print('Failed to fetch image.');
  }
}
```

#### Saving the Avatar to a File

The `getGravatar` function also allows you to save the image directly to disk.

```dart
await getGravatar(
  'talha-_-0@hotmail.com',
  size: 500,
  saveToFile: true,
  outputPath: 'profile_picture.jpg',
);

print('Image saved to profile_picture.jpg');
```

### 2. Getting Profile Information (`getGravatarProfile`)

Use this to fetch a user's public profile (as JSON), which may include their name, location, "about me" text, etc.

```dart
void main() async {
  // An email known to have a public profile (for testing)
  const email = 'beau@wordpress.com';

  final profileData = await getGravatarProfile(email);

  if (profileData != null) {
    // Gravatar returns data inside an 'entry' list
    if (profileData.containsKey('entry') &&
        (profileData['entry'] as List).isNotEmpty) {
      final entry = (profileData['entry'] as List)[0] as Map<String, dynamic>;

      print('Display Name: ${entry['displayName']}');
      print('Location: ${entry['currentLocation']}');
      print('About Me: ${entry['aboutMe']}');
    }
  } else {
    print('No profile found for this email (404).');
  }
}
```

---

## 📚 API Quick Reference

### `Future<Uint8List?> getGravatar(String email, { ... })`

Returns the avatar image as a `Uint8List`.

**Optional Parameters:**
* `int? size`: Image size in pixels (1-2048).
* `String? defaultImage`: Fallback image to use if not found ('mp', 'identicon', '404', or a URL).
* `String? rating`: Maximum allowed image rating ('g', 'pg', 'r', 'x').
* `bool saveToFile`: If `true`, saves the image to disk (default: `false`).
* `String outputPath`: The file path to use if `saveToFile` is true (default: 'avatar.jpg').

### `Future<Map<String, dynamic>?> getGravatarProfile(String email)`

Returns the public profile associated with the email as a JSON `Map`. Returns `null` if the profile is not found or is private.

---

## 📄 License

This package is released under the [MIT License](./LICENSE).
