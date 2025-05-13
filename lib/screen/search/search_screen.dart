import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../api/api_service.dart';
import '../../models/parents.dart';
import '../../models/teachers.dart'; // ✅ Thêm import Teacher model

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Dio _dio = Dio();
  late ApiService _apiService;

  List<Parent> parents = [];
  List<Teacher> teachers = []; // ✅ Đổi kiểu sang List<Teacher>
  String searchQuery = "";
  bool isTeacherSelected = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(_dio);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final parentResponse = await _apiService.getParents();
      final teacherResponse = await _apiService.getTeachers(); // ✅ Gọi API giáo viên

      setState(() {
        parents = parentResponse;
        teachers = teacherResponse;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = isTeacherSelected
        ? teachers.where((t) => t.name.toLowerCase().contains(searchQuery.toLowerCase())).toList()
        : parents.where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh bạ"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Tìm kiếm",
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTeacherSelected = true;
                  });
                },
                child: const Text("Giáo viên"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTeacherSelected = false;
                  });
                },
                child: const Text("Phụ huynh"),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (isTeacherSelected) {
                  final teacher = filteredList[index] as Teacher;
                  return ListTile(
                    title: Text(teacher.name),
                    trailing: Text(teacher.phone ?? "Chưa có số"),
                  );
                } else {
                  final parent = filteredList[index] as Parent;
                  return ListTile(
                    title: Text(parent.name),
                    subtitle: parent.studentId != null ? Text("Học sinh: ${parent.studentId}") : null,
                    trailing: Text(parent.phone ?? "Chưa có số"),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
