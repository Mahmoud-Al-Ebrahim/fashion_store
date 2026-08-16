import 'package:flutter/material.dart';


class NoData extends StatelessWidget {
  final double heightt;
  final double? imageHeight;
  final String text;
  final bool isInternet;

  const NoData({
    super.key,
    required this.heightt,
    this.imageHeight,
    required this.text,
    this.isInternet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isInternet == false
                ? 'assets/images/nodata.png'
                : 'assets/images/no_internet.png',
            height: imageHeight ?? 250,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
