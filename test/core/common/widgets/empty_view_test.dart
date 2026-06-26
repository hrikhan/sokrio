import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokrio_task/core/common/widgets/empty_view.dart';

void main() {
  testWidgets('EmptyView displays title and message', (WidgetTester tester) async {
    const title = 'No Users Found';
    const message = 'Please try again later.';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyView(
            title: title,
            message: message,
          ),
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
    expect(find.text(message), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('EmptyView action button triggers callback', (WidgetTester tester) async {
    bool isPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyView(
            onAction: () => isPressed = true,
            actionLabel: 'Retry Now',
          ),
        ),
      ),
    );

    final buttonFinder = find.text('Retry Now');
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();

    expect(isPressed, isTrue);
  });
}
