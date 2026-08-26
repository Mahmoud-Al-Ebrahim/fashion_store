import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keeps user-visible text out of the source and in the language files.
///
/// A string literal containing Arabic inside `lib/` is almost always text
/// that was never localised - it shows up in Arabic even when the app is
/// running in English. This scan catches that, with a short allowlist for
/// the places where Arabic in source is correct.
void main() {
  /// Files where Arabic literals are legitimate, and why.
  const allowed = <String, String>{
    'lib/core/constants/product_enums.dart':
        'colour names as the API stores them, plus the spelling-normalisation '
            'table - these are data values, not display text',
    'lib/core/utils/helper_functions.dart':
        'Arabic-Indic digit conversion table',
    'lib/core/localization/language_service.dart':
        'a language is listed in its own script by design',
    'lib/features/auth/pages/sign_in_screen/sign_in_screen.dart':
        'matches a substring of the server error message, not display text',
    'lib/features/auth/widgets/product_icons.dart':
        'unused leftover from the original restaurant app; renders nowhere',
  };

  final arabic = RegExp('[؀-ۿ]');
  final literal = RegExp("'([^']*)'|\"([^\"]*)\"");

  test('no user-visible Arabic is hardcoded in lib/', () {
    final offenders = <String>[];

    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path.split(Platform.pathSeparator).join('/');
      if (allowed.keys.any(path.endsWith)) continue;

      final lines = const LineSplitter().convert(file.readAsStringSync());
      for (var i = 0; i < lines.length; i++) {
        final trimmed = lines[i].trim();
        // Comments may explain a message in Arabic; only code counts.
        if (trimmed.startsWith('//') || trimmed.startsWith('*')) continue;
        for (final m in literal.allMatches(lines[i])) {
          final text = (m.group(1) ?? m.group(2) ?? '').trim();
          if (text.isNotEmpty && arabic.hasMatch(text)) {
            offenders.add('$path:${i + 1}  $text');
          }
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'these strings would stay Arabic in the English build - move '
          'them into the language files:\n${offenders.join('\n')}',
    );
  });

  test('the allowlist stays honest', () {
    // A file that no longer exists, or no longer contains Arabic, should be
    // dropped so the list does not rot.
    for (final path in allowed.keys) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: '$path no longer exists');
      expect(
        arabic.hasMatch(file.readAsStringSync()),
        isTrue,
        reason: '$path has no Arabic left - remove it from the allowlist',
      );
    }
  });

  test('both language files carry exactly the same keys', () {
    Map<String, String> flatten(Map<String, dynamic> map, [String prefix = '']) {
      final out = <String, String>{};
      map.forEach((key, value) {
        final path = prefix.isEmpty ? key : '$prefix.$key';
        if (value is Map<String, dynamic>) {
          out.addAll(flatten(value, path));
        } else {
          out[path] = '$value';
        }
      });
      return out;
    }

    final en = flatten(
      jsonDecode(File('assets/languages/en-US.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    final ar = flatten(
      jsonDecode(File('assets/languages/ar-SY.json').readAsStringSync())
          as Map<String, dynamic>,
    );

    expect(en.keys.toSet().difference(ar.keys.toSet()), isEmpty,
        reason: 'missing Arabic translations');
    expect(ar.keys.toSet().difference(en.keys.toSet()), isEmpty,
        reason: 'missing English translations');
    expect(
      en.entries.where((e) => e.value.trim().isEmpty).map((e) => e.key),
      isEmpty,
      reason: 'blank English values',
    );
    expect(
      ar.entries.where((e) => e.value.trim().isEmpty).map((e) => e.key),
      isEmpty,
      reason: 'blank Arabic values',
    );
  });

  test('every LK constant resolves to a real key', () {
    final source =
        File('lib/core/localization/translation_keys.dart').readAsStringSync();
    final keys = RegExp(r"static const \w+ = '([^']+)'")
        .allMatches(source)
        .map((m) => m.group(1)!)
        .toList();

    Map<String, dynamic> en =
        jsonDecode(File('assets/languages/en-US.json').readAsStringSync())
            as Map<String, dynamic>;

    bool resolves(String dotted) {
      dynamic node = en;
      for (final part in dotted.split('.')) {
        if (node is! Map<String, dynamic> || !node.containsKey(part)) {
          return false;
        }
        node = node[part];
      }
      return node is String;
    }

    expect(keys, isNotEmpty);
    expect(keys.where((k) => !resolves(k)), isEmpty);
  });
}
