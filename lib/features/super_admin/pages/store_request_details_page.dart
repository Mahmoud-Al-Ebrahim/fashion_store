import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Both blocs declare a `GetAllStoreCategoryStatus`; prefix keeps the
// super-admin one unqualified since this screen is its surface.
import '../../../blocs/category_bloc/category_bloc.dart' as cat;
import '../../../blocs/super_admin_bloc/super_admin_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/whatsapp.dart';
import '../../../models/store/store_detail_model.dart';
import '../../../models/user/user_profile_model.dart';
import '../../admin/widgets/admin_status_badge.dart';

/// Everything the platform admin needs to judge a store request: the store's
/// own details plus the account behind it.
///
/// The request feed only carries `ownerId`, so the owner's name, email and
/// phone are resolved by matching that id against `SuperAdmin/ActiveUsers`.
/// A banned or deleted owner won't be in that list, which is itself worth
/// showing - hence the explicit "owner details unavailable" state rather
/// than a blank block.
class StoreRequestDetailsPage extends StatefulWidget {
  const StoreRequestDetailsPage({super.key, required this.request});

  final StoreDetailModel request;

  @override
  State<StoreRequestDetailsPage> createState() =>
      _StoreRequestDetailsPageState();
}

class _StoreRequestDetailsPageState extends State<StoreRequestDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Needed to resolve the owner; cheap and already cached if the users
    // tab has been opened this session.
    context.read<SuperAdminBloc>().add(GetActiveUsersEvent());
    // Which sections this store sells under. The endpoint returns category
    // ids only, so the global list is loaded alongside to name them.
    context.read<SuperAdminBloc>().add(
      GetAllStoreCategoryEvent(storeId: widget.request.id),
    );
    context.read<cat.CategoryBloc>().add(cat.GetAllCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final logo = ApiService.resolveUrl(request.logo) ?? '';
    final featured = ApiService.resolveUrl(request.featuredImage) ?? '';

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.superadminRequestDetails.tr()),
      ),
      body: ListView(
        padding: EdgeInsets.all(width(16)),
        children: [
          // ----- banner + logo -----
          if (featured.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: featured,
                height: height(140),
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          SizedBox(height: height(12)),
          Row(
            children: [
              CircleAvatar(
                radius: width(28),
                backgroundColor: const Color(0xFFEAEAF2),
                backgroundImage: logo.isEmpty
                    ? null
                    : CachedNetworkImageProvider(logo),
                child: logo.isEmpty
                    ? const Icon(Icons.storefront_outlined)
                    : null,
              ),
              SizedBox(width: width(12)),
              Expanded(
                child: Text(
                  request.storeName,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AdminStatusBadge(status: request.storeStatus),
            ],
          ),
          SizedBox(height: height(18)),

          // ----- store block -----
          _SectionTitle(LK.superadminStoreInfo.tr()),
          _Field(
            icon: Icons.description_outlined,
            label: LK.sellerDescription.tr(),
            value: request.description,
          ),
          _Field(
            icon: Icons.location_on_outlined,
            label: LK.storeAddress.tr(),
            value: request.address,
          ),
          _Field(
            icon: Icons.email_outlined,
            label: LK.authEmail.tr(),
            value: request.storeEmail,
          ),
          _Field(
            icon: Icons.phone_outlined,
            label: LK.authPhone.tr(),
            value: request.storePhoneNumber,
            // The phone is a WhatsApp shortcut, as requested.
            onAction: request.storePhoneNumber.isEmpty
                ? null
                : () => openWhatsApp(context, phone: request.storePhoneNumber),
          ),
          _Field(
            icon: Icons.schedule,
            label: LK.superadminWorkingHours.tr(),
            value: '${request.workingHoursStart} - ${request.workingHoursEnd}',
          ),
          _Field(
            icon: Icons.event_outlined,
            label: LK.superadminSubmittedAt.tr(),
            value: _formatDate(request.createdAt),
          ),
          if (request.note != null && request.note!.isNotEmpty)
            _Field(
              icon: Icons.sticky_note_2_outlined,
              label: LK.storeStatusRejectionReason.tr(),
              value: request.note!,
            ),

          SizedBox(height: height(18)),

          // ----- owner block -----
          _SectionTitle(LK.superadminOwnerInfo.tr()),
          BlocBuilder<SuperAdminBloc, SuperAdminState>(
            buildWhen: (p, c) =>
                p.activeUsers != c.activeUsers ||
                p.getActiveUsersStatus != c.getActiveUsersStatus,
            builder: (context, state) {
              if (state.getActiveUsersStatus == GetActiveUsersStatus.loading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: height(16)),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              final owner = _findOwner(state.activeUsers, request.ownerId);
              if (owner == null) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: height(10)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: width(6)),
                      Expanded(
                        child: Text(
                          LK.superadminOwnerUnknown.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return _OwnerBlock(owner: owner);
            },
          ),
          SizedBox(height: height(18)),

          // ----- what this store sells -----
          _SectionTitle(LK.superadminStoreCategories.tr()),
          BlocBuilder<SuperAdminBloc, SuperAdminState>(
            buildWhen: (p, c) =>
                p.storeCategories != c.storeCategories ||
                p.getAllStoreCategoryStatus != c.getAllStoreCategoryStatus,
            builder: (context, state) {
              if (state.getAllStoreCategoryStatus ==
                  GetAllStoreCategoryStatus.loading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: height(12)),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (state.storeCategories.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: height(8)),
                  child: Text(
                    LK.superadminNoCategories.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                  ),
                );
              }
              return BlocBuilder<cat.CategoryBloc, cat.CategoryState>(
                buildWhen: (p, c) => p.categories != c.categories,
                builder: (context, catState) {
                  return Wrap(
                    spacing: width(8),
                    runSpacing: height(8),
                    children: state.storeCategories.map((sc) {
                      // Fall back to the raw id when the global list has
                      // not arrived (or no longer contains the category).
                      var label = '#${sc.categoryId}';
                      for (final c in catState.categories) {
                        if (c.id == sc.categoryId) {
                          label = c.name;
                          break;
                        }
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(12),
                          vertical: height(6),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          SizedBox(height: height(24)),
        ],
      ),
    );
  }

  static UserProfileModel? _findOwner(
    List<UserProfileModel> users,
    String? ownerId,
  ) {
    if (ownerId == null || ownerId.isEmpty) return null;
    for (final user in users) {
      if (user.id == ownerId) return user;
    }
    return null;
  }
}

class _OwnerBlock extends StatelessWidget {
  const _OwnerBlock({required this.owner});

  final UserProfileModel owner;

  @override
  Widget build(BuildContext context) {
    final photo = ApiService.resolveUrl(owner.profilePhoto) ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: width(22),
              backgroundColor: const Color(0xFFEAEAF2),
              backgroundImage: photo.isEmpty
                  ? null
                  : CachedNetworkImageProvider(photo),
              child: photo.isEmpty
                  ? Text(owner.firstName.isNotEmpty ? owner.firstName[0] : '?')
                  : null,
            ),
            SizedBox(width: width(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${owner.firstName} ${owner.lastName}'.trim(),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '@${owner.userName}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: height(6)),
        _Field(
          icon: Icons.email_outlined,
          label: LK.authEmail.tr(),
          value: owner.email,
        ),
        _Field(
          icon: Icons.phone_outlined,
          label: LK.authPhone.tr(),
          value: owner.phoneNumber,
          onAction: owner.phoneNumber.isEmpty
              ? null
              : () => openWhatsApp(context, phone: owner.phoneNumber),
        ),
        _Field(
          icon: Icons.person_outline,
          label: LK.authGender.tr(),
          value: owner.gender == 'Female'
              ? LK.authFemale.tr()
              : LK.authMale.tr(),
        ),
        _Field(
          icon: Icons.cake_outlined,
          label: LK.authBirthDate.tr(),
          value: _formatDate(owner.birthDate),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(6)),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// One labelled row. When [onAction] is set the row becomes tappable and
/// grows a WhatsApp affordance on the trailing edge.
class _Field extends StatelessWidget {
  const _Field({
    required this.icon,
    required this.label,
    required this.value,
    this.onAction,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    const whatsappGreen = Color(0xFF25D366);

    return InkWell(
      onTap: onAction,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height(7)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            SizedBox(width: width(8)),
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
                  SizedBox(height: height(2)),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (onAction != null) ...[
              SizedBox(width: width(8)),
              Container(
                padding: EdgeInsets.all(width(7)),
                decoration: BoxDecoration(
                  color: whatsappGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chat, size: 16, color: whatsappGreen),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
