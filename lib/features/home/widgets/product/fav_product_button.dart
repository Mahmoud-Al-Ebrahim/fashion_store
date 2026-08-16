import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/screen_util.dart';
class FavProductButton extends StatelessWidget {
  final bool isLiked;
  final String productId;

  const FavProductButton({
    super.key,
    required this.isLiked,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<FavBloc, FavState>(
    //   listenWhen: (previous, current) =>
    //   previous.addToFav[productId] != current.addToFav[productId],
    //   buildWhen: (previous, current) =>
    //   previous.addToFav[productId] != current.addToFav[productId],
    //
    //   listener: (context, state) {
    //     final blocState = state.addToFav[productId];
    //     if (blocState?.isFailed == true && blocState?.message != null) {
    //       showFlushBar(context, blocState!.message!);
    //     }
    //   },
    //
    //   builder: (context, state) {
    //     final blocState = state.addToFav[productId];
    //     final currentLikedState = blocState?.data ?? isLiked;

        return Positioned(
          top: height(35),
          left: width(15),
          child: GestureDetector(
            onTap: () {
              // if (AuthServiceLocator.instance.token == null ||
              //     AuthServiceLocator.instance.token!.isEmpty) {
              //   showFlushBar(
              //       context, "يرجى تسجيل الدخول لتتمكن من الإعجاب بالمنتج");
              //   return;
              // }
              //
              // context.read<FavBloc>().add(
              //   AddToFavEvent(
              //     id: productId,
              //     initialValue: currentLikedState,
              //   ),
              // );
            },
            child: Container(
              width: width(44),
              height: height(44),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .shadow
                        .withOpacity(0.11),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SvgPicture.asset(
                    true
                        ? "assets/svg/save_fill.svg"
                        : "assets/svg/save.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
