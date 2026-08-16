import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/store/store_products_model.dart';
import 'one_item_more_detail.dart';

class MoreDetailAboutProduct extends StatelessWidget {
  final Store store;
  final Product product;
  const MoreDetailAboutProduct({super.key, required this.store, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(57),
      decoration: BoxDecoration(
        color: Color(0xFF666A7A).withOpacity(0.11),

        // صح، بس تأكد من ترتيب ARGB مش RGB
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 0.05,

          color: Theme.of(context).colorScheme.shadow.withOpacity(0.30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(20)),
        child: Row(
          children: [
            OneItemMoreDetail(icon: "assets/svg/who_i_follow.svg", title: store!.name??"___"),
            // SizedBox(width: width(24),),
            // OneItemMoreDetail(icon: Assets.svgTime, title: productModel.preparationTime??"___"),
            SizedBox(width: width(24),),
            OneItemMoreDetail(icon: "assets/svg/Coins.svg", title: "${product.price} \$"),

          ],
        ),
      ),
    );
  }
}
