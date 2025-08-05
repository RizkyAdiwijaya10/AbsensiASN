import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absensi',  style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFEBA17),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterSection(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceHistory.length,
                itemBuilder: (context, index) {
                  return _buildAttendanceCard(attendanceHistory[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: 'Juli 2023',
            decoration: InputDecoration(
              labelText: 'Bulan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: <String>['Juni 2023', 'Juli 2023', 'Agustus 2023']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: 'Semua Status',
            decoration: InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: <String>['Semua Status', 'Hadir', 'Terlambat', 'Izin', 'Sakit']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {},
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(AttendanceRecord record) {
    Color statusColor;
    switch (record.status) {
      case 'Hadir':
        statusColor = Colors.green;
        break;
      case 'Terlambat':
        statusColor = Colors.orange;
        break;
      case 'Izin':
        statusColor = Colors.blue;
        break;
      case 'Sakit':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(record.date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    record.status,
                    style: TextStyle(color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (record.status == 'Hadir' || record.status == 'Terlambat')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeInfo('Masuk', record.checkIn),
                  _buildTimeInfo('Pulang', record.checkOut),
                  _buildTimeInfo('Total', record.workDuration),
                ],
              ),
            if (record.status == 'Izin' || record.status == 'Sakit')
              Text(
                'Keterangan: ${record.notes}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String? time) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          time ?? '-',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class AttendanceRecord {
  final DateTime date;
  final String status;
  final String? checkIn;
  final String? checkOut;
  final String? workDuration;
  final String? notes;

  AttendanceRecord({
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.workDuration,
    this.notes,
  });
}

final List<AttendanceRecord> attendanceHistory = [
  AttendanceRecord(
    date: DateTime.now().subtract(const Duration(days: 1)),
    status: 'Hadir',
    checkIn: '07:45',
    checkOut: '16:10',
    workDuration: '8 jam 25 menit',
  ),
  AttendanceRecord(
    date: DateTime.now().subtract(const Duration(days: 2)),
    status: 'Terlambat',
    checkIn: '08:15',
    checkOut: '16:30',
    workDuration: '8 jam 15 menit',
  ),
  AttendanceRecord(
    date: DateTime.now().subtract(const Duration(days: 3)),
    status: 'Hadir',
    checkIn: '07:30',
    checkOut: '16:00',
    workDuration: '8 jam 30 menit',
  ),
  AttendanceRecord(
    date: DateTime.now().subtract(const Duration(days: 4)),
    status: 'Izin',
    notes: 'Acara keluarga',
  ),
  AttendanceRecord(
    date: DateTime.now().subtract(const Duration(days: 5)),
    status: 'Sakit',
    notes: 'Demam tinggi',
  ),
  AttendanceRecord(
    date: DateTime.now().subtract(const Duration(days: 6)),
    status: 'Hadir',
    checkIn: '07:50',
    checkOut: '16:05',
    workDuration: '8 jam 15 menit',
  ),
];