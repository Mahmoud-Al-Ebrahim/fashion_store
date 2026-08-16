import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';

class SelectStoryAndNoteDialog extends StatefulWidget {
  const SelectStoryAndNoteDialog({super.key});

  @override
  State<SelectStoryAndNoteDialog> createState() =>
      _SelectStoryAndNoteDialogState();
}

class _SelectStoryAndNoteDialogState extends State<SelectStoryAndNoteDialog> {
  File? _selectedFile;

  final TextEditingController controller = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia() async {
    final XFile? file = await _picker.pickMedia();

    if (file != null) {
      setState(() {
        _selectedFile = File(file.path);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      content: Stack(
        children: [
          SizedBox(
            height: height(500),
            width: 1.sw,
            child: Column(
              spacing: height(15),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickMedia(),
                  icon: Icon(Icons.perm_media_outlined , color: Theme.of(context).colorScheme.primary,),
                  label: Text("اختر صورة أو فيديو"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: AuthTextField(
                    controller: controller,
                    hintText: "إضافة نص",
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                AuthButton(
                  text: "رفع",
                  onTap: () {
                    if (_selectedFile == null) {
                      showMessage("رجاء قم باختيار ملف");
                    }
                    // BlocProvider.of<CommunityBloc>(context).add(
                    //   AddStoryEvent(
                    //     onSuccess: () {},
                    //     params: AddStoryParams(
                    //       imageOrVideo: _selectedFile!,
                    //       text: controller.text,
                    //     ),
                    //   ),
                    // );
                    context.pop();
                  },
                  widthButton: 1.sw - 75,
                  heightButton: height(60),
                ),
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: height(35),
                  width: width(35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(child: SvgPicture.asset("assets/svg/cancel.svg")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
