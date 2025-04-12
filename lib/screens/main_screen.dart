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

  // Hàm xử lý khi nhấn vào item trên BottomNavigationBar
  void _onItemTapped(int index) {
    // Nếu nhấn vào tab đang được chọn VÀ tab đó có màn hình con (có thể pop)
    if (_currentIndex == index && _navigatorKeys[index].currentState!.canPop()) {
      // Pop về màn hình gốc (đầu tiên) của tab đó
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    }
    // Nếu nhấn vào một tab khác
    else if (_currentIndex != index) {
      setState(() {
        _currentIndex = index; // Chuyển sang tab mới
      });
      // Không cần popUntil ở đây khi chuyển tab, vì Offstage/IndexedStack quản lý state
    }
  }

  // Hàm trợ giúp để build màn hình gốc cho từng tab dựa trên index
  Widget _buildScreenByIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const HistoryScreen();
      case 2:
        return const AccountScreen();
      default:
      // Trường hợp không mong muốn, trả về container trống
        return Container(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng WillPopScope để chặn sự kiện back của hệ thống
    return WillPopScope(
      onWillPop: () async {
        // Lấy NavigatorState của tab hiện tại đang được chọn
        final NavigatorState? currentNavigator =
            _navigatorKeys[_currentIndex].currentState;

        // Kiểm tra xem Navigator của tab hiện tại có tồn tại và có thể pop không
        if (currentNavigator != null && currentNavigator.canPop()) {
          // Nếu có thể pop (tức là đang ở màn hình con trong tab đó, ví dụ BookingScreen)
          currentNavigator.pop(); // Thực hiện pop màn hình con đó
          // Trả về false để ngăn WillPopScope này tiếp tục xử lý (không thoát app)
          return false;
        } else {
          // Nếu không thể pop (đang ở màn hình gốc của tab)
          // thì hiển thị hộp thoại xác nhận thoát ứng dụng
          bool? shouldExit = await showDialog<bool>( // Sử dụng kiểu bool?
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
          // Nếu dialog bị đóng mà không chọn (shouldExit là null), coi như không thoát (false)
          // Trả về true nếu người dùng chọn "Có", ngược lại trả về false
          return shouldExit ?? false;
        }
      },
      child: Scaffold(
        body: Stack(
          // Sử dụng Stack + Offstage hoặc IndexedStack để quản lý các tab
          // Offstage ẩn các tab không hoạt động nhưng giữ state của Navigator
          children: List.generate(3, (index) {
            return Offstage(
              offstage: _currentIndex != index, // Chỉ hiển thị tab hiện tại
              child: Navigator(
                // Gán key tương ứng cho Navigator của mỗi tab
                key: _navigatorKeys[index],
                // Quan trọng: Sử dụng onGenerateRoute để định nghĩa màn hình gốc
                onGenerateRoute: (routeSettings) {
                  // Tạo MaterialPageRoute cho màn hình gốc của tab này
                  return MaterialPageRoute(
                    builder: (context) => _buildScreenByIndex(index),
                    settings: routeSettings, // Giữ lại route settings
                  );
                  // Lưu ý: Chỉ cần xử lý route gốc ở đây.
                  // Các màn hình con (như BookingScreen) sẽ được push vào Navigator này
                  // từ bên trong màn hình gốc (ví dụ: từ HomeScreen).
                },
              ),
            );
          }),
          // Bạn cũng có thể dùng IndexedStack thay cho Stack + Offstage:
          // body: IndexedStack(
          //   index: _currentIndex,
          //   children: List.generate(3, (index) {
          //      return Navigator(
          //         key: _navigatorKeys[index],
          //         onGenerateRoute: (routeSettings) {
          //           return MaterialPageRoute(
          //             builder: (context) => _buildScreenByIndex(index),
          //              settings: routeSettings,
          //           );
          //         },
          //      );
          //   }),
          // ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home), // Icon khi được chọn
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