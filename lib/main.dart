import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'staff_list.dart';
import 'add_staff.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Staff Manager',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), //ultra-light grey
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF343A40), //dark charcoal
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF495057), //medium grey
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 1,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF495057),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF495057)),
        dividerTheme: DividerThemeData(
          color: Colors.grey[200],
          thickness: 1,
          space: 0,
        ),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF343A40), //app bar color
          secondary: Color(0xFF495057), //buttons/FAB
          surface: Colors.white, //cards
          background: Color(0xFFF8F9FA), //scaffold
          onPrimary: Colors.white, //text on dark
          onSurface: Colors.black87, //text on white
        ),
      ),
      initialRoute: '/add_staff', //first screen
      routes: {
        '/': (context) => const StaffListPage(),
        '/add_staff': (context) => const AddStaffPage(),
      },
    );
  }
}
