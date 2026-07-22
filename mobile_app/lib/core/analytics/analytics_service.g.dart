// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsServiceHash() => r'2a9ebfd27e90caf7554a5a8d281b5f2111246b92';

/// Firebase Analytics への薄い facade。
///
/// Crashlytics 用 logger とは分離する。application 層からのみ呼び出す。
///
/// @doc doc/specs/analytics-events.md#概要
///
/// Copied from [analyticsService].
@ProviderFor(analyticsService)
final analyticsServiceProvider = Provider<AnalyticsService>.internal(
  analyticsService,
  name: r'analyticsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AnalyticsServiceRef = ProviderRef<AnalyticsService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
