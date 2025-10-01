import 'package:flutter/foundation.dart';

class HomeSummary {
  final Duration sessionDuration;   // 이번/최근 세션 시간
  final double totalDistanceKm;     // 누적 거리(필요에 맞게 기간 제한 가능)
  final double? avgPaceSecPerKm;    // 평균 페이스(초/킬로)
  final int? avgHr;                 // 평균 심박
  final DateTime? lastUpdated;

  const HomeSummary({
    required this.sessionDuration,
    required this.totalDistanceKm,
    required this.avgPaceSecPerKm,
    required this.avgHr,
    required this.lastUpdated,
  });

  static const empty = HomeSummary(
    sessionDuration: Duration.zero,
    totalDistanceKm: 0,
    avgPaceSecPerKm: null,
    avgHr: null,
    lastUpdated: null,
  );
}

@immutable
class HomeSummaryState {
  final bool isLoading;
  final Object? error;
  final HomeSummary data;

  const HomeSummaryState.loading() : isLoading = true, error = null, data = HomeSummary.empty;
  const HomeSummaryState.error(this.error) : isLoading = false, data = HomeSummary.empty;
  const HomeSummaryState.data(this.data) : isLoading = false, error = null;
}
