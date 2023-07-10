import 'package:android_companion_for_wear_os_ereader/app/app.dart';
import 'package:android_companion_for_wear_os_ereader/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
