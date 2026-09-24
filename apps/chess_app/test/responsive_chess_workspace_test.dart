import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess_app/src/widgets/board/responsive_chess_workspace.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ResponsiveChessWorkspace Forensic Sizing & Constraint Tests', () {
    testWidgets('Board strictly enlarges on every [+] click and disables visibly at true maximum', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      double currentBoardSize = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveChessWorkspace(
              initialScale: 0.5,
              boardBuilder: (context, size) {
                currentBoardSize = size;
                return Container(width: size, height: size, color: Colors.green);
              },
              sidePanel: Container(color: Colors.blue, child: const Text('Side Panel')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final initialSize = currentBoardSize;
      expect(initialSize, greaterThan(220.0));

      // Click [+] and verify size strictly increases
      final plusFinder = find.byIcon(Icons.add);
      expect(plusFinder, findsOneWidget);

      double previousSize = initialSize;
      int clicks = 0;

      // Click until button is disabled (up to 25 clicks)
      while (clicks < 25) {
        final iconButton = tester.widget<IconButton>(find.ancestor(
          of: plusFinder,
          matching: find.byType(IconButton),
        ));

        if (iconButton.onPressed == null) {
          // Reached true maximum!
          break;
        }

        await tester.tap(plusFinder);
        await tester.pumpAndSettle();
        clicks++;

        expect(currentBoardSize, greaterThan(previousSize),
            reason: 'Board size must strictly increase on click #$clicks (was $previousSize, now $currentBoardSize)');
        previousSize = currentBoardSize;
      }

      // Must have reached true maximum and disabled visibly
      final finalPlusButton = tester.widget<IconButton>(find.ancestor(
        of: plusFinder,
        matching: find.byType(IconButton),
      ));
      expect(finalPlusButton.onPressed, isNull, reason: '[+] button must be visibly disabled at true maximum');
    });

    testWidgets('Board strictly decreases on every [-] click and disables visibly at true minimum', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      double currentBoardSize = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveChessWorkspace(
              initialScale: 0.3,
              boardBuilder: (context, size) {
                currentBoardSize = size;
                return Container(width: size, height: size, color: Colors.green);
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final minusFinder = find.byIcon(Icons.remove);
      expect(minusFinder, findsOneWidget);

      double previousSize = currentBoardSize;
      int clicks = 0;

      while (clicks < 25) {
        final iconButton = tester.widget<IconButton>(find.ancestor(
          of: minusFinder,
          matching: find.byType(IconButton),
        ));

        if (iconButton.onPressed == null) {
          // Reached true minimum!
          break;
        }

        await tester.tap(minusFinder);
        await tester.pumpAndSettle();
        clicks++;

        expect(currentBoardSize, lessThan(previousSize),
            reason: 'Board size must strictly decrease on click #$clicks (was $previousSize, now $currentBoardSize)');
        previousSize = currentBoardSize;
      }

      final finalMinusButton = tester.widget<IconButton>(find.ancestor(
        of: minusFinder,
        matching: find.byType(IconButton),
      ));
      expect(finalMinusButton.onPressed, isNull, reason: '[-] button must be visibly disabled at true minimum');
      expect(currentBoardSize, equals(220.0));
    });

    testWidgets('FIT and AUTO buttons resize board to exact proportional bounds', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      double currentBoardSize = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveChessWorkspace(
              initialScale: 0.5,
              boardBuilder: (context, size) {
                currentBoardSize = size;
                return Container(width: size, height: size, color: Colors.green);
              },
              sidePanel: Container(color: Colors.blue, child: const Text('Side Panel')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap AUTO
      await tester.tap(find.text('AUTO'));
      await tester.pumpAndSettle();
      final autoSize = currentBoardSize;

      // Tap FIT (must be larger than AUTO)
      await tester.tap(find.text('FIT'));
      await tester.pumpAndSettle();
      final fitSize = currentBoardSize;

      expect(fitSize, greaterThan(autoSize));

      // Tap MAX (collapses panel, board expands even more)
      await tester.tap(find.text('MAX'));
      await tester.pumpAndSettle();
      final maxSize = currentBoardSize;

      expect(maxSize, greaterThanOrEqualTo(fitSize));
      expect(find.text('Side Panel'), findsNothing); // Panel collapsed in MAX mode
    });
  });
}
