import 'package:fashion_store/core/extensions/build_context.dart';
import 'package:flutter/material.dart';

import '../../../../core/screen_util.dart';
import '../../../../splash_screen.dart';
import '../../pages/drawer_pages/who_i_following_screen.dart';
import 'drawer_card.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    // required this.storeBloc,
    // required this.storeHomeBloc,
  });

  // final StoreBloc storeBloc;
  // final StoreHomeBloc storeHomeBloc;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.only(right: width(20)),
        child: Column(
          children: [
            SizedBox(height: height(100)),
            DrawerCard(
              showArrow: false,
              icon: "assets/svg/user.svg",
              title: "User Name",
              // "${AuthServiceLocator.instance.lastName ?? "______"} ${AuthServiceLocator.instance.firstName ?? ""} " ??
              // "___",
              onTap: () {},
            ),
            Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.onPrimary,
              endIndent: width(40),
            ),
            SizedBox(height: height(50)),
            DrawerCard(
              icon: "assets/svg/save.svg",
              title: "المحفوظات",
              onTap: () {
                // if (AuthServiceLocator.instance.token == null ||
                //     AuthServiceLocator.instance.token!.isEmpty) {
                //   showFlushBar(context, "يرجى تسجيل الدخول لتتمكن من الحفظ   ");
                //   return;
                // } else {
                //   context.pushNamed(FavouriteScreen.name, extra: storeBloc);
                // }
              },
            ),
            SizedBox(height: height(4)),
            DrawerCard(
              icon: "assets/svg/who_i_follow.svg",
              title: "من أتابع",
              onTap: () {
                context.pushPage(WhoIFollowingScreen());
                // if (AuthServiceLocator.instance.token == null ||
                //     AuthServiceLocator.instance.token!.isEmpty) {
                //   showFlushBar(
                //     context,
                //     "يرجى تسجيل الدخول لتتمكن من المتابعة  ",
                //   );
                //   return;
                // } else {
                //   context.pushNamed(.name);
                // }
              },
            ),
            // SizedBox(height: height(4)),
            // DrawerCard(
            //   icon: Assets.sendMessageSvg,
            //   title: "الدردشات",
            //   onTap: () {
            //     if (AuthServiceLocator.instance.token == null ||
            //         AuthServiceLocator.instance.token!.isEmpty) {
            //       showFlushBar(
            //         context,
            //         "يرجى تسجيل الدخول لتتمكن من المتابعة  ",
            //       );
            //       return;
            //     } else {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (_) => MyChatsPage()),
            //       );
            //     }
            //   },
            // ),
            SizedBox(height: height(4)),
            // if (AuthServiceLocator.instance.role != TypeUser.user) ...{
            //   DrawerCard(
            //     icon: "assets/svg/flag.svg",
            //     title: "مواقع التوصيل",
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => BlocProvider.value(
            //             value: storeHomeBloc,
            //             child: StorePickupLocationsPage(
            //               storeHomeBloc: storeHomeBloc,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            //   SizedBox(height: height(4)),
            //},
            DrawerCard(
              icon: "assets/svg/calling.svg",
              title: "مركز المساعدة",
              onTap: () {},
            ),
            SizedBox(height: height(4)),
            DrawerCard(
              icon: "assets/svg/lock.svg",
              title: "شروط الخصوصية",
              onTap: () {},
            ),
            SizedBox(
              height: height(
                // AuthServiceLocator.instance.role != TypeUser.user ? 100 : 200
                200,
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.onPrimary,
              endIndent: width(40),
            ),
            // AuthServiceLocator.instance.token == null ||
            //         AuthServiceLocator.instance.token!.isEmpty
            //     ? DrawerCard(
            //         icon: Assets.svgLogOut,
            //         title: "تسجيل الدخول",
            //         onTap: () {
            //           context.pushNamed(OnBoardingScreen.name);
            //         },
            //       )
            //     :
            DrawerCard(
              icon: "assets/svg/log_out.svg",
              title: "تسجيل الخروج",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      "تأكيد تسجيل الخروج",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    content: Text(
                      "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        // إغلاق الديالوج
                        child: const Text(
                          "لا",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          // await AuthServiceLocator.instance.logout();
                          // await AuthServiceLocator.instance.saveAuth(
                          //   null,
                          //   TypeUser.user,
                          // );

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => SplashScreen()),
                            (_) => false,
                          );
                          // إغلاق الديالوج
                          // 🔥 تابع تنفيذ تسجيل الخروج هون
                          // مثلا:
                          // context.read<AuthBloc>().add(LogoutEvent());
                        },
                        child: Text(
                          "نعم",
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
