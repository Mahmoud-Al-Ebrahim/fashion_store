import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/screen_util.dart';
import '../../see_more_category/choose_see_more_category.dart';
import 'store_see_more_list_view.dart';

class StoreTab extends StatefulWidget {
  // final HomeAndProductBloc homeAndProductBloc;
  // final AuthUserBloc authUserBloc;

  const StoreTab({
    super.key,
    // required this.homeAndProductBloc,
    // required this.authUserBloc,
  });

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              ChooseSeeMoreCategory(
                // authUserBloc: widget.authUserBloc,
                // homeAndProductBloc: widget.homeAndProductBloc,
                isProduct: false,
              ),
              SizedBox(height: height(20)),
            ],
          ),
        ),
        StoreSeeMoreList(),
        SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
    ;
  }
}
