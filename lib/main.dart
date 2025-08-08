

// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'pages/home_pages.dart';
// import 'pages/login_pages.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeDateFormatting('id_ID', null);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   final Future<Widget> _getInitialPage = _checkLoginStatus();

//   static Future<Widget> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     if (token != null && token.isNotEmpty) {
//       // We only need to pass the token now, as HomePages will fetch user data
//       return HomePages(token: token);
//     } else {
//       return const LoginPage();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Absensi',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: FutureBuilder<Widget>(
//         future: _getInitialPage,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.hasError) {
//             return const Scaffold(
//               body: Center(child: Text('Terjadi kesalahan')),
//             );
//           } else {
//             return snapshot.data!;
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_pages.dart';
import 'pages/login_pages.dart';
import 'pages/absen_pages.dart'; // Make sure to import your AbsensiPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define your routes
      routes: {
        '/': (context) => FutureBuilder<Widget>(
              future: _checkLoginStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return const Scaffold(
                    body: Center(child: Text('Terjadi kesalahan')),
                  );
                } else {
                  return snapshot.data!;
                }
              },
            ),
        '/login': (context) => const LoginPage(),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return HomePages(token: args?['token'] ?? '');
        },
        '/absensi': (context) => const AbsensiPage(nipBaru: '',),
      },
      onGenerateRoute: (settings) {
        // Handle any routes that aren't defined above
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
      },
    );
  }

  static Future<Widget> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        return HomePages(token: token);
      } else {
        return const LoginPage();
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return const LoginPage(); // Fallback to login page on error
    }
  }
}