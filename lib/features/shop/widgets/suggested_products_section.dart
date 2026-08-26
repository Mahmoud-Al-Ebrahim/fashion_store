import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../../core/constants/product_enums.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../models/clothing_item/suggested_product_model.dart';
import '../../../models/product/product_ref.dart';
import '../../home/pages/product_screen.dart';
import '../pages/suggested_products_page.dart';
import 'price_tag.dart';

/// "Similar products" strip driven by `ClothingItem/GetSuggestByProductId`.
///
/// Open to every role, signed in or not - the endpoint answers unauthenticated
/// requests too, so guests get recommendations while browsing.
class SuggestedProductsSection extends StatefulWidget {
  final int productId;

  const SuggestedProductsSection({super.key, required this.productId});

  @override
  State<SuggestedProductsSection> createState() =>
      _SuggestedProductsSectionState();
}

class _SuggestedProductsSectionState extends State<SuggestedProductsSection> {
  @override
  void initState() {
    super.initState();
    context.read<ClothingItemBloc>().add(
      GetSuggestedProductsEvent(productId: widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClothingItemBloc, ClothingItemState>(
      buildWhen: (p, c) =>
          p.getSuggestedProductsStatus != c.getSuggestedProductsStatus ||
          p.suggestedProducts != c.suggestedProducts,
      builder: (context, state) {
        final loading = state.getSuggestedProductsStatus ==
            GetSuggestedProductsStatus.loading;
        final items = state.suggestedProducts;

        // Nothing to recommend - stay out of the way entirely.
        if (!loading && items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  LK.productSuggested.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.pushPage(
                    SuggestedProductsPage(productId: widget.productId),
                  ),
                  child: Text(LK.suggestionsSeeAll.tr()),
                ),
              ],
            ),
            SizedBox(height: height(12)),
            SizedBox(
              height: height(210),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => SizedBox(width: width(12)),
                      itemBuilder: (context, index) =>
                          _SuggestionCard(item: items[index]),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final SuggestedProductModel item;

  const _SuggestionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Push a fresh details screen for the suggested product.
      onTap: () => context.pushPage(
        ProductScreen(
          product: ProductRef.fromSuggested(item),
        ),
      ),
      child: SizedBox(
        width: width(140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl: ApiService.resolveUrl(item.imageUrl) ?? '',
                height: height(130),
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: const Color(0xFFEAEAF2)),
                errorWidget: (_, __, ___) => Container(
                  color: const Color(0xFFEAEAF2),
                  child: const Icon(Icons.checkroom, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: height(6)),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              localizedColorName(item.color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
            SizedBox(height: height(2)),
            PriceTag(
              price: item.price,
              priceAfterDiscount: item.priceAfterDiscount,
              hasDiscount: item.priceAfterDiscount < item.price,
              fontSize: 13,
            ),
          ],
        ),
      ),
    );
  }
}
