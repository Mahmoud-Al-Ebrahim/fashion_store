import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../blocs/store_bloc/store_bloc.dart';
import '../../../core/screen_util.dart';
import '../widgets/see_more_tabs_sections/detail_tabs_name.dart';
import '../widgets/see_more_tabs_sections/product_filter_sheet.dart';
import '../widgets/see_more_tabs_sections/search_filter_section.dart';
import '../widgets/see_more_tabs_sections/tabs/product_tab/product_tab.dart';
import '../widgets/see_more_tabs_sections/tabs/store_tab/store_tab.dart';

/// Explore screen: product search/filter in one tab, store browsing in the
/// other. Typing searches products (`Product/GetSearch`), while the filter
/// button applies `Product/GetFilter`.
class SeeMoreBar extends StatefulWidget {
  const SeeMoreBar({super.key});

  @override
  State<SeeMoreBar> createState() => _SeeMoreBarState();
}

class _SeeMoreBarState extends State<SeeMoreBar> {
  int _currentTab = 0;
  String _query = '';
  ProductFilterValues _filters = const ProductFilterValues();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Seed both tabs so the screen isn't empty before the user types.
    context.read<ProductBloc>().add(FilterProductsEvent());
    if (context.read<StoreBloc>().state.stores.isEmpty) {
      context.read<StoreBloc>().add(GetAllStoresEvent());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      _query = value.trim();
      if (_currentTab == 0) _runProductQuery();
      setState(() {});
    });
  }

  /// Search and filter are separate endpoints - a non-empty query wins,
  /// otherwise the filter values are applied.
  void _runProductQuery() {
    if (_query.isNotEmpty) {
      context.read<ProductBloc>().add(SearchProductsEvent(query: _query));
    } else {
      context.read<ProductBloc>().add(
        FilterProductsEvent(
          minPrice: _filters.minPrice,
          maxPrice: _filters.maxPrice,
          type: _filters.type,
          color: _filters.color,
          size: _filters.size,
        ),
      );
    }
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<ProductFilterValues>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductFilterSheet(initial: _filters),
    );
    if (result == null || !mounted) return;
    setState(() {
      _filters = result;
      _query = '';
    });
    _runProductQuery();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchFilterSection(
              onSearchChanged: _onSearchChanged,
              onFilterTap: _openFilters,
              showFilter: _currentTab == 0,
            ),
            SeeMoreTabBarsName(
              onTap: (index) => setState(() => _currentTab = index),
            ),
            SizedBox(height: height(10)),
            Expanded(
              child: TabBarView(
                children: [
                  ProductsTab(
                    hasQuery: _query.isNotEmpty,
                    onRetry: _runProductQuery,
                  ),
                  StoreTab(query: _query),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
