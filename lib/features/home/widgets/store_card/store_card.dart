import 'package:fashion_store/features/home/widgets/store_card/store_card-founder_photo.dart';
import 'package:fashion_store/features/home/widgets/store_card/store_card_detail.dart';
import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';

import '../product_card/layers/add_layer.dart';
import '../product_card/layers/save_layer.dart';
class StoreCard extends StatelessWidget {
  final Store recommendedStore;

  const StoreCard({super.key, required this.recommendedStore});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          StoreCardDetail(recommendedStore: recommendedStore),
          StoreCardFounderPhoto(
            imageUrl: recommendedStore.logoUrl ?? "",
          ),
          SaveLayer(
            id: recommendedStore.id ?? "",
            isLiked: false , //recommendedStore.i ?? false,
          ),
          AddLayer(
            productId: recommendedStore.id ?? "",
            price: 0,
            isShowProductDetail: true,
            isRest: true,
          ),
        ],
      ),
    );
  }
}
