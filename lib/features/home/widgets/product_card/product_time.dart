// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../../../core/const/screen_util.dart';
// import '../../../../../../generated/assets.dart';
// import '../../../../store/data/models/store_productes_model.dart';
//
// class ProductTime extends StatelessWidget {
//   final Product product;
//   const ProductTime({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return   Container(
//       width: width(75),
//       height: height(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Theme.of(context).colorScheme.onPrimary,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         child: Row(
//           children: [
//             SvgPicture.asset(Assets.svgTime,color: Theme.of(context).colorScheme.onSurface,height: 10,width: 10,),
//             SizedBox(width: width(5),),
//             SizedBox(
//               width: width(50),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 2),
//                 child: Text(
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   " ${product.preparationTime??"_____"}  ",
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                       color: Theme.of(context).colorScheme.onSurface,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 9
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
