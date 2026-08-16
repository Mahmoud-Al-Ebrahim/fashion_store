import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../store/pages/store_screen.dart';

class StoreCardDetail extends StatelessWidget {
  final Store recommendedStore;
  const StoreCardDetail({super.key, required this.recommendedStore});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        context.pushPage(StoreScreen(storeId: recommendedStore.id.toString(),),
          );

      },
      child: Container(
        height: height(197),
        width: width(165),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.11),
              blurRadius: 1,
              offset: const Offset(0.5, 0.5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height(60)),
              Text(
                recommendedStore.name??"________",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: height(2)),

              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: width(12),
                    color: index < (recommendedStore.averageRating ?? 0)
                        ? Colors.orange
                        : Colors.grey.withOpacity(0.4),
                  );
                }),
              ),
              SizedBox(height: height(9)),
              Text(
                recommendedStore.description??"__________",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w100,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
