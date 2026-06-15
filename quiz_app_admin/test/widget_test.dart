// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_app_admin/main.dart';

void main() {
  testWidgets('Home screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuizApp());

    // Verify that our home screen shows the welcome message.
    expect(find.text('Welcome to the Quiz App'), findsOneWidget);
    
    // Verify that Admin Panel and Student Panel buttons exist.
    expect(find.text('Admin Panel'), findsOneWidget);
    expect(find.text('Student Panel'), findsOneWidget);

    // Verify that tapping Admin Panel navigates or triggers an action.
    await tester.tap(find.text('Admin Panel'));
    await tester.pumpAndSettle();

    expect(find.text('Admin Dashboard'), findsOneWidget);
  });
}
