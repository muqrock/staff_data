// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Required for Firebase initialization
import 'package:cloud_firestore/cloud_firestore.dart'; // Required for Firestore operations
import 'package:firebase_auth/firebase_auth.dart'; // Required for Firebase Authentication (for security rules)

import 'add_staff.dart'; // Import the staff creation page
import 'staff_list.dart'; // Import the staff list page
import 'staff_model.dart'; // Import the Staff model

// This is where your Firebase configuration will go.
// Replace with your actual Firebase project configuration.
// You will get this from your Firebase project settings (Web app configuration).
// For a real project, consider using flutter_dotenv or build_runner to manage environment variables.
const firebaseOptions = {
  apiKey:
      "YOUR_API_KEY", // This will be provided when you register your Android app!
  authDomain: "lab-test-d20221104752.firebaseapp.com",
  projectId: "lab-test-d20221104752",
  storageBucket: "lab-test-d20221104752.firebasestorage.app",
  messagingSenderId: "515738333498", // Your Project Number
  appId:
      "YOUR_APP_ID", // This unique ID will be provided when you register your Android app!
  measurementId:
      undefined, // Optional: Will appear if you enable Google Analytics later
};

void main() async {
  // Ensure Flutter widgets are initialized before Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the options defined above.
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: firebaseOptions['apiKey']!,
        authDomain: firebaseOptions['authDomain']!,
        projectId: firebaseOptions['projectId']!,
        storageBucket: firebaseOptions['storageBucket']!,
        messagingSenderId: firebaseOptions['messagingSenderId']!,
        appId: firebaseOptions['appId']!,
        // If you have measurementId, uncomment the line below
        // measurementId: firebaseOptions['measurementId'],
      ),
    );
    // Sign in anonymously to satisfy Firestore security rules that require authentication.
    // If you plan to implement user authentication, replace this with your chosen method.
    await FirebaseAuth.instance.signInAnonymously();
    print("Firebase initialized and signed in anonymously.");
  } catch (e) {
    print("Error initializing Firebase: $e");
    // You might want to display an error message to the user here.
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Enable Material 3 design
      ),
      // Define named routes for easy navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const StaffListPage(), // Home page is the staff list
        '/add_staff':
            (context) => const AddStaffPage(), // Route to add staff page
      },
    );
  }
}
