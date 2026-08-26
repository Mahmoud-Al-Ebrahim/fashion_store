import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the wiring between the bloc layer and the screens.
///
/// Every bloc handler that calls an endpoint should be reachable from some
/// UI, otherwise the feature exists on paper only. This scans the source
/// rather than the network, so it runs offline and fails the moment a new
/// event is added without a screen that dispatches it.
void main() {
  /// Events that intentionally have no screen behind them, with the reason.
  /// Anything not listed here must be dispatched somewhere in `lib/features`.
  const deliberatelyUnwired = <String, String>{
    'RefreshTokenEvent':
        'the 401 interceptor in ApiService refreshes directly, so the '
            'endpoint is exercised without going through the bloc',
    'GetClothingItemEvent':
        'ClothingItem/GetAll already returns every colour with its sizes; '
            'fetching one by id would be a redundant round-trip',
    'GetAllSizesByProductColorEvent':
        'same data as ClothingItem/GetAll, which the product screen '
            'already loads up front',
  };

  late final Map<String, Set<String>> endpointsByEvent;
  late final Set<String> dispatched;

  setUpAll(() {
    endpointsByEvent = _endpointsByEvent();
    dispatched = _dispatchedEvents();
  });

  test('every endpoint-calling event is dispatched by some screen', () {
    final orphans = <String>[];
    for (final event in endpointsByEvent.keys) {
      if (dispatched.contains(event)) continue;
      if (deliberatelyUnwired.containsKey(event)) continue;
      orphans.add('$event -> ${endpointsByEvent[event]!.join(', ')}');
    }
    expect(
      orphans,
      isEmpty,
      reason: 'these events call an API but no screen triggers them:\n'
          '${orphans.join('\n')}',
    );
  });

  test('the unwired allowlist stays honest', () {
    // If one of these gets wired up, drop it from the list so the first
    // test starts guarding it.
    for (final entry in deliberatelyUnwired.entries) {
      if (!endpointsByEvent.containsKey(entry.key)) continue;
      expect(
        dispatched,
        isNot(contains(entry.key)),
        reason: '${entry.key} is now dispatched - remove it from '
            'deliberatelyUnwired',
      );
    }
  });

  test('the scan actually found the bloc layer', () {
    // A regex that silently matches nothing would make the tests above pass
    // for the wrong reason.
    expect(endpointsByEvent.length, greaterThan(50));
    expect(dispatched, isNotEmpty);
  });
}

/// Maps each `*Event` to the endpoints its handler calls.
Map<String, Set<String>> _endpointsByEvent() {
  final result = <String, Set<String>>{};
  final handler = RegExp(
    r'FutureOr<void> _on\w+\(\s*(\w+Event)\b(.*?)(?=\n  FutureOr<void> |$)',
    dotAll: true,
  );
  final endpoint = RegExp(r"endPoint: *'([^']+)'");

  for (final file in _dartFiles('lib/blocs')) {
    if (!file.path.endsWith('_bloc.dart')) continue;
    final source = file.readAsStringSync();
    for (final match in handler.allMatches(source)) {
      final event = match.group(1)!;
      final eps = endpoint
          .allMatches(match.group(2)!)
          .map((m) => m.group(1)!)
          .toSet();
      if (eps.isNotEmpty) {
        result.putIfAbsent(event, () => <String>{}).addAll(eps);
      }
    }
  }
  return result;
}

/// Every `SomethingEvent(` construction outside the bloc layer.
Set<String> _dispatchedEvents() {
  final found = <String>{};
  // Only a *construction* counts as a dispatch. Requiring an uppercase
  // start and no preceding identifier character keeps handler names like
  // `_onLoginEvent(` from being mistaken for `LoginEvent(`.
  final construction = RegExp(r'(?<![A-Za-z0-9_])([A-Z]\w*Event)\s*\(');
  for (final file in _dartFiles('lib')) {
    // Path separators differ by platform, so normalise before matching.
    final path = file.path.split(Platform.pathSeparator).join('/');
    if (path.contains('lib/blocs/')) continue;
    for (final m in construction.allMatches(file.readAsStringSync())) {
      found.add(m.group(1)!);
    }
  }
  return found;
}

List<File> _dartFiles(String dir) => Directory(dir)
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    .toList();
