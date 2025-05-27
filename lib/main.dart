import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // File konfigurasi Firebase (dihasilkan oleh FlutterFire CLI)
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_task_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/add_category.dart';

// ValueNotifier untuk mengontrol tema (light/dark)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'TICKY To-Do List',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          initialRoute: '/',
          routes: {
            '/': (context) => StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Jika pengguna sudah login, arahkan ke /home
                    // Jika tidak, arahkan ke LandingPage
                    return snapshot.hasData
                        ? const HomeScreen()
                        : const LandingPage();
                  },
                ),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const HomeScreen(),
            '/add-task': (context) => const AddEditTaskScreen(),
            '/edit-task': (context) => const EditTaskScreen(),
            '/add-category': (context) => const AddCategory(),
          },
        );
      },
    );
  }
}
