import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/core/design_system/app_theme.dart';
import 'package:medical_appointment_app/data/mock_data/feature_screen_catalog.dart';
import 'package:medical_appointment_app/features/shared/presentation/feature_preview_screen.dart';
import 'package:medical_appointment_app/features/shared/presentation/screen_catalog_screen.dart';

void main() {
  Widget app(Widget child) => MaterialApp(theme: AppTheme.light, home: child);

  test('catalog contains every remaining Figma frame', () {
    expect(FeatureScreenCatalog.patient, hasLength(27));
    expect(FeatureScreenCatalog.doctor, hasLength(28));
    expect(FeatureScreenCatalog.admin, hasLength(27));
    expect(FeatureScreenCatalog.all, hasLength(82));
    expect(
      FeatureScreenCatalog.all.map((screen) => screen.id).toSet(),
      hasLength(82),
    );
  });

  testWidgets('all feature screens render without layout exceptions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final screen in FeatureScreenCatalog.all) {
      await tester.pumpWidget(
        app(
          FeaturePreviewScreen(
            spec: screen,
            onOpenScreen: (_) {},
            onOpenCatalog: () {},
          ),
        ),
      );
      await tester.pump();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Lỗi bố cục tại ${screen.id}',
      );
    }
  });

  testWidgets('admin dashboard adapts to desktop width', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        FeaturePreviewScreen(
          spec: FeatureScreenCatalog.find('A01')!,
          onOpenScreen: (_) {},
          onOpenCatalog: () {},
        ),
      ),
    );

    expect(find.text('MediCare+ Admin'), findsOneWidget);
    expect(find.text('Tổng quan quản trị'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('screen catalog exposes all three roles', (tester) async {
    await tester.pumpWidget(
      app(ScreenCatalogScreen(onOpenScreen: (_) {}, onOpenExisting: (_) {})),
    );

    expect(find.text('Patient · 27 màn còn lại'), findsOneWidget);
    expect(find.text('Doctor · 28 màn'), findsOneWidget);
    expect(find.text('Admin · 27 màn'), findsOneWidget);
  });
}
