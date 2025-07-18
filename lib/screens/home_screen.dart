import 'package:car_service_appointment/screens/booking_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> locations = [
    {
      "image": "images/quan7.jpg",
      "name": "Trụ sở chính",
      "distance": "0.5 km",
      "rating": "4.7",
      "reviews": "1,018",
      "tag": "Đặt ngay",
    },
    {
      "image": "images/nhabe.jpg",
      "name": "Chi nhánh 1",
      "distance": "0.5 km",
      "rating": "4.7",
      "reviews": "1,018",
      "tag": "Đặt ngay",
    },
    {
      "image": "images/your_location.jpg",
      "name": "Địa điểm của bạn",
      "distance": "0.5 km",
      "rating": "4.7",
      "reviews": "1,018",
      "tag": "Đặt ngay",
    },
  ];
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    filteredLocations = locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: filteredLocations.map((location) => locationCard(location)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Header với tiêu đề & thanh tìm kiếm
  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Thanh Phong Auto",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Thanh tìm kiếm
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      filteredLocations = locations.where((location) {
                        final name = location["name"].toString().toLowerCase();
                        return name.contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm địa điểm",
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget locationCard(Map<String, dynamic> location) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BookingScreen(locationName: location["name"]),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                location["image"],
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location["name"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.green,
                      ),
                      Text(location["distance"]),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text("${location["rating"]} (${location["reviews"]})"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
