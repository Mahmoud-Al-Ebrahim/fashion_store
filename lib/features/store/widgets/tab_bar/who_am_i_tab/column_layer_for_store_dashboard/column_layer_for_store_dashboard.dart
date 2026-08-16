import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../app/widgets/app_draggable_sheet.dart';
import '../../../../../../app/widgets/button.dart';
import '../../../../../../app/widgets/text_field.dart';
import '../../../../../../core/screen_util.dart';
import '../../../../../../models/store/store_products_model.dart';
import '../../../../../../models/store/store_who_am_i_model.dart';
import '../../../../../common/categories_picker.dart';
import 'image_who_am_i_for_store_dashboard.dart';

class ColumnLayerForStoreDashboard extends StatefulWidget {
  final StoreWhoAmIModel storeWhoAmIModel;

  const ColumnLayerForStoreDashboard({
    super.key,
    required this.storeWhoAmIModel,
  });

  @override
  State<ColumnLayerForStoreDashboard> createState() =>
      _ColumnLayerForStoreDashboardState();
}

class _ColumnLayerForStoreDashboardState
    extends State<ColumnLayerForStoreDashboard> {
  final ValueNotifier<File?> mainImage = ValueNotifier(null);

  final TextEditingController description = TextEditingController();
  final TextEditingController workHours = TextEditingController();

  final TextEditingController countryController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? countryId, categoryId;

  // late final AuthUserBloc authUserBloc;

  String type = '';

  @override
  void initState() {
    super.initState();
    // type =
    //     AuthServiceLocator.instance.role == TypeUser.store
    //         ? "store"
    //         : "store";
    description.text = widget.storeWhoAmIModel.description.toString();
    workHours.text = widget.storeWhoAmIModel.workingHours.toString();
    countryController.text =
        widget.storeWhoAmIModel.country?.name?.toString() ?? '';
    countryId = widget.storeWhoAmIModel.country?.id;
    categoryController.text =
        widget.storeWhoAmIModel.categories?.name?.toString() ?? '';
    categoryId = widget.storeWhoAmIModel.categories?.id;

    // authUserBloc = getIt<AuthUserBloc>();
    //
    // authUserBloc.add(GetAllCategoriesEvent(type: type));
    // authUserBloc.add(GetAllCountriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height(75),),
              ImageWhoAmIForStoreDashboard(
                imageUrl: widget.storeWhoAmIModel.mainImage ?? "",
                image: mainImage,
              ),
              SizedBox(height: height(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(15)),
                child: SizedBox(
                  height: height(100),
                  child: AuthTextField(
                    controller: description,
                    hintText: "وصف",
                    maxLines: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الوصف مطلوب";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // SizedBox(height: height(20),),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: width(15)),
              //   child: InkWell(
              //     onTap: () async {
              //       final CountriesResponseModel? country =
              //           await AppDraggableSheet.show<CountriesResponseModel>(
              //             context: context,
              //             builder:
              //                 (_, scrollController) => BlocProvider.value(
              //                   value: authUserBloc,
              //                   child: CountriesPicker(
              //                     scrollController: scrollController,
              //                   ),
              //                 ),
              //           );
              //       if (country != null) {
              //         countryController.text = country.name ?? '';
              //         countryId = country.id!;
              //       }
              //     },
              //     child: AuthTextField(
              //       controller: countryController,
              //       hintText: "البلد",
              //       enabled: false,
              //       validator: (String? value) {
              //         if (value == null || value.isEmpty) {
              //           return "يجب اختيار البلد";
              //         }
              //         return null;
              //       },
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(15)),
                child: InkWell(
                  onTap: () async {
                    final Category? category =
                        await AppDraggableSheet.show<Category>(
                          context: context,
                          builder:
                              (_, scrollController) => CategoriesPicker(
                                scrollController: scrollController,
                                type: type,
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(15)),
                child: AuthTextField(
                  controller: workHours,
                  hintText: "ساعات العمل",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "يجب تحديد ساعات العمل";
                    }
                    return null;
                  },
                ),
              ),

              // BlocBuilder<StoreBloc, StoreState>(
              //   buildWhen:
              //       (p, c) =>
              //           p.updateStoreProfileState !=
              //           c.updateStoreProfileState,
              //   builder: (context, state) {
              //     return state.updateStoreProfileState.isLoading
              //         ? Center(child: MinBaytyLoader())
              //         :

                  AuthButton(
                        text: "حفظ",
                        onTap: () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          // BlocProvider.of<StoreBloc>(context).add(
                          //   UpdateStoreProfileEvent(
                          //     params: UpdateStoreProfileParams(
                          //       storeId:
                          //           AuthServiceLocator.instance.storeId!,
                          //       information:
                          //           widget.storeWhoAmIModel.description !=
                          //                   description.text
                          //               ? description.text
                          //               : null,
                          //       workingHours:
                          //           widget.storeWhoAmIModel.workingHours !=
                          //                   workHours.text
                          //               ? workHours.text
                          //               : null,
                          //       countryId:
                          //           countryId !=
                          //                   widget
                          //                       .storeWhoAmIModel
                          //                       .country
                          //                       ?.id
                          //               ? countryId
                          //               : null,
                          //       categoryId:
                          //           categoryId !=
                          //                   widget
                          //                       .storeWhoAmIModel
                          //                       .categories
                          //                       ?.id
                          //               ? categoryId
                          //               : null,
                          //       mainImageForUpload:
                          //           mainImage.value == null
                          //               ? null
                          //               : File(mainImage.value!.path),
                          //     ),
                          //   ),
                          // );
                        },
                        widthButton: 1.sw - 50,
                        heightButton: height(60),
                      ),
              SizedBox(height: height(20)),
            ],
          ),
        ),
      ),
    );
  }
}
