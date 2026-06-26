import 'package:flutter_test/flutter_test.dart';
import 'package:sokrio_task/app/app.dart';
import 'package:sokrio_task/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await di.init();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.text('Sokrio Users', findRichText: true), findsOneWidget);
  });
}
