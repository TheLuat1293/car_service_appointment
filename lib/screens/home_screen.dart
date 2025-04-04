import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 80),
          const Text(
            "Chọn địa điểm sửa chữa",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.white,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          appoinment(
            imageUrl: "images/quan7.jpg",
            name: "Trụ sở chính",
            location: "68B Nguyễn Hữu Thọ, Tân Hưng, Quận 7 - HCM",
          ),
          appoinment(
            imageUrl: "images/nhabe.jpg",
            name: "Chi nhánh 1",
            location: "1260 Lê Văn Lương, Xã Phước Kiển, Huyện Nhà Bè - HCM",
          ),
          appoinment(
            imageUrl: "images/your_location.jpg",
            name: "Sửa chữa tại nhà",
            location: "Địa chỉ của bạn",
          ),
        ],
      ),
    );
  }

  Widget appoinment({
    required String imageUrl,
    required String name,
    required String location,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              imageUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
