
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:fashion_store/features/store/pages/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/screen_util.dart';
import '../../models/posts_response_model.dart';
import '../home/widgets/see_more_tabs_sections/store_favorite_first_section.dart';

class StoreFavCard extends StatelessWidget {
  final Store store;

  const StoreFavCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: (){
          context.pushPage(StoreScreen(storeId: store.id.toString()));
        },
        child: Container(
          height: height(140),
          width: width(380),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.5),
            color: Theme.of(context).colorScheme.onPrimary,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.10),
                blurRadius: 1,
                offset: const Offset(0.5, 0.5),
              ),
            ],
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            children: [
              StoreFavouriteSectionFirstSection(store: store,),
              Spacer(),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
                child: CachedNetworkImage(
                  imageUrl: store.mainImage ?? "",
                  width: width(100),
                  height: height(140),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: width(110),
                      color: Colors.grey.shade300,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: width(110),
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
