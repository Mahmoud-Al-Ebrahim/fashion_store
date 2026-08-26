import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../../../core/utils/validators.dart';
import '../../../models/store/store_detail_model.dart';

/// Lets the applicant correct a store request that is still under review,
/// via `PUT StoreRequest/UpdateRequest/{storeId}/update`.
///
/// Only the descriptive fields are editable here. Email, phone and the
/// uploaded documents are part of the original submission and the update
/// DTO does not carry them - changing those means cancelling and filing a
/// new request.
class StoreRequestEditPage extends StatefulWidget {
  const StoreRequestEditPage({super.key, required this.request});

  final StoreDetailModel request;

  @override
  State<StoreRequestEditPage> createState() => _StoreRequestEditPageState();
}

class _StoreRequestEditPageState extends State<StoreRequestEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _address;
  late TimeOfDay? _start;
  late TimeOfDay? _end;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.request.storeName);
    _description = TextEditingController(text: widget.request.description);
    _address = TextEditingController(text: widget.request.address);
    _start = _parse(widget.request.workingHoursStart);
    _end = _parse(widget.request.workingHoursEnd);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  /// The API hands hours back as "HH:mm:ss".
  static TimeOfDay? _parse(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  static String _format(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _pick(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _start : _end) ?? TimeOfDay.now(),
    );
    if (picked == null) return;
    setState(() => isStart ? _start = picked : _end = picked);
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<StoreRequestBloc>().add(
      UpdateStoreRequestEvent(
        storeId: widget.request.id,
        storeName: _name.text.trim(),
        description: _description.text.trim(),
        address: _address.text.trim(),
        workingHoursStart: _start == null ? null : _format(_start!),
        workingHoursEnd: _end == null ? null : _format(_end!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.storeStatusEditRequest.tr()),
      ),
      body: BlocConsumer<StoreRequestBloc, StoreRequestState>(
        listenWhen: (p, c) =>
            p.storeRequestTransactionStatus != c.storeRequestTransactionStatus,
        listener: (context, state) {
          if (state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.success) {
            showMessage(LK.storeStatusRequestUpdated.tr(), hasError: false);
            context.read<StoreRequestBloc>().add(
              GetAllStoreRequestsByUserEvent(),
            );
            Navigator.of(context).pop(true);
          } else if (state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final saving =
              state.storeRequestTransactionStatus ==
              StoreRequestTransactionStatus.loading;
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(width(16)),
              children: [
                AuthTextField(
                  controller: _name,
                  hintText: LK.sellerStoreName.tr(),
                  validator: validateRequired,
                ),
                SizedBox(height: height(12)),
                AuthTextField(
                  controller: _description,
                  hintText: LK.sellerDescription.tr(),
                  validator: validateRequired,
                  maxLines: 4,
                  radius: 16,
                ),
                SizedBox(height: height(12)),
                AuthTextField(
                  controller: _address,
                  hintText: LK.storeAddress.tr(),
                  validator: validateRequired,
                ),
                SizedBox(height: height(12)),
                Row(
                  children: [
                    Expanded(
                      child: _TimeField(
                        label: LK.commonFrom.tr(),
                        value: _start,
                        onTap: () => _pick(true),
                      ),
                    ),
                    SizedBox(width: width(10)),
                    Expanded(
                      child: _TimeField(
                        label: LK.commonTo.tr(),
                        value: _end,
                        onTap: () => _pick(false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(26)),
                AuthButton(
                  text: saving ? LK.commonSaving.tr() : LK.commonSave.tr(),
                  onTap: saving ? null : _save,
                  widthButton: double.infinity,
                  heightButton: height(52),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TimeOfDay? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width(14),
          vertical: height(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD3D3E4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.schedule, size: 16),
            SizedBox(width: width(8)),
            Expanded(
              child: Text(
                value == null
                    ? label
                    : '$label ${value!.hour.toString().padLeft(2, '0')}:'
                          '${value!.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
