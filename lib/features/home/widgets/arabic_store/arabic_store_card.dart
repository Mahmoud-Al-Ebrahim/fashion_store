import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:fashion_store/features/home/widgets/arabic_store/photo_arabic_store.dart';
import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';
import '../../../store/pages/store_screen.dart';
import '../../pages/arabic_store_by_id_page.dart';
import 'flag_and_name_arabic_store.dart';

class ArabicStoreCard extends StatelessWidget {
  final Store arabicStore;

  const ArabicStoreCard({super.key, required this.arabicStore});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          context.pushPage(StoreScreen(storeId: arabicStore.id!));
        },
        child: SizedBox(
          height: height(120),
          width: width(118),
          child: Column(
            spacing: height(10),
            children: [
              PhotoArabicStore(
                imageUrl: arabicStore.logoUrl ?? '',
              ),

              FlagAndNameArabicStore(arabicStore: arabicStore),
            ],
          ),
        ),
      ),
    );
    Placeholder();
  }
}
