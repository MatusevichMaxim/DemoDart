import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_demo/main.dart';

void main() {
  testWidgets('Should display Home Screen when MyApp execute', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Open Screen'), findsOneWidget);
  });
}