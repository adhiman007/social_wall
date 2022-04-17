import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../authentication/screens/authentication_screen.dart';
import '../../create_post/screens/create_post_screen.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/post_list_widget.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Wall', style: textTheme.headline6),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: _showSearch,
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const PostListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        tooltip: 'Create Post',
        child: const Icon(Icons.post_add),
      ),
    );
  }

  void _init() => ref.read(firebaseAuthProvider).userStream.listen((e) {
        if (e.isEmpty) _gotoAuthentication();
      });

  void _createPost() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => const CreatePostScreen()));

  Future<void> _signOut() async {
    if (await context.isConnected) {
      ref.read(firebaseAuthProvider).signOut();
    }
  }

  void _gotoAuthentication() => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthenticationScreen()));

  Future<void> _showSearch() async {
    if (await context.isConnected) {
      showSearch(context: context, delegate: SearchScreen());
    }
  }
}
