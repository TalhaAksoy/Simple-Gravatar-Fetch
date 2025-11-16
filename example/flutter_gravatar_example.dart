import 'package:flutter_gravatar/flutter_gravatar.dart';

void main(List<String> arguments) async {
  const email = 'acme@mail.com';

  print('--- Scenario 1: Download and save the image to a file ---');
  await getGravatar(
    email,
    size: 1000,
    saveToFile: true,
    outputPath: 'profile_picture.jpg',
    rating: 'g',
  );

  print('\n--- Scenario 2: Fetch image data into a variable ---');
  final imageData = await getGravatar(
    email,
    size: 1000,
    defaultImage: 'identicon',
    rating: 'g',
  );

  if (imageData != null) {
    print('Image data fetched successfully.');
    print('Size: ${imageData.lengthInBytes} bytes');
    // In a Flutter app, you could use this data with Image.memory(imageData).
  } else {
    print('Failed to fetch image data.');
  }

  final profileData = await getGravatarProfile('talha-_-0@hotmail.com');

  if (profileData != null) {
    if (profileData.containsKey('entry') &&
        (profileData['entry'] as List).isNotEmpty) {
      final entry = (profileData['entry'] as List)[0] as Map<String, dynamic>;
      print('DisplayName: ${entry['displayName']}');
      print('AboutMe: ${entry['aboutMe']}');
      print(entry);
    }
  } else {
    print('Profile Data Not Found');
  }
}
