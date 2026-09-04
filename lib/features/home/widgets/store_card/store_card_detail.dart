import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/store/store_model.dart';
import '../../../store/pages/store_screen.dart';

/// White rounded store card body - original design, bound to [StoreModel].
///
/// The API has no per-store rating endpoint, so the star row was replaced by
/// the store's working hours, which the store list does return.
class StoreCardDetail extends StatelessWidget {
  final StoreModel recommendedStore;

  const StoreCardDetail({super.key, required this.recommendedStore});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushPage(StoreScreen(store: recommendedStore)),
      child: Container(
        height: height(197),
        width: width(165),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.11),
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
                recommendedStore.storeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: height(4)),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: width(12),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: width(4)),
                  Expanded(
                    child: Text(
                      '${recommendedStore.workingHoursStart} - ${recommendedStore.workingHoursEnd}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height(9)),
              Text(
                recommendedStore.description,
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
