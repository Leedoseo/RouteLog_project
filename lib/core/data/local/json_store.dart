import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 앱 문서 디렉토리 절대경로
Future<String> getAppDocsPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

/// 단순 JSON 배열 파일을 다루는 헬퍼.
/// - 파일이 없거나 비어 있으면 빈 리스트 반환
/// - 쓰기는 임시파일(.tmp)에 기록 후 rename으로 원자적 교체
class JsonStore {
  JsonStore(this.filepath);

  final String filepath;

  Future<List<dynamic>> readList() async {
    final f = File(filepath);
    if (!await f.exists()) return [];
    final txt = await f.readAsString();
    if (txt.trim().isEmpty) return [];
    final decoded = jsonDecode(txt);
    if (decoded is List) return decoded;
    return [];
  }

  Future<void> writeList(List<dynamic> items) async {
    final f = File(filepath);
    // 디렉토리 보장
    await f.parent.create(recursive: true);

    final tmp = File('${f.path}.tmp');
    final txt = const JsonEncoder.withIndent('  ').convert(items);

    // 임시 파일에 기록 후 rename으로 교체 (원자적)
    await tmp.writeAsString(txt, flush: true);

    if (await f.exists()) {
      await f.delete();
    }
    await tmp.rename(f.path);
  }
}
