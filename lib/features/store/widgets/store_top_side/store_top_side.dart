import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/button.dart';
import '../../../../blocs/store_follower_bloc/store_follower_bloc.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/helper/helper_functions.dart';
import '../../../../core/utils/session.dart';
import '../../../../core/utils/show_message.dart';
import '../../../auth/pages/sign_in_screen/sign_in_screen.dart';
import '../../../../models/store/store_model.dart';
import 'image_top_side.dart';
import 'store_name_and_stars_top_side.dart';

/// Store header: logo, name, live follower count, and a follow/unfollow
/// toggle backed by `StoreFollower/StoreFollow`.
class StoreTopSide extends StatefulWidget {
  final StoreModel store;

  const StoreTopSide({super.key, required this.store});

  @override
  State<StoreTopSide> createState() => _StoreTopSideState();
}

class _StoreTopSideState extends State<StoreTopSide> {
  /// The follow endpoint is a toggle and there's no "am I following?" query,
  /// so this mirrors whatever the last toggle returned for this store.
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(13)),
      child: BlocConsumer<StoreFollowerBloc, StoreFollowerState>(
        listenWhen: (p, c) => p.storeFollow != c.storeFollow,
        listener: (context, state) {
          final follow = state.storeFollow;
          if (follow != null && follow.storeId == widget.store.id) {
            setState(() => _isFollowing = follow.isFollow);
            showMessage(
              follow.isFollow ? LK.storeFollow.tr() : LK.storeUnfollow.tr(),
              hasError: false,
            );
          }
        },
        builder: (context, state) {
          final busy = state.toggleStoreFollowStatus ==
              ToggleStoreFollowStatus.loading;
          return Row(
            children: [
              ImageTopSide(
                heightWidth: 55,
                imageUrl: ApiService.resolveUrl(widget.store.logo) ?? '',
              ),
              SizedBox(width: width(10)),
              Flexible(
                child: StoreNameAndStarsTopSide(
                  storeName: widget.store.storeName,
                  followingNumber: state.followersCount,
                ),
              ),
              const Spacer(),
              busy
                  ? SizedBox(
                      width: width(70),
                      height: height(30),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        if (!await requireAuth(
                          context,
                          onSignIn: () =>
                              HelperFunctions.navigateToPageAndPopAll(
                            context,
                            const SignInScreen(),
                            true,
                          ),
                        )) {
                          return;
                        }
                        if (!context.mounted) return;
                        context.read<StoreFollowerBloc>().add(
                          ToggleStoreFollowEvent(storeId: widget.store.id),
                        );
                      },
                      child: FollowButton(isFollowing: _isFollowing),
                    ),
            ],
          );
        },
      ),
    );
  }
}
