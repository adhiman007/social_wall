import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';

class CloudFirestoreUtil {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _posts =
      FirebaseFirestore.instance.collection('posts');

  void addUser(String id, String name) => _users.doc(id).set({'name': name});

  Future<String> getUserName(String id) async =>
      ((await _users.doc(id).get()).data() as Map<String, dynamic>)['name'];

  Future<String> createPost(PostModel post) async =>
      (await _posts.add(post.toMap())).id;

  void updatePost(PostModel post) => _posts.doc(post.id).set(post.toMap());

  void deletePost(String postId) => _posts.doc(postId).delete();

  Stream<List<PostModel>> get posts =>
      _posts.orderBy('timestamp', descending: true).snapshots().map(_mapPost);

  Stream<List<PostModel>> filter(String query) {
    return _posts
        .orderBy('title')
        .orderBy('description')
        .startAt([query])
        .endAt([query + "\uf8ff"])
        .snapshots()
        .map(_mapPost);
  }

  void addToLike(String postId, String userId) {
    _posts.doc(postId).get().then((value) {
      final data = value.data() as Map<String, dynamic>;
      final post = PostModel.fromMap(data);
      if (!post.likes.contains(userId)) {
        _posts.doc(postId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
      }
    });
  }

  void removeFromLike(String postId, String userId) {
    _posts.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId])
    });
  }

  void updateImage(String postId, String image) {
    _posts.doc(postId).update({'url': image});
  }

  List<PostModel> _mapPost(QuerySnapshot snapshot) => snapshot.docs
      .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>)
          .copyWith(id: doc.id))
      .toList();
}
