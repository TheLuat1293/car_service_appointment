import 'package:car_service_appointment/screens/booking_2_screen.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final String locationName;

  const BookingScreen({super.key, required this.locationName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = "";

  final List<String> availableTimes = [
    "8:00 AM",
    "8:30 AM",
    "9:00 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "12:00 PM",
    "12:30 PM",
    "1:00 PM",
    "2:00 PM",
    "3:30 PM",
    "4:00 PM",
  ];

  final Map<String, String> locationAddresses = {
    "Trụ sở chính": "68B Nguyễn Hữu Thọ, Tân Hưng, Quận 7, TP.HCM",
    "Chi nhánh 1": "1260 Lê Văn Lương, Phước Kiển, Nhà Bè, TP.HCM",
  };

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String locationAddress =
        locationAddresses[widget.locationName] ?? "Địa chỉ của bạn";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đặt lịch dịch vụ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ), // Icon Back
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin địa điểm
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.locationName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            locationAddress,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Chọn ngày
            const Text(
              "Chọn ngày:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.blue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Chọn giờ
            const Text(
              "Chọn giờ:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                // Tính chiều rộng cho mỗi ô để đủ 3 ô mỗi hàng
                double totalSpacing = 10 * 2; // 2 khoảng cách giữa 3 cột
                double itemWidth = (constraints.maxWidth - totalSpacing) / 3;

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableTimes.map((time) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTime = time;
                        });
                      },
                      child: Container(
                        width: itemWidth,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: selectedTime == time ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            if (selectedTime == time)
                              const BoxShadow(
                                color: Colors.blueAccent,
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            time,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectedTime == time ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: selectedTime.isNotEmpty
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Booking2Screen()),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Xác nhận đặt lịch", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}