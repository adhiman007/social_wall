import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/models/post_model.dart';
import '../../../core/utils/extensions.dart';
import '../../create_post/screens/create_post_screen.dart';
import '../providers/dashboard_provider.dart';

class PostWidget extends StatelessWidget {
  final String userId;
  final PostModel post;
  final Reader read;
  const PostWidget({
    Key? key,
    required this.userId,
    required this.post,
    required this.read,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final liked = hasMyLike;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      post.createdByName[0].toUpperCase(),
                      style: textTheme.caption!.copyWith(color: Colors.white),
                    ),
                    maxRadius: 12.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(post.createdByName,
                      style: textTheme.bodyText2!
                          .copyWith(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Text(
                    timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(post.timestamp)),
                    style: textTheme.caption!.copyWith(color: Colors.black26),
                  ),
                  if (post.createdById == userId)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: 8.0 * 3, maxHeight: 8.0 * 4),
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 8.0 * 2,
                        ),
                        onSelected: (value) => _moreOption(context, value),
                        itemBuilder: (context) => ['Edit', 'Delete']
                            .map((e) => PopupMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: e == 'Delete'
                                        ? textTheme.bodyText1
                                            ?.copyWith(color: Colors.red)
                                        : textTheme.bodyText2,
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                post.title,
                style:
                    textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              if (post.hasImage)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: post.url.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : CachedNetworkImage(
                              imageUrl: post.url,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 80.0,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              Text(
                post.description,
                style: textTheme.bodyText2!.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8.0),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: _toggleLike,
                        child: Icon(
                          liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: liked ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: post.likes.isEmpty ? '' : ' ${post.likes.length}',
                      style: textTheme.bodyText2,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get hasMyLike => post.likes.contains(userId);

  Future<void> _moreOption(BuildContext context, String value) async {
    if (value == 'Edit') {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => CreatePostScreen(post: post)));
    } else if (value == 'Delete') {
      if (await context.isConnected) {
        read(repositoryProvider).deletePost(postId: post.id, image: post.image);
      }
    }
  }

  void _toggleLike() {
    final repository = read(repositoryProvider);
    if (hasMyLike) {
      repository.removeFromLike(postId: post.id, userId: userId);
    } else {
      repository.addToLike(postId: post.id, userId: userId);
    }
  }
}
