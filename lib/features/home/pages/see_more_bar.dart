import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/screen_util.dart';
import '../widgets/see_more_tabs_sections/detail_tabs_name.dart';
import '../widgets/see_more_tabs_sections/search_filter_section.dart';
import '../widgets/see_more_tabs_sections/tabs/store_tab/store_tab.dart';
import '../widgets/see_more_tabs_sections/tabs/product_tab/product_tab.dart';


class SeeMoreBar extends StatefulWidget {
  // final HomeAndProductBloc homeAndProductBloc;

  const SeeMoreBar({super.key,});

  @override
  State<SeeMoreBar> createState() => _SeeMoreBarState();
}

class _SeeMoreBarState extends State<SeeMoreBar> {
  // late AuthUserBloc authUserBloc;

  late final List<Widget> _tabs;
  final ValueNotifier<int> currentTab = ValueNotifier(0);

  @override
  void initState() {
    // authUserBloc = getIt<AuthUserBloc>();

    _tabs = [
      ProductsTab(
        // authUserBloc: authUserBloc,
        // homeAndProductBloc: widget.homeAndProductBloc,
      ),
      // CountryTab(homeAndProductBloc: widget.homeAndProductBloc),
      StoreTab(
        // homeAndProductBloc: widget.homeAndProductBloc,
        // authUserBloc: authUserBloc,
      ),
    ];

    super.initState();
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
              // homeAndProductBloc: widget.homeAndProductBloc,
            ),
            SeeMoreTabBarsName(onTap: (index){
              currentTab.value = index;
            },),
            SizedBox(height: height(10)),
            Expanded(
              child: TabBarView(
                children: _tabs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
