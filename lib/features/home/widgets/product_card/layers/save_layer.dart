import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/screen_util.dart';

class SaveLayer extends StatelessWidget {
  final String id;
  final bool isLiked;

  const SaveLayer({
    super.key,
    required this.id,
    required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {

      // return BlocConsumer<FavBloc, FavState>(
      // listenWhen: (previous, current) =>
      // previous.addToFav[id] != current.addToFav[id],
      // buildWhen: (previous, current) =>
      // previous.addToFav[id] != current.addToFav[id],
      //
      // listener: (context, state) {
      //   final blocState = state.addToFav[id];
      //   if (blocState?.isFailed == true && blocState?.message != null) {
      //     showFlushBar(context, blocState!.message!);
      //   }
      // },
      //
      // builder: (context, state) {
      //   final blocState = state.addToFav[id];
      //   final currentLikedState = blocState?.data ?? isLiked;

        return Positioned(
          left: 14,
          top: 14,
          child: GestureDetector(
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
              height: height(45),
              width: width(45),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onPrimary,
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
                  padding: const EdgeInsets.only(bottom: 0.5),
                  child: SvgPicture.asset(
                    height: 17,
                    width: 17,
                    color:  Theme.of(context).colorScheme.primary,
                    true
                        ? "assets/svg/save_fill.svg" // currentLikedState
                        : "assets/svg/save.svg",
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
