import 'package:flutter/material.dart';

import '../../../core/extensions/build_context.dart';

/// Store page app bar. The notifications action was removed - the backend
/// exposes no notifications feature.
class StoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final String? title;
  final bool hideLeading;

  const StoreAppBar({
    super.key,
    this.onTap,
    this.title,
    this.hideLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: hideLeading
          ? null
          : IconButton(
              onPressed: onTap ?? () => context.pop(),
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
