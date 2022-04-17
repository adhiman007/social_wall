import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialwall/core/providers/firebase_providers.dart';

import '../providers/dashboard_provider.dart';
import 'post_widget.dart';

class PostListWidget extends StatelessWidget {
  const PostListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final userId = ref.read(firebaseAuthProvider).currentUser.id;
      final post = ref.watch(firestorePostProvider);
      return post.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('No Data Found'));
            } else {
              return ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, index) => PostWidget(
                  userId: userId,
                  post: data[index],
                  read: ref.read,
                ),
              );
            }
          },
          error: (err, stack) => Center(child: Text(err.toString())),
          loading: () => const Center(child: CircularProgressIndicator()));
    });
  }
}
