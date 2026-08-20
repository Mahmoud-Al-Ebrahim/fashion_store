import 'package:fashion_store/features/home/widgets/store_card/store_card-founder_photo.dart';
import 'package:fashion_store/features/home/widgets/store_card/store_card_detail.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/api_service.dart';
import '../../../../models/store/store_model.dart';

/// Store tile: the white detail card with the store logo overlapping its
/// top corner. The old Save/Add overlays were dropped - the backend has no
/// favourites endpoint and a store isn't something you add to a cart.
class StoreCard extends StatelessWidget {
  final StoreModel recommendedStore;

  const StoreCard({super.key, required this.recommendedStore});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          StoreCardDetail(recommendedStore: recommendedStore),
          StoreCardFounderPhoto(
            imageUrl: ApiService.resolveUrl(recommendedStore.logo) ?? '',
          ),
        ],
      ),
    );
  }
}
