import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/screen_util.dart';
import '../../../../models/posts_response_model.dart';
import '../../../store/widgets/store_top_side/image_top_side.dart';
import '../../../store/widgets/store_top_side/reviews_stars.dart';


class StoreFavouriteSectionFirstSection extends StatelessWidget {
  final Store store;
  const StoreFavouriteSectionFirstSection({super.key, required this.store, });

  @override
  Widget build(BuildContext context) {
    return           Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height(12),),
          StoreFavouriteSectionFirstSectionRow(store: store,),
          SizedBox(height: height(12)),
          SizedBox(
            width: width(220),
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              store.description ?? "_______",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Color(0xff7A7A7A),
              ),
            ),
          ),
        ],
      ),
    )
    ;
  }
}


class StoreFavouriteSectionFirstSectionRow extends StatelessWidget {
  final Store store;

  const StoreFavouriteSectionFirstSectionRow({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(220),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageTopSide(heightWidth: 44, imageUrl: store.logoUrl ?? ""),
          SizedBox(width: width(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(5)),
                Text(
                  store.name ?? "_____",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: height(6)),
                ReviewsStars(rating: 4.2),
              ],
            ),
          ),
          SizedBox(width: width(5)),
          SaveLayerWithOutStack(
            id: store.id ?? "",
            isLiked:  true,
          ),
        ],
      ),
    );
  }
}

class SaveLayerWithOutStack extends StatelessWidget {
  final String id;
  final bool isLiked;
  final double? heightAndWidth;

  const SaveLayerWithOutStack({
    super.key,
    required this.id,
    required this.isLiked,
    this.heightAndWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (AuthServiceLocator.instance.token == null ||
        //     AuthServiceLocator.instance.token!.isEmpty) {
        //   showFlushBar(context, "يرجى تسجيل الدخول لتتمكن من الإعجاب");
        //   return;
        // }
        //
        // context.read<FavBloc>().add(
        //   AddToFavEvent(
        //     id: id,
        //     initialValue: currentLikedState,
        //   ),
        // );
      },
      child: Container(
        height: height(heightAndWidth ?? 45),
        width: width(heightAndWidth ?? 45),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .shadow
                  .withOpacity(0.35),
              blurRadius: 2.3,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.5),
            child: SvgPicture.asset(
              height: 17,
              width: 17,
              color: Theme.of(context).colorScheme.primary,
              false
                  ? "assets/svg/save_fill.svg"
                  : "assets/svg/save.svg",
            ),
          ),
        ),
      ),
    );
    // return BlocConsumer<FavBloc, FavState>(
    //   listenWhen: (previous, current) =>
    //   previous.addToFav[id] != current.addToFav[id],
    //   buildWhen: (previous, current) =>
    //   previous.addToFav[id] != current.addToFav[id],
    //   listener: (context, state) {
    //     final blocState = state.addToFav[id];
    //     if (blocState?.isFailed == true && blocState?.message != null) {
    //       showFlushBar(context, blocState!.message!);
    //     }
    //   },
    //
    //   builder: (context, state) {
    //     final blocState = state.addToFav[id];
    //     final currentLikedState = blocState?.data ?? isLiked;
    //
    //     return GestureDetector(
    //       onTap: () {
    //         if (AuthServiceLocator.instance.token == null ||
    //             AuthServiceLocator.instance.token!.isEmpty) {
    //           showFlushBar(context, "يرجى تسجيل الدخول لتتمكن من الإعجاب");
    //           return;
    //         }
    //
    //         context.read<FavBloc>().add(
    //           AddToFavEvent(
    //             id: id,
    //             initialValue: currentLikedState,
    //           ),
    //         );
    //       },
    //       child: Container(
    //         height: height(heightAndWidth ?? 45),
    //         width: width(heightAndWidth ?? 45),
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           color: Theme.of(context).colorScheme.onPrimary,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Theme.of(context)
    //                   .colorScheme
    //                   .shadow
    //                   .withOpacity(0.35),
    //               blurRadius: 2.3,
    //               offset: const Offset(1, 1),
    //             ),
    //           ],
    //         ),
    //         child: Center(
    //           child: Padding(
    //             padding: const EdgeInsets.only(bottom: 0.5),
    //             child: SvgPicture.asset(
    //               height: 17,
    //               width: 17,
    //               color: currentLikedState
    //                   ? Theme.of(context).colorScheme.primary
    //                   : Theme.of(context).colorScheme.primary,
    //               currentLikedState
    //                   ? Assets.svgSaveFill
    //                   : Assets.svgSave,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
