// ---------------- WhoAmITab ----------------
import 'package:fashion_store/models/dummy/store_fake.dart';
import 'package:flutter/material.dart';
import '../../../../../core/screen_util.dart';
import '../../store_top_side/image_top_side.dart';

import 'column_layer/column_layer.dart';

class WhoAmITab extends StatefulWidget {
  // final StoreBloc storeBloc;
  final String storeId;

  const WhoAmITab({
    super.key,
    // required this.storeBloc,
    required this.storeId,
  });

  @override
  State<WhoAmITab> createState() => _WhoAmITabState();
}

class _WhoAmITabState extends State<WhoAmITab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // widget.storeBloc.add(StoreWhoAmIEvent(storeId: widget.storeId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return BlocSelector<
    //   StoreBloc,
    //   StoreState,
    //   BlocStateData<StoreWhoAmIModel>
    // >(
    //   selector: (state) => state.storeWhoAmIState,
    //   builder: (context, state) {
    //     return BlocStateDataBuilder(
    //       data: state,
    //       onFailed: WhoAmIShimmer(),
    //       onLoading: WhoAmIShimmer(),
    //       onSuccess: (state) {
            return RefreshIndicator(
              onRefresh: () async {
                // widget.storeBloc.add(StoreWhoAmIEvent(storeId: widget.storeId));
              },
              child: Stack(
                children: [
                   ColumnLayerWhoAmI( storeWhoAmIModel: fakeStoreInfo,),
                  Positioned(
                    top: height(20),
                    left: 0,
                    right: 0,
                    child: Center(child: ImageTopSide(heightWidth: 82, imageUrl: fakeStoreInfo.logoUrl??"",)),
                  ),
                  // Positioned(
                  //   bottom: 30,
                  //   left: 20,
                  //     child:
                  //         AuthServiceLocator.instance.token != null &&
                  //         AuthServiceLocator.instance.token!.isNotEmpty
                  //         ? BlocSelector<
                  //         StoreBloc,
                  //         StoreState,
                  //         BlocStateData<StoreUpperModel>
                  //     >(
                  //       selector: (state) => state.storeUpperState,
                  //       builder: (context, storeState) {
                  //         return storeState.data == null
                  //             ? SizedBox.shrink()
                  //             : BlocConsumer<ChatBloc, ChatState>(
                  //           buildWhen:
                  //               (p, c) =>
                  //           p.createConversation !=
                  //               c.createConversation,
                  //           listenWhen:
                  //               (p, c) =>
                  //           p.createConversation !=
                  //               c.createConversation,
                  //           listener: (context, state) {
                  //             if (state.createConversation.isSuccess) {
                  //               String userName =
                  //                   '${state.createConversation.data!.participants![0].firstName ?? ''} ${state.createConversation.data!.participants![0].lastName ?? ''}';
                  //
                  //               String? picture =
                  //                   state
                  //                       .createConversation
                  //                       .data!
                  //                       .participants![0]
                  //                       .storeLogo ??
                  //                       state
                  //                           .createConversation
                  //                           .data!
                  //                           .participants![0]
                  //                           .profilePicture;
                  //               Navigator.of(context).push(
                  //                 MaterialPageRoute(
                  //                   builder:
                  //                       (_) => ChatPage(
                  //                     picture: picture,
                  //                     receiverName:
                  //                     state
                  //                         .createConversation
                  //                         .data!
                  //                         .participants![0]
                  //                         .storeName ??
                  //                         userName,
                  //                     conversationId:
                  //                     state
                  //                         .createConversation
                  //                         .data!
                  //                         .id!,
                  //                     receiverId:
                  //                     storeState.data!.userId!,
                  //                   ),
                  //                 ),
                  //               );
                  //             }
                  //           },
                  //           builder: (context, state) {
                  //             return state.createConversation.isLoading
                  //                 ? MinBaytyLoader()
                  //                 : FloatingActionButton(
                  //               shape: CircleBorder(),
                  //               onPressed: () {
                  //                 String? storeUserId =
                  //                     storeState.data?.userId;
                  //
                  //                 if (storeUserId == null) return;
                  //
                  //                 int index  = state
                  //                     .getConversations
                  //                     .items
                  //                     .indexWhere(
                  //                       (item) =>
                  //                   item.participants![0].id ==
                  //                       storeUserId,
                  //                 );
                  //                 if (index == -1) {
                  //                   BlocProvider.of<ChatBloc>(context).add(
                  //                     CreateConversationEvent(
                  //                       recipientId: storeUserId,
                  //                     ),
                  //                   );
                  //                   return;
                  //                 }
                  //                 Conversation conversation = state
                  //                     .getConversations
                  //                     .items[index];
                  //                 String userName =
                  //                     '${conversation.participants![0].firstName ?? ''} ${conversation.participants![0].lastName ?? ''}';
                  //                 String? picture =
                  //                     conversation
                  //                         .participants![0]
                  //                         .storeLogo ??
                  //                         conversation
                  //                             .participants![0]
                  //                             .profilePicture;
                  //                 Navigator.of(context).push(
                  //                   MaterialPageRoute(
                  //                     builder:
                  //                         (_) => ChatPage(
                  //                       picture: picture,
                  //                       receiverName:
                  //                       conversation
                  //                           .participants![0]
                  //                           .storeName ??
                  //                           userName,
                  //                       conversationId:
                  //                       conversation.id!,
                  //                       receiverId: storeUserId,
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //               child: Center(
                  //                 child: Icon(Icons.chat_outlined),
                  //               ),
                  //             );
                  //           },
                  //         );
                  //       },
                  //     )
                  //         : SizedBox()
                  // ),
                ],
              ),
            );
  }
}
