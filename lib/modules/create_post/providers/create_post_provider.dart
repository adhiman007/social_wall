import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../repository/create_post_repository.dart';

final repositoryProvider = Provider<CreatePostRepository>(((_) => getIt()));

final autoValidateProvider = StateProvider<AutovalidateMode>((_) => AutovalidateMode.disabled);

final selectedImageProvider = StateProvider.autoDispose<String>((_) => '');