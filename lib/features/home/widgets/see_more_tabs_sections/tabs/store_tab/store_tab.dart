import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/widgets/async_view.dart';
import '../../../../../../blocs/store_bloc/store_bloc.dart';
import '../../../../../../core/localization/translation_keys.dart';
import '../../../../../../core/screen_util.dart';
import '../../../store_card/store_card.dart';

/// Explore > stores. The backend has no store-search endpoint, so the query
/// filters the already-loaded store list on the client.
class StoreTab extends StatelessWidget {
  final String query;

  const StoreTab({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final normalized = query.trim().toLowerCase();
        final stores = normalized.isEmpty
            ? state.stores
            : state.stores
                  .where(
                    (s) =>
                        s.storeName.toLowerCase().contains(normalized) ||
                        s.description.toLowerCase().contains(normalized) ||
                        s.address.toLowerCase().contains(normalized),
                  )
                  .toList();

        return AsyncView(
          isLoading: state.getAllStoresStatus == GetAllStoresStatus.loading,
          isFailure: state.getAllStoresStatus == GetAllStoresStatus.failure,
          isEmpty: stores.isEmpty,
          errorMessage: state.errorMessage,
          emptyText: LK.exploreNoResults.tr(),
          onRetry: () => context.read<StoreBloc>().add(GetAllStoresEvent()),
          child: GridView.builder(
            padding: EdgeInsets.only(
              left: width(8),
              right: width(8),
              top: height(20),
              bottom: height(8),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: stores.length,
            itemBuilder: (context, index) =>
                StoreCard(recommendedStore: stores[index]),
          ),
        );
      },
    );
  }
}
