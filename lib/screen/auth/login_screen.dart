import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../api/api_service.dart';
import '../../models/login_request.dart';
import 'package:t2305m_teacher/root_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _StateLogin createState() => _StateLogin();
}

class _StateLogin extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hidePassword = true;

  late final ApiService apiService;

  @override
  void initState() {
    super.initState();
    initialization();

    // ✅ Khởi tạo Dio và ApiService chỉ một lần
    final dio = Dio(BaseOptions(
      baseUrl: "http://192.168.1.102:8080/t2305m_flutter/api/users",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    apiService = ApiService(dio);
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  Future<void> login(String email, String password) async {
    try {
      final user = await apiService.loginUser(
        LoginRequest(email: email, password: password),
      );

      if (user != null) {
        if (kDebugMode) {
          print("✅ Đăng nhập thành công: ${user.name}");
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootPage()),
        );
      } else {
        showError("❌ Không có dữ liệu người dùng.");
      }
    } on DioException catch (dioError) {
      String errorMsg;

      if (dioError.type == DioExceptionType.connectionTimeout) {
        errorMsg = "⏱ Kết nối hết thời gian.";
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        errorMsg = "⏱ Máy chủ không phản hồi.";
      } else if (dioError.type == DioExceptionType.badResponse) {
        errorMsg = "❌ Lỗi từ máy chủ: ${dioError.response?.statusCode}";
      } else if (dioError.error is SocketException) {
        errorMsg = "📡 Không thể kết nối máy chủ. Kiểm tra mạng hoặc IP.";
      } else {
        errorMsg = "❗ Lỗi không xác định: ${dioError.message}";
      }

      showError(errorMsg);
    } catch (e) {
      showError("❌ Lỗi không mong muốn: $e");
    }
  }

  void showError(String message) {
    if (kDebugMode) print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16.0)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4D65F9), Color(0xFFFF4880)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "SISAP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                labelText: "SĐT",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                labelText: "Mật khẩu",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
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
                  login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Đăng nhập",
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
