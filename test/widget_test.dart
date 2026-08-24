import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:where_is_that/app/app.dart';
import 'package:where_is_that/core/data/demo_app_repository.dart';
import 'package:where_is_that/core/data/repository_providers.dart';

void main() {
  testWidgets('demo mode opens the space picker', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRepositoryProvider.overrideWithValue(DemoAppRepository()),
        ],
        child: const WhereIsThatApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('우리집'), findsOneWidget);
  });

  testWidgets('demo mode can navigate into a space', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRepositoryProvider.overrideWithValue(DemoAppRepository()),
        ],
        child: const WhereIsThatApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('우리집'));
    await tester.pumpAndSettle();

    expect(find.text('물건 등록'), findsWidgets);
  });
}
