import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../utils/exceptions.dart';

class FirebaseStorageUtil {
  final Reference _ref = FirebaseStorage.instance.ref();

  Future<String> uploadImage(String image) async {
    try {
      final name = image.split('/').last;
      final location = _ref.child('images/$name');
      await location.putFile(File(image));
      final url = await location.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw FireBaseException(e.message ?? 'Unknown Error');
    } catch (e) {
      throw const FireBaseException('Unknown Error. Please try again');
    }
  }

  void deleteImage(String image) => _ref.child('images/$image').delete();
}
