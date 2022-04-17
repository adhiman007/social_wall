import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/post_model.dart';
import '../../../core/providers/firebase_providers.dart';

final firestoreFilterPostProvider =
    StreamProvider.family<List<PostModel>, String>(
        (ref, filter) => ref.read(cloudFirestoreProvider).filter(filter));
