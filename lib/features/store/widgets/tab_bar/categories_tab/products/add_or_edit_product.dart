import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../app/widgets/app_draggable_sheet.dart';
import '../../../../../../app/widgets/button.dart';
import '../../../../../../app/widgets/text_field.dart';
import '../../../../../../core/extensions/build_context.dart';
import '../../../../../../core/screen_util.dart';
import '../../../../../../core/utils/show_message.dart';
import '../../../../../../models/store/store_products_model.dart';
import '../../../../../common/categories_picker.dart';

class AddOrEditProduct extends StatefulWidget {
  const AddOrEditProduct({super.key, this.product});

  final Product? product;

  @override
  State<AddOrEditProduct> createState() => _AddOrEditProductState();
}

class _AddOrEditProductState extends State<AddOrEditProduct> {
  final formKey = GlobalKey<FormState>();

  // late final AuthUserBloc authUserBloc;

  late final TextEditingController price;
  late final TextEditingController productName;
  late final TextEditingController preparationTime;
  late final TextEditingController description;
  late final TextEditingController categoryController;

  late final ValueNotifier<XFile?> image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      image.value = file;
    }
  }

  @override
  void initState() {
    // authUserBloc = getIt<AuthUserBloc>();
    super.initState();
    productName = TextEditingController(text: widget.product?.name);
    description = TextEditingController(text: widget.product?.description);
    preparationTime = TextEditingController(text: widget.product?.preparationTime);
    categoryController = TextEditingController(
      text: widget.product?.category?.name,
    );
    price = TextEditingController(text: widget.product?.price.toString());
    image = ValueNotifier(null);

    // authUserBloc.add(
    //   GetAllCategoriesEvent(
    //     type:
    //         AuthServiceLocator.instance.role == TypeUser.store
    //             ? "store"
    //             : "store",
    //   ),
    // );
  }

  String? categoryId;

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
            height: height(0.8.sh),
            child: Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: productName,
                          hintText: "اسم المنتج",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الاسم مطلوب";
                            }
                            return null;
                          },
                        ),
                        AuthTextField(
                          controller: price,
                          hintText: "السعر",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "السعر مطلوب";
                            }
                            if (double.tryParse(price.text) == null) {
                              return "السعر يجب أن يكون عدد";
                            }
                            return null;
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            final Category? category =
                                await AppDraggableSheet.show<Category>(
                                  context: context,
                                  builder:
                                      (_, scrollController) => CategoriesPicker(
                                        scrollController: scrollController,
                                        type:"store"
                                            // AuthServiceLocator.instance.role ==
                                            //         TypeUser.store
                                            //     ? "store"
                                            //     : ,
                                      ),
                                );
                            if (category != null) {
                              categoryController.text = category.name ?? '';
                              categoryId = category.id!;
                            }
                          },
                          child: AuthTextField(
                            controller: categoryController,
                            hintText: "النوع",
                            enabled: false,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "يجب اختيار النوع";
                              }
                              return null;
                            },
                          ),
                        ),
                        AuthTextField(
                          controller: preparationTime,
                          hintText: "وقت التحضير",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "وقت التحضير مطلوب";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          width: width(1.sw),
                          child: ElevatedButton.icon(
                            onPressed: () => _pickMedia(),
                            icon: Icon(
                              Icons.image_outlined,
                              color: context.theme.colorScheme.primary,
                            ),
                            label: Text("صورة"),
                          ),
                        ),
                        SizedBox(height: height(15),),
                        AuthTextField(
                          controller: description,
                          maxLines: 5,
                          hintText: "وصف عنه",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "الوصف مطلوب";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height(15),),
                        AuthButton(
                          text: "حفظ",
                          onTap: () {
                            if (!(formKey.currentState?.validate() ?? false)) return;
                            if (widget.product == null && image.value == null) {
                              showMessage("رجاء قم بإضافة صورة");
                            }
                            // BlocProvider.of<StoreBloc>(context).add(
                            //   widget.product == null
                            //       ? AddProductEvent(
                            //         params: AddProductParams(
                            //           image: File(image.value!.path),
                            //           description: description.text,
                            //           name: productName.text,
                            //           categoryId: categoryId!,
                            //           preparationTime: preparationTime.text,
                            //           storeId:
                            //               AuthServiceLocator.instance.storeId!,
                            //           price: price.text,
                            //         ),
                            //       )
                            //       : EditProductEvent(
                            //         params: EditProductParams(
                            //           productId: widget.product!.id!,
                            //           price:
                            //               widget.product?.price.toString() != price.text
                            //                   ? price.text
                            //                   : null,
                            //           preparationTime:
                            //               widget.product?.preparationTime !=
                            //                       preparationTime.text
                            //                   ? preparationTime.text
                            //                   : null,
                            //           name:
                            //               widget.product?.name != productName.text
                            //                   ? productName.text
                            //                   : null,
                            //           description:
                            //               widget.product?.description != description.text
                            //                   ? preparationTime.text
                            //                   : null,
                            //           categoryId:
                            //               categoryId != widget.product?.category?.id
                            //                   ? categoryId
                            //                   : null,
                            //           image: image.value == null ? null : File(image.value!.path),
                            //         ),
                            //       ),
                            // );
                            context.pop();
                          },
                          widthButton: 1.sw - 75,
                          heightButton: height(60),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
