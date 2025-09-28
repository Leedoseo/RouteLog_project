import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  FirebaseRepository._();
  static final instance = FirebaseRepository._();

  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  /// Settings
  Future<void> setDistanceUnit(String unit) async {
    final ref = _db.collection("users").doc(_uid);
    await ref.set(
      {"distanceUnit": unit, "updatedAt": FieldValue.serverTimestamp()},
    );
  }

  Stream<String?> distanceUnitStream() {
    return _db.collection("users").doc(_uid).snapshots()
        .map((d) => d.data()?["distanceUnit"] as String?);
  }

  /// Sessions
  Future<void> addSession({
    required double distanceKm,
    required int durationSec,
    required int avgPaceSecPerKm,
    int? avgHr,
  }) async {
    final ref = _db.collection('users').doc(_uid).collection('sessions').doc();
    await ref.set({
      'distance': distanceKm,
      'durationSec': durationSec,
      'avgPaceSecPerKm': avgPaceSecPerKm,
      'avgHr': avgHr,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> recentSessionsStream({int limit = 20}) {
    return _db.collection('users').doc(_uid).collection('sessions')
        .orderBy('createdAt', descending: true).limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  /// Routes (mock)
  Stream<List<Map<String, dynamic>>> routesStream({int limit = 20})  {
    return _db.collection("users").doc(_uid).collection("routes")
        .orderBy("createdAt", descending: true).limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  Future<void> addMockRoute({
    required String title,
    required double distanceKm,
    required String meta,
  }) async {
    final ref = _db.collection('users').doc(_uid).collection('routes').doc();
    await ref.set({
      'title': title,
      'distanceKm': distanceKm,
      'meta': meta,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}