import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/admin_bloc/admin_bloc.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/show_message.dart';
import '../widgets/admin_async_view.dart';
import '../widgets/confirm_dialog.dart';
import 'admin_product_detail_page.dart';
import 'admin_product_form_page.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<AdminBloc>().add(
      GetProductDashboardEvent(pageNumber: 1, pageSize: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('المنتجات'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await context.pushPage<bool>(const AdminProductFormPage());
          if (added == true) _load();
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة منتج'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.productTransactionStatus != c.productTransactionStatus,
            listener: (context, state) {
              if (state.productTransactionStatus == ProductTransactionStatus.success) {
                showMessage('تم حذف المنتج', hasError: false);
                _load();
              } else if (state.productTransactionStatus == ProductTransactionStatus.failure) {
                showMessage(state.errorMessage);
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async => _load(),
          child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              final products = state.productDashboard?.products ?? [];
              return AdminAsyncView(
                isLoading:
                    state.getProductDashboardStatus == GetProductDashboardStatus.loading,
                isFailure:
                    state.getProductDashboardStatus == GetProductDashboardStatus.failure,
                isEmpty:
                    state.getProductDashboardStatus == GetProductDashboardStatus.success &&
                        products.isEmpty,
                errorMessage: state.errorMessage,
                emptyText: 'لا توجد منتجات بعد، أضف أول منتج لمتجرك',
                onRetry: _load,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(width(16)),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => SizedBox(height: height(10)),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFD3D3E4)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: width(10),
                          vertical: height(6),
                        ),
                        onTap: () async {
                          final changed = await context.pushPage<bool>(
                            AdminProductDetailPage(product: product),
                          );
                          if (changed == true) _load();
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: product.image,
                            width: width(56),
                            height: width(56),
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.image_not_supported_outlined),
                          ),
                        ),
                        title: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          'السعر: ${product.priceAfterDiscount.toStringAsFixed(0)}  •  المخزون: ${product.totalStock}  •  مباع: ${product.soldCount}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final confirmed = await confirmDialog(
                              context,
                              title: 'حذف المنتج',
                              message: 'هل أنت متأكد من حذف "${product.name}"؟',
                            );
                            if (!confirmed || !context.mounted) return;
                            context.read<ProductBloc>().add(
                              DeleteProductEvent(productId: product.id),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
