// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class LoginPages extends StatefulWidget {
// //   const LoginPages({super.key});

// //   @override
// //   State<LoginPages> createState() => _LoginPagesState();
// // }

// // class _LoginPagesState extends State<LoginPages> {
// //   final TextEditingController nipController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   bool isLoading = false;
// //   String? errorMessage;

// //   final String baseUrl = 'http://192.168.1.84:8000';

// //   Future<void> login() async {
// //     setState(() {
// //       isLoading = true;
// //       errorMessage = null;
// //     });

// //     final response = await http.post(
// //       Uri.parse('$baseUrl/api/login'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'nipBaru': nipController.text,
// //         'password': passwordController.text,
// //       }),
// //     );

// //     setState(() {
// //       isLoading = false;
// //     });

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       final token = data['token'];
// //       final userData = data['user'];

// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('token', token);
// //       await prefs.setString('user', jsonEncode(userData));

// //       // ✅ Navigasi ke halaman Home
// //       if (!mounted) return;
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => HomePage(user: userData, token: token)),
// //       );
// //     } else {
// //       final data = jsonDecode(response.body);
// //       setState(() {
// //         errorMessage = data['message'] ?? 'Login gagal';
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Login Pegawai')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: nipController,
// //               decoration: const InputDecoration(
// //                 labelText: 'NIP Baru',
// //                 prefixIcon: Icon(Icons.badge),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             TextField(
// //               controller: passwordController,
// //               obscureText: true,
// //               decoration: const InputDecoration(
// //                 labelText: 'Password',
// //                 prefixIcon: Icon(Icons.lock),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             if (errorMessage != null)
// //               Text(errorMessage!, style: const TextStyle(color: Colors.red)),
// //             const SizedBox(height: 10),
// //             isLoading
// //                 ? const CircularProgressIndicator()
// //                 : ElevatedButton.icon(
// //                     icon: const Icon(Icons.login),
// //                     onPressed: login,
// //                     label: const Text('Login'),
// //                   ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // class HomePage extends StatelessWidget {
// // //   final Map<String, dynamic> user;
// // //   final String token;

// // //   const HomePage({super.key, required this.user, required this.token});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Dashboard'),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(20.0),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Text("Selamat datang, ${user['username']}", style: const TextStyle(fontSize: 18)),
// // //             const SizedBox(height: 8),
// // //             Text("NIP: ${user['nipBaru']}"),
// // //             const SizedBox(height: 20),
// // //             const Divider(),
// // //             const Text("Token Anda:", style: TextStyle(fontWeight: FontWeight.bold)),
// // //             const SizedBox(height: 8),
// // //             SelectableText(token, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// import 'package:flutter/material.dart';
// import 'package:absensi_pegawai/pages/home_pages.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nipController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   final String baseUrl = 'http://192.168.1.84:8000';

//   @override
//   void dispose() {
//     _nipController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       final nip = _nipController.text.trim();
//       final password = _passwordController.text.trim();

//       try {
//         final response = await http.post(
//           Uri.parse('$baseUrl/api/login'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({'nipBaru': nip, 'password': password}),
//         );

//         final data = jsonDecode(response.body);

//         if (response.statusCode == 200) {
//           final token = data['token'];
//           final userData = data['user'];

//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', token);
//           await prefs.setString('user', jsonEncode(userData));

//           if (!mounted) return;
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => HomePages(user: {}, token: '',),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(data['message'] ?? 'Login gagal')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Gagal terhubung ke server')),
//         );
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFFFAE00), Color(0xFFF9E866)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children:[
//                       Image.asset(
//                         'assets/images/logo.png',
//                         height: 100,
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Aplikasi Absensi',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       TextFormField(
//                         controller: _nipController,
//                         decoration: InputDecoration(
//                           labelText: 'NIP',
//                           prefixIcon: const Icon(Icons.person_outline),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'NIP tidak boleh kosong';
//                           }
//                           if (value.length < 8) {
//                             return 'NIP minimal 8 karakter';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                         ),
//                         obscureText: _obscurePassword,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Password tidak boleh kosong';
//                           }
//                           if (value.length < 6) {
//                             return 'Password minimal 6 karakter';
//                           }
//                           return null;
//                         },
//                       ),
//                       // const SizedBox(height: 8),
//                       // Align(
//                       //   alignment: Alignment.centerRight,
//                       //   child: TextButton(
//                       //     onPressed: () {
//                       //       ScaffoldMessenger.of(context).showSnackBar(
//                       //         const SnackBar(
//                       //           content: Text('Fitur lupa password belum tersedia'),
//                       //         ),
//                       //       );
//                       //     },
//                       //     child: const Text('Lupa Password?'),
//                       //   ),
//                       // ),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _login,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFFEBA17),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 5,
//                           ),
//                           child: _isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   'MASUK',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:absensi_pegawai/pages/home_pages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // final String baseUrl = 'http://192.168.1.100:8000';
  final String baseUrl = 'http://127.0.0.1:8000';

  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final nip = _nipController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'nipBaru': nip, 'password': password}),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final token = data['token'];

          // Simpan token DAN NIP ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('nipBaru', nip); // Simpan NIP

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePages(token: token),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login gagal')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal terhubung ke server')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFAE00), Color(0xFFF9E866)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Aplikasi Absensi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nipController,
                        decoration: InputDecoration(
                          labelText: 'NIP',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIP tidak boleh kosong';
                          }
                          if (value.length < 8) {
                            return 'NIP minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEBA17),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'MASUK',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
