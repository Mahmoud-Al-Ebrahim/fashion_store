import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/extensions/build_context.dart';

class StoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final String? title; // 🔹 العنوان اختياري
  final bool hideLeading;

  const StoreAppBar({super.key, this.onTap, this.title , this.hideLeading = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: hideLeading ? null : IconButton(
        onPressed: onTap ?? () {
          context.pop();
        },
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
      actions: [
        GestureDetector(
          onTap: () {
            // if (AuthServiceLocator.instance.token == null ||
            //     AuthServiceLocator.instance.token!.isEmpty) {
            //   showFlushBar(context, "يرجى تسجيل الدخول لتتمكن من  رؤية الاشعارات ") ;
            // }else{
            //   context.pushNamed(NotificationPage.name);
            // }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              "assets/svg/notifications.svg",
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
