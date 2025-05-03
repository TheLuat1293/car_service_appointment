import 'dart:io';
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
        setState(() {
          avatarUrl = pickedFile.path;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chọn ảnh: $e')),
      );
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GridView.builder(
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
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(value as IconData, color: Colors.white, size: 30),
                      );
                      onTapAction = () {
                        _pickImage(option['action'] as ImageSource);
                      };
                    } else if (type == 'asset') {
                      final isSelected = avatarUrl == value;
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
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      );
                      onTapAction = () {
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
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: content,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng chỉnh sửa thông tin chưa được cài đặt.'),
      ),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng đổi mật khẩu chưa được cài đặt.'),
      ),
    );
  }

  void _viewHistory() {
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                // It's generally better to replace the stack than just push
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()), // Use const if StartScreen allows
                      (Route<dynamic> route) => false, // Remove all previous routes
                );
              },
              child: const Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

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
            const SizedBox(height: 54),
            _buildActionsCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    ImageProvider<Object> backgroundImage;

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('images/')) {
        backgroundImage = AssetImage(avatarUrl!);
      } else {
        try {
          backgroundImage = FileImage(File(avatarUrl!));
        } catch (e) {
          print("Error loading file image: $e. Falling back to default.");
          backgroundImage = AssetImage(defaultAvatarAsset);
        }
      }
    } else {
      backgroundImage = AssetImage(defaultAvatarAsset);
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 68,
                backgroundImage: backgroundImage,
                onBackgroundImageError: (exception, stackTrace) {
                  print("Error loading CircleAvatar background: $exception");
                },
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _changeAvatar,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }


  Widget _buildActionsCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.edit_outlined,
              title: "Chỉnh sửa thông tin",
              onTap: _editProfile,
              theme: theme,
            ),
            const Divider(indent: 16, endIndent: 16),
            _buildListTile(
              icon: Icons.lock_outline,
              title: "Đổi mật khẩu",
              onTap: _changePassword,
              theme: theme,
            ),
            const Divider(indent: 16, endIndent: 16),
            _buildListTile(
              icon: Icons.history_outlined,
              title: "Lịch sử đặt lịch",
              onTap: _viewHistory,
              theme: theme,
            ),
            const Divider(indent: 16, endIndent: 16),
            _buildListTile(
              icon: Icons.exit_to_app,
              title: "Đăng xuất",
              onTap: _logout,
              theme: theme,
              isDestructive: true,
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
    final color =
    isDestructive ? theme.colorScheme.error : theme.colorScheme.primary;
    final textStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color:
      isDestructive
          ? theme.colorScheme.error
          : theme.textTheme.bodyLarge?.color,
    );

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: textStyle),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        const Positioned(
          top: 55,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Tài khoản",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}