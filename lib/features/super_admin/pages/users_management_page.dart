import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/super_admin_bloc/super_admin_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/session.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/user/user_profile_model.dart';
import '../../admin/widgets/confirm_dialog.dart';
import '../../admin/widgets/option_picker_field.dart';

/// User administration: active/banned lists, role assignment, ban/unban and
/// deletion.
///
/// Banning is performed through `SuperAdmin/RevokeToken`, which ends every
/// session the account holds; `SuperAdmin/UnbanUser` reverses it.
class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<SuperAdminBloc>().add(GetActiveUsersEvent());
    context.read<SuperAdminBloc>().add(GetBannedUsersEvent());
  }

  Future<void> _assignRole(UserProfileModel user) async {
    String? role;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(LK.superadminAddRole.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LK.superadminAddRoleConfirm.tr()),
              SizedBox(height: height(12)),
              OptionPickerField(
                hintText: LK.superadminAddRole.tr(),
                // Only promotion to payment staff is offered. Becoming a
                // store owner goes through the store-request flow so the
                // account gets an actual store, and SuperAdmin is not
                // grantable from here.
                options: [
                  PickerOption(
                    ApiRoles.paymentEmployee,
                    LK.paymentEmployeeRole.tr(),
                  ),
                ],
                selectedValue: role,
                onSelected: (o) => setDialogState(() => role = o.value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(LK.commonCancel.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(LK.commonConfirm.tr()),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || role == null || !mounted) return;
    context.read<SuperAdminBloc>().add(
      AddRoleEvent(userId: user.id, role: role!),
    );
  }

  /// Strips a role from [user] via `SuperAdmin/RemoveRole`.
  ///
  /// Only the payment-employee role can be revoked, mirroring the fact that
  /// it is the only one this screen can grant. The others are deliberately
  /// absent:
  ///
  ///  * `Admin` (store owner) is tied to an approved store - revoking it
  ///    here would leave a live store with an owner who can no longer reach
  ///    it, and the store-request flow is what grants it in the first place.
  ///  * `SuperAdmin` is not manageable from the app at all.
  ///  * `User` is the base role - stripping it leaves an account that can
  ///    sign in and reach nothing.
  ///
  /// `ActiveUsers` does not report which roles an account already holds, so
  /// the server is what decides: it answers "المستخدم لا يملك هذا
  /// الدور" when the user never had it, and that is surfaced as-is.
  Future<void> _revokeRole(UserProfileModel user) async {
    String? role;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(LK.superadminRemoveRole.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LK.superadminPickRole.tr()),
              SizedBox(height: height(12)),
              OptionPickerField(
                hintText: LK.superadminRemoveRole.tr(),
                options: [
                  PickerOption(
                    ApiRoles.paymentEmployee,
                    LK.paymentEmployeeRole.tr(),
                  ),
                ],
                selectedValue: role,
                onSelected: (o) => setDialogState(() => role = o.value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(LK.commonCancel.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(LK.commonConfirm.tr()),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || role == null || !mounted) return;
    context.read<SuperAdminBloc>().add(
      RemoveRoleEvent(userId: user.id, role: role!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(LK.superadminUsers.tr()),
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: const Color(0xff666A7A),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: LK.superadminTabCustomers.tr()),
              Tab(text: LK.superadminTabStoreOwners.tr()),
              Tab(text: LK.superadminTabPaymentStaff.tr()),
              Tab(text: LK.superadminBannedUsers.tr()),
            ],
          ),
        ),
        body: BlocConsumer<SuperAdminBloc, SuperAdminState>(
          // One value decides the message, so the announcement always
          // matches the action the user actually ran.
          listenWhen: (p, c) => p.actionOutcome != c.actionOutcome,
          listener: (context, state) {
            switch (state.actionOutcome) {
              case SuperAdminOutcome.banned:
                showMessage(LK.superadminBannedDone.tr(), hasError: false);
                break;
              case SuperAdminOutcome.unbanned:
                showMessage(LK.superadminUnbannedDone.tr(), hasError: false);
                break;
              case SuperAdminOutcome.deleted:
                showMessage(LK.superadminDeletedDone.tr(), hasError: false);
                break;
              case SuperAdminOutcome.roleAdded:
                showMessage(LK.superadminRoleAdded.tr(), hasError: false);
                break;
              case SuperAdminOutcome.roleRemoved:
                showMessage(LK.superadminRemoveRoleDone.tr(), hasError: false);
                break;
              case SuperAdminOutcome.failure:
                showMessage(state.errorMessage);
                break;
              case SuperAdminOutcome.storeRequestDecided:
              case SuperAdminOutcome.none:
                break;
            }
          },
          builder: (context, state) {
            final activeLoading =
                state.getActiveUsersStatus == GetActiveUsersStatus.loading;
            final activeFailed =
                state.getActiveUsersStatus == GetActiveUsersStatus.failure;

            // A super admin is never listed - the screen is for managing
            // other people's accounts, not the platform's own operators.
            final visible = state.activeUsers
                .where((u) => !u.roles.contains(ApiRoles.superAdmin))
                .toList();

            List<UserProfileModel> withRole(String role) =>
                visible.where((u) => u.roles.contains(role)).toList();

            // With no roles from the server every account looks like a
            // plain customer; the note below explains the empty tabs.
            final rolesKnown = visible.any((u) => u.roles.isNotEmpty);
            final owners = withRole(ApiRoles.storeOwner);
            final staff = withRole(ApiRoles.paymentEmployee);
            final customers = visible
                .where(
                  (u) =>
                      !u.roles.contains(ApiRoles.storeOwner) &&
                      !u.roles.contains(ApiRoles.paymentEmployee),
                )
                .toList();

            return TabBarView(
              children: [
                _UserList(
                  users: customers,
                  isLoading: activeLoading,
                  isFailure: activeFailed,
                  errorMessage: state.errorMessage,
                  onRetry: _load,
                  banned: false,
                  // Only a plain customer can be promoted.
                  canAssignRole: true,
                  note: rolesKnown ? null : LK.superadminRolesUnavailable.tr(),
                  onAssignRole: _assignRole,
                  onRevokeRole: _revokeRole,
                ),
                _UserList(
                  users: owners,
                  isLoading: activeLoading,
                  isFailure: activeFailed,
                  errorMessage: state.errorMessage,
                  onRetry: _load,
                  banned: false,
                  canAssignRole: false,
                  onAssignRole: _assignRole,
                  onRevokeRole: _revokeRole,
                ),
                _UserList(
                  users: staff,
                  isLoading: activeLoading,
                  isFailure: activeFailed,
                  errorMessage: state.errorMessage,
                  onRetry: _load,
                  banned: false,
                  canAssignRole: false,
                  onAssignRole: _assignRole,
                  onRevokeRole: _revokeRole,
                ),
                _UserList(
                  users: state.bannedUsers,
                  isLoading:
                      state.getBannedUsersStatus ==
                      GetBannedUsersStatus.loading,
                  isFailure:
                      state.getBannedUsersStatus ==
                      GetBannedUsersStatus.failure,
                  errorMessage: state.errorMessage,
                  onRetry: _load,
                  banned: true,
                  canAssignRole: false,
                  onAssignRole: _assignRole,
                  onRevokeRole: _revokeRole,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<UserProfileModel> users;
  final bool isLoading;
  final bool isFailure;
  final String errorMessage;
  final VoidCallback onRetry;
  final bool banned;
  final ValueChanged<UserProfileModel> onAssignRole;
  final ValueChanged<UserProfileModel> onRevokeRole;

  /// Whether "assign role" belongs in this tab at all.
  final bool canAssignRole;

  /// Optional banner explaining why a tab looks the way it does.
  final String? note;

  const _UserList({
    required this.users,
    required this.isLoading,
    required this.isFailure,
    required this.errorMessage,
    required this.onRetry,
    required this.banned,
    required this.onAssignRole,
    required this.onRevokeRole,
    this.canAssignRole = false,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final list = AsyncView(
      isLoading: isLoading,
      isFailure: isFailure,
      isEmpty: !isLoading && users.isEmpty,
      errorMessage: errorMessage,
      emptyText: LK.superadminNoUsers.tr(),
      onRetry: onRetry,
      child: RefreshIndicator(
        onRefresh: () async => onRetry(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(width(16)),
          itemCount: users.length,
          separatorBuilder: (_, __) => SizedBox(height: height(10)),
          itemBuilder: (context, index) {
            final user = users[index];
            final photo = ApiService.resolveUrl(user.profilePhoto);
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: width(12),
                vertical: height(10),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD3D3E4)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFEAEAF2),
                    backgroundImage: photo != null
                        ? CachedNetworkImageProvider(photo)
                        : null,
                    child: photo == null ? const Icon(Icons.person) : null,
                  ),
                  SizedBox(width: width(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      final bloc = context.read<SuperAdminBloc>();
                      switch (value) {
                        case 'role':
                          onAssignRole(user);
                          break;
                        case 'revoke_role':
                          onRevokeRole(user);
                          break;
                        case 'unban':
                          final ok = await confirmDialog(
                            context,
                            title: LK.superadminUnban.tr(),
                            message: LK.superadminUnbanConfirm.tr(),
                            confirmText: LK.superadminUnban.tr(),
                            isDestructive: false,
                          );
                          if (ok) bloc.add(UnbanUserEvent(userId: user.id));
                          break;
                        case 'ban':
                          final ok = await confirmDialog(
                            context,
                            title: LK.superadminBanUser.tr(),
                            message: LK.superadminBanConfirm.tr(),
                            confirmText: LK.superadminBanUser.tr(),
                          );
                          if (ok) {
                            bloc.add(RevokeUserTokenEvent(userId: user.id));
                          }
                          break;
                        case 'delete':
                          final ok = await confirmDialog(
                            context,
                            title: LK.superadminDeleteUser.tr(),
                            message: LK.superadminDeleteUserConfirm.tr(),
                          );
                          if (ok) bloc.add(DeleteUserEvent(userId: user.id));
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      // A banned account cannot be granted or stripped of
                      // a role, and cannot be banned again - only unbanned
                      // or deleted.
                      if (!banned)
                        PopupMenuItem(
                          value: 'role',
                          child: Row(
                            children: [
                              const Icon(Icons.badge_outlined, size: 18),
                              SizedBox(width: width(8)),
                              Text(LK.superadminAddRole.tr()),
                            ],
                          ),
                        ),
                      if (!banned)
                        PopupMenuItem(
                          value: 'revoke_role',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.badge_outlined,
                                size: 18,
                                color: Colors.orange,
                              ),
                              SizedBox(width: width(8)),
                              Text(LK.superadminRemoveRole.tr()),
                            ],
                          ),
                        ),
                      if (banned)
                        PopupMenuItem(
                          value: 'unban',
                          child: Row(
                            children: [
                              const Icon(Icons.lock_open, size: 18),
                              SizedBox(width: width(8)),
                              Text(LK.superadminUnban.tr()),
                            ],
                          ),
                        ),
                      if (!banned)
                        PopupMenuItem(
                          value: 'ban',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.block,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: width(8)),
                              Text(LK.superadminBanUser.tr()),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red,
                            ),
                            SizedBox(width: width(8)),
                            Text(
                              LK.superadminDeleteUser.tr(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (note == null) return list;
    // Explains an otherwise puzzling empty tab.
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(width(16), height(10), width(16), 0),
          padding: EdgeInsets.all(width(10)),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.orange.shade800),
              SizedBox(width: width(8)),
              Expanded(
                child: Text(
                  note!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: list),
      ],
    );
  }
}
