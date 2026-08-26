import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user_bloc/user_bloc.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/utils/show_message.dart';
import 'edit_profile_page.dart';

/// User profile from `User/GetUserProfile`, with avatar replacement via
/// `User/UpdateProfilePhoto`.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _changePhoto(BuildContext context) async {
    final file = await HelperFunctions.pickImage();
    if (file == null || !context.mounted) return;
    context.read<UserBloc>().add(
      UpdateProfilePhotoEvent(image: File(file.path)),
    );
  }

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(GetUserProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.profileTitle.tr()),
        actions: [
          // Editing the account is role-independent - the endpoint acts on
          // whoever the token belongs to.
          BlocBuilder<UserBloc, UserState>(
            buildWhen: (p, c) => p.userProfile != c.userProfile,
            builder: (context, state) {
              final profile = state.userProfile;
              if (profile == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: LK.profileEdit.tr(),
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    context.pushPage(EditProfilePage(profile: profile)),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listenWhen: (p, c) =>
            p.updateProfilePhotoStatus != c.updateProfilePhotoStatus,
        listener: (context, state) {
          if (state.updateProfilePhotoStatus ==
              UpdateProfilePhotoStatus.success) {
            showMessage(LK.profilePhotoUpdated.tr(), hasError: false);
          } else if (state.updateProfilePhotoStatus ==
              UpdateProfilePhotoStatus.failure) {
            showMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          final profile = state.userProfile;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final photo = ApiService.resolveUrl(profile.profilePhoto);

          return ListView(
            padding: EdgeInsets.all(width(16)),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFFEAEAF2),
                      backgroundImage: photo != null
                          ? CachedNetworkImageProvider(photo)
                          : null,
                      child: photo == null
                          ? const Icon(
                              Icons.person,
                              size: 44,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: GestureDetector(
                        onTap: () => _changePhoto(context),
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height(20)),
              _ProfileRow(
                icon: Icons.person_outline,
                label: LK.authFirstName.tr(),
                value: profile.fullName,
              ),
              _ProfileRow(
                icon: Icons.alternate_email,
                label: LK.authUsername.tr(),
                value: profile.userName,
              ),
              _ProfileRow(
                icon: Icons.email_outlined,
                label: LK.authEmail.tr(),
                value: profile.email,
              ),
              _ProfileRow(
                icon: Icons.phone_outlined,
                label: LK.authPhone.tr(),
                value: profile.phoneNumber,
              ),
              _ProfileRow(
                icon: Icons.wc_outlined,
                label: LK.authGender.tr(),
                value: LK.genderKey(profile.gender).tr(),
              ),
              _ProfileRow(
                icon: Icons.cake_outlined,
                label: LK.authBirthDate.tr(),
                value:
                    '${profile.birthDate.year}-${profile.birthDate.month.toString().padLeft(2, '0')}-${profile.birthDate.day.toString().padLeft(2, '0')}',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: height(16)),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: width(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                ),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
