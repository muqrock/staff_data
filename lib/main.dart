import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'staff_list.dart';
import 'add_staff.dart'; // ✅ <-- Add this line to fix the error

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAuth.instance.signInAnonymously();

    runApp(const MyApp());
  } catch (e) {
    print("❌ Error initializing Firebase: $e");
  }
}

// ... rest of the code unchanged ...

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Staff Manager',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      initialRoute: '/add_staff', // 👈 This is now the first screen
      routes: {
        '/': (context) => const StaffListPage(),
        '/add_staff': (context) => const AddStaffPage(),
      },
    );
  }
}
