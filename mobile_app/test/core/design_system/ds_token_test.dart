import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/design_system/design_system.dart';

void main() {
  group('semantic token の値', () {
    test('DsSpacing が仕様どおりの値を持つ', () {
      expect(DsSpacing.tight, 4);
      expect(DsSpacing.inline, 8);
      expect(DsSpacing.item, 16);
      expect(DsSpacing.section, 24);
      expect(DsSpacing.block, 32);
      expect(DsSpacing.screenEnd, 40);
      expect(DsSpacing.screenHorizontal, 16);
      expect(DsSpacing.screenContent, 24);
      expect(DsSpacing.containerContent, 16);
    });

    test('DsRadius が仕様どおりの値を持つ', () {
      expect(DsRadius.pill, 48);
      expect(DsRadius.field, 40);
      expect(DsRadius.container, 16);
      expect(DsRadius.subtle, 4);
      expect(DsRadius.shimmer, 2);
    });

    test('DsSize が仕様どおりの値を持つ', () {
      expect(DsSize.iconSmall, 16);
      expect(DsSize.iconMedium, 20);
      expect(DsSize.iconLarge, 24);
      expect(DsSize.avatarIcon, 40);
    });

    test('DsElevation が仕様どおりの値を持つ', () {
      expect(DsElevation.none, 0);
      expect(DsElevation.hairline, 0.1);
    });

    test('DsOpacity が仕様どおりの値を持つ', () {
      expect(DsOpacity.disabled, 0.3);
    });
  });

  group('light / dark 双方でテーマ依存 token が解決できる', () {
    for (final brightness in Brightness.values) {
      testWidgets('$brightness で DsTypography の全 member が解決できる', (
        tester,
      ) async {
        late DsTypography typography;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildDsThemeData(brightness),
            home: Builder(
              builder: (context) {
                typography = context.dsTypography;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        final styles = <String, TextStyle>{
          'heading': typography.heading,
          'itemTitle': typography.itemTitle,
          'sectionLabel': typography.sectionLabel,
          'body': typography.body,
          'bodyEmphasis': typography.bodyEmphasis,
          'label': typography.label,
        };
        for (final entry in styles.entries) {
          expect(
            entry.value.fontFamily,
            dsFontFamily,
            reason: '${entry.key} に fontFamily が適用されていない',
          );
          expect(
            entry.value.color,
            isNotNull,
            reason: '${entry.key} に色が解決されていない',
          );
        }
      });

      testWidgets('$brightness で DsTypography がフォントサイズを持つ', (tester) async {
        late DsTypography typography;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildDsThemeData(brightness),
            home: Builder(
              builder: (context) {
                typography = context.dsTypography;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        // ThemeData 構築時の TextTheme にはサイズが無い。`Theme.of` が
        // 適用した geometry を反映していないと、見た目が変わる。
        expect(typography.heading.fontSize, 20);
        expect(typography.itemTitle.fontSize, 16);
        expect(typography.body.fontSize, 14);
        expect(typography.bodyEmphasis.fontSize, 18);
      });

      testWidgets('$brightness で DsColors が解決できる', (tester) async {
        late DsColors colors;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildDsThemeData(brightness),
            home: Builder(
              builder: (context) {
                colors = context.dsColors;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(colors.like, DsColors.standard.like);
      });
    }

    testWidgets('Ds のテーマを適用していなくても DsTypography が落ちない', (tester) async {
      late DsTypography typography;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              typography = context.dsTypography;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(typography.body, isNotNull);
    });
  });

  group('ThemeExtension の実装', () {
    test('DsColors の lerp が両端で一致する', () {
      const a = DsColors(like: Color(0xFF000000));
      const b = DsColors(like: Color(0xFFFFFFFF));
      expect(a.lerp(b, 0).like, a.like);
      expect(a.lerp(b, 1).like, b.like);
    });

    test('DsTypography は同じ TextTheme から同じ値になる', () {
      final textTheme = ThemeData.light().textTheme;
      expect(
        DsTypography.fromTextTheme(textTheme),
        DsTypography.fromTextTheme(textTheme),
      );
    });
  });
}
