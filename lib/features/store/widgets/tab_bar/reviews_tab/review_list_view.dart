import 'package:fashion_store/features/store/widgets/tab_bar/reviews_tab/reviews_card.dart';
import 'package:flutter/material.dart';

import '../../../../../models/store/store_review_model.dart';

class ReviewListView extends StatelessWidget {
  final List<Review> reviews;
  const ReviewListView({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, // ✅ أهم سطر
        // physics: const NeverScrollableScrollPhysics(), // ✅ حتى ما تتعارض مع التمرير الأساسي
      itemCount: reviews.length,
        itemBuilder: (context,index){
      return ReviewsCard(review: reviews[index],);
    });
  }
}
