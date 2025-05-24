import 'package:flutter/material.dart';
import 'package:t2305m_teacher/models/user.dart';
import 'package:t2305m_teacher/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:t2305m_teacher/screen/auth/login_screen.dart';

import '../../../models/announcements.dart';
import '../../../models/extracurricular_activity.dart';
import '../../models/program.dart'; // Import model ExtracurricularActivity
import 'dart:convert';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}


class _CartScreenState extends State<CartScreen> {
  String selectedTab = 'Chương trình';
  List<Program> programs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    setState(() => isLoading = true);
    try {
      ApiService apiService = ApiService(Dio());
      List<Program> data = await apiService.getPrograms();
      setState(() {
        programs = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi API: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ngoại khóa')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : programs.isEmpty
          ? const Center(child: Text('Không có chương trình nào'))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: programs.length,
        itemBuilder: (context, index) => _buildProgramCard(programs[index]),
      ),
    );
  }

  Widget _buildProgramCard(Program program) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(program.programName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text(program.programDescription ?? 'Không có mô tả'),
            const SizedBox(height: 5),
            Text(
              'Số buổi học: ${program.totalSessions ?? 'N/A'}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              'Học phí: ${program.tuition != null ? "${program.tuition} VNĐ" : "Miễn phí"}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),
            program.imageBase64 != null && program.imageBase64!.isNotEmpty
                ? Image.memory(
              // Giải mã base64 để hiển thị ảnh
              base64Decode(program.imageBase64!),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : const Text("Không có ảnh"),
          ],
        ),
      ),
    );
  }
}

