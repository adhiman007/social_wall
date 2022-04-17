import 'package:socialwall/core/firebase/firebase_storage_util.dart';

import '../../../core/firebase/cloud_firestore_util.dart';
import '../../../core/firebase/firebase_auth_util.dart';

abstract class RemoteDataSource {
  final CloudFirestoreUtil cloudFirestore;
  final FirebaseAuthUtil firebaseAuth;
  final FirebaseStorageUtil firebaseStorage;

  const RemoteDataSource(
      this.cloudFirestore, this.firebaseAuth, this.firebaseStorage);

  void addToLike({required String postId, required String userId});
  void removeFromLike({required String postId, required String userId});
  void deletePost({required String postId, required String image});
}

class RemoteDataSourceImpl extends RemoteDataSource {
  RemoteDataSourceImpl(
    CloudFirestoreUtil cloudFirestore,
    FirebaseAuthUtil firebaseAuth,
    FirebaseStorageUtil firebaseStorage,
  ) : super(cloudFirestore, firebaseAuth, firebaseStorage);

  @override
  void addToLike({required String postId, required String userId}) =>
      cloudFirestore.addToLike(postId, userId);

  @override
  void removeFromLike({required String postId, required String userId}) =>
      cloudFirestore.removeFromLike(postId, userId);

  @override
  void deletePost({required String postId, required String image}) {
    cloudFirestore.deletePost(postId);
    firebaseStorage.deleteImage(image);
  }
}
