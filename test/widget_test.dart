import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pani_puri_paps/main.dart';

void main() {
  // Prevent google_fonts from making network requests during tests.
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('App renders without throwing', (WidgetTester tester) async {
    await tester.pumpWidget(const PaniPuriApp());
    // Pump one frame so initState / layout completes.
    await tester.pump();

    // Verify key text elements are present.
    expect(find.textContaining('Pani, Puri'), findsWidgets);
    expect(find.text('CONTACT US'), findsOneWidget);
  });

  testWidgets('Contact modal opens on button tap', (WidgetTester tester) async {
    await tester.pumpWidget(const PaniPuriApp());
    await tester.pump();

    // Tap the CONTACT US button.
    await tester.tap(find.text('CONTACT US'));
    await tester.pumpAndSettle();

    // Modal content should be visible.
    expect(find.textContaining('Coles Street Market'), findsOneWidget);
    expect(find.text('VIEW ON GOOGLE MAPS'), findsOneWidget);

    // Dismiss modal with close button.
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.textContaining('Coles Street Market'), findsNothing);
  });
}
