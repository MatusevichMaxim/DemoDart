import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_demo/counter_screen.dart';
import 'package:tdd_demo/main.dart';

void main() {
  testWidgets('Navigates back to HomeScreen when back arrow is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.text('Open Screen'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Open Screen'), findsOneWidget);
  });

  test('Initial counter value should be 0', () {
    final counter = CounterModel();
    expect(counter.value, 0);
  });

  test('Increment should increase value by 1', () {
    final counter = CounterModel();
    counter.increment();
    expect(counter.value, 1);
  });

  test('Decrement should decrease value by 1', () {
    final counter = CounterModel();
    counter.increment();
    counter.decrement();
    expect(counter.value, 0);
  });

  test('Decrement should not allow value below 0', () {
    final counter = CounterModel();
    counter.decrement();
    expect(counter.value, 0);
  });
}