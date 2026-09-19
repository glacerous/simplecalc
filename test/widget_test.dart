// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tugas2mobile/main.dart';

void main() {
  testWidgets('Warnet App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WarnetApp(isLogin: false));

    // Verify that login title and button are present
    expect(find.text('WARNET POJOK'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
