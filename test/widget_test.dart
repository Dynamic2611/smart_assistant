import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_assistant/main.dart';

void main() {
  testWidgets('App launches and shows Smart Assistant title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // Verify the app bar title is shown
    expect(find.text('Smart Assistant'), findsOneWidget);

    // Verify the chat FAB is present
    expect(find.byIcon(Icons.chat_rounded), findsOneWidget);

    // Verify the history button is present
    expect(find.byIcon(Icons.history), findsOneWidget);
  });
}
