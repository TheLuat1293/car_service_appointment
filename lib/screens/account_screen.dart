import 'dart:io';
import 'package:car_service_appointment/screens/edit_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_service_appointment/screens/start_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = "Nguyễn Văn A";
  String userEmail = "nguyen@example.com";
  String userDob = '07/08/2002';
  String userPhone = '0821 123 456';
  String userGender = 'Nam';

  String? avatarUrl;
  final String defaultAvatarAsset = 'images/avatar1.png';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (pickedFile != null) {
        if (!mounted) return;
        setState(() {
          avatarUrl = pickedFile.path;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print("Lỗi chọn ảnh: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chọn ảnh: $e')),
      );
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _changeAvatar() async {
    final List<Map<String, dynamic>> gridOptions = [
      {'type': 'icon', 'value': Icons.camera_alt, 'action': ImageSource.camera},
      {'type': 'icon', 'value': Icons.image, 'action': ImageSource.gallery},
      {'type': 'asset', 'value': 'images/avatar1.png'},
      {'type': 'asset', 'value': 'images/avatar2.png'},
      {'type': 'asset', 'value': 'images/avatar3.png'},
      {'type': 'asset', 'value': 'images/avatar4.png'},
      {'type': 'asset', 'value': 'images/avatar5.png'},
      {'type': 'asset', 'value': 'images/avatar6.png'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: gridOptions.length,
              itemBuilder: (context, index) {
                final option = gridOptions[index];
                final type = option['type'];
                final value = option['value'];

                Widget content;
                VoidCallback? onTapAction;

                if (type == 'icon') {
                  content = Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade300)
                    ),
                    child: Icon(value as IconData, color: Colors.blue.shade800, size: 30),
                  );
                  onTapAction = () => _pickImage(option['action'] as ImageSource);
                } else if (type == 'asset') {
                  final bool isSelected = (avatarUrl == value);
                  content = Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          value as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                      if (isSelected)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue, width: 3),
                                color: Colors.black.withOpacity(0.1)
                            ),
                          ),
                        ),
                      if (isSelected)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 14),
                          ),
                        ),
                      if (!isSelected)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300, width: 1)
                          ),
                        )
                    ],
                  );
                  onTapAction = () {
                    if (!mounted) return;
                    setState(() {
                      avatarUrl = value;
                    });
                    Navigator.pop(context);
                  };
                } else {
                  content = const SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: onTapAction,
                  child: AspectRatio(aspectRatio: 1.0, child: content),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAccountScreen(
          initialName: userName,
          initialEmail: userEmail,
          initialDob: userDob,
          initialPhone: userPhone,
          initialGender: userGender,
          initialAvatarPath: avatarUrl ?? defaultAvatarAsset,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (!mounted) return;
      setState(() {
        userName = result['name'] ?? userName;
        userEmail = result['email'] ?? userEmail;
        userDob = result['dob'] ?? userDob;
        userPhone = result['phone'] ?? userPhone;
        userGender = result['gender'] ?? userGender;
      });
    }
  }

  void _changePassword() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng đổi mật khẩu chưa được cài đặt.')),
    );
  }

  void _viewHistory() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng xem lịch sử chưa được cài đặt.')),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Chỉ đóng dialog
              child: const Text("Hủy"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog trước khi điều hướng
                // Xóa toàn bộ stack và đi đến StartScreen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

  // --- Build UI ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildProfileHeader(theme),
            const SizedBox(height: 30), // Giảm khoảng cách một chút
            _buildActionsCard(theme),
            const SizedBox(height: 20), // Thêm khoảng trống cuối trang
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    ImageProvider<Object> backgroundImage;

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      // Kiểm tra xem là asset path hay file path
      if (avatarUrl!.startsWith('images/')) { // Giả sử asset nằm trong thư mục images
        backgroundImage = AssetImage(avatarUrl!);
      } else {
        // Là file path từ image picker
        final file = File(avatarUrl!);
        // Kiểm tra file có tồn tại không phòng trường hợp file tạm bị xóa
        if (file.existsSync()) {
          backgroundImage = FileImage(file);
        } else {
          print("Warning: File ảnh không tồn tại: ${avatarUrl!}. Sử dụng ảnh mặc định.");
          backgroundImage = AssetImage(defaultAvatarAsset); // Fallback nếu file mất
          // Cân nhắc reset avatarUrl về null hoặc defaultAvatarAsset ở đây nếu cần
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if(mounted) setState(() => avatarUrl = null);
          // });
        }
      }
    } else {
      // Không có avatar hoặc avatar là null, dùng ảnh mặc định
      backgroundImage = AssetImage(defaultAvatarAsset);
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4), // Viền gradient
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade300],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: CircleAvatar(
                radius: 68, // Kích thước avatar
                backgroundColor: Colors.grey.shade300, // Màu nền khi ảnh đang tải/lỗi
                backgroundImage: backgroundImage,
                onBackgroundImageError: (exception, stackTrace) {
                  // Xử lý lỗi tải ảnh nền (ví dụ: file bị hỏng)
                  print("Lỗi tải ảnh nền CircleAvatar: $exception");
                  // Có thể hiện ảnh mặc định ở đây nếu muốn
                  // setState(() => avatarUrl = defaultAvatarAsset);
                },
              ),
            ),
            Positioned( // Nút camera để đổi avatar
              right: 4, bottom: 4, // Điều chỉnh vị trí nút camera
              child: GestureDetector(
                onTap: _changeAvatar,
                child: Container(
                  padding: const EdgeInsets.all(8), // Kích thước nút camera
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5), // Viền trắng
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName, // Sử dụng state variable
          style: theme.textTheme.headlineSmall?.copyWith( // Tăng kích thước chữ một chút
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          userEmail, // Sử dụng state variable
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionsCard(ThemeData theme) {
    // Card chứa các hành động
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20), // Tăng margin ngang
      child: Card(
        elevation: 2, // Giảm độ nổi của card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias, // Giúp bo tròn các widget con bên trong
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.edit_outlined, title: "Chỉnh sửa thông tin",
              onTap: _editProfile, theme: theme,
            ),
            const Divider(indent: 16, endIndent: 16, height: 1, thickness: 0.5),
            _buildListTile(
              icon: Icons.lock_outline, title: "Đổi mật khẩu",
              onTap: _changePassword, theme: theme,
            ),
            const Divider(indent: 16, endIndent: 16, height: 1, thickness: 0.5),
            _buildListTile(
              icon: Icons.history_outlined, title: "Lịch sử đặt lịch",
              onTap: _viewHistory, theme: theme,
            ),
            const Divider(indent: 16, endIndent: 16, height: 1, thickness: 0.5),
            _buildListTile(
              icon: Icons.exit_to_app, title: "Đăng xuất",
              onTap: _logout, theme: theme, isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    bool isDestructive = false,
  }) {
    // Widget cho mỗi hàng trong Card
    final color = isDestructive ? theme.colorScheme.error : theme.colorScheme.primary;
    final textStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: isDestructive ? theme.colorScheme.error : theme.textTheme.bodyLarge?.color,
    );

    return ListTile(
      leading: Icon(icon, color: color, size: 22), // Kích thước icon
      title: Text(title, style: textStyle),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
      dense: true, // Làm cho ListTile nhỏ gọn hơn
    );
  }

  Widget _buildHeader() {
    // Header màu xanh phía trên
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 20, right: 20), // Padding
      decoration: BoxDecoration(
        color: Colors.blue.shade700, // Màu đậm hơn
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
        gradient: LinearGradient( // Thêm gradient cho đẹp hơn
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: Text(
          "Tài khoản",
          style: TextStyle(
            fontSize: 26, // Kích thước chữ
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5, // Giãn cách chữ
          ),
        ),
      ),
    );
  }
}