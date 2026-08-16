// import 'package:fashion_store/models/posts_response_model.dart';
// import 'package:flutter/material.dart';
// import '../../../../core/screen_util.dart';
//
// class UpperSection extends StatelessWidget {
//   final Store store;
//
//   const UpperSection({super.key, required this.store});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width(380),
//       height: height(90),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(width: 1.4, color: Colors.grey),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Row(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 25,
//                       height: 25,
//                       child: Hero(
//                         tag: 'store_${store.id}',
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(25),
//                           child: Image.network(
//                             store.flagImage ?? Assets.pngLogo2,
//                             // 🔹 fallback image
//                             width: width(25),
//                             height: height(25),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: width(10)),
//                     Text(
//                       store.name ?? "___",
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: height(10)),
//                 Text(
//                   "${store. ?? 0}  متجر " ?? "___",
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     color: Theme.of(context).colorScheme.primary,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             // Spacer(),
//             // SaveLayerWithOutStack(
//             //   id: store.id ?? "",
//             //   isLiked: store.isLiked ?? false,
//             //   heightAndWidth: 40,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
