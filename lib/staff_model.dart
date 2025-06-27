// staff_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  String? id; // Firestore document ID
  String name;
  String staffId; // Renamed from 'id' to avoid confusion with document ID
  int age;

  Staff({
    this.id,
    required this.name,
    required this.staffId,
    required this.age,
  });

  // Factory constructor to create a Staff object from a Firestore document
  factory Staff.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Staff(
      id: doc.id,
      name: data['name'] ?? '',
      staffId: data['staffId'] ?? '',
      age: data['age'] ?? 0,
    );
  }

  // Convert a Staff object to a Map for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'staffId': staffId,
      'age': age,
      'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for ordering
    };
  }
}
