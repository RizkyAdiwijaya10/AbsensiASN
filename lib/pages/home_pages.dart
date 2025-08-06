// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:absensi_pegawai/pages/profil_pages.dart';
// import 'package:absensi_pegawai/pages/absen_pages.dart';
// import 'package:absensi_pegawai/pages/izin_pages.dart';
// import 'package:absensi_pegawai/pages/statistik_pages.dart';
// import 'package:absensi_pegawai/pages/riwayat_pages.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';

// class HomePages extends StatefulWidget {
//   final String token;

//   const HomePages({super.key, required this.token});

//   @override
//   State<HomePages> createState() => _HomePagesState();
// }

// class _HomePagesState extends State<HomePages> {
//   Map<String, dynamic> user = {};
//   bool isLoading = true;
//   String errorMessage = '';
//   String currentTime = '';
//   String currentDate = '';

//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting();
//     _fetchUserData();
//     _updateTime();
//   }

//   void _updateTime() {
//     setState(() {
//       currentTime = DateFormat.Hm().format(DateTime.now());
//       currentDate =
//           DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());
//     });
//     Future.delayed(const Duration(seconds: 1), _updateTime);
//   }

//   Future<void> _fetchUserData() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://192.168.1.100:8000/api/user'),
//         // Uri.parse('http://127.0.0.1:8000/api/user'),
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           user = data;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Gagal memuat data pengguna: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Terjadi kesalahan: $e';
//       });
//     }
//   }

//   String getFullNameWithTitles() {
//     final gelarDepan = user['gelarDepan'] ?? '';
//     final gelarBelakang = user['gelarBelakang'] ?? '';
//     final username = user['username'] ?? '';

//     return '$gelarDepan $username $gelarBelakang'.trim();
//   }

//   Widget _buildProfileImage() {
//     if (isLoading) {
//       return const CircleAvatar(
//         radius: 50,
//         child: CircularProgressIndicator(),
//       );
//     }

//     // Get image URL from API response
//     final imageUrl = user['gambar'] as String?;

//     if (imageUrl == null || imageUrl.isEmpty) {
//       return const CircleAvatar(
//         radius: 50,
//         child: Icon(Icons.person, size: 40),
//       );
//     }

//     return CachedNetworkImage(
//       imageUrl: imageUrl,
//       imageBuilder: (context, imageProvider) => CircleAvatar(
//         radius: 50,
//         backgroundImage: imageProvider,
//       ),
//       placeholder: (context, url) => const CircleAvatar(
//         radius: 50,
//         child: CircularProgressIndicator(),
//       ),
//       errorWidget: (context, url, error) => const CircleAvatar(
//         radius: 50,
//         child: Icon(Icons.error),
//       ),
//       httpHeaders: {
//         'Authorization': 'Bearer ${widget.token}',
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : errorMessage.isNotEmpty
//                 ? Center(child: Text(errorMessage))
//                 : Column(
//                     children: [
//                       _buildHeaderProfil(context),
//                       _buildDateTimeInfo(),
//                       _buildMainMenu(context),
//                     ],
//                   ),
//       ),
//     );
//   }

//   Widget _buildHeaderProfil(BuildContext context) {
//     return Container(
//       height: 275,
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color(0xFFE45D0B),
//             Color(0xFFFFDE59),
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfilPage(user: user)),
//               );
//             },
//             child: _buildProfileImage(),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             getFullNameWithTitles(),
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             user['nip'] ?? 'NIP tidak tersedia',
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             user['jabatan'] ?? 'Jabatan tidak tersedia',
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             user['dinas'] ?? 'Dinas tidak tersedia',
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             user['unor'] ?? 'Unit Organisasi tidak tersedia',
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ... (keep the rest of your existing methods unchanged)
//   Widget _buildDateTimeInfo() {
//     return Container(
//       margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 currentDate,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 currentTime,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 'Jam Masuk: 07:30',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'Jam Pulang: 16:00',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainMenu(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   _buildMenuCard(
//                     icon: Icons.fingerprint,
//                     title: 'Absensi',
//                     color: Colors.blue,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const AbsensiPage(
//                                 nipBaru: '',
//                               )),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   _buildMenuCard(
//                     icon: Icons.assignment_outlined,
//                     title: 'Izin',
//                     color: Colors.orange,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const IzinPage()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 15),
//             Expanded(
//               child: Row(
//                 children: [
//                   _buildMenuCard(
//                     icon: Icons.bar_chart,
//                     title: 'Statistik',
//                     color: Colors.green,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const StatistikPage()),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   _buildMenuCard(
//                     icon: Icons.history,
//                     title: 'Riwayat',
//                     color: Colors.purple,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const RiwayatPage()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuCard({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: color),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 40, color: color),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:absensi_pegawai/pages/profil_pages.dart';
import 'package:absensi_pegawai/pages/absen_pages.dart';
import 'package:absensi_pegawai/pages/izin_pages.dart';
import 'package:absensi_pegawai/pages/statistik_pages.dart';
import 'package:absensi_pegawai/pages/riwayat_pages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class HomePages extends StatefulWidget {
  final String token;

  const HomePages({super.key, required this.token});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  Map<String, dynamic> user = {};
  bool isLoading = true;
  String errorMessage = '';
  String currentTime = '';
  String currentDate = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _fetchUserData();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      currentTime = DateFormat.Hm().format(now);
      currentDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
    });
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        // Uri.parse('http://192.168.1.100:8000/api/user'),
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          user = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Gagal memuat data pengguna: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      });
    }
  }

  String getFullNameWithTitles() {
    final gelarDepan = user['gelarDepan']?.toString().trim() ?? '';
    final gelarBelakang = user['gelarBelakang']?.toString().trim() ?? '';
    final username = user['username']?.toString().trim() ?? '';

    return [gelarDepan, username, gelarBelakang]
        .where((part) => part.isNotEmpty)
        .join(' ');
  }

  Widget _buildProfileImage() {
    if (isLoading) {
      return const CircleAvatar(
        radius: 50,
        child: CircularProgressIndicator(),
      );
    }

    final imageUrl = user['gambar']?.toString();

    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 40, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: Icon(Icons.error, color: Colors.red),
      ),
      httpHeaders: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : Column(
                    children: [
                      _buildHeaderProfil(context),
                      _buildDateTimeInfo(),
                      _buildMainMenu(context),
                    ],
                  ),
      ),
    );
  }

  Widget _buildHeaderProfil(BuildContext context) {
    return Container(
      height: 275,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE45D0B),
            Color(0xFFFFDE59),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilPage(user: user),
                ),
              );
            },
            child: _buildProfileImage(),
          ),
          const SizedBox(height: 10),
          Text(
            getFullNameWithTitles(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            user['nip']?.toString() ?? 'NIP tidak tersedia',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            user['jabatan']?.toString() ?? 'Jabatan tidak tersedia',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            user['dinas']?.toString() ?? 'Dinas tidak tersedia',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            user['unor']?.toString() ?? 'Unit Organisasi tidak tersedia',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  currentDate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                currentTime,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Jam Masuk: 07:30',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                'Jam Pulang: 16:00',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildMenuCard(
                    icon: Icons.fingerprint,
                    title: 'Absensi',
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AbsensiPage(
                          nipBaru: user['nip']?.toString() ?? '',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  _buildMenuCard(
                    icon: Icons.assignment_outlined,
                    title: 'Izin',
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IzinPage()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Row(
                children: [
                  _buildMenuCard(
                    icon: Icons.bar_chart,
                    title: 'Statistik',
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StatistikPage()),
                    ),
                  ),
                  const SizedBox(width: 15),
                  _buildMenuCard(
                    icon: Icons.history,
                    title: 'Riwayat',
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RiwayatPage()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}