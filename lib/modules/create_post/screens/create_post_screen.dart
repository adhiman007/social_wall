import 'package:flutter/material.dart';
import 'package:socialwall/core/models/post_model.dart';

import '../widgets/create_post_form_widget.dart';

class CreatePostScreen extends StatelessWidget {
  final PostModel? post;
  const CreatePostScreen({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post', style: textTheme.headline6),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: CreatePostFormWidget(post: post),
    );
  }
}
