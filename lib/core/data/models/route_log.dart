import 'latlng_dto.dart';
import 'tag.dart';

class RouteLog {
  final String id;
  final String title;
  final DateTime startedAt;
  final DateTime endedAt;
  final List<LatLngDto> path; // 경로 좌표
  final double distanceMeters; // 총 거리(m)
  final Duration movingTime;   // 이동 시간
  final double? avgPaceSecPerKm; // 초/킬로
  final List<Tag> tags;
  final String? notes;
  final String source; // 'recorded' | 'imported' 등

  const RouteLog({
    required this.id,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.path,
    required this.distanceMeters,
    required this.movingTime,
    required this.avgPaceSecPerKm,
    required this.tags,
    required this.source,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt.toIso8601String(),
    'path': path.map((e) => e.toJson()).toList(),
    'distanceMeters': distanceMeters,
    'movingTimeSec': movingTime.inSeconds,
    'avgPaceSecPerKm': avgPaceSecPerKm,
    'tags': tags.map((e) => e.toJson()).toList(),
    'notes': notes,
    'source': source,
  };

  factory RouteLog.fromJson(Map<String, dynamic> json) => RouteLog(
    id: json['id'] as String,
    title: json['title'] as String,
    startedAt: DateTime.parse(json['startedAt'] as String),
    endedAt: DateTime.parse(json['endedAt'] as String),
    path: (json['path'] as List).map((e) => LatLngDto.fromJson(e)).toList(),
    distanceMeters: (json['distanceMeters'] as num).toDouble(),
    movingTime: Duration(seconds: json['movingTimeSec'] as int),
    avgPaceSecPerKm: (json['avgPaceSecPerKm'] as num?)?.toDouble(),
    tags: (json['tags'] as List).map((e) => Tag.fromJson(e)).toList(),
    notes: json['notes'] as String?,
    source: json['source'] as String,
  );
}
