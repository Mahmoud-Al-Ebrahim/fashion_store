import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/widgets/text_field.dart';
import '../../../../core/screen_util.dart';

// ✅ تغيير من StatelessWidget إلى StatefulWidget
class SearchFilterSection extends StatefulWidget {
  // final HomeAndProductBloc homeAndProductBloc;

  const SearchFilterSection({super.key, });

  @override
  State<SearchFilterSection> createState() => _SearchFilterSectionState();
}

class _SearchFilterSectionState extends State<SearchFilterSection> {
  // ✅ إضافة: Controller يتم إنشاءه مرة واحدة
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

  // ✅ إضافة: دالة منفصلة للبحث
  // void _performSearch(SeeMoreControllerCubit cubit, String value) {
  //   cubit.executeSearch(value);
  //
  //   if (cubit.state.currentTabIndex == 0) {
  //     widget.homeAndProductBloc.add(
  //       SeeMoreProductsEvent(
  //         params: SeeMoreProductsParams(
  //           page: '1',
  //           category: cubit.state.selectedCategory?.id ?? '', // ✅ هون منيح
  //           search: value,
  //         ),
  //       ),
  //     );
  //   } else if (cubit.state.currentTabIndex == 1) {
  //     widget.homeAndProductBloc.add(
  //       SeeMoreCountriesEvent(
  //         params: SeeMoreCountriesParams(search: value),
  //       ),
  //     );
  //   } else {
  //     widget.homeAndProductBloc.add(
  //       SeeMoreStoresEvent(
  //         params: SeeMoreStoreParams(
  //           page: '1',
  //           category: cubit.state.selectedCategory?.id ?? '', // ✅ هون منيح
  //           search: value,
  //         ),
  //       ),
  //     );
  //   }
  // }
  // void _performSearch(SeeMoreControllerCubit cubit, String value) {
  //   cubit.executeSearch(value);
  //
  //   if (cubit.state.currentTabIndex == 0) {
  //     widget.homeAndProductBloc.add(
  //       SeeMoreProductsEvent(
  //         params: SeeMoreProductsParams(
  //           page: '1',
  //           category: cubit.state.selectedCategory?.id ?? '',
  //           search: value,
  //         ),
  //       ),
  //     );
  //   } else if (cubit.state.currentTabIndex == 1) {
  //     widget.homeAndProductBloc.add(
  //       SeeMoreCountriesEvent(
  //         params: SeeMoreCountriesParams(search: value),
  //       ),
  //     );
  //   } else {
  //     widget.homeAndProductBloc.add(
  //       SeeMoreStoresEvent(
  //         params: SeeMoreStoreParams(
  //           page: '1',
  //           category: cubit.state.selectedCategory?.id ?? '',
  //           search: value,
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // ✅ تغيير من BlocBuilder إلى BlocConsumer
    // return BlocConsumer<SeeMoreControllerCubit, SeeMoreControllerState>(
    //   listener: (context, state) {
    //     if (state.searchQuery.isEmpty && _controller.text.isNotEmpty) {
    //       _controller.clear();
    //     }
    //   },
    //   builder: (context, state) {
    //     final cubit = context.read<SeeMoreControllerCubit>();

        // ✅ إزالة: السطر القديم
        // final controller = TextEditingController(text: state.searchQuery);
        // controller.addListener(() { ... });

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width(300),
              child: AuthTextField(
                onChanged: (value) {
                  // _performSearch(cubit, value);
                },


                // onFieldSubmitted: (value) {
                //   if (value.trim().isNotEmpty) {
                //     _performSearch(cubit, value); // ✅ استخدام الدالة الجديدة
                //   }
                // },
                isHomePage: true,
                controller: _controller, // ✅ استخدام _controller بدل controller
                hintText: "ابحث عن أي شي تريده",
                validator: (value) => null,
              ),
            ),
            SizedBox(width: width(10)),
            Container(
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
          ],
        );
  }
}