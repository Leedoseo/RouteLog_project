import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RecordGoogleMap extends StatefulWidget {
  const RecordGoogleMap({
    super.key,
    required this.height,
    required this.path,
    this.fallbackCenter = const LatLng(37.5665, 126.9780), // 서울 시청 근처(실패 시 폴백)
    this.zoom = 16.0,
    this.followUser = true,
    this.useCurrentLocationAsFallback = true, // 추가: path 비면 현재 위치로 초기 이동 시도
  });

  final double height;
  final List<LatLng> path;
  final LatLng fallbackCenter;
  final double zoom;
  final bool followUser;

  /// path가 비었을 때 현재 위치를 얻어 초기 카메라를 현재 위치로 옮길지 여부
  final bool useCurrentLocationAsFallback;

  @override
  State<RecordGoogleMap> createState() => _RecordGoogleMapState();
}

class _RecordGoogleMapState extends State<RecordGoogleMap> {
  GoogleMapController? _mapCtrl;
  LatLng? _resolvedFallback; // 현재 위치를 성공적으로 받으면 여기 저장
  bool _movedToCurrentOnce = false;
  bool _mapReady = false;

  CameraPosition _initialCamera() {
    final center = widget.path.isNotEmpty
        ? widget.path.last
        : (_resolvedFallback ?? widget.fallbackCenter);
    return CameraPosition(target: center, zoom: widget.zoom);
  }

  @override
  void initState() {
    super.initState();
    // path가 비어 있고 옵션이 켜져 있으면 현재 위치로 한 번 이동 시도
    if (widget.useCurrentLocationAsFallback && widget.path.isEmpty) {
      _loadCurrentAndMaybeMove();
    }
  }

  /// 현재 위치를 얻고, 가능하면 카메라를 그 위치로 애니메이션
  Future<void> _loadCurrentAndMaybeMove() async {
    if (_movedToCurrentOnce) return; // 한 번만
    try {
      // 서비스/권한 체크
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return;
      }
      if (perm == LocationPermission.deniedForever) {
        // 설정에서 권한 허용 필요
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final target = LatLng(pos.latitude, pos.longitude);
      _resolvedFallback = target;

      // 맵 준비가 되었으면 즉시 이동
      if (_mapReady && _mapCtrl != null) {
        await _mapCtrl!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: widget.zoom),
          ),
        );
        _movedToCurrentOnce = true;
      }
    } catch (e) {
      // 조용히 실패 허용(폴백은 서울시청 유지)
      debugPrint('RecordGoogleMap: current-loc fetch failed: $e');
    }
  }

  @override
  void didUpdateWidget(covariant RecordGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 기록 중이면 최신 좌표를 따라감
    if (widget.followUser && widget.path.isNotEmpty && _mapCtrl != null) {
      final last = widget.path.last;
      _mapCtrl!.animateCamera(
        CameraUpdate.newLatLngZoom(last, widget.zoom),
      );
    }

    // path가 여전히 비어있고, 아직 현재 위치로 이동되지 않았다면 한 번 더 시도
    if (widget.useCurrentLocationAsFallback && widget.path.isEmpty && !_movedToCurrentOnce) {
      _loadCurrentAndMaybeMove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final polyline = Polyline(
      polylineId: const PolylineId('record_path'),
      points: widget.path,
      width: 4,
      color: Theme.of(context).colorScheme.primary,
    );

    final lastMarker = widget.path.isNotEmpty
        ? {
      Marker(
        markerId: const MarkerId('me'),
        position: widget.path.last,
        anchor: const Offset(0.5, 0.5),
      ),
    }
        : <Marker>{};

    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: _initialCamera(),
          onMapCreated: (c) async {
            _mapCtrl = c;
            _mapReady = true;

            // onMapCreated 이후, 현재 위치를 받아둔 경우 즉시 이동
            if (!_movedToCurrentOnce && _resolvedFallback != null && widget.path.isEmpty) {
              await _mapCtrl!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _resolvedFallback!, zoom: widget.zoom),
                ),
              );
              _movedToCurrentOnce = true;
            } else if (widget.useCurrentLocationAsFallback && widget.path.isEmpty) {
              // 아직 못받았으면 한 번 더 시도
              unawaited(_loadCurrentAndMaybeMove());
            }
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          polylines: {polyline},
          markers: lastMarker,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapCtrl?.dispose();
    super.dispose();
  }
}
