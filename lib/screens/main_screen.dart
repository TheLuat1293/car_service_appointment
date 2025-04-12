import 'package:car_service_appointment/screens/history_screen.dart';
import 'package:car_service_appointment/screens/home_screen.dart';
import 'package:car_service_appointment/screens/account_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // GlobalKeys để truy cập NavigatorState của từng tab
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Key cho tab Home
    GlobalKey<NavigatorState>(), // Key cho tab History
    GlobalKey<NavigatorState>(), // Key cho tab Account
  ];

  void _onItemTapped(int index) {
    if (_currentIndex == index && _navigatorKeys[index].currentState!.canPop()) {
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    }
    else if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
  Widget _buildScreenByIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const HistoryScreen();
      case 2:
        return const AccountScreen();
      default:
        return Container(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState? currentNavigator =
            _navigatorKeys[_currentIndex].currentState;
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
          return false;
        } else {
          bool? shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Xác nhận"),
              content: const Text("Bạn có chắc muốn thoát ứng dụng không?"),
              actions: [
                TextButton(
                  // Trả về false khi nhấn "Không"
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Không"),
                ),
                TextButton(
                  // Trả về true khi nhấn "Có"
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Có"),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: List.generate(3, (index) {
            return Offstage(
              offstage: _currentIndex != index,
              child: Navigator(
                key: _navigatorKeys[index],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => _buildScreenByIndex(index),
                    settings: routeSettings,
                  );
                },
              ),
            );
          }),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Lịch sử',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Hồ sơ của tôi',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped, // Gọi hàm xử lý khi nhấn tab
          type: BottomNavigationBarType.fixed, // Đảm bảo label luôn hiển thị
          showUnselectedLabels: true, // Hiển thị cả label chưa chọn
        ),
      ),
    );
  }
}