import '../../../core/models/post_model.dart';
import '../data_source/remote_data_source.dart';

abstract class CreatePostRepository {
  final RemoteDataSource remoteDataSource;

  const CreatePostRepository(this.remoteDataSource);

  Future<void> createPost({
    required String title,
    required String description,
    required bool hasImage,
    required String image,
  });
  void updatePost(PostModel post);
}

class CreatePostRepositoryImpl extends CreatePostRepository {
  CreatePostRepositoryImpl(RemoteDataSource remoteDataSource)
      : super(remoteDataSource);

  @override
  Future<void> createPost({
    required String title,
    required String description,
    required bool hasImage,
    required String image,
  }) =>
      remoteDataSource.createPost(
        title: title,
        description: description,
        hasImage: hasImage,
        image: image,
      );

  @override
  void updatePost(PostModel post) => remoteDataSource.updatePost(post);
}
