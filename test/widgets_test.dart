import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickfix/core/widgets/qf_button.dart';
import 'package:quickfix/core/widgets/qf_animated_pulse.dart';

void main() {
  group('QFButton Tests', () {
    testWidgets('renders primary button with label', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QFButton(
              label: 'Book Repair',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Book Repair'), findsOneWidget);
      await tester.tap(find.text('Book Repair'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('renders shimmer variant and glass variant without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                QFButton.shimmer(
                  label: 'Proceed to Checkout',
                  onPressed: () {},
                ),
                QFButton.glass(
                  label: 'Frosted Glass Action',
                  onPressed: () {},
                ),
                QFButton.pulse(
                  label: 'Emergency Express',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Proceed to Checkout'), findsOneWidget);
      expect(find.text('Frosted Glass Action'), findsOneWidget);
      expect(find.text('Emergency Express'), findsOneWidget);
    });
  });

  group('QFAnimatedPulse Tests', () {
    testWidgets('renders pulse indicator and pulse badge', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                QFAnimatedPulse.live(),
                const QFAnimatedPulseBadge(label: 'LIVE TRACKING'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(QFAnimatedPulse), findsNWidgets(2));
      expect(find.text('LIVE TRACKING'), findsOneWidget);
    });
  });
}
