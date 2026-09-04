import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

import '../../../../core/screen_util.dart';

class OneItemMoreDetail extends StatelessWidget {
  final String icon;
  final String title;
  const OneItemMoreDetail({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height(25),
          width: width(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Center(child: SvgPicture.asset(icon)),
        ),
        SizedBox(width: width(5)),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          maxLines: 1, // سطر واحد فقط
          overflow: TextOverflow.ellipsis, // يضيف نقاط (...)
          softWrap: false, // يمنع النزول للسطر الثاني
        ),
      ],
    );
  }
}
