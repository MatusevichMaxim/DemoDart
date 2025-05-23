import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_demo/main.dart';

void main() {
  testWidgets('Navigates to CounterScreen when "Open Screen" is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.text('Open Screen'));
    await tester.pumpAndSettle();

    expect(find.text('Counter'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
    expect(find.text('+7'), findsOneWidget);
    expect(find.text('-7'), findsOneWidget);
  });
}