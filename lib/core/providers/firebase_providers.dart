import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core.dart';
import '../firebase/cloud_firestore_util.dart';
import '../firebase/firebase_auth_util.dart';

final firebaseAuthProvider = Provider<FirebaseAuthUtil>(((_) => getIt()));

final cloudFirestoreProvider = Provider<CloudFirestoreUtil>((_) => getIt());