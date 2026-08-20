import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/widgets/text_field.dart';
import '../../../../core/localization/translation_keys.dart';
import '../../../../core/screen_util.dart';

/// Search field + filter button. Search fires on submit/change (debounced by
/// the caller); the filter button opens the product filter sheet.
class SearchFilterSection extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;
  final bool showFilter;

  const SearchFilterSection({
    super.key,
    required this.onSearchChanged,
    required this.onFilterTap,
    this.showFilter = true,
  });

  @override
  State<SearchFilterSection> createState() => _SearchFilterSectionState();
}

class _SearchFilterSectionState extends State<SearchFilterSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AuthTextField(
            onChanged: widget.onSearchChanged,
            onFieldSubmitted: widget.onSearchChanged,
            isHomePage: true,
            controller: _controller,
            hintText: LK.exploreSearchHint.tr(),
            validator: (value) => null,
          ),
        ),
        if (widget.showFilter) ...[
          SizedBox(width: width(10)),
          GestureDetector(
            onTap: widget.onFilterTap,
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              height: height(42),
              width: width(42),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset("assets/svg/filter.svg"),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
