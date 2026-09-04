import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/translation_keys.dart';
import '../../../../../core/screen_util.dart';
import '../../../../../core/utils/api_service.dart';
import '../../../../../models/store/store_model.dart';
import '../../../../shop/pages/image_viewer_page.dart';

/// "About" tab - featured image plus the store's description and contact
/// details, all straight off the store record.
class WhoAmITab extends StatelessWidget {
  final StoreModel store;

  const WhoAmITab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: width(16),
        vertical: height(16),
      ),
      children: [
        if ((store.featuredImage ?? '').isNotEmpty)
          Builder(
            builder: (context) {
              final url = ApiService.resolveUrl(store.featuredImage)!;
              final tag = 'store-featured-${store.id}';
              return GestureDetector(
                // Same full-screen zoom as everywhere else in the app - the
                // storefront photo is the one image a shopper wants to look
                // at properly before following or buying.
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ImageViewerPage(imageUrl: url, heroTag: tag),
                  ),
                ),
                child: Hero(
                  tag: tag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      height: height(170),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: const Color(0xFFEAEAF2)),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFFEAEAF2),
                        child: const Icon(Icons.storefront, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        SizedBox(height: height(16)),
        Text(store.description, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: height(20)),
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: LK.storeAddress.tr(),
          value: store.address,
        ),
        _InfoRow(
          icon: Icons.schedule,
          label: LK.storeWorkingHours.tr(),
          value: '${store.workingHoursStart} - ${store.workingHoursEnd}',
        ),
        _InfoRow(
          icon: Icons.phone_outlined,
          label: LK.storePhone.tr(),
          value: store.storePhoneNumber,
        ),
        _InfoRow(
          icon: Icons.email_outlined,
          label: LK.storeEmail.tr(),
          value: store.storeEmail,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: height(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: width(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                ),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
