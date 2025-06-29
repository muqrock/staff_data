// staff_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  String? id;
  String name;
  String staffId;
  int age;

  Staff({
    this.id,
    required this.name,
    required this.staffId,
    required this.age,
  });

  factory Staff.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Staff(
      id: doc.id,
      name: data['name'] ?? '',
      staffId: data['staffId'] ?? '',
      age: data['age'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'staffId': staffId,
      'age': age,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
