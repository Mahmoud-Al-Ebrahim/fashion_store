import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/widgets/button.dart';
import '../../../../../app/widgets/text_field.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/helper/helper_functions.dart';
import '../../../../../core/screen_util.dart';

class AddReview extends StatefulWidget {
  final String storeId;
// final StoreBloc storeBloc;

  const AddReview({super.key, required this.storeId,});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {


  @override
  initState() {
    super.initState();

  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ✅ المفتاح
  TextEditingController noteController = TextEditingController();
  double rating = 0;
  File? selectedImage;



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      titlePadding: EdgeInsets.zero,
      title: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
        child: GestureDetector(
          onTap: () {
            context.pop();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
              }
            });
          },
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              height: height(35),
              width: width(35),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  width: 2,
                ),
              ),
              child: Center(child: SvgPicture.asset("assets/svg/cancel.svg")),
            ),
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Form( // ✅ أضفنا الفورم
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "اضافة تقييم",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurface,
                  ),
                ),
                SizedBox(height: height(20)),

                // النجوم
                RatingBar.builder(
                  glowColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  initialRating: 0,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(
                        Icons.star,
                        color: Theme
                            .of(context)
                            .primaryColor,
                      ),
                  onRatingUpdate: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
                SizedBox(height: height(30)),

                // حقل الملاحظة
                AuthTextField(
                  controller: noteController,
                  hintText: "اكتب ملاحظة",
                  radius: 7,
                  validator: (value) {
                    if (value == null || value
                        .trim()
                        .isEmpty) {
                      return "الرجاء إدخال ملاحظة";
                    }
                    return null;
                  },
                ),

                SizedBox(height: height(30)),

                // اختيار الصورة
                GestureDetector(
                  onTap: ()async{
                    XFile? image = await HelperFunctions.pickImage();
                    if (image != null) {
                      setState(() {
                        selectedImage = File(image.path);
                      });
                    }
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        width: 1,
                      ),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Center(
                      child: Text(
                        "اضغط لاختيار صورة",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height(40)),

                // BlocBuilder<StoreBloc, StoreState>(
                //   bloc: widget.storeBloc,
                //   builder: (context, state) {
                //     return state.addReviewState.isLoading
                //         ? LinearProgressIndicator(
                //       minHeight: 2.5,
                //       backgroundColor: Theme
                //           .of(context)
                //           .colorScheme
                //           .surfaceTint
                //           .withOpacity(0.2),
                //     )
                //         : const SizedBox();
                //   },
                // ),
                SizedBox(height: height(10)),

                // BlocBuilder<StoreBloc, StoreState>(
                //   bloc: widget.storeBloc,
                //   builder: (context, state) {
                //     return

                      AuthButton(
                      text: "تقييم",
                      onTap: () {
                        if (_formKey.currentState!
                            .validate()) {} // ✅ تحقق من الفالديشن
                          // widget.storeBloc.add(
                          //   AddReviewEvent(
                          //     storeId: widget.storeId,
                          //     params: AddReviewParams(
                          //       storeId: widget.storeId,
                          //       rate: rating,
                          //       review: noteController.text,
                          //       image: selectedImage,
                          //     ),
                          //       onSuccess: () {
                          //         widget.storeBloc.add(
                          //           StoreReviewsEvent(storeId: widget.storeId, page: '1',),
                          //         );
                          //
                          //         WidgetsBinding.instance.addPostFrameCallback((_) {
                          //           if (context.mounted) {
                          //             Navigator.of(context, rootNavigator: true).pop();
                          //
                          //             Future.delayed(const Duration(milliseconds: 300), () {
                          //               if (mounted) {
                          //                 // مرر سياق من مستوى أعلى بدل Theme.of(context)
                          //                 showFlushBar(
                          //                   Navigator.of(context, rootNavigator: true).context,
                          //                   "تم التقييم بنجاح",
                          //                 );
                          //               }
                          //             });
                          //           }
                          //         });
                          //       }
                          //
                          //
                          //   ),
                        //   );
                        // }
                      },
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}