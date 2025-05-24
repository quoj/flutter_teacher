import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../api/api_service.dart';
import '../../models/program.dart';
import 'dart:convert';   // thêm trên đầu file search_screen.dart

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Dio _dio = Dio();
  late ApiService _apiService;

  List<Program> programs = []; // Thay đổi từ students sang programs
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(_dio);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final programResponse = await _apiService.getPrograms(); // Gọi API lấy chương trình
      if (mounted) {
        setState(() {
          programs = programResponse;
        });
      }
    } catch (e) {
      debugPrint("Error fetching programs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = programs; // Bạn có thể thêm logic lọc ở đây nếu cần

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo "),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final program = filteredList[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                program.programName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (program.programDescription != null)
                    Text("Mô tả: ${program.programDescription}"),
                  if (program.tuition != null)
                    Text("Học phí: \$${program.tuition}"),
                  if (program.totalSessions != null)
                    Text("Tổng số buổi: ${program.totalSessions}"),
                ],
              ),
              trailing: const Icon(Icons.info, color: Colors.grey),
              onTap: () {
                // TODO: Thêm chức năng chi tiết chương trình
              },
            ),
          );
        },
      ),
    );
  }
}