import 'package:flutter/material.dart';

import '../core/helper/helper_functions.dart';
import '../core/utils/my_shared_pref.dart';
import '../core/utils/session.dart';
import 'admin/admin_shell_screen.dart';
import 'nav_bar/user_nav_bar/user_nav_bar_screen.dart';
import 'payment_employee/payment_employee_shell_screen.dart';
import 'shop/pages/seller_request_page.dart';
import 'super_admin/super_admin_shell_screen.dart';

/// Decides which surface a session lands on.
///
///  - **SuperAdmin** -> platform administration (store approvals, users,
///    global categories) *plus* the store dashboard.
///  - **Admin** (store owner) -> the store dashboard, gated on their store
///    request having been approved.
///  - **EmployeeOfPayment** -> the payment desk (top-up history + credit
///    a wallet), and nothing else.
///  - **User / guest** -> the customer shell.
class RoleRouter {
  RoleRouter._();

  /// The landing widget for the current session.
  static Widget homeFor(AppRole role) {
    switch (role) {
      case AppRole.superAdmin:
        return const SuperAdminShellScreen();
      case AppRole.paymentEmployee:
        return const PaymentEmployeeShellScreen();
      case AppRole.storeOwner:
        return const AdminShellScreen();
      case AppRole.user:
      case AppRole.guest:
        return const UserNavBar();
    }
  }

  /// Replaces the whole stack with the right home for the current session.
  ///
  /// A user who registered intending to open a store is dropped straight on
  /// the store-request form the first time they arrive as a plain customer.
  static void goHome(BuildContext context) {
    final role = Session.role;

    if (role == AppRole.user && MySharedPref.getWantsStore()) {
      MySharedPref.clearWantsStore();
      HelperFunctions.navigateToPageAndPopAll(context, const UserNavBar(), true);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SellerRequestPage()),
      );
      return;
    }

    HelperFunctions.navigateToPageAndPopAll(context, homeFor(role), true);
  }
}
