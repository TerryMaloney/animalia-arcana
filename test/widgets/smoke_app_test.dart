import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/test_app.dart';

void main() {
  testWidgets('App boots and shows a scaffold', (tester) async {
    await tester.pumpWidget(const TestApp());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}
