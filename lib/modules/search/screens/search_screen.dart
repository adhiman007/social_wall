import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialwall/modules/search/providers/search_providers.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../dashboard/widgets/post_widget.dart';

class SearchScreen extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
        ));
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) =>
      Consumer(builder: (context, ref, child) {
        final userId = ref.read(firebaseAuthProvider).currentUser.id;
        final posts = ref.watch(firestoreFilterPostProvider(query.trim()));
        return posts.when(
            data: (data) => data.isEmpty
                ? const Center(child: Text('No Data Found'))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => PostWidget(
                          userId: userId,
                          post: data[index],
                          read: ref.read,
                        )),
            error: (err, stack) => Center(child: Text(err.toString())),
            loading: () => const Center(child: CircularProgressIndicator()));
      });

  @override
  Widget buildSuggestions(BuildContext context) => query.trim().isEmpty
      ? const SizedBox.shrink()
      : Consumer(builder: (context, ref, child) {
          final userId = ref.read(firebaseAuthProvider).currentUser.id;
          final posts = ref.watch(firestoreFilterPostProvider(query.trim()));
          return posts.when(
              data: (data) => data.isEmpty
                  ? const Center(child: Text('No Data Found'))
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => PostWidget(
                            userId: userId,
                            post: data[index],
                            read: ref.read,
                          )),
              error: (err, stack) => Center(child: Text(err.toString())),
              loading: () => const Center(child: CircularProgressIndicator()));
        });
}
