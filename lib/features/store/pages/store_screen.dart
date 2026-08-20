import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../blocs/store_follower_bloc/store_follower_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../../../models/store/store_model.dart';
import '../widgets/store_app_bar.dart';
import '../widgets/store_top_side/store_top_side.dart';
import '../widgets/tab_bar/categories_tab/categories_tab.dart';
import '../widgets/tab_bar/posts_tab/posts_tab.dart';
import '../widgets/tab_bar/tab_bar.dart';
import '../widgets/tab_bar/who_am_i_tab/who_am_i_tab.dart';

/// Public store page. Three tabs - About / Products / Posts.
///
/// The original design had a fourth "reviews" tab, but the backend exposes
/// ratings and comments per *product* only (there is no store-review
/// endpoint), so that tab was dropped rather than faked.
class StoreScreen extends StatefulWidget {
  final StoreModel store;

  static String name = "store_screen";
  static String path = "/store_screen";

  const StoreScreen({super.key, required this.store});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StoreBloc>().add(
      GetAllProductsByStoreEvent(storeId: widget.store.id),
    );
    context.read<PostBloc>().add(GetAllPostsEvent(storeId: widget.store.id));
    context.read<StoreFollowerBloc>().add(
      GetStoreFollowersCountEvent(storeId: widget.store.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: StoreAppBar(onTap: () => context.pop(), hideLeading: false),
        body: Column(
          children: [
            StoreTopSide(store: widget.store),
            SizedBox(height: height(10)),
            const TabBarsName(),
            Expanded(
              child: TabBarView(
                children: [
                  WhoAmITab(store: widget.store),
                  CategoriesTab(store: widget.store),
                  PostsTab(storeId: widget.store.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
