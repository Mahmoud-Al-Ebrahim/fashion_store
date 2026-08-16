import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:fashion_store/features/nav_bar/user_nav_bar/user_nav_bar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/screen_util.dart';
import '../../community/pages/community_page.dart';
import '../../home/pages/home_page_screen.dart';
import '../../home/pages/notification_page.dart';
import '../../home/pages/see_more_bar.dart';
import '../../home/widgets/drawer/drawer.dart';


class UserNavBar extends StatefulWidget {
  static String name = "UserNavBar";
  static String path = "/UserNavBar";

  const UserNavBar({super.key});

  @override
  State<UserNavBar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<UserNavBar> {
  // late HomeAndProductBloc homeAndProductBloc;
  // late StoreHomeBloc storeHomeBloc;
  // late StoreBloc storeBloc;
  // late CommunityBloc communityBloc;
  // late OrderBloc orderBloc;

  @override
  void initState() {
    // homeAndProductBloc = getIt<HomeAndProductBloc>();
    // storeHomeBloc = getIt<StoreHomeBloc>();
    // storeBloc = getIt<StoreBloc>();
    // communityBloc = getIt<CommunityBloc>();
    // orderBloc = getIt<OrderBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavBarBloc()),
        // BlocProvider.value(value: homeAndProductBloc),
        // BlocProvider.value(value: storeHomeBloc),
        // BlocProvider.value(value: storeHomeBloc),
        // BlocProvider.value(value: storeBloc),
        // BlocProvider.value(value: communityBloc),
        // BlocProvider.value(value: orderBloc),
      ],
      child: BlocBuilder<NavBarBloc, NavBarState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final colorSelected = theme.colorScheme.primary;
          final colorUnselected = Colors.grey;

          final isUser = true ; //AuthServiceLocator.instance.role == TypeUser.user;

          final List<_NavItemData> items = [
            _NavItemData("assets/svg/home.svg", "الرئيسية"),
            _NavItemData("assets/svg/community.svg", "المجتمع "),
            _NavItemData(
              isUser ? "assets/svg/Search.svg" : "assets/svg/home.svg",
              isUser ? "التصنيفات" : "الطلبات",
            ),
            _NavItemData(
              isUser ? "assets/svg/bag.svg" : "assets/svg/home.svg",
              isUser ? "طلباتي" : "ملفي",
            ),
          ];
          /// هنا بدل النصوص بصفحاتك
          final List<Widget> screens =
              isUser
                  ? [
                    HomePageScreen(),
                    // للمجتمع
                    CommunityPage(),
                    SeeMoreBar(),
                Container(),
                    // MyOrdersPage(orderBloc: orderBloc), // لطلباتي
                  ]
                  : [
                    // StoreHomePage(
                    //   storeHomeBloc: storeHomeBloc,
                    //   storeBloc: storeBloc,
                    // ),
                    // CommunityPage(communityBloc: communityBloc),
                    // MyOrdersPage(orderBloc: orderBloc),
                    // StoreScreen(
                    //   storeId: AuthServiceLocator.instance.storeId!,
                    // ),
                  ];

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            drawer: CustomDrawer(
            ),
            appBar:
                (state.currentIndex == 3 && !isUser)
                    ? null
                    : AppBar(
                      scrolledUnderElevation: 0,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: true,
                      title: GestureDetector(
                        onTap: () async {
                          // await showDialog(
                          //   context: context,
                          //   builder: (_) => const ChooseOptionDialog(),
                          // );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "المتاجر",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            // Icon(
                            //   Icons.arrow_drop_down,
                            //   size: 20,
                            //   color: Theme.of(context).colorScheme.primary,
                            // ),
                          ],
                        ),
                      ),
                      leading: Builder(
                        builder:
                            (context) => IconButton(
                              onPressed: () {
                                Scaffold.of(
                                  context,
                                ).openDrawer(); // يفتح الـ Drawer
                              },
                              icon: SvgPicture.asset(
                                "assets/svg/drawer.svg",
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              // if (AuthServiceLocator.instance.token == null ||
                              //     AuthServiceLocator.instance.token!.isEmpty) {
                              //   showFlushBar(
                              //     context,
                              //     "يرجى تسجيل الدخول لتتمكن من  رؤية الاشعارات ",
                              //   );
                              // } else {
                              //   context.pushNamed(NotificationPage.name);
                              // }
                              context.pushPage(NotificationPage());
                            },
                            child: SvgPicture.asset(
                              "assets/svg/notifications.svg",
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
            body: IndexedStack(index: state.currentIndex, children: screens),
            bottomNavigationBar: Container(
              color: theme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: height(0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == state.currentIndex;

                  return GestureDetector(
                    onTap: () {
                      context.read<NavBarBloc>().add(
                        ChangeNavBar(index: index),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<NavBarBloc>().add(
                              ChangeNavBar(index: index),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 45,
                            height: 2,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? colorSelected
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: height(6)),
                        GestureDetector(
                          onTap: () {
                            context.read<NavBarBloc>().add(
                              ChangeNavBar(index: index),
                            );
                          },
                          child: SvgPicture.asset(
                            item.svgPath,
                            width: width(24),
                            height: height(24),
                            colorFilter: ColorFilter.mode(
                              isSelected ? colorSelected : colorUnselected,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(height: height(6)),
                        GestureDetector(
                          onTap: () {
                            context.read<NavBarBloc>().add(
                              ChangeNavBar(index: index),
                            );
                          },
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontFamily: 'El Messiri',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected ? colorSelected : colorUnselected,
                            ),
                          ),
                        ),
                        SizedBox(height: height(4)),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItemData {
  final String svgPath;
  final String label;

  _NavItemData(this.svgPath, this.label);
}
