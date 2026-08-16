import 'package:fashion_store/features/store/widgets/tab_bar/who_am_i_tab/column_layer/text_desc_column_who_am_i.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/screen_util.dart';
import '../../../../../../models/store/store_who_am_i_model.dart';
import '../../../../../home/widgets/product/des_product_scrooll.dart';
import 'image_who_am_i.dart';

class ColumnLayerWhoAmI extends StatelessWidget {
  final StoreWhoAmIModel storeWhoAmIModel;

  const ColumnLayerWhoAmI({super.key, required this.storeWhoAmIModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height(500),
        width: width(350),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: Column(
          children: [
            ImageWhoAmI(imageUrl: storeWhoAmIModel.mainImage ?? ""),
            SizedBox(height: height(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ContentProductScrollable(
                title: storeWhoAmIModel.description ?? "____",
                heightScroll: 120,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            TextDescColumnWhoAmI(
              text: "المتجر",
              desc: storeWhoAmIModel.country?.name ?? "____",
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            TextDescColumnWhoAmI(text: "الأصناف", desc: "نسائي , عصري"),
            Divider(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            TextDescColumnWhoAmI(
              text: "أوقات العمل",
              desc: storeWhoAmIModel.workingHours ?? "____",
            ),
          ],
        ),
      ),
    );
  }
}
