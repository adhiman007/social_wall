import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/post_model.dart';
import '../../../core/utils/extensions.dart';
import '../providers/create_post_provider.dart';

class CreatePostFormWidget extends StatefulWidget {
  final PostModel? post;
  const CreatePostFormWidget({Key? key, this.post}) : super(key: key);

  @override
  State<CreatePostFormWidget> createState() => _CreatePostFormWidgetState();
}

class _CreatePostFormWidgetState extends State<CreatePostFormWidget> {
  final _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkForEdit();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0 * 2),
      child: Consumer(builder: (context, ref, child) {
        return IgnorePointer(
          ignoring: false,
          child: Consumer(builder: (context, ref, child) {
            final autoValidate = ref.watch(autoValidateProvider);
            return Form(
                key: _formKey,
                autovalidateMode: autoValidate,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _titleController,
                        maxLines: 1,
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          labelText: 'Title',
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter title';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 8.0 * 2),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        maxLength: 500,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          labelText: 'Post Description',
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter post description';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 8.0 * 2),
                      widget.post == null || widget.post!.url.isEmpty
                          ? Consumer(
                              builder: (context, ref, child) {
                                final image = ref.watch(selectedImageProvider);
                                return image.isEmpty
                                    ? child!
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.file(
                                            File(image),
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: 0.0,
                                            right: 8.0,
                                            child: IconButton(
                                              onPressed: () =>
                                                  _updateImage(ref, ''),
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                size: 8.0 * 4,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: PopupMenuButton<String>(
                                  icon: const Icon(Icons.add_a_photo_rounded),
                                  onSelected: (value) =>
                                      _captureImage(ref, value),
                                  itemBuilder: (context) =>
                                      ['Gallery', 'Camera']
                                          .map((e) => PopupMenuItem<String>(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                ),
                              ),
                            )
                          : widget.post!.hasImage && widget.post!.url.isNotEmpty
                              ? Image.network(widget.post!.url)
                              : const SizedBox.shrink(),
                      const SizedBox(height: 8.0 * 2),
                      ElevatedButton(
                        onPressed: () => _createUpdatePost(ref),
                        child: Text(widget.post == null
                            ? 'Create Post'
                            : 'Update Post'),
                      ),
                    ],
                  ),
                ));
          }),
        );
      }),
    );
  }

  Future<void> _captureImage(WidgetRef ref, String value) async {
    final image = await _picker.pickImage(
      source: value == 'Gallery' ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      _updateImage(ref, image.path);
    } else {
      _updateImage(ref, '');
    }
  }

  Future<void> _createUpdatePost(WidgetRef ref) async {
    if (await context.isConnected) {
      if (_formKey.currentState!.validate()) {
        final repository = ref.read(repositoryProvider);
        final image = ref.read(selectedImageProvider);
        if (widget.post == null) {
          repository.createPost(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            hasImage: image.isNotEmpty,
            image: image,
          );
        } else {
          final post = widget.post!.url.isEmpty
              ? widget.post!.copyWith(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  hasImage: image.isNotEmpty,
                  image: image,
                )
              : widget.post!.copyWith(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                );
          repository.updatePost(post);
        }
        Navigator.of(context).pop();
      } else {
        ref
            .read(autoValidateProvider.notifier)
            .update((_) => AutovalidateMode.always);
      }
    }
  }

  void _checkForEdit() {
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _descriptionController.text = widget.post!.description;
    }
  }

  void _updateImage(WidgetRef ref, String image) =>
      ref.read(selectedImageProvider.notifier).update((_) => image);
}
