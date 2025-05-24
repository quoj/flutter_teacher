import 'package:flutter/material.dart';
import 'package:t2305m_teacher/screen/auth/login_screen.dart';

class FeatureProductsScreen extends StatelessWidget {
  const FeatureProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thiết lập",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Thay đổi mật khẩu"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Nhóm"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("SISAP dành cho Phụ huynh"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text("Mã bảo vệ"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Thông báo từ MISA"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text("Đánh giá ứng dụng"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Góp ý với nhà phát triển"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Giới thiệu cho bạn"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Thông tin sản phẩm"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Hỗ trợ"),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Đăng xuất"),
              onTap: () {
                // Điều hướng về màn hình đăng nhập
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()), // Thay đổi đường dẫn nếu cần
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}