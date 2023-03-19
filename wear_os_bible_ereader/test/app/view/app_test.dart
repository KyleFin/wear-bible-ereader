import 'package:flutter_test/flutter_test.dart';
import 'package:wear_os_bible_ereader/app/app.dart';
import 'package:wear_os_bible_ereader/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
