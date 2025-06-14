import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Booking {
  final String brand;
  final String model;
  final String service;
  final String plate;
  final DateTime date;

  Booking({
    required this.brand,
    required this.model,
    required this.service,
    required this.plate,
    required this.date,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Booking> allBookings = [
    Booking(
      brand: 'Toyota',
      model: 'Camry',
      service: 'Bảo dưỡng nội thất',
      plate: '59A-123.45',
      date: DateTime(2024, 12, 1),
    ),
    Booking(
      brand: 'Honda',
      model: 'Civic',
      service: 'Sơn dặm vá xe',
      plate: '51G-678.90',
      date: DateTime(2025, 1, 15),
    ),
    Booking(
      brand: 'Ford',
      model: 'Ranger',
      service: 'Bảo dưỡng định kỳ',
      plate: '60C-999.88',
      date: DateTime(2025, 2, 5),
    ),
  ];

  String? selectedService;

  @override
  Widget build(BuildContext context) {
    List<Booking> filteredBookings =
        selectedService == null
            ? allBookings
            : allBookings.where((b) => b.service == selectedService).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch Sử Dịch Vụ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DropdownButtonFormField2<String>(
              value: selectedService,
              decoration: InputDecoration(
                labelText: "Lọc theo trạng thái",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.filter_list),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("Tất cả"),
                ),
                ...allBookings
                    .map((e) => e.service)
                    .toSet()
                    .map(
                      (service) => DropdownMenuItem(
                        value: service,
                        child: Text(service),
                      ),
                    ),
              ],
              onChanged: (value) {
                setState(() => selectedService = value);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                filteredBookings.isEmpty
                    ? const Center(
                      child: Text(
                        'Không có lịch sử phù hợp.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: const Icon(
                              Icons.car_repair,
                              size: 32,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              '${booking.brand} ${booking.model}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('Dịch vụ: ${booking.service}'),
                                Text('Biển số: ${booking.plate}'),
                                Text(
                                  'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(booking.date)}',
                                ),
                              ],
                            ),
                            trailing: TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context, booking);
                              },
                              label: const Text(
                                "Đặt lại",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
