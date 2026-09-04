import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../core/localization/translation_keys.dart';
import '../../../core/screen_util.dart';
import '../../../models/product/product_ref.dart';
import '../../home/pages/product_screen.dart';

/// Opens the product details screen for [productId].
///
/// Cart lines, order items and the sales breakdown all identify a product by
/// id alone - none of them carry its name or description, and the API has no
/// "get product by id". This resolves the full product first, then replaces
/// itself with the normal [ProductScreen], so the user lands on exactly the
/// same page they would reach from the catalogue.
///
/// Uses `pushReplacement` on success: the resolver is plumbing, and Back
/// should return to the cart or order, not to a spinner.
/// Set [allowPurchase] to false when the viewer owns the catalogue being
/// inspected - see [ProductScreen.allowPurchase].
void openProductById(
  BuildContext context,
  int productId, {
  bool allowPurchase = true,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) =>
          ProductByIdPage(productId: productId, allowPurchase: allowPurchase),
    ),
  );
}

class ProductByIdPage extends StatefulWidget {
  const ProductByIdPage({
    super.key,
    required this.productId,
    this.allowPurchase = true,
  });

  final int productId;
  final bool allowPurchase;

  @override
  State<ProductByIdPage> createState() => _ProductByIdPageState();
}

class _ProductByIdPageState extends State<ProductByIdPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => context.read<ProductBloc>().add(
    LookupProductEvent(productId: widget.productId),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listenWhen: (p, c) => p.lookupProductStatus != c.lookupProductStatus,
        listener: (context, state) {
          if (state.lookupProductStatus != LookupProductStatus.success) return;
          final product = state.lookupProduct;
          if (product == null) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ProductScreen(
                product: ProductRef.fromCatalog(product),
                allowPurchase: widget.allowPurchase,
              ),
            ),
          );
        },
        builder: (context, state) {
          switch (state.lookupProductStatus) {
            case LookupProductStatus.notFound:
              // The product was removed from the catalogue but still exists
              // in this order - say so instead of showing a dead spinner.
              return _Message(
                icon: Icons.search_off,
                text: LK.productUnavailable.tr(),
              );
            case LookupProductStatus.failure:
              return _Message(
                icon: Icons.error_outline,
                text: state.errorMessage.isEmpty
                    ? LK.commonErrorGeneric.tr()
                    : state.errorMessage,
                onRetry: _load,
              );
            case LookupProductStatus.init:
            case LookupProductStatus.loading:
            case LookupProductStatus.success:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: width(56), color: Colors.grey),
            SizedBox(height: height(12)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: height(12)),
              TextButton(onPressed: onRetry, child: Text(LK.commonRetry.tr())),
            ],
          ],
        ),
      ),
    );
  }
}
