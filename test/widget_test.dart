import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:croma_app/app.dart';

void main() {
  testWidgets('CromaApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame within a ProviderScope.
    await tester.pumpWidget(const ProviderScope(child: CromaApp()));

    // Verify that the app builds.
    // Since everything is dynamic, we just check if CromaApp is present.
    expect(find.byType(CromaApp), findsOneWidget);
  });
}
