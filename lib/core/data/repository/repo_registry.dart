import 'package:routelog_project/core/data/repository/i_route_repository.dart';
import 'package:routelog_project/core/data/repository/mock/mock_route_repository.dart';

class RepoRegistry {
  RepoRegistry._();
  static final RepoRegistry I = RepoRegistry._();

  // 전역으로 하나만 사용 (목록/상세 동일 데이터 공유)
  final IRouteRepository routeRepo = MockRouteRepository();
}
