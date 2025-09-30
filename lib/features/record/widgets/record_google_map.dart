import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecordGoogleMap extends StatefulWidget {
  const RecordGoogleMap({
    super.key,
    required this.height,
    required this.path,
    this.fallbackCenter = const LatLng(37.5665, 126.9780), // 서울 시청 근처
    this.zoom = 16.0,
    this.followUser = true,
  });

  final double height;
  final List<LatLng> path;
  final LatLng fallbackCenter;
  final double zoom;
  final bool followUser;

  @override
  State<RecordGoogleMap> createState() => _RecordGoogleMapState();
}

class _RecordGoogleMapState extends State<RecordGoogleMap> {
  GoogleMapController? _mapCtrl;

  CameraPosition _initialCamera() {
    final c = widget.path.isNotEmpty ? widget.path.last : widget.fallbackCenter;
    return CameraPosition(target: c, zoom: widget.zoom);
  }

  @override
  void didUpdateWidget(covariant RecordGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.followUser && widget.path.isNotEmpty && _mapCtrl != null) {
      final last = widget.path.last;
      _mapCtrl!.animateCamera(CameraUpdate.newLatLng(last));
    }
  }

  @override
  Widget build(BuildContext context) {
    final polyline = Polyline(
      polylineId: const PolylineId('record_path'),
      points: widget.path,
      width: 4,
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
          onMapCreated: (c) => _mapCtrl = c,
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
}
