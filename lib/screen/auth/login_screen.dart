import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:t2305m_teacher/root_page.dart';
import '../../api/api_service.dart';
import '../../models/login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _StateLogin createState() => _StateLogin();
}

class _StateLogin extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hidePassword = true;

  bool isAdmin = false; // Thêm biến này để xác định quyền admin

  Future<void> login(String email, String password) async {
    final dio = Dio();
    final apiService = ApiService(dio);

    try {
      final user = await apiService.loginUser(LoginRequest(email: email, password: password));
      print("Đăng nhập thành công: ${user.name}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RootPage()),
      );
    } on DioException catch (e) {
      String errorMsg = "Lỗi đăng nhập không xác định";

      // Kiểm tra các loại lỗi từ Dio
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = "Kết nối hết thời gian. Kiểm tra lại mạng!";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = "Máy chủ không phản hồi kịp!";
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.statusCode == 403) {
          errorMsg = "Bạn không có quyền truy cập vào tài nguyên này (403)";
        } else if (e.response?.statusCode == 401) {
          errorMsg = "Thông tin đăng nhập không hợp lệ (401)";
        } else {
          errorMsg = "Lỗi từ máy chủ: ${e.response?.statusCode}";
        }
      } else if (e.error is SocketException) {
        errorMsg = "Không thể kết nối máy chủ. Kiểm tra mạng hoặc IP.";
      }

      // Hiển thị lỗi chi tiết
      showError(errorMsg);
    } catch (e) {
      showError("Lỗi không mong muốn: $e");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16.0)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Baby",
                      style: TextStyle(
                        color: Color(0xFFFF4880),
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Care",
                      style: TextStyle(
                        color: Color(0xFF4D65F9),
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  login(emailController.text.trim(), passwordController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}