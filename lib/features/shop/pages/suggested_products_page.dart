import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/async_view.dart';
import '../../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../../core/constants/product_enums.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../models/product/product_ref.dart';
import '../../home/pages/product_screen.dart';
import '../widgets/price_tag.dart';

/// Full-page list of products suggested for a given product, reached from
/// the "see all" link on the product details sheet.
class SuggestedProductsPage extends StatefulWidget {
  final int productId;

  const SuggestedProductsPage({super.key, required this.productId});

  @override
  State<SuggestedProductsPage> createState() => _SuggestedProductsPageState();
}

class _SuggestedProductsPageState extends State<SuggestedProductsPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<ClothingItemBloc>().add(
        GetSuggestedProductsEvent(productId: widget.productId),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.suggestionsTitle.tr()),
      ),
      body: BlocBuilder<ClothingItemBloc, ClothingItemState>(
        builder: (context, state) {
          return AsyncView(
            isLoading: state.getSuggestedProductsStatus ==
                GetSuggestedProductsStatus.loading,
            isFailure: state.getSuggestedProductsStatus ==
                GetSuggestedProductsStatus.failure,
            isEmpty: state.getSuggestedProductsStatus ==
                    GetSuggestedProductsStatus.success &&
                state.suggestedProducts.isEmpty,
            errorMessage: state.errorMessage,
            emptyText: LK.suggestionsNone.tr(),
            onRetry: _load,
            child: RefreshIndicator(
              onRefresh: () async => _load(),
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(width(16)),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemCount: state.suggestedProducts.length,
                itemBuilder: (context, index) {
                  final item = state.suggestedProducts[index];
                  return GestureDetector(
                    onTap: () => context.pushPage(
                      ProductScreen(product: ProductRef.fromSuggested(item)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              imageUrl:
                                  ApiService.resolveUrl(item.imageUrl) ?? '',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  Container(color: const Color(0xFFEAEAF2)),
                              errorWidget: (_, __, ___) => Container(
                                color: const Color(0xFFEAEAF2),
                                child: const Icon(
                                  Icons.checkroom,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height(6)),
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${localizedColorName(item.color)} • ${LK.typeKey(item.type).tr()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(color: Colors.grey, fontSize: 11),
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
