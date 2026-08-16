import 'package:flutter/material.dart';

class TabBarsName extends StatelessWidget {
  const TabBarsName({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: Colors
          .transparent,
      indicatorColor: Theme.of(context).colorScheme.primary,
      labelColor: Theme.of(context).colorScheme.primary,
      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500),
      unselectedLabelColor: Color(0xff666A7A),
      physics: NeverScrollableScrollPhysics(),
      tabs: const [
        Tab(text: 'من أنا',),
        Tab(text: 'المنتجات'),
        Tab(text: 'المنشورات '),
        Tab(text: 'التقييمات'),
      ],
    );
  }
}
