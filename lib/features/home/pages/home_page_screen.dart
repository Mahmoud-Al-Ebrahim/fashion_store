import 'dart:ui';
import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/screen_util.dart';
import '../../nav_bar/user_nav_bar/user_nav_bar_bloc.dart';
import '../widgets/ad/ad_.dart';
import '../widgets/arabic_store/arabic_store_list_view.dart';
import '../widgets/product_card/store_card_list_view.dart';
import '../widgets/store_card/store_list_view.dart';
import '../widgets/title_and_see_more.dart';

class HomePageScreen extends StatefulWidget {
  static String name = "home-screen";
  static String path = "/home-screen";

  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
    // widget.homeAndProductBloc.add(HomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // widget.homeAndProductBloc.add(HomeEvent());
        },
        child: Padding(
          padding: EdgeInsets.only(
            right: width(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: height(22),
              children: [
                // 1️⃣ Ad - من اليمين لليسار
                Ad()
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                // 2️⃣ عنوان + المزيد - من اليسار لليمين
                TitleAndSeeMore(
                      onSeeMore: () {
                        context.read<NavBarBloc>().add(ChangeNavBar(index: 2));
                      },
                      title: "الصيحات الموصى بها",
                    )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(-1, 0), duration: 500.ms),

                // 3️⃣ المأكولات الموصى بها - من اليمين لليسار
                ProductCardListView(
                      favouriteProducts: fakeProducts.products ?? [],
                      isHomePage: true,
                    )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                // 4️⃣ مطابخ عربية - من اليسار لليمين
                TitleAndSeeMore(
                      onSeeMore: () {
                        context.read<NavBarBloc>().add(ChangeNavBar(index: 2));
                      },
                      title:
                          // AuthServiceLocator.instance.role ==
                          //     TypeUser.restaurant
                          //     ? " مطابخ عربية"
                          //     :
                          "متاجر عالمية",
                    )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(-1, 0), duration: 500.ms),

                ArabicStoreListView()
                    .animate(delay: 800.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                // 5️⃣ المطاعم الموصى بها - من اليسار لليمين
                TitleAndSeeMore(
                      onSeeMore: () {
                        context.read<NavBarBloc>().add(ChangeNavBar(index: 2));
                      },
                      title: " متاجر موصى بها",
                    )
                    .animate(delay: 1000.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(-1, 0), duration: 500.ms),

                StoreListView()
                    .animate(delay: 1200.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                // 6️⃣ الأرخص سعراً - من اليسار لليمين
                TitleAndSeeMore(
                      onSeeMore: () {
                        context.read<NavBarBloc>().add(ChangeNavBar(index: 2));
                      },
                      title: "الأرخص سعرا ",
                    )
                    .animate(delay: 1400.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(-1, 0), duration: 500.ms),

                ProductCardListView(
                      favouriteProducts: fakeProducts.products ?? [],
                      isHomePage: true,
                    )
                    .animate(delay: 1600.ms)
                    .fadeIn(duration: 400.ms)
                    .slide(begin: const Offset(1, 0), duration: 500.ms),

                SizedBox(height: height(25)),

                // (state.nearbyStores ?? []).isNotEmpty
                if (true) ...[
                  TitleAndSeeMore(
                        onSeeMore: () {
                          context.read<NavBarBloc>().add(
                            ChangeNavBar(index: 2),
                          );
                        },
                        title: "المتاجر الاقرب اليك",
                      )
                      .animate(delay: 1800.ms)
                      .fadeIn(duration: 400.ms)
                      .slide(begin: const Offset(-1, 0), duration: 500.ms),
                  StoreListView()
                      .animate(delay: 2000.ms)
                      .fadeIn(duration: 400.ms)
                      .slide(begin: const Offset(1, 0), duration: 500.ms),
                  const SizedBox(height: 20),
                ],
              ],
            ),

            // BlocSelector<
            //   HomeAndProductBloc,
            //   HomeAndProductState,
            //   BlocStateData<HomeModel>
            // >(
            //   selector: (state) => state.homeState,
            //   builder: (context, state) {
            //     return BlocStateDataBuilder(
            //       onLoading: HomePageShimmer(),
            //       data: state,
            //       onFailed: NoData(
            //         heightt: height(750),
            //         isInternet: true,
            //         text: "يبدو انك فقدت الاتصال بالانترنت يرجى المحاولة لاحقا",
            //       ),
            //       onSuccess: (state) {
            //         return Column(
            //           spacing: height(22),
            //           children: [
            //             // 1️⃣ Ad - من اليمين لليسار
            //             Ad()
            //                 .animate()
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(begin: const Offset(1, 0), duration: 500.ms),
            //
            //             // 2️⃣ عنوان + المزيد - من اليسار لليمين
            //             TitleAndSeeMore(
            //                   onSeeMore: () {
            //                     context.read<NavBarBloc>().add(
            //                       ChangeNavBar(index: 2),
            //                     );
            //                   },
            //                   title:
            //                       AuthServiceLocator.instance.role ==
            //                               TypeUser.restaurant
            //                           ? "المأكولات الموصى بها"
            //                           : "المنتجات الموصى بها",
            //                 )
            //                 .animate(delay: 200.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(
            //                   begin: const Offset(-1, 0),
            //                   duration: 500.ms,
            //                 ),
            //
            //             // 3️⃣ المأكولات الموصى بها - من اليمين لليسار
            //             ProductCardListView(
            //                   favouriteProducts: state?.favoriteProducts ?? [],
            //                   isHomePage: true,
            //                 )
            //                 .animate(delay: 400.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(begin: const Offset(1, 0), duration: 500.ms),
            //
            //             // 4️⃣ مطابخ عربية - من اليسار لليمين
            //             TitleAndSeeMore(
            //                   onSeeMore: () {
            //                     context.read<NavBarBloc>().add(
            //                       ChangeNavBar(index: 2),
            //                     );
            //                   },
            //                   title:
            //                       AuthServiceLocator.instance.role ==
            //                               TypeUser.restaurant
            //                           ? " مطابخ عربية"
            //                           : "متاجر عربية",
            //                 )
            //                 .animate(delay: 600.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(
            //                   begin: const Offset(-1, 0),
            //                   duration: 500.ms,
            //                 ),
            //
            //             ArabicStoreListView(
            //                   arabicStores: state!.arabicStores ?? [],
            //                 )
            //                 .animate(delay: 800.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(begin: const Offset(1, 0), duration: 500.ms),
            //
            //             // 5️⃣ المطاعم الموصى بها - من اليسار لليمين
            //             TitleAndSeeMore(
            //                   onSeeMore: () {
            //                     context.read<NavBarBloc>().add(
            //                       ChangeNavBar(index: 2),
            //                     );
            //                   },
            //                   title:
            //                       AuthServiceLocator.instance.role ==
            //                               TypeUser.restaurant
            //                           ? " مطاعم موصى بها"
            //                           : " متاجر موصى بها",
            //                 )
            //                 .animate(delay: 1000.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(
            //                   begin: const Offset(-1, 0),
            //                   duration: 500.ms,
            //                 ),
            //
            //             StoreListView(
            //                   recommendedStores:
            //                       state.recommendedStores ?? [],
            //                 )
            //                 .animate(delay: 1200.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(begin: const Offset(1, 0), duration: 500.ms),
            //
            //             // 6️⃣ الأرخص سعراً - من اليسار لليمين
            //             TitleAndSeeMore(
            //                   onSeeMore: () {
            //                     context.read<NavBarBloc>().add(
            //                       ChangeNavBar(index: 2),
            //                     );
            //                   },
            //                   title: "الأرخص سعرا ",
            //                 )
            //                 .animate(delay: 1400.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(
            //                   begin: const Offset(-1, 0),
            //                   duration: 500.ms,
            //                 ),
            //
            //             ProductCardListView(
            //                   favouriteProducts: state.cheap ?? [],
            //                   isHomePage: true,
            //                 )
            //                 .animate(delay: 1600.ms)
            //                 .fadeIn(duration: 400.ms)
            //                 .slide(begin: const Offset(1, 0), duration: 500.ms),
            //
            //             SizedBox(height: height(25)),
            //
            //             if ((state.nearbyStores ?? []).isNotEmpty) ...[
            //               TitleAndSeeMore(
            //                     onSeeMore: () {
            //                       context.read<NavBarBloc>().add(
            //                         ChangeNavBar(index: 2),
            //                       );
            //                     },
            //                     title:
            //                         AuthServiceLocator.instance.role ==
            //                                 TypeUser.restaurant
            //                             ? "مطابخ الاقرب اليك"
            //                             : "متاجر الاقرب اليك",
            //                   )
            //                   .animate(delay: 1800.ms)
            //                   .fadeIn(duration: 400.ms)
            //                   .slide(
            //                     begin: const Offset(-1, 0),
            //                     duration: 500.ms,
            //                   ),
            //               StoreListView(
            //                     recommendedStores:
            //                         state.nearbyStores!,
            //                   )
            //                   .animate(delay: 2000.ms)
            //                   .fadeIn(duration: 400.ms)
            //                   .slide(
            //                     begin: const Offset(1, 0),
            //                     duration: 500.ms,
            //                   ),
            //               const SizedBox(height: 20),
            //             ],
            //           ],
            //         );
            //       },
            //     );
            //   },
            // ),
          ),
        ),
      ),
    );
  }
}
