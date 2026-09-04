import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:mime_type/mime_type.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/post/post_model.dart';

part 'post_event.dart';

part 'post_state.dart';

/// Field names for one entry of `NewMedias` on `PUT Post/Update/{postId}`.
///
/// `NewMedias` binds to a `List<RequestAddPostMediaDto>`, so every entry
/// needs its own indexed, dotted keys - `NewMedias[0].File`,
/// `NewMedias[0].MediaType`, `NewMedias[0].Duration`. Sending the files as
/// a bare `NewMedias` list (which is what this used to do) bound an *empty*
/// list server-side: the call answered 200, the post's text and visibility
/// were updated, and the new image was silently dropped - which is exactly
/// how "editing a post's image does nothing" presented. `Post/Add` already
/// used this shape for `mediaDtos`, which is why *creating* a post with an
/// image always worked.
String updateMediaFileKey(int index) => 'NewMedias[$index].File';

String updateMediaTypeKey(int index) => 'NewMedias[$index].MediaType';

String updateMediaDurationKey(int index) => 'NewMedias[$index].Duration';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostState()) {
    on<AddPostEvent>(_onAddPostEvent);
    on<DeletePostEvent>(_onDeletePostEvent);
    on<GetAllPostsEvent>(_onGetAllPostsEvent);
    on<GetCommunityFeedEvent>(_onGetCommunityFeedEvent);
    on<UpdatePostEvent>(_onUpdatePostEvent);
    on<TogglePostReactionEvent>(_onTogglePostReactionEvent);
    on<ClearPostEvent>((event, emit) => emit(PostState()));
  }

  FutureOr<void> _onGetCommunityFeedEvent(
    GetCommunityFeedEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(
      state.copyWith(getCommunityFeedStatus: GetCommunityFeedStatus.loading),
    );
    if (event.storeIds.isEmpty) {
      emit(
        state.copyWith(
          getCommunityFeedStatus: GetCommunityFeedStatus.success,
          communityFeed: const [],
        ),
      );
      return;
    }
    try {
      final responses = await Future.wait(
        event.storeIds.map(
          (id) =>
              ApiService.getMethod(endPoint: 'Post/GetAll/$id')
              // One unreachable store shouldn't blank the whole feed.
              .catchError(
                (_) => Response(
                  requestOptions: RequestOptions(path: 'Post/GetAll/$id'),
                  data: {'data': []},
                ),
              ),
        ),
      );
      final merged = <PostModel>[];
      for (final response in responses) {
        try {
          final apiResponse = ApiResponseModel<List<PostModel>>.fromJson(
            response.data,
            (json) => postListFromJson(json),
          );
          merged.addAll(apiResponse.data ?? []);
        } catch (_) {
          // skip malformed store payloads
        }
      }
      merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(
        state.copyWith(
          getCommunityFeedStatus: GetCommunityFeedStatus.success,
          communityFeed: merged,
        ),
      );
    } catch (error) {
      log(error.toString());
      emit(
        state.copyWith(
          getCommunityFeedStatus: GetCommunityFeedStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }
  }

  Future<MultipartFile> _toMultipartFile(File file) async {
    final fileName = file.path.split('/').last;
    final mimeType = mime(fileName) ?? '';
    final parts = mimeType.split('/');
    return MultipartFile.fromFile(
      file.path,
      filename: fileName,
      contentType: parts.length == 2 ? MediaType(parts[0], parts[1]) : null,
    );
  }

  FutureOr<void> _onAddPostEvent(
    AddPostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(postTransactionStatus: PostTransactionStatus.loading));
    final Map<String, dynamic> form = {
      "Content": event.content,
      "Visibility": event.visibility,
    };
    for (var i = 0; i < event.media.length; i++) {
      final media = event.media[i];
      form['mediaDtos[$i].file'] = await _toMultipartFile(media.file);
      form['mediaDtos[$i].mediaType'] = media.mediaType;
      if (media.durationSeconds != null) {
        form['mediaDtos[$i].duration'] = media.durationSeconds;
      }
    }
    await ApiService.postMethod(
          endPoint: 'Post/Add',
          form: FormData.fromMap(form),
        )
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<PostModel>.fromJson(
            response.data,
            (json) => PostModel.fromJson(json),
          );
          if (apiResponse.data != null) {
            add(GetAllPostsEvent(storeId: apiResponse.data!.storeId));
          }
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onDeletePostEvent(
    DeletePostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(postTransactionStatus: PostTransactionStatus.loading));
    await ApiService.deleteMethod(endPoint: 'Post/Delete/${event.postId}')
        .then((response) {
          log(response.data.toString());
          add(GetAllPostsEvent(storeId: event.storeId));
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onGetAllPostsEvent(
    GetAllPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(getAllPostsStatus: GetAllPostsStatus.loading));
    await ApiService.getMethod(endPoint: 'Post/GetAll/${event.storeId}')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<List<PostModel>>.fromJson(
            response.data,
            (json) => postListFromJson(json),
          );
          emit(
            state.copyWith(
              getAllPostsStatus: GetAllPostsStatus.success,
              posts: apiResponse.data ?? [],
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllPostsStatus: GetAllPostsStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getAllPostsStatus: GetAllPostsStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdatePostEvent(
    UpdatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(postTransactionStatus: PostTransactionStatus.loading));
    final Map<String, dynamic> form = {};
    if (event.content != null) form['Content'] = event.content;
    if (event.visibility != null) form['Visibility'] = event.visibility;
    for (var i = 0; i < event.newMedias.length; i++) {
      final media = event.newMedias[i];
      form[updateMediaFileKey(i)] = await _toMultipartFile(media.file);
      form[updateMediaTypeKey(i)] = media.mediaType;
      // Sent unconditionally - 0 for an image - matching the request shape
      // confirmed working against the server.
      form[updateMediaDurationKey(i)] = media.durationSeconds ?? 0;
    }
    if (event.deletedMediaIds.isNotEmpty) {
      form['DeletedMediaIds'] = event.deletedMediaIds;
    }
    await ApiService.putMethod(
          endPoint: 'Post/Update/${event.postId}',
          form: FormData.fromMap(form),
        )
        .then((response) {
          log(response.data.toString());
          add(GetAllPostsEvent(storeId: event.storeId));
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              postTransactionStatus: PostTransactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onTogglePostReactionEvent(
    TogglePostReactionEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(postReactionStatus: PostReactionStatus.loading));
    await ApiService.postMethod(
          endPoint: 'PostReaction',
          body: {"postId": event.postId, "reactionType": event.reactionType},
        )
        .then((response) {
          log(response.data.toString());
          // Refresh whichever list the post came from so the new reaction shows.
          if (state.communityFeed.isNotEmpty) {
            add(
              GetCommunityFeedEvent(
                storeIds: state.communityFeed
                    .map((p) => p.storeId)
                    .toSet()
                    .toList(),
              ),
            );
          }
          if (state.posts.isNotEmpty) {
            add(GetAllPostsEvent(storeId: event.storeId));
          }
          emit(state.copyWith(postReactionStatus: PostReactionStatus.success));
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              postReactionStatus: PostReactionStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              postReactionStatus: PostReactionStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
