// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perf_telemetry_device.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$perfTelemetryDeviceHash() =>
    r'242d940f457e818973b8dfc02566c8cbe0c62be9';

/// 端末・ビルドの識別情報。1 セッション中は変わらないため keepAlive で 1 度だけ解決する。
///
/// `user_id` は含めない。パフォーマンス分析に不要で、個人情報の取り扱いが増えるだけ。
///
/// Copied from [perfTelemetryDevice].
@ProviderFor(perfTelemetryDevice)
final perfTelemetryDeviceProvider = FutureProvider<FrameStatsDevice>.internal(
  perfTelemetryDevice,
  name: r'perfTelemetryDeviceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$perfTelemetryDeviceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PerfTelemetryDeviceRef = FutureProviderRef<FrameStatsDevice>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
