import 'package:socialwall/modules/dashboard/data_source/remote_data_source.dart';

abstract class DashboardRepository {
  final RemoteDataSource remoteDataSource;

  const DashboardRepository(this.remoteDataSource);

  void addToLike({required String postId, required String userId});
  void removeFromLike({required String postId, required String userId});
  void deletePost({required String postId, required String image});
}

class DashboardRepositoryImpl extends DashboardRepository {
  DashboardRepositoryImpl(RemoteDataSource remoteDataSource)
      : super(remoteDataSource);

  @override
  void addToLike({required String postId, required String userId}) =>
      remoteDataSource.addToLike(postId: postId, userId: userId);

  @override
  void removeFromLike({required String postId, required String userId}) =>
      remoteDataSource.removeFromLike(postId: postId, userId: userId);

  @override
  void deletePost({required String postId, required String image}) =>
      remoteDataSource.deletePost(postId: postId, image: image);
}
