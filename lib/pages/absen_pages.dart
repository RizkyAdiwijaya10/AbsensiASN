// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';

// class AbsensiPage extends StatefulWidget {
//   const AbsensiPage({super.key});

//   @override
//   State<AbsensiPage> createState() => _AbsensiPageState();
// }

// class _AbsensiPageState extends State<AbsensiPage> {
//   File? _selfieImage;
//   String _currentLocation = 'Mendapatkan lokasi...';
//   bool _isLoadingLocation = false;
//   bool _isLoadingAttendance = false;
//   DateTime? _lastAttendanceTime;

//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _isLoadingLocation = true;
//     });

//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _currentLocation = 'Layanan lokasi tidak aktif';
//         _isLoadingLocation = false;
//       });
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _currentLocation = 'Izin lokasi ditolak';
//           _isLoadingLocation = false;
//         });
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _currentLocation = 'Izin lokasi ditolak permanen';
//         _isLoadingLocation = false;
//       });
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // Here you would typically reverse geocode the coordinates to get an address
//       setState(() {
//         _currentLocation =
//             '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
//         _isLoadingLocation = false;
//       });
//     } catch (e) {
//       setState(() {
//         _currentLocation = 'Gagal mendapatkan lokasi';
//         _isLoadingLocation = false;
//       });
//     }
//   }

//   Future<void> _takeSelfie() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.camera,
//       preferredCameraDevice: CameraDevice.front,
//       imageQuality: 80,
//     );

//     if (image != null) {
//       setState(() {
//         _selfieImage = File(image.path);
//       });
//     }
//   }

//   Future<void> _submitAttendance(String type) async {
//     if (_selfieImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Harap ambil foto selfie terlebih dahulu')),
//       );
//       return;
//     }

//     if (_isLoadingLocation) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Sedang mendapatkan lokasi...')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoadingAttendance = true;
//     });

//     // Simulate API call
//     await Future.delayed(const Duration(seconds: 2));

//     setState(() {
//       _isLoadingAttendance = false;
//       _lastAttendanceTime = DateTime.now();
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Absensi $type berhasil dicatat'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   Widget _buildAttendanceButton(String type, TimeOfDay requiredTime) {
//     final now = TimeOfDay.now();
//     final isAvailable =
//         now.hour >= requiredTime.hour && now.minute >= requiredTime.minute;
//     final isEnabled =
//         isAvailable && _selfieImage != null && !_isLoadingAttendance;

//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isAvailable ? Colors.blue : Colors.grey,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: isEnabled ? () => _submitAttendance(type) : null,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 _getAttendanceIcon(type),
//                 size: 30,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Absen $type',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 '${requiredTime.hour}:${requiredTime.minute.toString().padLeft(2, '0')}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getAttendanceIcon(String type) {
//     switch (type) {
//       case 'Pagi':
//         return Icons.wb_sunny;
//       case 'Siang':
//         return Icons.lunch_dining;
//       case 'Pulang':
//         return Icons.nightlight_round;
//       default:
//         return Icons.access_time;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFEBA17),
//         title: const Text('Absensi', style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Selfie Section
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Foto Selfie',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     GestureDetector(
//                       onTap: _takeSelfie,
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.grey,
//                             width: 1,
//                           ),
//                         ),
//                         child: _selfieImage != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(
//                                   _selfieImage!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.camera_alt,
//                                 size: 50,
//                                 color: Colors.grey,
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _selfieImage == null
//                           ? 'Tekan untuk mengambil foto'
//                           : 'Tekan untuk mengambil foto baru',
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Location Section
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Lokasi Saat Ini',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             _currentLocation,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         if (_isLoadingLocation)
//                           const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         else
//                           IconButton(
//                             icon: const Icon(Icons.refresh),
//                             onPressed: _getCurrentLocation,
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Attendance Buttons
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Absensi Hari Ini',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         _buildAttendanceButton(
//                             'Pagi', const TimeOfDay(hour: 7, minute: 0)),
//                         _buildAttendanceButton(
//                             'Siang', const TimeOfDay(hour: 12, minute: 0)),
//                         _buildAttendanceButton(
//                             'Pulang', const TimeOfDay(hour: 16, minute: 0)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Last Attendance Info
//             if (_lastAttendanceTime != null)
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Absensi Terakhir',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID')
//                             .format(_lastAttendanceTime!),
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// class AbsensiPage extends StatefulWidget {
//   final String nipBaru; // Tambahkan parameter NIP

//   const AbsensiPage({super.key, required this.nipBaru});

//   @override
//   State<AbsensiPage> createState() => _AbsensiPageState();
// }

// class _AbsensiPageState extends State<AbsensiPage> {
//   File? _selfieImage;
//   String _currentLocation = 'Mendapatkan lokasi...';
//   bool _isLoadingLocation = false;
//   bool _isLoadingAttendance = false;
//   DateTime? _lastAttendanceTime;
//   Position? _currentPosition;

//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _isLoadingLocation = true;
//     });

//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _currentLocation = 'Layanan lokasi tidak aktif';
//         _isLoadingLocation = false;
//       });
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _currentLocation = 'Izin lokasi ditolak';
//           _isLoadingLocation = false;
//         });
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _currentLocation = 'Izin lokasi ditolak permanen';
//         _isLoadingLocation = false;
//       });
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         _currentPosition = position;
//         _currentLocation =
//             '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
//         _isLoadingLocation = false;
//       });
//     } catch (e) {
//       setState(() {
//         _currentLocation = 'Gagal mendapatkan lokasi: ${e.toString()}';
//         _isLoadingLocation = false;
//       });
//     }
//   }

//   Future<void> _takeSelfie() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.camera,
//       preferredCameraDevice: CameraDevice.front,
//       imageQuality: 80,
//     );

//     if (image != null) {
//       setState(() {
//         _selfieImage = File(image.path);
//       });
//     }
//   }

//   Future<void> _submitAttendance(String type) async {
//     // Konversi tipe ke format backend
//     String backendType;
//     switch (type) {
//       case 'Pagi':
//         backendType = 'masuk';
//         break;
//       case 'Siang':
//         backendType = 'siang';
//         break;
//       case 'Pulang':
//         backendType = 'pulang';
//         break;
//       default:
//         backendType = type.toLowerCase();
//     }

//     if (_selfieImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Harap ambil foto selfie terlebih dahulu')),
//       );
//       return;
//     }

//     if (_isLoadingLocation || _currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Sedang mendapatkan lokasi...')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoadingAttendance = true;
//     });

//     try {
//       // Buat multipart request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://127.0.0.1:8000/api/absen'),
//       );

//       // Tambahkan headers jika diperlukan
//       // request.headers.addAll({'Authorization': 'Bearer your_token'});

//       // Tambahkan form data
//       request.fields.addAll({
//         'tipe': backendType,
//         'nipBaru': widget.nipBaru,
//         'lat': _currentPosition!.latitude.toString(),
//         'long': _currentPosition!.longitude.toString(),
//       });

//       // Tambahkan file gambar
//       request.files.add(await http.MultipartFile.fromPath(
//         'gambar',
//         _selfieImage!.path,
//         contentType: MediaType('image', 'jpeg'),
//       ));

//       // Kirim request
//       var response = await request.send();
//       final responseBody = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         setState(() {
//           _isLoadingAttendance = false;
//           _lastAttendanceTime = DateTime.now();
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Absensi $type berhasil dicatat'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         setState(() {
//           _isLoadingAttendance = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Gagal: ${response.statusCode} - $responseBody'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoadingAttendance = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Widget _buildAttendanceButton(String type, TimeOfDay requiredTime) {
//     final now = TimeOfDay.now();
//     final isAvailable =
//         now.hour > requiredTime.hour || 
//         (now.hour == requiredTime.hour && now.minute >= requiredTime.minute);
//     final isEnabled =
//         isAvailable && _selfieImage != null && !_isLoadingAttendance;

//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isAvailable ? Colors.blue : Colors.grey,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: isEnabled ? () => _submitAttendance(type) : null,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 _getAttendanceIcon(type),
//                 size: 30,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Absen $type',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 '${requiredTime.hour}:${requiredTime.minute.toString().padLeft(2, '0')}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getAttendanceIcon(String type) {
//     switch (type) {
//       case 'Pagi':
//         return Icons.wb_sunny;
//       case 'Siang':
//         return Icons.lunch_dining;
//       case 'Pulang':
//         return Icons.nightlight_round;
//       default:
//         return Icons.access_time;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFEBA17),
//         title: const Text('Absensi', style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Informasi NIP
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.badge, color: Colors.blue),
//                     const SizedBox(width: 8),
//                     Text(
//                       'NIP: ${widget.nipBaru}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Selfie Section
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Foto Selfie',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     GestureDetector(
//                       onTap: _takeSelfie,
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.grey,
//                             width: 1,
//                           ),
//                         ),
//                         child: _selfieImage != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(
//                                   _selfieImage!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.camera_alt,
//                                 size: 50,
//                                 color: Colors.grey,
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _selfieImage == null
//                           ? 'Tekan untuk mengambil foto'
//                           : 'Tekan untuk mengambil foto baru',
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Location Section
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Lokasi Saat Ini',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             _currentLocation,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         if (_isLoadingLocation)
//                           const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         else
//                           IconButton(
//                             icon: const Icon(Icons.refresh),
//                             onPressed: _getCurrentLocation,
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Attendance Buttons
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Absensi Hari Ini',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         _buildAttendanceButton(
//                             'Pagi', const TimeOfDay(hour: 7, minute: 0)),
//                         _buildAttendanceButton(
//                             'Siang', const TimeOfDay(hour: 12, minute: 0)),
//                         _buildAttendanceButton(
//                             'Pulang', const TimeOfDay(hour: 16, minute: 0)),
//                       ],
//                     ),
//                     if (_isLoadingAttendance)
//                       const Padding(
//                         padding: EdgeInsets.only(top: 16),
//                         child: CircularProgressIndicator(),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Last Attendance Info
//             if (_lastAttendanceTime != null)
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Absensi Terakhir',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID')
//                             .format(_lastAttendanceTime!),
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AbsensiPage extends StatefulWidget {
  final String nipBaru;

  const AbsensiPage({super.key, required this.nipBaru});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  File? _selfieImage;
  String _currentLocation = 'Mendapatkan lokasi...';
  bool _isLoadingLocation = false;
  bool _isLoadingAttendance = false;
  DateTime? _lastAttendanceTime;
  Position? _currentPosition;
  String? _attendanceError;

  final ImagePicker _picker = ImagePicker();
  final String _baseUrl = 'http://192.168.1.100:8000'; // Update with your server URL
  // final String _baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation) return;
    
    setState(() {
      _isLoadingLocation = true;
      _currentLocation = 'Mendapatkan lokasi...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Layanan lokasi tidak aktif';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _currentLocation = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        _attendanceError = null;
      });
    } catch (e) {
      setState(() {
        _currentLocation = 'Gagal: $e';
        _attendanceError = 'Lokasi diperlukan untuk absensi';
      });
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _takeSelfie() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selfieImage = File(image.path);
          _attendanceError = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil foto: $e')),
      );
    }
  }

  String _translateAttendanceType(String type) {
    switch (type) {
      case 'Pagi': return 'masuk';
      case 'Siang': return 'siang';
      case 'Pulang': return 'pulang';
      default: return type.toLowerCase();
    }
  }

  Future<void> _submitAttendance(String type) async {
    if (_selfieImage == null) {
      setState(() => _attendanceError = 'Harap ambil foto selfie terlebih dahulu');
      return;
    }

    if (_isLoadingLocation || _currentPosition == null) {
      setState(() => _attendanceError = 'Sedang mendapatkan lokasi...');
      await _getCurrentLocation();
      if (_currentPosition == null) return;
    }

    setState(() {
      _isLoadingAttendance = true;
      _attendanceError = null;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/absen'),
      );

      request.fields.addAll({
        'tipe': _translateAttendanceType(type),
        'nipBaru': widget.nipBaru,
        'lat': _currentPosition!.latitude.toString(),
        'long': _currentPosition!.longitude.toString(),
      });

      request.files.add(await http.MultipartFile.fromPath(
        'gambar',
        _selfieImage!.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          _lastAttendanceTime = DateTime.now();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Absensi $type berhasil dicatat'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw '${response.statusCode}: $responseBody';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal absen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoadingAttendance = false);
    }
  }

  Widget _buildAttendanceButton(String type, TimeOfDay requiredTime) {
    final now = TimeOfDay.now();
    final isAvailable = now.hour > requiredTime.hour || 
                      (now.hour == requiredTime.hour && now.minute >= requiredTime.minute);
    final isEnabled = isAvailable && _selfieImage != null && 
                     !_isLoadingAttendance && !_isLoadingLocation;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isAvailable ? Colors.blue : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isEnabled ? () => _submitAttendance(type) : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getAttendanceIcon(type),
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                'Absen $type',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${requiredTime.hour}:${requiredTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAttendanceIcon(String type) {
    switch (type) {
      case 'Pagi': return Icons.wb_sunny;
      case 'Siang': return Icons.lunch_dining;
      case 'Pulang': return Icons.nightlight_round;
      default: return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // NIP Card
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge, color: Colors.blue),
                title: const Text('NIP'),
                subtitle: Text(widget.nipBaru),
              ),
            ),
            const SizedBox(height: 16),

            // Selfie Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Foto Selfie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _takeSelfie,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _selfieImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_selfieImage!, fit: BoxFit.cover),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                                  Text('Ambil Foto'),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Location Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lokasi Saat Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_currentLocation)),
                        if (_isLoadingLocation)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _getCurrentLocation,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Attendance Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Absensi Hari Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_attendanceError != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _attendanceError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    Row(
                      children: [
                        _buildAttendanceButton('Pagi', const TimeOfDay(hour: 7, minute: 0)),
                        _buildAttendanceButton('Siang', const TimeOfDay(hour: 12, minute: 0)),
                        _buildAttendanceButton('Pulang', const TimeOfDay(hour: 16, minute: 0)),
                      ],
                    ),
                    if (_isLoadingAttendance)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),

            // Last Attendance
            if (_lastAttendanceTime != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Absensi Terakhir',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID')
                            .format(_lastAttendanceTime!),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}