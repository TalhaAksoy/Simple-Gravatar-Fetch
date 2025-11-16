import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// Get Gravatar User Profile Data
/// [email] String , user email
///
/// [returnValue]
///  - {
///   "entry": [
///     {
///       "hash": "...",
///       "displayName": "UserName",
///       "aboutMe": "AboutText",
///       "currentLocation": "Location...",
///       "urls": [ ... ],
///       "accounts": [ ... ]
///     }
///   ]
/// }
Future<Map<String, dynamic>?> getGravatarProfile(String email) async {
  final trimmedMail = email.trim().toLowerCase();

  final bytes = utf8.encode(trimmedMail);
  final digest = md5.convert(bytes);
  final hash = digest.toString();

  final url = Uri.https('www.gravatar.com', '/$hash.json');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final profileData = jsonDecode(response.body) as Map<String, dynamic>;
      return profileData;
    } else if (response.statusCode == 404) {
      print('Profile Not Found For This Email');
      return null;
    } else {
      print("Can't get profile. Status Code : ${response.statusCode}");
      return null;
    }
  } on http.ClientException catch (e) {
    print('Network Error : $e ');
    return null;
  } on SocketException catch (e) {
    print('Socket Error : $e');
    return null;
  } on FormatException catch (e) {
    print('JSON Parse Error : $e');
    return null;
  } catch (e) {
    print('Unexpected Error : $e');
    return null;
  }
}

/// Fetches a Gravatar profile picture for a given email address.
///
/// Returns the image data as a [Uint8List] on success, or `null` on failure.
///
/// The [email] is trimmed and converted to lowercase before being hashed.
///
/// Optional parameters:
/// - [size]: The desired image size in pixels (1 to 2048).
/// - [defaultImage]: The fallback image to use if no Gravatar is found.
///   Can be a URL or a predefined Gravatar option (e.g., 'mp', 'identicon').
/// - [rating]: The maximum allowed image rating (e.g., 'g', 'pg', 'r', 'x').
/// - [saveToFile]: If `true`, the downloaded image will be saved to [outputPath].
/// - [outputPath]: The file path to save the image to if [saveToFile] is `true`.
Future<Uint8List?> getGravatar(
  String email, {
  bool saveToFile = false,
  String outputPath = 'avatar.jpg',
  int? size,
  String? defaultImage,
  String? rating,
}) async {
  // Ensure size is within the valid range for Gravatar.
  assert(
    size == null || (size >= 1 && size <= 2048),
    'Size must be between 1 and 2048.',
  );

  // Trim and lowercase the email as required by Gravatar.
  final trimmedEmail = email.trim().toLowerCase();

  // Create the MD5 hash of the email address.
  final bytes = utf8.encode(trimmedEmail);
  final digest = md5.convert(bytes);
  final hash = digest.toString();

  // Build the query parameters for the URL.
  final queryParameters = <String, String>{};

  if (size != null) {
    queryParameters['s'] = size.toString();
  }
  if (defaultImage != null) {
    queryParameters['d'] = defaultImage;
  }
  if (rating != null) {
    queryParameters['r'] = rating;
  }

  final url = Uri.https('www.gravatar.com', '/avatar/$hash', queryParameters);

  print('Fetching Gravatar from: $url');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final imageBytes = response.bodyBytes;

      // If requested, save the image to a file.
      if (saveToFile) {
        try {
          final file = File(outputPath);
          await file.writeAsBytes(imageBytes);
          print('Gravatar image saved successfully to: $outputPath');
        } on FileSystemException catch (e) {
          print('Error saving file: $e');
          // Return the bytes even if saving fails, as the download was successful.
        }
      }

      // Return the image data.
      return imageBytes;
    } else {
      print('Failed to fetch Gravatar. Status code: ${response.statusCode}');
      return null;
    }
  } on http.ClientException catch (e) {
    print('Network error fetching Gravatar: $e');
    return null;
  } on SocketException catch (e) {
    print('Socket error fetching Gravatar: $e');
    return null;
  } catch (e) {
    print('An unexpected error occurred: ');
    return null;
  }
}
