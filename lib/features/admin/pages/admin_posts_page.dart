import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/post_bloc/post_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/utils/show_message.dart';
import '../widgets/admin_async_view.dart';
import '../widgets/confirm_dialog.dart';
import 'admin_post_form_page.dart';

class AdminPostsPage extends StatefulWidget {
  const AdminPostsPage({super.key});

  @override
  State<AdminPostsPage> createState() => _AdminPostsPageState();
}

class _AdminPostsPageState extends State<AdminPostsPage> {
  int? _storeId;

  @override
  void initState() {
    super.initState();
    final store = context.read<StoreBloc>().state.myStore;
    if (store != null) _load(store.id);
  }

  void _load(int storeId) {
    _storeId = storeId;
    context.read<PostBloc>().add(GetAllPostsEvent(storeId: storeId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listenWhen: (p, c) => p.myStore?.id != c.myStore?.id,
      listener: (context, state) {
        if (state.myStore != null) _load(state.myStore!.id);
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: const Text('المنشورات'),
        ),
        floatingActionButton: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, storeState) {
            return FloatingActionButton.extended(
              onPressed: storeState.myStore == null
                  ? null
                  : () async {
                      await context.pushPage(
                        AdminPostFormPage(storeId: storeState.myStore!.id),
                      );
                    },
              icon: const Icon(Icons.add),
              label: const Text('منشور جديد'),
            );
          },
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PostBloc, PostState>(
              listenWhen: (p, c) => p.postTransactionStatus != c.postTransactionStatus,
              listener: (context, state) {
                if (state.postTransactionStatus == PostTransactionStatus.failure) {
                  showMessage(state.errorMessage);
                }
              },
            ),
          ],
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return AdminAsyncView(
                isLoading: state.getAllPostsStatus == GetAllPostsStatus.loading,
                isFailure: state.getAllPostsStatus == GetAllPostsStatus.failure,
                isEmpty: state.getAllPostsStatus == GetAllPostsStatus.success &&
                    state.posts.isEmpty,
                errorMessage: state.errorMessage,
                emptyText: 'لا توجد منشورات بعد',
                onRetry: () => _storeId != null ? _load(_storeId!) : null,
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (_storeId != null) _load(_storeId!);
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(width(16)),
                    itemCount: state.posts.length,
                    separatorBuilder: (_, __) => SizedBox(height: height(14)),
                    itemBuilder: (context, index) {
                      final post = state.posts[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD3D3E4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post.postMedias.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      ApiService.resolveUrl(post.postMedias.first.mediaUrl) ?? '',
                                  height: height(160),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.all(width(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.content),
                                  SizedBox(height: height(8)),
                                  Row(
                                    children: [
                                      Text(
                                        post.visibility == 'Public'
                                            ? 'عام'
                                            : 'للمتابعين فقط',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const Spacer(),
                                      Icon(Icons.favorite, size: 14, color: Colors.red.shade300),
                                      SizedBox(width: width(4)),
                                      Text(
                                        '${post.postReactions.fold<int>(0, (sum, r) => sum + r.count)}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      SizedBox(width: width(10)),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () async {
                                          final confirmed = await confirmDialog(
                                            context,
                                            title: 'حذف المنشور',
                                          );
                                          if (!confirmed || !context.mounted) return;
                                          context.read<PostBloc>().add(
                                            DeletePostEvent(
                                              postId: post.id,
                                              storeId: post.storeId,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
