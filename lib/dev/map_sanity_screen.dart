import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// 개발용 임시 지도/권한 점검 화면
/// - 앱 사용 중 위치 권한 요청
/// - 현재 위치로 카메라 이동
/// - 내 위치 표시(myLocationEnabled)
class MapSanityScreen extends StatefulWidget {
  const MapSanityScreen({super.key});

  @override
  State<MapSanityScreen> createState() => _MapSanityScreenState();
}

class _MapSanityScreenState extends State<MapSanityScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition _initial = const CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울 시청 근처
    zoom: 14,
  );

  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _ensurePermissionAndMove();
  }

  Future<void> _ensurePermissionAndMove() async {
    // 위치 서비스 활성 상태 확인
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 안내만 하고 종료
      if (!mounted) return;
      setState(() {
        _hasPermission = false;
      });
      return;
    }

    // 권한 상태 확인
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      if (!mounted) return;
      setState(() {
        _hasPermission = false;
      });
      return;
    }

    // 권한 OK
    if (!mounted) return;
    setState(() {
      _hasPermission = true;
    });

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      final target = LatLng(pos.latitude, pos.longitude);
      _initial = CameraPosition(target: target, zoom: 16);

      final c = await _controller.future;
      c.animateCamera(CameraUpdate.newCameraPosition(_initial));
    } catch (_) {
      // 위치 못 얻어도 지도는 기본 좌표로 뜨게 둠
    }
  }

  @override
  Widget build(BuildContext context) {
    final banner = !_hasPermission
        ? Container(
      width: double.infinity,
      color: Colors.red.withOpacity(0.1),
      padding: const EdgeInsets.all(12),
      child: const Text(
        '위치 권한이 없거나 위치 서비스가 비활성화되어 있음',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    )
        : const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Map Sanity Check')),
      body: Column(
        children: [
          banner,
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initial,
              myLocationEnabled: _hasPermission, // 파란 점 표시
              myLocationButtonEnabled: true,
              compassEnabled: true,
              onMapCreated: (controller) => _controller.complete(controller),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ensurePermissionAndMove,
        label: const Text('현재 위치로 이동'),
        icon: const Icon(Icons.my_location),
      ),
    );
  }
}
