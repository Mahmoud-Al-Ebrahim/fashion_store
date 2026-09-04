import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../models/post/post_model.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../widgets/option_picker_field.dart';
import '../../../core/localization/translation_keys.dart';

List<PickerOption> _visibilityOptions() => [
  PickerOption('Public', LK.communityPublic.tr()),
  PickerOption('Followers', LK.communityFollowersOnly.tr()),
];

/// Creates a post, or edits an existing one when [post] is supplied.
///
/// One form serves both so the two paths cannot drift apart. In edit mode
/// the media already on the post is listed alongside any newly picked
/// files: removing an existing one records its id for `deletedMediaIds`
/// rather than deleting it locally, which is what the update endpoint
/// expects.
class AdminPostFormPage extends StatefulWidget {
  final int storeId;
  final PostModel? post;

  const AdminPostFormPage({super.key, required this.storeId, this.post});

  bool get isEditing => post != null;

  @override
  State<AdminPostFormPage> createState() => _AdminPostFormPageState();
}

class _AdminPostFormPageState extends State<AdminPostFormPage> {
  final _contentController = TextEditingController();
  String _visibility = 'Public';
  final List<File> _images = [];

  /// Media already on the post, minus anything the user removed.
  late final List<PostMediaModel> _existingMedia;

  /// Ids the update call should detach.
  final List<int> _deletedMediaIds = [];

  @override
  void initState() {
    super.initState();
    final post = widget.post;
    _existingMedia = [...?post?.postMedias];
    if (post != null) {
      _contentController.text = post.content;
      _visibility = post.visibility;
    }
  }

  Future<void> _addImage() async {
    final file = await HelperFunctions.pickImage();
    if (file != null) setState(() => _images.add(File(file.path)));
  }

  void _submit() {
    if (_contentController.text.trim().isEmpty) {
      showMessage(LK.adminPostContentRequired.tr());
      return;
    }
    final bloc = context.read<PostBloc>();
    final post = widget.post;
    if (post == null) {
      bloc.add(
        AddPostEvent(
          content: _contentController.text.trim(),
          visibility: _visibility,
          media: _images
              .map((f) => PostMediaInput(file: f, mediaType: 'Image'))
              .toList(),
        ),
      );
      return;
    }
    bloc.add(
      UpdatePostEvent(
        postId: post.id,
        storeId: widget.storeId,
        content: _contentController.text.trim(),
        visibility: _visibility,
        newMedias: _images
            .map((f) => PostMediaInput(file: f, mediaType: 'Image'))
            .toList(),
        deletedMediaIds: _deletedMediaIds,
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.isEditing ? LK.adminEditPost.tr() : LK.adminNewPost.tr(),
        ),
      ),
      body: BlocListener<PostBloc, PostState>(
        listenWhen: (p, c) =>
            p.postTransactionStatus != c.postTransactionStatus,
        listener: (context, state) {
          if (state.postTransactionStatus == PostTransactionStatus.success) {
            showMessage(
              widget.isEditing
                  ? LK.adminPostUpdated.tr()
                  : LK.adminPostPublished.tr(),
              hasError: false,
            );
            Navigator.of(context).pop();
          } else if (state.postTransactionStatus ==
              PostTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                controller: _contentController,
                hintText: LK.adminPostContent.tr(),
                maxLines: 5,
                validator: (_) => null,
              ),
              SizedBox(height: height(12)),
              OptionPickerField(
                hintText: LK.adminPostVisibility.tr(),
                options: _visibilityOptions(),
                selectedValue: _visibility,
                onSelected: (o) => setState(() => _visibility = o.value),
              ),
              SizedBox(height: height(12)),
              Wrap(
                spacing: width(10),
                runSpacing: height(10),
                children: [
                  // Media already on the post; removing one queues its id
                  // for deletion instead of dropping it silently.
                  ..._existingMedia.map(
                    (media) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            media.mediaUrl,
                            width: width(90),
                            height: width(90),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: width(90),
                              height: width(90),
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _deletedMediaIds.add(media.postMediaId);
                              _existingMedia.remove(media);
                            }),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._images.map(
                    (file) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            file,
                            width: width(90),
                            height: width(90),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => setState(() => _images.remove(file)),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _addImage,
                    child: Container(
                      width: width(90),
                      height: width(90),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_photo_alternate_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height(24)),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  final loading =
                      state.postTransactionStatus ==
                      PostTransactionStatus.loading;
                  return AuthButton(
                    text: loading
                        ? LK.adminPublishing.tr()
                        : LK.adminPublish.tr(),
                    onTap: loading ? null : _submit,
                    widthButton: double.infinity,
                    heightButton: height(56),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
