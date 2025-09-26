import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:minq/data/repositories/quest_log_repository.dart';
import 'package:minq/domain/log/quest_log.dart';

class FirestoreSyncService {
  FirestoreSyncService(this._firestore, this._logRepository, this._isar);

  final FirebaseFirestore _firestore;
  final QuestLogRepository _logRepository;
  final Isar _isar;

  Future<void> syncQuestLogs(String uid) async {
    final unsyncedLogs =
        await _isar.questLogs
            .filter()
            .uidEqualTo(uid)
            .syncedEqualTo(false)
            .findAll();

    if (unsyncedLogs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final log in unsyncedLogs) {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('quest_logs')
          .doc(log.id.toString());
      batch.set(docRef, {
        'questId': log.questId,
        'ts': log.ts,
        'proofType': log.proofType.name,
        'proofValue': log.proofValue,
      }, SetOptions(merge: true));
    }

    try {
      await batch.commit();
      await _logRepository.markLogsAsSynced(
        unsyncedLogs.map((log) => log.id).toList(),
      );
    } catch (e) {
      // Commit failed; keep the logs marked as unsynced so they retry next time.
      // TODO: replace with structured logging once a logger is in place.
      // ignore: avoid_print
      print('Error syncing quest logs: $e');
    }
  }
}
