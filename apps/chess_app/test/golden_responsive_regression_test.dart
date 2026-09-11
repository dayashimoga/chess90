import 'dart:io';
import 'package:chess_app/main.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Golden Responsive & Visual Regression Multi-Viewport Suite', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('responsive_golden_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    final targetViewports = <String, Size>{
      'Mobile 360x640': const Size(360, 640),
      'Mobile 390x844': const Size(390, 844),
      'Foldable 600x900': const Size(600, 900),
      'Tablet/Laptop 1280x800': const Size(1280, 800),
      'Desktop Full HD 1920x1080': const Size(1920, 1080),
    };

    for (final entry in targetViewports.entries) {
      final name = entry.key;
      final size = entry.value;

      testWidgets('$name renders cleanly in Dark Theme without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ChessMasterApp(
            repository: repo,
            initialThemeMode: ThemeMode.dark,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Render overflow detected on $name (Dark Theme)');
        expect(find.byType(ChessMasterApp), findsOneWidget);
        expect(find.text('CHESSMASTER'), findsOneWidget);
      });

      testWidgets('$name renders cleanly in Light Theme with 1.5x text scale without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        tester.platformDispatcher.textScaleFactorTestValue = 1.5;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpWidget(
          ChessMasterApp(
            repository: repo,
            initialThemeMode: ThemeMode.light,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Render overflow detected on $name (Light Theme 1.5x text scale)');
        expect(find.byType(ChessMasterApp), findsOneWidget);
      });
    }

    testWidgets('Adaptive navigation displays mobile BottomBar on mobile viewport 360x640', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(ChessMasterApp(repository: repo));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);

      // Tap navigation bar item on mobile: Labs
      final labsMobileTab = find.text('Labs');
      expect(labsMobileTab, findsOneWidget);
      await tester.tap(labsMobileTab);
      await tester.pumpAndSettle();
    });

    testWidgets('Adaptive navigation displays desktop NavigationRail on desktop viewport 1280x800', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(ChessMasterApp(repository: repo));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });
  });
}
