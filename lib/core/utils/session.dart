import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localization/translation_keys.dart';
import 'jwt_helper.dart';
import 'my_shared_pref.dart';

/// The roles the backend issues, plus the signed-out browsing mode.
enum AppRole {
  /// Browsing without an account. Read-only.
  guest,

  /// A normal customer.
  user,

  /// A store owner ("Admin" role in the API).
  storeOwner,

  /// Back-office staff who top up customer wallets
  /// ("EmployeeOfPayment" role in the API).
  paymentEmployee,

  /// The platform administrator ("SuperAdmin" role in the API).
  superAdmin,
}

/// Role names exactly as the API spells them.
class ApiRoles {
  ApiRoles._();

  static const user = 'User';
  static const storeOwner = 'Admin';
  static const superAdmin = 'SuperAdmin';
  static const paymentEmployee = 'EmployeeOfPayment';
}

/// Single source of truth for "who is using the app right now".
class Session {
  Session._();

  /// Resolves the effective role from what's persisted after login.
  ///
  /// SuperAdmin wins over the rest: a platform admin can do everything a
  /// store owner can, so they get the admin surface plus the extra tools.
  static AppRole get role {
    if (MySharedPref.getToken() == null) return AppRole.guest;
    final roles = MySharedPref.getRoles();
    if (roles.contains(ApiRoles.superAdmin)) return AppRole.superAdmin;
    if (roles.contains(ApiRoles.paymentEmployee)) return AppRole.paymentEmployee;
    if (roles.contains(ApiRoles.storeOwner)) return AppRole.storeOwner;
    return AppRole.user;
  }

  static bool get isGuest => role == AppRole.guest;

  static bool get isSignedIn => !isGuest;

  static bool get isSuperAdmin => role == AppRole.superAdmin;

  static bool get isStoreOwner => role == AppRole.storeOwner;

  static bool get isPaymentEmployee => role == AppRole.paymentEmployee;

  /// Store owners and super admins both reach the store dashboard.
  static bool get canManageStore =>
      role == AppRole.storeOwner || role == AppRole.superAdmin;

  /// Crediting a wallet is restricted to payment staff and platform admins.
  static bool get canTopUpWallets =>
      role == AppRole.paymentEmployee || role == AppRole.superAdmin;

  /// Id of the signed-in account, used to decide which content the user owns
  /// (their own comments, for instance).
  ///
  /// Normally read from the value stored at login, but falls back to the
  /// `nameidentifier` claim on the live access token so a session created
  /// before the id was persisted still recognises its own content.
  static String? get currentUserId {
    final stored = MySharedPref.getUserId();
    if (stored != null && stored.isNotEmpty) return stored;

    final token = MySharedPref.getToken();
    if (token == null) return null;
    final fromToken = JwtHelper.getUserId(token);
    if (fromToken != null && fromToken.isNotEmpty) {
      // Backfill so later reads are cheap.
      MySharedPref.saveUserId(fromToken);
    }
    return fromToken;
  }

  /// Whether the signed-in user authored [authorUserId].
  static bool owns(String authorUserId) {
    final me = currentUserId;
    return me != null && me.isNotEmpty && me == authorUserId;
  }
}

/// Gate for actions that need a real account (cart, follow, rate, comment,
/// checkout, complaints...). Returns true when the caller may proceed;
/// otherwise it shows a prompt offering to sign in and returns false.
Future<bool> requireAuth(BuildContext context, {VoidCallback? onSignIn}) async {
  if (Session.isSignedIn) return true;

  final goToSignIn = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(LK.authLoginRequired.tr()),
      content: Text(LK.authLoginRequiredBody.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(LK.commonCancel.tr()),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(LK.authLoginNow.tr()),
        ),
      ],
    ),
  );

  if (goToSignIn == true) onSignIn?.call();
  return false;
}
