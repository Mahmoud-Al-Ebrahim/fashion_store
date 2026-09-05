import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Signing out must leave no trace of the previous account.
///
/// The blocs are provided once at the app root so pushed routes can reach
/// them, which means they outlive a session. Every one of them therefore
/// needs a reset event, and sign-out has to dispatch it - a bloc that is
/// added later and forgotten here would leak the last user's data into the
/// next sign-in.
void main() {
  late final List<String> blocNames;
  late final String helper;

  setUpAll(() {
    blocNames = Directory('lib/blocs')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('_bloc.dart'))
        .map(
          (f) => RegExp(
            r'class (\w+Bloc) extends Bloc<',
          ).firstMatch(f.readAsStringSync())?.group(1),
        )
        .whereType<String>()
        .toList();
    helper = File('lib/core/utils/clear_session_blocs.dart').readAsStringSync();
  });

  test('the scan found the bloc layer', () {
    expect(blocNames.length, greaterThan(10));
  });

  test('every bloc has a Clear event and handles it', () {
    final missing = <String>[];
    for (final bloc in blocNames) {
      final prefix = bloc.substring(0, bloc.length - 'Bloc'.length);
      final clear = 'Clear${prefix}Event';
      final dir = Directory('lib/blocs').listSync().whereType<Directory>();
      var declared = false;
      var handled = false;
      for (final d in dir) {
        for (final f in d.listSync().whereType<File>()) {
          final src = f.readAsStringSync();
          if (f.path.endsWith('_event.dart') &&
              src.contains('class $clear extends')) {
            declared = true;
          }
          if (f.path.endsWith('_bloc.dart') && src.contains('on<$clear>')) {
            handled = true;
          }
        }
      }
      if (!declared) missing.add('$clear is not declared');
      if (!handled) missing.add('$clear is never handled');
    }
    expect(missing, isEmpty, reason: missing.join('\n'));
  });

  test('sign-out clears every bloc except AuthBloc', () {
    final notCleared = <String>[];
    for (final bloc in blocNames) {
      if (bloc == 'AuthBloc') {
        // It owns the sign-out, so clearing it there would discard the
        // result - it may only be reset behind the `includeAuth` flag, which
        // the guest-mode paths pass and sign-out does not.
        expect(
          helper.contains('if (includeAuth) context.read<AuthBloc>()'),
          isTrue,
          reason: 'AuthBloc must only be reset when includeAuth is set',
        );
        continue;
      }
      if (!helper.contains('context.read<$bloc>()')) {
        notCleared.add(bloc);
      }
    }
    expect(
      notCleared,
      isEmpty,
      reason: 'clearSessionBlocs misses: ${notCleared.join(', ')}',
    );
  });

  /// Dropping into guest mode is the other way a session ends, and it used
  /// to clear only the stored token. The blocs outlive the session, so the
  /// guest saw the previous account's cart, orders, wallet and profile -
  /// each screen only corrects itself once its own fetch returns, and as a
  /// guest those fetches 401 and leave the stale data on screen.
  ///
  /// So: anywhere in the UI that drops the stored session must drop the
  /// in-memory one in the same breath.
  test('every screen that clears stored auth also clears the blocs', () {
    final offenders = <String>[];
    for (final file
        in Directory('lib/features')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final src = file.readAsStringSync();
      if (!src.contains('MySharedPref.clearAuthData()')) continue;
      final path = file.path.split(Platform.pathSeparator).join('/');
      if (!src.contains('clearSessionBlocs(context')) {
        offenders.add('$path drops the stored session but not the blocs');
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });

  test('guest mode also resets AuthBloc, which still holds the tokens', () {
    for (final path in const [
      'lib/features/auth/pages/sign_in_screen/sign_in_screen.dart',
      'lib/features/auth/widgets/on_boarding/column_layer.dart',
    ]) {
      final src = File(path).readAsStringSync();
      expect(
        src.contains('clearSessionBlocs(context, includeAuth: true)'),
        isTrue,
        reason: '$path enters guest mode without resetting AuthBloc',
      );
    }
  });

  /// The profile fields cached at login are personal data; leaving them in
  /// SharedPreferences means the next person to use the phone still has the
  /// previous account's name, email and photo on disk.
  test('clearing stored auth clears the cached profile too', () {
    final src = File('lib/core/utils/my_shared_pref.dart').readAsStringSync();
    final body = src.substring(src.indexOf('clearAuthData'));
    for (final key in const [
      'fullName',
      'email',
      'phone',
      'userName',
      "'image'",
      '_isAdmin',
      '_wantsStoreKey',
    ]) {
      expect(
        body.contains('remove($key)'),
        isTrue,
        reason: 'clearAuthData leaves $key behind',
      );
    }
    // Device preferences are not the account's, and must survive.
    for (final key in const ['_language', '_lightThemeKey', '_onBoarding']) {
      expect(
        body.contains('remove($key)'),
        isFalse,
        reason: '$key belongs to the device, not the session',
      );
    }
  });

  test('every sign-out call site clears the blocs first', () {
    final offenders = <String>[];
    for (final file
        in Directory('lib/features')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final src = file.readAsStringSync();
      if (!src.contains('LogoutEvent()')) continue;
      final path = file.path.split(Platform.pathSeparator).join('/');
      if (!src.contains('clearSessionBlocs(context)')) {
        offenders.add(path);
        continue;
      }
      // And it must come before the logout, not after.
      if (src.indexOf('clearSessionBlocs(context)') >
          src.indexOf('LogoutEvent()')) {
        offenders.add('$path (clears after signing out)');
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
