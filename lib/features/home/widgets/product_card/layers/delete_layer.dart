import 'package:flutter/material.dart';
class DeleteLayer extends StatelessWidget {
  final String id;

  const DeleteLayer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return
      // AuthServiceLocator.instance.role != TypeUser.user
      //   ? Positioned(
      //     right: -2,
      //     top: -8,
      //     child: BlocBuilder<StoreBloc, StoreState>(
      //       buildWhen: (p, c) => p.deleteProductState[id] != c.deleteProductState[id],
      //       builder: (context, state) {
      //         return (state.deleteProductState[id]?.isLoading ?? false)
      //             ? MinBaytyLoader()
      //             : GestureDetector(
      //               onTap: () {
      //                 context.read<StoreBloc>().add(
      //                   DeleteProductEvent(params: DeleteProductParams(productId: id)),
      //                 );
      //               },
      //               child: Container(
      //                 height: height(45),
      //                 width: width(45),
      //                 decoration: BoxDecoration(
      //                   shape: BoxShape.circle,
      //                   color: Theme.of(context).colorScheme.onPrimary,
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: Theme.of(
      //                         context,
      //                       ).colorScheme.shadow.withOpacity(0.11),
      //                       blurRadius: 2,
      //                       offset: const Offset(1, 1),
      //                     ),
      //                   ],
      //                 ),
      //                 child: Center(
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(bottom: 0.5),
      //                     child: SvgPicture.asset(
      //                       height: 17,
      //                       width: 17,
      //                       Assets.svgCancel,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             );
      //       },
      //     ),
      //   )
      //   :
    SizedBox.shrink();
  }
}
