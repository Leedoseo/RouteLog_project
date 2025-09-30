import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routelog_project/core/data/models/latlng_dto.dart';

class RoutePolylineMap extends StatefulWidget {
  const RoutePolylineMap({
    super.key,
    required this.path,
    this.height = 220,
    this.padding = const EdgeInsets.all(24),
    this.strokeWidth = 5,
  });

  final List<LatLngDto> path;
  final double height;
  final EdgeInsets padding;
  final double strokeWidth;

  @override
  State<RoutePolylineMap> createState() => _RoutePolylineMapState();
}

class _RoutePolylineMapState extends State<RoutePolylineMap> {
  GoogleMapController? _mapCtrl;

  CameraPosition get _fallbackCamera => const CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울 시청 근처
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final points = widget.path
        .map((e) => LatLng(e.lat, e.lng))
        .toList(growable: false);

    final hasPath = points.length >= 2;

    final poly = hasPath
        ? {
      Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        width: widget.strokeWidth.toInt(),
        color: cs.primary,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      )
    }
        : <Polyline>{};

    final markers = <Marker>{};
    if (hasPath) {
      markers.add(Marker(
        markerId: const MarkerId('start'),
        position: points.first,
        infoWindow: const InfoWindow(title: '출발'),
      ));
      markers.add(Marker(
        markerId: const MarkerId('end'),
        position: points.last,
        infoWindow: const InfoWindow(title: '도착'),
      ));
    }

    return SizedBox(
      height: widget.height,
      child: GoogleMap(
        key: const ValueKey('route_detail_map'),
        initialCameraPosition: hasPath
            ? CameraPosition(target: points.first, zoom: 15)
            : _fallbackCamera,
        polylines: poly,
        markers: markers,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: (c) async {
          _mapCtrl = c;
          if (hasPath) {
            await _fitToPolyline(points, widget.padding);
          }
        },
      ),
    );
  }

  Future<void> _fitToPolyline(List<LatLng> pts, EdgeInsets pad) async {
    if (_mapCtrl == null || pts.isEmpty) return;

    // bounds 계산
    double minLat = pts.first.latitude;
    double maxLat = pts.first.latitude;
    double minLng = pts.first.longitude;
    double maxLng = pts.first.longitude;

    for (final p in pts) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await _mapCtrl!.moveCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          math.max(pad.left + pad.right, pad.top + pad.bottom),
        ),
      );
    } catch (_) {
      // iOS 초기 1프레임 지연 이슈 대비
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        await _mapCtrl!.moveCamera(
          CameraUpdate.newLatLngBounds(
            bounds,
            math.max(pad.left + pad.right, pad.top + pad.bottom),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _mapCtrl?.dispose();
    super.dispose();
  }
}
