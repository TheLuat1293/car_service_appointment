import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Booking2Screen extends StatefulWidget {
  const Booking2Screen({super.key});

  @override
  State<Booking2Screen> createState() => _Booking2ScreenState();
}

class _Booking2ScreenState extends State<Booking2Screen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedService;

  void _resetFields() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _carYearController.clear();
      _plateController.clear();
      _noteController.clear();
      _addressController.clear();
      _selectedBrand = null;
      _selectedModel = null;
      _selectedService = null;
    });
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedBrand == null ||
        _selectedModel == null ||
        _selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập đầy đủ thông tin cần thiết!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text("Đặt lịch thành công!", style: TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options, String? selectedValue, void Function(String?) onChanged, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: isRequired ? '$label (*)' : label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10), // Adjusted padding
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
          ),
          iconSize: 24,
        ),
        value: selectedValue,
        items: options.isEmpty
            ? [DropdownMenuItem(enabled: false, child: Text("Chọn ${label.toLowerCase()} trước"))]
            : options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(); // Quay lại trang trước
        return false; // Không thoát app
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Đặt Lịch Dịch Vụ", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Nhập thông tin chi tiết của bạn",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // 🟢 Thông tin cá nhân
                _buildCard("Thông tin cá nhân", [
                  _buildTextField("Họ và tên", "vd: Nguyễn Văn A", _nameController),
                  _buildTextField("Email", "vd: nguyenvana@gmail.com", _emailController, keyboardType: TextInputType.emailAddress),
                  _buildTextField("Số điện thoại", "vd: 0879121567", _phoneController, keyboardType: TextInputType.phone),
                  _buildTextField("Địa chỉ", "vd: 123 đường ABC, Quận 1", _addressController),
                ]),

                // 🚗 Thông tin xe
                _buildCard("Thông tin xe", [
                  Row(
                    children: [
                      Expanded(child: _buildDropdownField("Hãng xe", ["Toyota", "Honda", "Ford"], _selectedBrand, (value) => setState(() => _selectedBrand = value))),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdownField("Dòng xe", ["Camry", "Civic", "Ranger"], _selectedModel, (value) => setState(() => _selectedModel = value))),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Đời xe", "vd: 2025", _carYearController, keyboardType: TextInputType.number)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildTextField("Biển số xe", "vd: 59A-999.99", _plateController)),
                    ],
                  ),
                ]),

                // 🛠 Dịch vụ
                _buildDropdownField("Dịch vụ", [
                  "Khoang dưỡng động cơ",
                  "Bảo dưỡng nội thất",
                  "Bảo dưỡng định kỳ",
                  "Sơn dặm vá xe",
                  "Sửa chữa điện lạnh"
                ], _selectedService, (value) => setState(() => _selectedService = value)),

                _buildTextField("Ghi chú", "vd: Xe không khởi động được", _noteController),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _resetFields,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                        child: const Text("Hủy"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                        child: const Text("Xác nhận"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}
