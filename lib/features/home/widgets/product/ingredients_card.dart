// import 'package:flutter/material.dart';
//
// import '../../../../../../core/const/screen_util.dart';
// import '../../../../../../generated/assets.dart';
//
// class IngredientsCard extends StatelessWidget {
//   const IngredientsCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.asset(
//                 Assets.jpgCheese,
//                 width: width(40),
//                 height: height(44),
//               ),
//             ),
//             SizedBox(width: width(20)),
//             Text(
//               "الخميرة",
//               style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                 fontWeight: FontWeight.w500,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//             Spacer(),
//             Text(
//               "100 كالوري",
//               style: Theme.of(
//                 context,
//               ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//         SizedBox(height: height(3),),
//         Container(
//           height: 1,
//           width: double.infinity,
//           color: Theme.of(context).colorScheme.primary.withOpacity(0.5),)
//       ],
//     );
//   }
// }
