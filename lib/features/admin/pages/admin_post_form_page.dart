import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../widgets/option_picker_field.dart';

const _visibilityOptions = [
  PickerOption('Public', 'عام'),
  PickerOption('Followers', 'للمتابعين فقط'),
];

class AdminPostFormPage extends StatefulWidget {
  final int storeId;

  const AdminPostFormPage({super.key, required this.storeId});

  @override
  State<AdminPostFormPage> createState() => _AdminPostFormPageState();
}

class _AdminPostFormPageState extends State<AdminPostFormPage> {
  final _contentController = TextEditingController();
  String _visibility = 'Public';
  final List<File> _images = [];

  Future<void> _addImage() async {
    final file = await HelperFunctions.pickImage();
    if (file != null) setState(() => _images.add(File(file.path)));
  }

  void _submit() {
    if (_contentController.text.trim().isEmpty) {
      showMessage('يرجى كتابة محتوى المنشور');
      return;
    }
    context.read<PostBloc>().add(
      AddPostEvent(
        content: _contentController.text.trim(),
        visibility: _visibility,
        media: _images
            .map((f) => PostMediaInput(file: f, mediaType: 'Image'))
            .toList(),
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
        title: const Text('منشور جديد'),
      ),
      body: BlocListener<PostBloc, PostState>(
        listenWhen: (p, c) => p.postTransactionStatus != c.postTransactionStatus,
        listener: (context, state) {
          if (state.postTransactionStatus == PostTransactionStatus.success) {
            showMessage('تم نشر المنشور', hasError: false);
            Navigator.of(context).pop();
          } else if (state.postTransactionStatus == PostTransactionStatus.failure) {
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
                hintText: 'اكتب شيئاً...',
                maxLines: 5,
                validator: (_) => null,
              ),
              SizedBox(height: height(12)),
              OptionPickerField(
                hintText: 'من يمكنه رؤية المنشور',
                options: _visibilityOptions,
                selectedValue: _visibility,
                onSelected: (o) => setState(() => _visibility = o.value),
              ),
              SizedBox(height: height(12)),
              Wrap(
                spacing: width(10),
                runSpacing: height(10),
                children: [
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
                              child: Icon(Icons.close, size: 12, color: Colors.white),
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
                      state.postTransactionStatus == PostTransactionStatus.loading;
                  return AuthButton(
                    text: loading ? '...جاري النشر' : 'نشر',
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
