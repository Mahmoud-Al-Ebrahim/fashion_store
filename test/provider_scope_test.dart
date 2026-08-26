import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the app's provider architecture.
///
/// `Navigator.push` mounts the new route as a child of the Navigator, *not*
/// of the widget that pushed it. A bloc provided inside a route (e.g. in a
/// shell) is therefore invisible to every page pushed out of that shell -
/// and when the same bloc type also exists higher up, the pushed page
/// silently binds to the *other* instance and quietly shows stale data.
///
/// `FashionApp` avoids both failure modes by declaring every shared bloc
/// above `MaterialApp`. These tests pin that down.
class _CounterCubit extends Cubit<int> {
  _CounterCubit(super.initialState);
}

class _PushedPage extends StatelessWidget {
  const _PushedPage();

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Text('value:${context.watch<_CounterCubit>().state}'));
}

Widget _shellThatPushes() => Builder(
      builder: (context) => Scaffold(
        body: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const _PushedPage()),
          ),
          child: const Text('go'),
        ),
      ),
    );

void main() {
  testWidgets('a provider above MaterialApp is visible to pushed routes',
      (tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => _CounterCubit(7),
        child: MaterialApp(home: _shellThatPushes()),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('value:7'), findsOneWidget);
  });

  testWidgets('a provider inside a route is NOT visible to pushed routes',
      (tester) async {
    // Documents the trap the shells used to fall into.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => _CounterCubit(7),
          child: _shellThatPushes(),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isA<ProviderNotFoundException>());
  });

  testWidgets('a shell re-providing a root bloc shadows it', (tester) async {
    // The subtle version: no crash, but the pushed page reads the *root*
    // instance while the shell reads its own, so the two disagree forever.
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => _CounterCubit(7),
        child: MaterialApp(
          home: BlocProvider(
            create: (_) => _CounterCubit(99),
            child: _shellThatPushes(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('value:7'), findsOneWidget, reason: 'reads root, not 99');
  });

  test('no shell re-provides a bloc that FashionApp already provides', () {
    final rootSource = File('lib/fashion_app.dart').readAsStringSync();
    final rootBlocs = RegExp(r'create: \(context\) => (\w+Bloc)\(')
        .allMatches(rootSource)
        .map((m) => m.group(1)!)
        .toSet();

    expect(rootBlocs, isNotEmpty, reason: 'root providers should parse');

    const shells = [
      'lib/features/nav_bar/user_nav_bar/user_nav_bar_screen.dart',
      'lib/features/admin/admin_shell_screen.dart',
      'lib/features/super_admin/super_admin_shell_screen.dart',
      'lib/features/payment_employee/payment_employee_shell_screen.dart',
    ];

    for (final path in shells) {
      final source = File(path).readAsStringSync();
      final provided = RegExp(r'create: \(_?\w*\) => (\w+Bloc)\(')
          .allMatches(source)
          .map((m) => m.group(1)!)
          .toSet();
      final shadowed = provided.intersection(rootBlocs);
      expect(
        shadowed,
        isEmpty,
        reason: '$path re-creates $shadowed, which FashionApp already '
            'provides - pushed pages would bind to a different instance',
      );
    }
  });
}
