import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/metric_pill.dart';
import 'package:routelog_project/core/widgets/soft_info_card.dart';

class RouteMetaPanel extends StatelessWidget {
  const RouteMetaPanel({
    super.key,
    required this.distanceText,
    required this.durationText,
    required this.paceText,
    required this.elevationText,
  });

  final String distanceText;
  final String durationText;
  final String paceText;
  final String elevationText;

  @override
  Widget build(BuildContext context) {
    return SoftInfoCard(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          MetricPill(label: 'DISTANCE', value: distanceText, icon: Icons.straighten_rounded),
          MetricPill(label: 'DURATION', value: durationText, icon: Icons.timer_outlined),
          MetricPill(label: 'PACE', value: paceText, icon: Icons.speed_rounded),
          MetricPill(label: 'ELEV', value: elevationText, icon: Icons.terrain_rounded),
        ],
      ),
    );
  }
}