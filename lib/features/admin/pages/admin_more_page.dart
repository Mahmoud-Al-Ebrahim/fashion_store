import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/helper/helper_functions.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../widgets/confirm_dialog.dart';
import 'admin_complaints_page.dart';
import 'admin_store_categories_page.dart';
import 'admin_store_profile_page.dart';
import 'admin_wallet_page.dart';

class AdminMorePage extends StatelessWidget {
  const AdminMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('المزيد'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: height(10)),
        children: [
          BlocBuilder<StoreBloc, StoreState>(
            builder: (context, state) {
              final store = state.myStore;
              if (store == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: width(16), vertical: height(10)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFEAEAF2),
                      backgroundImage: store.logo != null
                          ? NetworkImage(ApiService.resolveUrl(store.logo)!)
                          : null,
                      child: store.logo == null ? const Icon(Icons.store) : null,
                    ),
                    SizedBox(width: width(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(store.storeName, style: Theme.of(context).textTheme.titleMedium),
                          Text(store.storeEmail, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          _tile(
            context,
            icon: Icons.storefront_outlined,
            title: 'الملف الشخصي للمتجر',
            onTap: () => context.pushPage(const AdminStoreProfilePage()),
          ),
          _tile(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'المحفظة والمعاملات',
            onTap: () => context.pushPage(const AdminWalletPage()),
          ),
          _tile(
            context,
            icon: Icons.category_outlined,
            title: 'تصنيفات المتجر',
            onTap: () => context.pushPage(const AdminStoreCategoriesPage()),
          ),
          _tile(
            context,
            icon: Icons.support_agent_outlined,
            title: 'الشكاوى',
            onTap: () => context.pushPage(const AdminComplaintsPage()),
          ),
          const Divider(),
          _tile(
            context,
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            color: Colors.red,
            onTap: () async {
              final confirmed = await confirmDialog(
                context,
                title: 'تسجيل الخروج',
                message: 'هل تريد تسجيل الخروج من حساب المتجر؟',
                confirmText: 'خروج',
              );
              if (!confirmed || !context.mounted) return;
              context.read<AuthBloc>().add(LogoutEvent());
              HelperFunctions.navigateToPageAndPopAll(context, const SignInScreen(), true);
            },
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_left),
      onTap: onTap,
    );
  }
}
