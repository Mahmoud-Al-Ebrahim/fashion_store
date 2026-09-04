import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_store/blocs/post_bloc/post_bloc.dart';

/// `PUT Post/Update/{postId}` binds `NewMedias` as a
/// `List<RequestAddPostMediaDto>`, so each entry has to arrive as its own
/// indexed, dotted set of fields. The update used to post the picked files
/// as a bare `NewMedias` list, which bound an empty list server-side: the
/// request answered 200, the text and visibility were saved, and the new
/// image was dropped without a word.
///
/// The expected names below are copied from the request the backend
/// confirmed working in Postman:
///
///   Content              test
///   Visibility           Followers
///   NewMedias[0].File    (the picked file)
///   NewMedias[0].MediaType   Image
///   NewMedias[0].Duration    0
void main() {
  group('Post/Update media field names', () {
    test('match the shape the server binds', () {
      expect(updateMediaFileKey(0), 'NewMedias[0].File');
      expect(updateMediaTypeKey(0), 'NewMedias[0].MediaType');
      expect(updateMediaDurationKey(0), 'NewMedias[0].Duration');
    });

    test('every entry carries its own index', () {
      expect(updateMediaFileKey(2), 'NewMedias[2].File');
      expect(updateMediaTypeKey(2), 'NewMedias[2].MediaType');
      expect(updateMediaDurationKey(2), 'NewMedias[2].Duration');
    });

    test('the file field is never a bare list name', () {
      // The regression: `form['NewMedias'] = [file, file]`.
      for (var i = 0; i < 3; i++) {
        expect(updateMediaFileKey(i), isNot('NewMedias'));
        expect(updateMediaFileKey(i), contains('['));
        expect(updateMediaFileKey(i), contains('].'));
      }
    });
  });
}
