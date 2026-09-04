import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/admin_bloc/admin_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../core/utils/api_service.dart';
import '../../shop/widgets/price_tag.dart';
import '../../../core/extensions/build_context.dart';
import '../../../core/utils/show_message.dart';
import '../../../models/admin/product_dashboard_model.dart';
import '../widgets/admin_async_view.dart';
import 'admin_product_detail_page.dart';

/// Everything in this store that currently carries a discount, from
/// `Admin/GetAllDiscountProductByStore`.
///
/// The main products list shows the whole catalog; this is the store
/// owner's view of what is on offer right now, so an expired or forgotten
/// promotion is easy to spot. Read-only - editing a discount happens on the
/// product itself.
class AdminDiscountedProductsPage extends StatefulWidget {
  const AdminDiscountedProductsPage({super.key});

  @override
  State<AdminDiscountedProductsPage> createState() =>
      _AdminDiscountedProductsPageState();
}

class _AdminDiscountedProductsPageState
    extends State<AdminDiscountedProductsPage> {
  @override
  void initState() {
    super.initState();
    _load();
    // Needed to resolve a row to the full product record on tap.
    context.read<AdminBloc>().add(
      GetProductDashboardEvent(pageNumber: 1, pageSize: 100),
    );
  }

  void _load() =>
      context.read<AdminBloc>().add(GetAllDiscountProductByStoreEvent());

  /// Opens the product's management screen.
  ///
  /// This list is a projection that lacks the colour/size breakdown the
  /// management screen needs, so the full record is taken from the product
  /// dashboard - loaded here for exactly that purpose.
  Future<void> _openProduct(BuildContext context, int productId) async {
    final products =
        context.read<AdminBloc>().state.productDashboard?.products ??
        const <ProductDashboardItemModel>[];
    ProductDashboardItemModel? match;
    for (final candidate in products) {
      if (candidate.id == productId) {
        match = candidate;
        break;
      }
    }
    if (match == null) {
      showMessage(LK.commonNoData.tr());
      return;
    }
    final changed = await context.pushPage<bool>(
      AdminProductDetailPage(product: match),
    );
    if (changed == true && mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(LK.adminDiscountedProducts.tr()),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        buildWhen: (p, c) =>
            p.getAllDiscountProductByStoreStatus !=
                c.getAllDiscountProductByStoreStatus ||
            p.discountedStoreProducts != c.discountedStoreProducts,
        builder: (context, state) {
          final status = state.getAllDiscountProductByStoreStatus;
          return AdminAsyncView(
            isLoading: status == GetAllDiscountProductByStoreStatus.loading,
            isFailure: status == GetAllDiscountProductByStoreStatus.failure,
            isEmpty:
                status == GetAllDiscountProductByStoreStatus.success &&
                state.discountedStoreProducts.isEmpty,
            errorMessage: state.errorMessage,
            emptyText: LK.adminNoDiscounts.tr(),
            onRetry: _load,
            child: RefreshIndicator(
              onRefresh: () async => _load(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(width(16)),
                itemCount: state.discountedStoreProducts.length,
                separatorBuilder: (_, __) => SizedBox(height: height(10)),
                itemBuilder: (context, index) {
                  final product = state.discountedStoreProducts[index];
                  final image = ApiService.resolveUrl(product.image) ?? '';
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    // An owner tapping their own product manages it.
                    onTap: () => _openProduct(context, product.id),
                    child: Container(
                      padding: EdgeInsets.all(width(10)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD3D3E4)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: image.isEmpty
                                ? Container(
                                    width: width(56),
                                    height: width(56),
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: image,
                                    width: width(56),
                                    height: width(56),
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(
                                      width: width(56),
                                      height: width(56),
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: width(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                SizedBox(height: height(4)),
                                if (product.discountEndDate != null)
                                  Text(
                                    '${LK.commonTo.tr()} '
                                    '${_formatDate(product.discountEndDate!)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: width(8)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (product.discountPercentage != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width(8),
                                    vertical: height(3),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '-${product.discountPercentage!.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              SizedBox(height: height(4)),
                              PriceTag(
                                price: product.price,
                                priceAfterDiscount: product.priceAfterDiscount,
                                hasDiscount:
                                    product.priceAfterDiscount < product.price,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
