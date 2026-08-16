import 'package:flutter/material.dart';

import '../../../app/widgets/app_draggable_sheet.dart';
import '../../../app/widgets/text_field.dart';
import '../../../core/screen_util.dart';

/// A single option shown in an [OptionPickerField]'s bottom sheet. [value] is
/// what gets sent to the API, [label] is what the user sees.
class PickerOption {
  final String value;
  final String label;

  const PickerOption(this.value, [String? label]) : label = label ?? value;
}

/// Read-only text field that opens a bottom-sheet list of [options] on tap
/// (the app has no dropdown widget - this mirrors the existing
/// "AuthTextField(enabled:false) + InkWell" category-picker convention).
class OptionPickerField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final List<PickerOption> options;
  final String? selectedValue;
  final ValueChanged<PickerOption> onSelected;

  const OptionPickerField({
    super.key,
    required this.hintText,
    required this.options,
    required this.onSelected,
    this.selectedValue,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: options
          .where((o) => o.value == selectedValue)
          .map((o) => o.label)
          .firstOrNull,
    );
    return InkWell(
      onTap: () async {
        final picked = await AppDraggableSheet.show<PickerOption>(
          context: context,
          initialChildSize: 0.5,
          builder: (_, scrollController) {
            return ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: width(20),
                vertical: height(16),
              ),
              itemCount: options.length,
              separatorBuilder: (_, __) => Divider(height: height(1)),
              itemBuilder: (context, index) {
                final option = options[index];
                final selected = option.value == selectedValue;
                return ListTile(
                  title: Text(option.label),
                  trailing: selected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(option),
                );
              },
            );
          },
        );
        if (picked != null) onSelected(picked);
      },
      child: AbsorbPointer(
        child: AuthTextField(
          controller: controller,
          hintText: hintText,
          enabled: false,
          validator: validator ?? (_) => null,
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
