import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class PairRepository {
  PairRepository(this._firestore);

  final FirebaseFirestore _firestore;
  final _random = Random();

  Future<String> createPair(String uid1, String uid2, String category) async {
    final pairRef = _firestore.collection('pairs').doc();
    await pairRef.set({
      'members': [uid1, uid2],
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
      'lastHighfiveAt': null,
      'lastHighfiveBy': null,
    });

    await _setPairAssignment(uid1, pairRef.id);
    await _setPairAssignment(uid2, pairRef.id);

    return pairRef.id;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPairStream(String pairId) {
    return _firestore.collection('pairs').doc(pairId).snapshots();
  }

  Future<void> sendHighFive(String pairId, String senderUid) async {
    await _firestore.collection('pairs').doc(pairId).update({
      'lastHighfiveAt': FieldValue.serverTimestamp(),
      'lastHighfiveBy': senderUid,
    });
  }

  Future<String?> requestRandomPair(String uid, String category) async {
    final queueDoc = _firestore.collection('pair_queue').doc(category);
    final pairRef = _firestore.collection('pairs').doc();

    return _firestore.runTransaction<String?>((transaction) async {
      final snapshot = await transaction.get(queueDoc);
      if (!snapshot.exists) {
        transaction.set(queueDoc, {
          'waitingUid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return null;
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final waitingUid = data['waitingUid'] as String?;
      if (waitingUid == null || waitingUid == uid) {
        transaction.set(queueDoc, {
          'waitingUid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return null;
      }

      transaction.delete(queueDoc);
      transaction.set(pairRef, {
        'members': [waitingUid, uid],
        'category': category,
        'createdAt': FieldValue.serverTimestamp(),
        'lastHighfiveAt': null,
        'lastHighfiveBy': null,
      });
      transaction.set(
        _firestore.collection('pair_assignments').doc(waitingUid),
        {'pairId': pairRef.id, 'updatedAt': FieldValue.serverTimestamp()},
      );
      transaction.set(_firestore.collection('pair_assignments').doc(uid), {
        'pairId': pairRef.id,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return pairRef.id;
    });
  }

  Future<void> cancelRandomRequest(String uid, String category) async {
    final queueDoc = _firestore.collection('pair_queue').doc(category);
    await _firestore.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(queueDoc);
      if (!snapshot.exists) {
        return;
      }
      final data = snapshot.data() as Map<String, dynamic>;
      if (data['waitingUid'] == uid) {
        transaction.delete(queueDoc);
      }
    });
  }

  Future<String> createInvitation(String ownerUid, String category) async {
    final code = _generateInviteCode();
    await _firestore.collection('pair_invites').doc(code).set({
      'ownerUid': ownerUid,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return code;
  }

  Future<String?> joinByInvitation(String code, String joinerUid) async {
    final normalizedCode = code.toUpperCase();
    final inviteRef = _firestore.collection('pair_invites').doc(normalizedCode);

    final result = await _firestore.runTransaction<String?>((
      transaction,
    ) async {
      final snapshot = await transaction.get(inviteRef);
      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final ownerUid = data['ownerUid'] as String?;
      final category = data['category'] as String? ?? 'general';

      if (ownerUid == null || ownerUid == joinerUid) {
        return null;
      }

      transaction.delete(inviteRef);
      return '$ownerUid::$category';
    });

    if (result == null) {
      return null;
    }

    final parts = result.split('::');
    return createPair(parts[0], joinerUid, parts[1]);
  }

  Future<Map<String, dynamic>?> fetchAssignment(String uid) async {
    final snapshot =
        await _firestore.collection('pair_assignments').doc(uid).get();
    return snapshot.data();
  }

  Future<void> _setPairAssignment(String uid, String pairId) async {
    await _firestore.collection('pair_assignments').doc(uid).set({
      'pairId': pairId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _generateInviteCode() {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(
      6,
      (_) => letters[_random.nextInt(letters.length)],
    ).join();
  }
}
