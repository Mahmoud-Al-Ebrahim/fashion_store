import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/store/store_products_model.dart';
class CategoriesPicker extends StatefulWidget {
  const CategoriesPicker({
    super.key,
    required this.scrollController, required this.type,
  });

  final String type;

  final ScrollController scrollController;

  @override
  State<CategoriesPicker> createState() => _CategoriesPickerState();
}

class _CategoriesPickerState extends State<CategoriesPicker> {
  @override
  void initState() {
    widget.scrollController.addListener(_paginationListener);
    super.initState();
  }

  _paginationListener() {
    // if (widget.scrollController.offset >=
    //     (widget.scrollController.position.maxScrollExtent * 0.7)) {
    //   BlocProvider.of<AuthUserBloc>(
    //     context,
    //   ).add(GetAllCategoriesEvent(type: widget.type));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 33),
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          // BlocBuilder<AuthUserBloc, AuthUserState>(
          //   buildWhen: (p, c) =>
          //   p.getAllCategoriesPagination.paginationStatus !=
          //       c.getAllCategoriesPagination.paginationStatus,
          //   builder: (context, state) {
          //     if (state.getAllCategoriesPagination.paginationStatus ==
          //         PaginationStatus.loading &&
          //         state.getAllCategoriesPagination.items.isEmpty) {
          //       return SliverToBoxAdapter(child: MinBaytyLoader());
          //     }
          //     if (state.getAllCategoriesPagination.paginationStatus ==
          //         PaginationStatus.failure) {
          //       return SliverToBoxAdapter(child: TryAgainWidget(onTap: () {
          //         BlocProvider.of<AuthUserBloc>(
          //           context,
          //         ).add(GetAllCategoriesEvent(type: widget.type));
          //       }));
          //     }
               SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(
                            context,
                            categories[index]
                            // state.getAllCategoriesPagination.items[index],
                          );
                          return;
                        },
                        child: categoryItem(
                        categories[index]
                          // state.getAllCategoriesPagination.items[index],
                        ),
                      ),
                      Divider(
                        indent: 22.w,
                        endIndent: 22.w,
                        height: 0,
                      ),
                    ],
                  ),
                  childCount: categories.length , //state.getAllCategoriesPagination.items.length,
                ),
              )

          // BlocBuilder<AuthUserBloc, AuthUserState>(
          //   buildWhen: (p, c) =>
          //   p.getAllCategoriesPagination.paginationStatus !=
          //       c.getAllCategoriesPagination.paginationStatus,
          //   builder: (context, state) {
          //     if (state.getAllCategoriesPagination.paginationStatus ==
          //         PaginationStatus.loading &&
          //         state.getAllCategoriesPagination.items.isNotEmpty) {
          //       return SliverToBoxAdapter(child: MinBaytyLoader());
          //     }
          //     return SliverToBoxAdapter(child: SizedBox.shrink());
          //   },
          // ),
        ],
      ),
    );
  }

  Widget categoryItem(Category category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          if (category.imageUrl!= null) ...{
            15.horizontalSpace,
            CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: category.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300], // ممكن تحط shimmer بدل اللون الرمادي
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          },
          20.horizontalSpace,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: (1.sw - 100).w),
            child: Text(
              category.name.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          15.horizontalSpace,
        ],
      ),
    );
  }
}
