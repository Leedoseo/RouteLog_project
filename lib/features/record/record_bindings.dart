import 'package:flutter/material.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/features/record/state/record_controller.dart';
import 'package:routelog_project/features/record/record_screen.dart';

class RecordBindings extends StatefulWidget {
  const RecordBindings({super.key});

  @override
  State<RecordBindings> createState() => _RecordBindingsState();
}

class _RecordBindingsState extends State<RecordBindings> {
  late final RecordController controller;

  @override
  void initState() {
    super.initState();
    controller = RecordController();
    controller.initPermission(); // 권한/서비스 체크 시작
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotifierProvider<RecordController>(
      notifier: controller,
      child: const RecordScreen(),
    );
  }
}
