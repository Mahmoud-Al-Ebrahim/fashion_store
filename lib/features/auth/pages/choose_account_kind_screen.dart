import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/widgets/button.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../widgets/choose_account/choose_account_widget.dart';
import 'sign_up/sign_up_screen.dart';

/// What the user intends to do with the account they're about to create.
enum AccountKind { customer, storeOwner }

/// Account-type picker shown before registration.
///
/// Both kinds create the same account - the backend only registers users.
/// Picking "store owner" simply carries the intent through so that, right
/// after the account is verified and signed in, the app takes them straight
/// to the store-request form for admin review.
class ChooseAccountKindScreen extends StatefulWidget {
  static String name = "ChooseAccountKindScreen";
  static String route = "/ChooseAccountKindScreen";

  const ChooseAccountKindScreen({super.key});

  @override
  State<ChooseAccountKindScreen> createState() =>
      _ChooseAccountKindScreenState();
}

class _ChooseAccountKindScreenState extends State<ChooseAccountKindScreen> {
  AccountKind? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(width(16)),
        child: Column(
          children: [
            SizedBox(height: height(20)),
            Center(
              child: Text(
                LK.accountKindTitle.tr(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ).animate().slide(
              begin: const Offset(1, 0),
              end: Offset.zero,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
            SizedBox(height: height(40)),
            SizedBox(
              height: height(220),
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                children: [
                  AccountKindItem(
                    title: LK.accountKindCustomer.tr(),
                    description: LK.accountKindCustomerDesc.tr(),
                    icon: Icons.shopping_bag_outlined,
                    isSelected: _selected == AccountKind.customer,
                    onTap: () =>
                        setState(() => _selected = AccountKind.customer),
                  ),
                  AccountKindItem(
                    title: LK.accountKindStoreOwner.tr(),
                    description: LK.accountKindStoreOwnerDesc.tr(),
                    icon: Icons.storefront_outlined,
                    isSelected: _selected == AccountKind.storeOwner,
                    onTap: () =>
                        setState(() => _selected = AccountKind.storeOwner),
                  ),
                ],
              ).animate().slide(
                begin: const Offset(-1, 0),
                end: Offset.zero,
                duration: 600.ms,
                curve: Curves.easeOut,
              ),
            ),
            if (_selected == AccountKind.storeOwner) ...[
              SizedBox(height: height(16)),
              Container(
                padding: EdgeInsets.all(width(12)),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAF2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: width(8)),
                    Expanded(
                      child: Text(
                        LK.accountKindStoreNote.tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ],
            const Spacer(),
            if (_selected != null)
              AuthButton(
                text: LK.commonNext.tr(),
                widthButton: double.infinity,
                onTap: () => HelperFunctions.navigateToPage(
                  context,
                  SignUpScreen(
                    wantsStore: _selected == AccountKind.storeOwner,
                  ),
                ),
              ),
            SizedBox(height: height(20)),
          ],
        ),
      ),
    );
  }
}
