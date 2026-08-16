import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';


class ContentProductScrollable extends StatefulWidget {
  final String title;
  final double heightScroll;
  const ContentProductScrollable({super.key, required this.title, required this.heightScroll});

  @override
  State<ContentProductScrollable> createState() => _ContentProductScrollableState();
}

class _ContentProductScrollableState extends State<ContentProductScrollable> {
  double _scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
         double containerHeight = widget.heightScroll;
         double greenLineMaxHeight = containerHeight;
        return SizedBox(
          height: containerHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.maxScrollExtent > 0) {
                      setState(() {
                        _scrollPercent =
                            scrollNotification.metrics.pixels /
                                scrollNotification.metrics.maxScrollExtent;
                      });
                    }
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:  EdgeInsets.only(right: width(12)),
                      child: Text(
                        widget.title ,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          height: height(2.5),
                          color: Color(0xff666A7A),
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 0,
                top: 8,
                child: Container(
                  width: 3,
                  height: greenLineMaxHeight * _scrollPercent.clamp(0.2, 1.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
