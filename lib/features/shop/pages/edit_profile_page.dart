import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/button.dart';
import '../../../app/widgets/text_field.dart';
import '../../../blocs/user_bloc/user_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../../../core/utils/validators.dart';
import '../../../models/user/user_profile_model.dart';
import '../../admin/widgets/option_picker_field.dart';

/// Edits the signed-in account's own details via `PUT User/UpdateUser`.
///
/// Available to every role - each of them has a personal profile, and the
/// endpoint acts on whoever the token belongs to. Email and username are
/// shown on the profile but are not editable: the API's update DTO does not
/// accept them.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final UserProfileModel profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;
  late String _gender;
  late DateTime _birthDate;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.profile.firstName);
    _lastName = TextEditingController(text: widget.profile.lastName);
    _phone = TextEditingController(text: widget.profile.phoneNumber);
    _gender = widget.profile.gender.isEmpty ? 'Male' : widget.profile.gender;
    _birthDate = widget.profile.birthDate;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      // Nobody signing up is younger than this; also stops a future date.
      lastDate: now,
      helpText: LK.profilePickBirthdate.tr(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // The phone is only sent when it actually changed. The server checks
    // phone uniqueness *without* excluding the current account, so echoing
    // the user's own number back is rejected with "رقم الهاتف موجود مسبقا" -
    // which would block someone who only wanted to fix a typo in their name.
    // Omitting the field leaves it untouched.
    final phone = normalizeSyrianPhone(_phone.text);
    final phoneChanged = phone != widget.profile.phoneNumber;

    context.read<UserBloc>().add(
      UpdateUserEvent(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        birthDate: _birthDate,
        gender: _gender,
        phoneNumber: phoneChanged ? phone : null,
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
        title: Text(LK.profileEdit.tr()),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listenWhen: (p, c) => p.updateUserStatus != c.updateUserStatus,
        listener: (context, state) {
          if (state.updateUserStatus == UpdateUserStatus.success) {
            showMessage(LK.profileEditSaved.tr(), hasError: false);
            Navigator.of(context).pop(true);
          } else if (state.updateUserStatus == UpdateUserStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final saving = state.updateUserStatus == UpdateUserStatus.loading;
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(width(16)),
              children: [
                AuthTextField(
                  controller: _firstName,
                  hintText: LK.authFirstName.tr(),
                  validator: validateName,
                ),
                SizedBox(height: height(12)),
                AuthTextField(
                  controller: _lastName,
                  hintText: LK.authLastName.tr(),
                  validator: validateName,
                ),
                SizedBox(height: height(12)),
                AuthTextField(
                  controller: _phone,
                  hintText: LK.authPhone.tr(),
                  validator: validateSyrianPhone,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: height(12)),
                OptionPickerField(
                  hintText: LK.authGender.tr(),
                  options: [
                    PickerOption('Male', LK.authMale.tr()),
                    PickerOption('Female', LK.authFemale.tr()),
                  ],
                  selectedValue: _gender,
                  onSelected: (o) => setState(() => _gender = o.value),
                ),
                SizedBox(height: height(12)),
                InkWell(
                  onTap: _pickBirthDate,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(16),
                      vertical: height(16),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFD3D3E4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cake_outlined, size: 18),
                        SizedBox(width: width(10)),
                        Expanded(
                          child: Text(
                            '${LK.authBirthDate.tr()}: '
                            '${_formatDate(_birthDate)}',
                          ),
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 16),
                      ],
                    ),
                  ),
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

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
