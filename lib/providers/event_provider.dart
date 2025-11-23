import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';

final eventsProvider = StreamProvider<List<Event>>((ref) {
  return FirebaseFirestore.instance
      .collection('events')
      .orderBy('startTime')
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList(),
      );
});

final liveEventsProvider = StreamProvider<List<Event>>((ref) {
  return FirebaseFirestore.instance
      .collection('events')
      .where('isLive', isEqualTo: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList(),
      );
});
