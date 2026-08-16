// import 'package:flutter/material.dart';
// import 'package:min_bayty/core/const/screen_util.dart';
// import 'package:min_bayty/features/user/home_page/presentation/widgets/product/ingredients_card.dart';
//
// import '../../../../../../generated/assets.dart';
//
// class IngredientsProduct extends StatelessWidget {
//   const IngredientsProduct({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height(355), // ارتفاع ثابت
//       clipBehavior: Clip.hardEdge, // هذا مهم! يمنع المحتوى من الخروج
//       decoration: const BoxDecoration(), // ضروري للـ clipBehavior
//       child: ListView.builder(
//           itemCount: 20,
//           physics: const BouncingScrollPhysics(), // scroll عادي
//           padding: EdgeInsets.zero,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: width(10),
//                   vertical: height(index == 0 ? 0 : 10)
//               ),
//               child: IngredientsCard(),
//             );
//           }
//       ),
//     );
//   }
// }