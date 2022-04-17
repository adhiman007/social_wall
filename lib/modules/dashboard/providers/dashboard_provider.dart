import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/firebase_providers.dart';
import '../repository/dashboard_repository.dart';

final repositoryProvider = Provider<DashboardRepository>(((_) => getIt()));

final firestorePostProvider = StreamProvider<List<PostModel>>(
    (ref) => ref.read(cloudFirestoreProvider).posts);
