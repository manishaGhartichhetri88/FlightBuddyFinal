import 'dart:io';

class ImageService {
  Future<String> uploadImage(File image) async {
    await Future.delayed(const Duration(seconds: 2));
    return "https://picsum.photos/200"; // mock server image
  }

  Future<String> fetchProfileImage() async {
    await Future.delayed(const Duration(seconds: 1));
    return "https://picsum.photos/200";
  }
}
