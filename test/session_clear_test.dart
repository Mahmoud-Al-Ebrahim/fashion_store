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
        .map((f) => RegExp(r'class (\w+Bloc) extends Bloc<')
            .firstMatch(f.readAsStringSync())
            ?.group(1))
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
        // It owns the sign-out; clearing it would discard the result.
        expect(
          helper.contains('context.read<AuthBloc>()'),
          isFalse,
          reason: 'AuthBloc must not be reset by the helper',
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

  test('every sign-out call site clears the blocs first', () {
    final offenders = <String>[];
    for (final file in Directory('lib/features')
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
