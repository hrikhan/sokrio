import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokrio_task/core/common/widgets/app_error_widget.dart';

void main() {
  testWidgets('AppErrorWidget displays error message', (WidgetTester tester) async {
    const errorMsg = 'Failed to load data';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            errorMessage: errorMsg,
          ),
        ),
      ),
    );

    expect(find.text('Oops! Something went wrong'), findsOneWidget);
    expect(find.text(errorMsg), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });

  testWidgets('AppErrorWidget retry button triggers callback', (WidgetTester tester) async {
    bool isPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            errorMessage: 'Error',
            onRetry: () => isPressed = true,
          ),
        ),
      ),
    );

    final buttonFinder = find.text('Try Again');
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();

    expect(isPressed, isTrue);
  });
}
