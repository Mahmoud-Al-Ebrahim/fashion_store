import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/screen_util.dart';
import '../../../../../models/store/store_review_model.dart';
import '../../store_top_side/image_top_side.dart';
import '../../store_top_side/reviews_stars.dart';
class ReviewsCard extends StatelessWidget {
  final Review review;

  const ReviewsCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                ImageTopSide(
                  heightWidth: 50,
                  imageUrl: review.user!.profilePicture ?? "",
                ),
                SizedBox(width: width(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height(5)),
                    Text(
                      review.user!.name ?? "___",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: height(3)),

                    Text(
                     review.timeAgo ?? "___",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: height(30)),
                  child: ReviewsStars(rating: review.score,),
                ),
              ],
            ),
          ),
          SizedBox(height: height(12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width(12)),
            child: Text(
              review.comment ?? "___",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          SizedBox(height: height(12)),
          if(review.image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CachedNetworkImage(
                imageUrl: review.image ?? "", // 🔹 ضع رابط الصورة هون
                width: 1.sw,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(), // 🔹 أثناء التحميل
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error, // 🔹 إذا صار خطأ بالتحميل
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(height: height(10)),
          Divider(thickness: 1.2, color: Colors.grey.shade300),
          SizedBox(height: height(10)),
        ],
      ),
    );
  }
}
