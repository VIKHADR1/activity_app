import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  /// Adds event details with a `createdAt` timestamp
  Future<void> addEventDetail(
      Map<String, dynamic> eventDetailMap, String id) async {
    // Add createdAt field with server timestamp
    eventDetailMap['createdAt'] = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance
        .collection("EventDetail")
        .doc(id)
        .set(eventDetailMap);
  }

  /// Fetches event details sorted by creation time (ascending order)
  /// Optionally filters by category if provided
  Future<Stream<QuerySnapshot>> getEventDetail({String? category}) async {
    var query = FirebaseFirestore.instance
        .collection("EventDetail")
        .orderBy('createdAt', descending: false);

    // If a category is provided, filter the events by that category
    if (category != null && category.isNotEmpty) {
      query = query.where('Category', isEqualTo: category);
    }

    return query.snapshots();
  }
}
