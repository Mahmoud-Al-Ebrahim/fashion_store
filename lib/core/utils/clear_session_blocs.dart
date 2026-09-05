import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/admin_bloc/admin_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';
import '../../blocs/category_bloc/category_bloc.dart';
import '../../blocs/clothing_item_bloc/clothing_item_bloc.dart';
import '../../blocs/comment_bloc/comment_bloc.dart';
import '../../blocs/complaint_bloc/complaint_bloc.dart';
import '../../blocs/order_bloc/order_bloc.dart';
import '../../blocs/post_bloc/post_bloc.dart';
import '../../blocs/product_bloc/product_bloc.dart';
import '../../blocs/rating_bloc/rating_bloc.dart';
import '../../blocs/store_bloc/store_bloc.dart';
import '../../blocs/store_follower_bloc/store_follower_bloc.dart';
import '../../blocs/store_request_bloc/store_request_bloc.dart';
import '../../blocs/super_admin_bloc/super_admin_bloc.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import '../../blocs/wallet_bloc/wallet_bloc.dart';
import '../services/chat_hub_service.dart';

/// Resets every bloc that holds session data back to its initial state.
///
/// The blocs are provided once at the app root so that pushed routes can
/// reach them, which means they outlive sign-out. Without an explicit wipe
/// the next account to sign in on the same device would briefly see the
/// previous user's cart, orders, wallet, complaints and profile - each
/// screen only corrects itself once its own fetch returns, and some screens
/// never refetch at all.
///
/// [AuthBloc] is excluded by default: it owns the sign-out itself, and
/// clearing it mid-flight would discard the very state that reports the
/// sign-out succeeded. Pass [includeAuth] on the paths that are *not* a
/// sign-out - dropping into guest mode, most importantly, where AuthBloc
/// still holds the previous account's login response (tokens included).
void clearSessionBlocs(BuildContext context, {bool includeAuth = false}) {
  if (includeAuth) context.read<AuthBloc>().add(ClearAuthEvent());
  context.read<AdminBloc>().add(ClearAdminEvent());
  context.read<CartBloc>().add(ClearCartEvent());
  context.read<CategoryBloc>().add(ClearCategoryEvent());
  context.read<ClothingItemBloc>().add(ClearClothingItemEvent());
  context.read<CommentBloc>().add(ClearCommentEvent());
  context.read<ComplaintBloc>().add(ClearComplaintEvent());
  context.read<OrderBloc>().add(ClearOrderEvent());
  context.read<PostBloc>().add(ClearPostEvent());
  context.read<ProductBloc>().add(ClearProductEvent());
  context.read<RatingBloc>().add(ClearRatingEvent());
  context.read<StoreBloc>().add(ClearStoreEvent());
  context.read<StoreFollowerBloc>().add(ClearStoreFollowerEvent());
  context.read<StoreRequestBloc>().add(ClearStoreRequestEvent());
  context.read<SuperAdminBloc>().add(ClearSuperAdminEvent());
  context.read<UserBloc>().add(ClearUserEvent());
  context.read<WalletBloc>().add(ClearWalletEvent());
  // Not a bloc, but the same problem: the chat hub is a singleton holding
  // the signed-out account's token and its complaint-group memberships.
  // Left open, the next account on this device would inherit both.
  ChatHubService.instance.disconnect();
}
