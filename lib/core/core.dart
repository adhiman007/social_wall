import 'package:get_it/get_it.dart';

import '../modules/create_post/data_source/remote_data_source.dart'
    as createpost;
import '../modules/create_post/repository/create_post_repository.dart';
import '../modules/dashboard/data_source/remote_data_source.dart' as dashboard;
import '../modules/dashboard/repository/dashboard_repository.dart';
import 'firebase/cloud_firestore_util.dart';
import 'firebase/firebase_auth_util.dart';
import 'firebase/firebase_storage_util.dart';

final getIt = GetIt.instance;

void init() {
  _initFirebase();
  _dashboard();
  _createPost();
}

void _initFirebase() {
  getIt.registerLazySingleton<FirebaseAuthUtil>(() => FirebaseAuthUtil());
  getIt.registerLazySingleton<CloudFirestoreUtil>(() => CloudFirestoreUtil());
  getIt.registerLazySingleton<FirebaseStorageUtil>(() => FirebaseStorageUtil());
}

void _dashboard() {
  getIt.registerLazySingleton<dashboard.RemoteDataSource>(
      () => dashboard.RemoteDataSourceImpl(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(getIt()));
}

void _createPost() {
  getIt.registerLazySingleton<createpost.RemoteDataSource>(
      () => createpost.RemoteDataSourceImpl(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<CreatePostRepository>(
      () => CreatePostRepositoryImpl(getIt()));
}
