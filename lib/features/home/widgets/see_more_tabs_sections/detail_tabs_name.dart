import 'package:flutter/material.dart';

class SeeMoreTabBarsName extends StatelessWidget {
  const SeeMoreTabBarsName({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index) {
        onTap.call(index);
        // context.read<SeeMoreControllerCubit>().changeTab(index);
      },
      dividerColor: Colors.transparent,
      indicatorColor: Theme.of(context).colorScheme.primary,
      labelColor: Theme.of(context).colorScheme.primary,
      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelColor: const Color(0xff666A7A),
      tabs: const [
        Tab(text: 'منتجات '),
        // Tab(text: 'بلدان'),
        Tab(text: 'متاجر'),
      ],
    );
  }
}
