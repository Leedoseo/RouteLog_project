import 'dart:async';
import 'dart:math' show cos, sin, sqrt, atan2;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum RecordStatus { idle, recording, paused, finished }
enum LocationPermissionState { unknown, granted, denied, serviceDisabled }

class RecordController extends ChangeNotifier {
  // 상태
  RecordStatus _status = RecordStatus.idle;
  LocationPermissionState _perm = LocationPermissionState.unknown;

  // 측정 값
  final List<LatLng> _path = [];
  double _distanceMeters = 0.0; // 누적 거리(m)
  Duration _elapsed = Duration.zero; // 총 경과(일시정지 제외)
  late final Stopwatch _stopwatch;

  // 위치 구독
  StreamSubscription<Position>? _posSub;

  // 위치 설정
  final LocationSettings _locSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 3, // 3m 이상 이동 시 업데이트
  );

  RecordController() {
    _stopwatch = Stopwatch();
  }

  // Getters
  RecordStatus get status => _status;
  LocationPermissionState get permission => _perm;
  List<LatLng> get path => List.unmodifiable(_path);
  double get distanceMeters => _distanceMeters;
  Duration get elapsed => _elapsed;

  double? get paceSecPerKm {
    final km = _distanceMeters / 1000.0;
    if (km <= 0) return null;
    final sec = _elapsed.inSeconds.toDouble();
    return sec / km; // 초/킬로
  }

  // ---- 권한 & 서비스 체크 ----
  Future<void> initPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _perm = LocationPermissionState.serviceDisabled;
      notifyListeners();
      return;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      _perm = LocationPermissionState.denied;
    } else {
      _perm = LocationPermissionState.granted;
    }
    notifyListeners();
  }

  // ---- 기록 제어 ----
  Future<void> start() async {
    if (_status == RecordStatus.recording) return;

    _status = RecordStatus.recording;
    _path.clear();
    _distanceMeters = 0.0;
    _elapsed = Duration.zero;

    _stopwatch
      ..reset()
      ..start();

    // 기존 구독 해제
    await _posSub?.cancel();

    _posSub = Geolocator.getPositionStream(locationSettings: _locSettings)
        .listen(_onPosition, onError: (e) {
      // 필요 시 에러 핸들링
    });

    // 1초 틱으로 경과 갱신
    _tick();
    notifyListeners();
  }

  void _tick() {
    if (_status != RecordStatus.recording) return;
    _elapsed = _stopwatch.elapsed;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), _tick);
  }

  Future<void> pause() async {
    if (_status != RecordStatus.recording) return;
    _status = RecordStatus.paused;
    _stopwatch.stop();
    _posSub?.pause();
    _elapsed = _stopwatch.elapsed;
    notifyListeners();
  }

  Future<void> resume() async {
    if (_status != RecordStatus.paused) return;
    _status = RecordStatus.recording;
    _stopwatch.start();
    _posSub?.resume();
    _tick();
    notifyListeners();
  }

  Future<void> stop() async {
    if (_status == RecordStatus.idle || _status == RecordStatus.finished) return;
    _status = RecordStatus.finished;
    _stopwatch.stop();
    await _posSub?.cancel();
    _posSub = null;
    _elapsed = _stopwatch.elapsed;
    notifyListeners();
  }

  // ---- 위치 처리 ----
  void _onPosition(Position p) {
    final pt = LatLng(p.latitude, p.longitude);
    if (_path.isNotEmpty) {
      final prev = _path.last;
      final inc = _haversine(prev, pt); // m
      _distanceMeters += inc;
    }
    _path.add(pt);
    if (_status == RecordStatus.recording) {
      _elapsed = _stopwatch.elapsed;
      notifyListeners();
    }
  }

  // Haversine 거리(m)
  static double _haversine(LatLng a, LatLng b) {
    const R = 6371000.0; // 지구 반경(m)
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final lat1 = _deg2rad(a.latitude);
    final lat2 = _deg2rad(b.latitude);

    final h = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    final c = 2 * atan2(sqrt(h), sqrt(1 - h));
    return R * c;
  }

  static double _deg2rad(double d) => d * (3.1415926535897932 / 180.0);

  @override
  void dispose() {
    _posSub?.cancel();
    super.dispose();
  }
}
