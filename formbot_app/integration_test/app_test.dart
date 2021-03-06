// This is a basic Flutter integration test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:formbot_app/main.dart' as app;

void main() {
  testWidgets('Title widget test', (WidgetTester tester) async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    // Build our app and trigger a frame.
    app.main();

    // Trigger a frame.
    await tester.pumpAndSettle();

    //TODO: Add more tests.
  });
}
