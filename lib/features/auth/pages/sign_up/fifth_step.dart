// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:min_bayty/common/button.dart';
// import 'package:min_bayty/common/nav_bar/user_nav_bar/user_nav_bar_screen.dart';
// import 'package:min_bayty/core/bloc/app_state_state.dart';
// import 'package:min_bayty/core/bloc/bloc_state_data_builder.dart';
// import 'package:min_bayty/core/const/screen_util.dart';
// import 'package:min_bayty/features/user/auth/data/models/auth_model.dart';
// import 'package:min_bayty/features/user/auth/data/models/choose_product_kind_model.dart';
// import 'package:min_bayty/features/user/auth/domain/use_cases/user_auth_use_case.dart';
// import 'package:min_bayty/features/user/auth/presentation/manager/auth_user_bloc.dart';
// import '../../../../../../common/shimmer/choose_product_kind/choose_product_kind_shimmer.dart';
// import '../../../../../../core/di/injection.dart';
// import '../../widgets/choose_account/choose_account_contructor_params.dart';
// import '../../widgets/choose_account/choose_account_widget.dart';
// import '../../widgets/product_icons.dart';
//
// class FifthStep extends StatefulWidget {
//   final ChooseAccountConstructorParams? chooseAccountConstructorParams;
//
//   const FifthStep({super.key, this.chooseAccountConstructorParams});
//
//   @override
//   State<FifthStep> createState() => _FifthStepState();
// }
//
// class _FifthStepState extends State<FifthStep> {
//   late AuthUserBloc authUserBloc;
//
//   @override
//   void initState() {
//     super.initState();
//     authUserBloc = getIt<AuthUserBloc>();
//     authUserBloc.add(GetAllProductKindEvent()); // جلب البيانات من البداية
//   }
//
//   int? selectedIndex;
//   String? selectedValue;
//
//   @override
//   Widget build(BuildContext context) {
//     final maxGridHeight = MediaQuery.of(context).size.height * 0.60;
//
//     return BlocProvider.value(
//       value: authUserBloc,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             SizedBox(height: height(10)),
//             Center(
//               child: Text(
//                 "اي منتج تفضل؟",
//                 style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             SizedBox(height: height(10)),
//
//             // عرض الأصناف
//             BlocSelector<
//               AuthUserBloc,
//               AuthUserState,
//               BlocStateData<GetAllProductKindModel>
//             >(
//               selector: (state) => state.getAllProductKindState,
//               builder: (context, state) {
//                 return BlocStateDataBuilder(
//                   data: state,
//                   onFailed: Text(
//                     state.message ??
//                         "يرجى التحقق من اتصالك بالشبكة وفي حال التأكد من جودة الانترنت حاول لاحقا",
//                   ),
//                   onLoading: ChooseProductKindShimmer(),
//                   onSuccess: (data) {
//                     if (data!.category == null || data.category!.isEmpty) {
//                       return const Center(child: Text("لا يوجد عناصر"));
//                     }
//                     return ConstrainedBox(
//                       constraints: BoxConstraints(maxHeight: maxGridHeight),
//                       child: GridView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: data!.category!.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 16,
//                               crossAxisSpacing: 16,
//                               childAspectRatio: 1,
//                             ),
//                         itemBuilder: (context, index) {
//                           final kind = data.category![index];
//                           final iconPath =
//                               ProductIcons.iconsMap[kind.name] ??
//                               ProductIcons.svgBurger; // fallback
//
//                           return AccountKindItem(
//                             title: kind.name ?? "لايوجد اسم",
//                             icon: iconPath, // هون صارت asset مش url
//                             isSelected: selectedIndex == index,
//                             onTap: () {
//                               setState(() {
//                                 selectedIndex = index;
//                                 selectedValue = kind.id;
//                               });
//                             },
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//
//             const SizedBox(height: 10),
//
//             // اللودينغ عند الضغط على إنشاء الحساب فقط
//             BlocBuilder<AuthUserBloc, AuthUserState>(
//               builder: (context, state) {
//                 return state.signUpState.isLoading
//                     ? LinearProgressIndicator(
//                       minHeight: 2.5,
//                       backgroundColor: Theme.of(
//                         context,
//                       ).colorScheme.surfaceTint.withOpacity(0.2),
//                     )
//                     : const SizedBox();
//               },
//             ),
//
//             const SizedBox(height: 10),
//
//             // زر إنشاء الحساب
//             if (selectedIndex != null)
//               BlocSelector<
//                 AuthUserBloc,
//                 AuthUserState,
//                 BlocStateData<AuthModel>
//               >(
//                 selector: (state) => state.signUpState,
//                 builder: (context, state) {
//                   return AuthButton(
//                     text: 'انشاء حساب',
//                     onTap: () async {
//                       authUserBloc.add(
//                         AuthUserSignUpEvent(
//                           params: UserSignUpParams(
//                             firstName:
//                                 widget
//                                     .chooseAccountConstructorParams
//                                     ?.firstName ??
//                                 "",
//                             lastName:
//                                 widget
//                                     .chooseAccountConstructorParams
//                                     ?.lastName ??
//                                 "",
//                             email:
//                                 widget.chooseAccountConstructorParams?.email ??
//                                 "",
//                             password:
//                                 widget
//                                     .chooseAccountConstructorParams
//                                     ?.password ??
//                                 "",
//                             gender:
//                                 widget.chooseAccountConstructorParams?.gender ??
//                                 "",
//                             birthDate:
//                                 widget
//                                     .chooseAccountConstructorParams
//                                     ?.birthDate ??
//                                 "",
//                             confirmPassword:
//                                 widget
//                                     .chooseAccountConstructorParams
//                                     ?.confirmPassword ??
//                                 "",
//                           //  favProduct: selectedValue ?? "",
//                             userType:
//                                 widget
//                                     .chooseAccountConstructorParams
//                                     ?.userType ??
//                                 "",
//                             fcmToken:
//                                 await FirebaseMessaging.instance.getToken() ??
//                                 "",
//                           ),
//                           onSuccess: () {
//                             context.goNamed(UserNavBar.name);
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
