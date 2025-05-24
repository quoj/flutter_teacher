import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../api/api_service.dart';
import '../../models/students.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Dio _dio = Dio();
  late ApiService _apiService;

  List<Student> students = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(_dio);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final studentResponse = await _apiService.getStudents(); // Lấy dữ liệu học sinh
      setState(() {
        students = studentResponse;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh bạ học sinh"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: students.isEmpty
          ? const Center(child: Text("Không có học sinh nào"))
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: students.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                student.name ?? 'Chưa có tên',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Địa chỉ: ${student.address ?? 'Chưa có địa chỉ'}"),
                  Text("Số điện thoại bố: ${student.phoneDad ?? 'Chưa có số'}"),
                  Text("Số điện thoại mẹ: ${student.phoneMom ?? 'Chưa có số'}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
