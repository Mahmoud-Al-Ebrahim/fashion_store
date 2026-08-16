import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/category_bloc/category_bloc.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../widgets/admin_async_view.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/option_picker_field.dart';

class AdminStoreCategoriesPage extends StatefulWidget {
  const AdminStoreCategoriesPage({super.key});

  @override
  State<AdminStoreCategoriesPage> createState() => _AdminStoreCategoriesPageState();
}

class _AdminStoreCategoriesPageState extends State<AdminStoreCategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    context.read<CategoryBloc>().add(GetAllStoreCategoryByAdminEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('تصنيفات المتجر'),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listenWhen: (p, c) =>
            p.storeCategoryTransactionStatus != c.storeCategoryTransactionStatus,
        listener: (context, state) {
          if (state.storeCategoryTransactionStatus ==
              StoreCategoryTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final assignedCategoryIds = state.storeCategories.map((sc) => sc.categoryId).toSet();
          final availableCategories = state.categories
              .where((c) => !assignedCategoryIds.contains(c.id))
              .toList();

          return Padding(
            padding: EdgeInsets.all(width(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (availableCategories.isNotEmpty)
                  OptionPickerField(
                    hintText: 'إضافة تصنيف',
                    options: availableCategories
                        .map((c) => PickerOption(c.id.toString(), c.name))
                        .toList(),
                    onSelected: (o) {
                      context.read<CategoryBloc>().add(
                        AddStoreCategoryEvent(categoryId: int.parse(o.value)),
                      );
                    },
                  ),
                SizedBox(height: height(16)),
                Expanded(
                  child: AdminAsyncView(
                    isLoading: state.getAllStoreCategoryStatus ==
                        GetAllStoreCategoryStatus.loading,
                    isFailure: state.getAllStoreCategoryStatus ==
                        GetAllStoreCategoryStatus.failure,
                    isEmpty: state.getAllStoreCategoryStatus ==
                            GetAllStoreCategoryStatus.success &&
                        state.storeCategories.isEmpty,
                    errorMessage: state.errorMessage,
                    emptyText: 'لم يتم إضافة تصنيفات بعد',
                    child: Wrap(
                      spacing: width(10),
                      runSpacing: height(10),
                      children: state.storeCategories.map((sc) {
                        final category = state.categories
                            .where((c) => c.id == sc.categoryId);
                        final name =
                            category.isNotEmpty ? category.first.name : 'تصنيف #${sc.categoryId}';
                        return Chip(
                          label: Text(name),
                          onDeleted: () async {
                            final confirmed = await confirmDialog(
                              context,
                              title: 'حذف التصنيف',
                              message: 'إزالة "$name" من تصنيفات المتجر؟',
                            );
                            if (!confirmed || !context.mounted) return;
                            context.read<CategoryBloc>().add(
                              DeleteStoreCategoryEvent(storeCategoryId: sc.id),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
