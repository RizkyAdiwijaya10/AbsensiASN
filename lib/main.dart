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
//     final userData = prefs.getString('user');

//     if (token != null && token.isNotEmpty && userData != null) {
//       final user = jsonDecode(userData) as Map<String, dynamic>;
//       return HomePages(user: user, token: token);
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
import 'dart:convert';
import 'pages/home_pages.dart';
import 'pages/login_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<Widget> _getInitialPage = _checkLoginStatus();

  static Future<Widget> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // We only need to pass the token now, as HomePages will fetch user data
      return HomePages(token: token);
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialPage,
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
    );
  }
}