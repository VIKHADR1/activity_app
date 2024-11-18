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

  // Toggle the favorite status for a specific event
  Future<void> toggleFavoriteStatus(
      String userId, String eventId, bool isFavorite) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Check if the user document exists
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Cast the data to a Map<String, dynamic>
        var userData = userDocSnapshot.data() as Map<String, dynamic>;

        // Check if the 'favourites' field exists in the user data map
        if (!userData.containsKey('favourites')) {
          await userDocRef.update({
            'favourites': {}
          }); // Initialize the 'favourites' map if it doesn't exist
        }

        // Update the specific event's favorite status in the 'favourites' map
        await userDocRef.update({
          'favourites.$eventId': isFavorite,
        });

        print("Favorite status for eventId $eventId set to $isFavorite.");
      } else {
        print("User document not found.");
      }
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }
}
