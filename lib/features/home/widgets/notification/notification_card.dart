import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/screen_util.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(10)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width(50),
                height: height(50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: SvgPicture.asset(
                  "assets/svg/notifications.svg",
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                ),
              ),
              SizedBox(width: width(10)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      SizedBox(
                        width: width(220),
                        child: Text(
                          "عنوان",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          "منذ 12 دقيقة",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height(6)),
                  SizedBox(
                    width: width(280),
                    child: Text(
                      "وصف",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: height(5)),
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 1),
        ],
      ),
    );
  }
}
