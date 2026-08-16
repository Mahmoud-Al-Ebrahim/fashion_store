import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../widgets/store_app_bar.dart';
import '../widgets/store_top_side/store_top_side.dart';
import '../widgets/tab_bar/categories_tab/categories_tab.dart';
import '../widgets/tab_bar/posts_tab/posts_tab.dart';
import '../widgets/tab_bar/reviews_tab/review_tab.dart';
import '../widgets/tab_bar/tab_bar.dart';
import '../widgets/tab_bar/who_am_i_tab/who_am_i_tab.dart';

class StoreScreen extends StatefulWidget {
  final String storeId;
  static String name = "store_screen";
  static String path = "/store_screen";

  const StoreScreen({super.key, required this.storeId});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  // late AuthUserBloc authUserBloc;
  // late StoreBloc storeBloc;
  // late HomeAndProductBloc homeAndProductBloc;
  // late ChatBloc chatBloc;

  @override
  void initState() {
    // authUserBloc = getIt<AuthUserBloc>();
    // storeBloc = getIt<StoreBloc>();
    // homeAndProductBloc = getIt<HomeAndProductBloc>();
    // chatBloc = getIt<ChatBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: StoreAppBar(
          onTap: () {
            context.pop();
          },
          hideLeading: false, // AuthServiceLocator.instance.role != TypeUser.user,
        ),
        body: Column(
          children: [
            StoreTopSide(
              // storeBloc: storeBloc,
              storeId: widget.storeId,
            ),
            SizedBox(height: height(10)),
            TabBarsName(),
            Expanded(
              child: TabBarView(
                children: [
                  // AuthServiceLocator.instance.role == TypeUser.user
                  //     ?
                  WhoAmITab(
                        // storeBloc: storeBloc,
                        storeId: widget.storeId,
                      ),
                      // : WhoAmITabForStoreDashboard(
                      //   storeBloc: storeBloc,
                      //   storeId: widget.storeId,
                      // ),
                  CategoriesTab(
                    // authUserBloc: authUserBloc,
                    storeId: widget.storeId,
                    // storeBloc: storeBloc,
                  ),
                  PostsTab(
                    // storeBloc: storeBloc,
                    storeId: widget.storeId,
                  ),
                  ReviewTab(
                    // storeBloc: storeBloc,
                    storeId: widget.storeId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
