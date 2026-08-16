import 'package:fashion_store/models/posts_response_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/screen_util.dart';

class FlagAndNameArabicStore extends StatelessWidget {
  final Store arabicStore;
  const FlagAndNameArabicStore({super.key, required this.arabicStore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(8)),
      child: Row(
        children: [
          Hero(
            tag: 'store_${arabicStore.id}',

            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: width(20),
                height: width(20),
                child:
                Image.network(
                  arabicStore.logoUrl!,
                  fit: BoxFit.cover, // يضمن تغطية كامل الدائرة
                ),
              ),
            ),
          ),
          SizedBox(width:22,),
          Expanded(
            child: Text(
             arabicStore.name??"___",
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // مهم جداً
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
