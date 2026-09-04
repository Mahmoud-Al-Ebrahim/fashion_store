import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/category_bloc/category_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../../admin/widgets/confirm_dialog.dart';

/// The platform-wide category catalog that store owners tag their stores and
/// products with. Only a super admin can add or remove entries.
class GlobalCategoriesPage extends StatefulWidget {
  const GlobalCategoriesPage({super.key});

  @override
  State<GlobalCategoriesPage> createState() => _GlobalCategoriesPageState();
}

class _GlobalCategoriesPageState extends State<GlobalCategoriesPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<CategoryBloc>().add(GetAllCategoriesEvent());

  Future<void> _addCategory() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LK.superadminAddGlobalCategory.tr()),
        content: AuthTextField(
          controller: controller,
          hintText: LK.superadminCategoryName.tr(),
          validator: (_) => null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LK.commonCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LK.commonSave.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final name = controller.text.trim();
    if (name.isEmpty) {
      showMessage(LK.commonRequiredField.tr());
      return;
    }
    context.read<CategoryBloc>().add(AddCategoryEvent(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.superadminGlobalCategories.tr()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCategory,
        icon: const Icon(Icons.add),
        label: Text(LK.superadminAddGlobalCategory.tr()),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listenWhen: (p, c) =>
            p.categoryTransactionStatus != c.categoryTransactionStatus,
        listener: (context, state) {
          if (state.categoryTransactionStatus ==
              CategoryTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          return AsyncView(
            isLoading:
                state.getAllCategoriesStatus == GetAllCategoriesStatus.loading,
            isFailure:
                state.getAllCategoriesStatus == GetAllCategoriesStatus.failure,
            isEmpty:
                state.getAllCategoriesStatus ==
                    GetAllCategoriesStatus.success &&
                state.categories.isEmpty,
            errorMessage: state.errorMessage,
            emptyText: LK.adminNoCategories.tr(),
            onRetry: _load,
            child: RefreshIndicator(
              onRefresh: () async => _load(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(width(16)),
                itemCount: state.categories.length,
                separatorBuilder: (_, __) => SizedBox(height: height(10)),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD3D3E4)),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.category_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(category.name),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final ok = await confirmDialog(
                            context,
                            title: LK.commonDelete.tr(),
                            message: category.name,
                          );
                          if (!ok || !context.mounted) return;
                          context.read<CategoryBloc>().add(
                            DeleteCategoryEvent(categoryId: category.id),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
