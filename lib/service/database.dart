import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addEventDetail(Map<String, dynamic> eventDetailMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("EventDetail")
        .doc(id)
        .set(eventDetailMap);
  }

  Future<Stream<QuerySnapshot>> getEventDetail() async {
    return await FirebaseFirestore.instance
        .collection("EventDetail")
        .snapshots();
  }
}
