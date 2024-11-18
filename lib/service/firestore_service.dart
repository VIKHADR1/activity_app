import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Toggle the favorite status for a specific event
  Future<void> toggleFavoriteStatus(String userId, String eventId, bool isFavorite) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Check if the user document exists
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Cast the data to a Map<String, dynamic>
        var userData = userDocSnapshot.data() as Map<String, dynamic>;

        // Check if the 'favourites' field exists in the user data map
        if (!userData.containsKey('favourites')) {
          await userDocRef.update({'favourites': {}}); // Initialize the 'favourites' map if it doesn't exist
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
