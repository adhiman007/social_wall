import '../../../core/firebase/cloud_firestore_util.dart';
import '../../../core/firebase/firebase_auth_util.dart';
import '../../../core/firebase/firebase_storage_util.dart';
import '../../../core/models/post_model.dart';

abstract class RemoteDataSource {
  final CloudFirestoreUtil cloudFirestore;
  final FirebaseAuthUtil firebaseAuth;
  final FirebaseStorageUtil firebaseStorage;
  const RemoteDataSource(
      this.cloudFirestore, this.firebaseAuth, this.firebaseStorage);

  Future<void> createPost({
    required String title,
    required String description,
    required bool hasImage,
    required String image,
  });
  void updatePost(PostModel post);
}

class RemoteDataSourceImpl extends RemoteDataSource {
  RemoteDataSourceImpl(
    CloudFirestoreUtil cloudFirestore,
    FirebaseAuthUtil firebaseAuth,
    FirebaseStorageUtil firebaseStorage,
  ) : super(cloudFirestore, firebaseAuth, firebaseStorage);

  @override
  Future<void> createPost({
    required String title,
    required String description,
    required bool hasImage,
    required String image,
  }) async {
    final userId = firebaseAuth.currentUser.id;
    final name = await cloudFirestore.getUserName(userId);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final post = PostModel(
      title: title,
      description: description,
      createdById: userId,
      createdByName: name,
      timestamp: timestamp,
      image: image.split('/').last,
      url: '',
      hasImage: hasImage,
      likes: [],
    );
    cloudFirestore.createPost(post).then((postId) => firebaseStorage
        .uploadImage(image)
        .then((url) => cloudFirestore.updateImage(postId, url)));
  }

  @override
  void updatePost(PostModel post) {
    if (post.url.isEmpty) {
      final image = post.image;
      cloudFirestore.updatePost(post.copyWith(image: image.split('/').last));
      firebaseStorage
          .uploadImage(image)
          .then((url) => cloudFirestore.updateImage(post.id, url));
    } else {
      cloudFirestore.updatePost(post);
    }
  }
}
