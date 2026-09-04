import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/store_bloc/store_bloc.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/product/product_ref.dart';
import '../../../store/pages/store_screen.dart';

/// The selling store, shown on the product detail screen: logo, name, and
/// the store's own description underneath it.
///
/// The catalog endpoints (`GetFilter`, `GetAllDiscountProduct`,
/// `GetProductsByFollowerStores`) return only `storeId` - no store name and
/// no description - so a product opened from the home page showed nothing
/// about who sells it. The store record is resolved out of `StoreBloc`
/// (`Store/GetAllStores`, already loaded for the home and explore screens)
/// and the name carried on [ProductRef] is used as the fallback for the
/// paths that do provide one.
///
/// Tapping it opens that store. Only possible once the store record has
/// resolved - the fallback name alone is not enough to open a store page,
/// so the block stays inert (and drops the chevron) in that case.
class ProductStoreBlock extends StatelessWidget {
  const ProductStoreBlock({super.key, required this.product});

  final ProductRef product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      buildWhen: (p, c) => p.stores != c.stores,
      builder: (context, state) {
        final store = state.stores
            .where((s) => s.id == product.storeId)
            .firstOrNull;

        final name = store?.storeName ?? product.storeName ?? '';
        final description = store?.description ?? '';
        if (name.isEmpty && description.isEmpty) return const SizedBox.shrink();

        final theme = Theme.of(context);
        final logo = store?.logo ?? '';

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: store == null
              ? null
              : () => context.pushPage(StoreScreen(store: store)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(width(14)),
            decoration: BoxDecoration(
              color: const Color(0xFF666A7A).withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (logo.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: logo,
                          width: width(40),
                          height: width(40),
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            width: width(40),
                            height: width(40),
                            color: const Color(0xFFEAEAF2),
                            child: const Icon(
                              Icons.storefront_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width(10)),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LK.productAboutStore.tr(),
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          if (name.isNotEmpty)
                            Text(
                              name,
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (store != null)
                      Icon(
                        // Points the way the row reads - a right-facing
                        // chevron on the left edge of an Arabic layout
                        // would be pointing back at the text.
                        Directionality.of(context) == ui.TextDirection.rtl
                            ? Icons.chevron_left
                            : Icons.chevron_right,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: height(8)),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: const Color(0xff666A7A),
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
