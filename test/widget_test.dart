import 'package:flutter_test/flutter_test.dart';

import 'package:chapter_one_companion/main.dart';

void main() {
  testWidgets('App boots to splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ChapterOneCompanionApp());
    await tester.pump();

    expect(find.text('Chapter One'), findsOneWidget);

    // Flush the splash screen's navigation timer so it doesn't leak past the test.
    await tester.pump(const Duration(milliseconds: 1500));
  });
}
