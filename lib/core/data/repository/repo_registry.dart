// lib/core/data/repository/repo_registry.dart
import 'package:routelog_project/core/data/repository/i_route_repository.dart';
import 'package:routelog_project/core/data/repository/file/file_route_repository.dart';
import 'package:routelog_project/core/data/repository/mock/mock_route_repository.dart';

/// 앱 전역 레포 레지스트리 (싱글턴)
class RepoRegistry {
  RepoRegistry._();
  static final RepoRegistry I = RepoRegistry._();

  late IRouteRepository routeRepo;

  /// 앱 시작 시 한 번 호출해서 레포를 준비한다.
  ///
  /// [seedIfEmpty] 가 true이면 파일 스토어가 비어 있을 때
  /// Mock 데이터로 몇 개 시드해 준다(포트폴리오 데모용).
  Future<void> init({bool seedIfEmpty = false}) async {
    // 파일 기반 레포 열기 (routes.json 저장)
    final fileRepo = await FileRouteRepository.open(filename: 'routes.json');

    if (seedIfEmpty) {
      final existing = await fileRepo.list();
      if (existing.isEmpty) {
        // MockRepo에서 가져온 데이터를 새 id로 저장해 시드
        final mock = MockRouteRepository();
        final seeds = await mock.list();
        for (final s in seeds) {
          await fileRepo.create(s.copyWith(id: ''));
        }
      }
    }

    // 기본 레포로 파일 레포를 사용
    routeRepo = fileRepo;

    // 개발 중에 메모리 Mock을 쓰고 싶다면 아래 한 줄로 전환 가능
    // routeRepo = MockRouteRepository();
  }
}
