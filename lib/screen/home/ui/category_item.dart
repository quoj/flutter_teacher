import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:t2305m_teacher/api/api_service.dart';
import 'package:t2305m_teacher/models/feedback.dart';
import 'package:t2305m_teacher/models/schedule.dart';
import 'package:t2305m_teacher/models/messages.dart';
import 'package:t2305m_teacher/models/tuition.dart';
import 'package:t2305m_teacher/models/health.dart';
import 'package:t2305m_teacher/models/menu.dart';
import 'package:t2305m_teacher/models/attendance.dart';
import 'package:t2305m_teacher/models/class_diaries.dart';
import 'package:t2305m_teacher/models/students.dart';
import 'package:t2305m_teacher/models/leave_requests.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:t2305m_teacher/model/category.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../models/study_comments.dart';
import '../../../models/study_results.dart';
import '../../../models/images.dart';
import 'category_item.dart' as _tabController;

class CategoryItem extends StatelessWidget {
  final Category category;
  final int imageIndex;

  const CategoryItem({
    super.key,
    required this.category,
    required this.imageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrls = [
      "assets/images/be.jpg",
      "assets/images/loinhan.jpg",
      "assets/images/nhatky.jpg",
    ];

    final imageLabels = [
      "Điểm danh",
      "Lời nhắn",
      "Nhật ký lớp",
    ];

    final pages = [
      AttendancePage(),
      MessagePage(),
      ClassDiaryPage(),
    ];

    final imageUrl = imageUrls[imageIndex % imageUrls.length];
    final imageLabel = imageLabels[imageIndex % imageLabels.length];
    final targetPage = pages[imageIndex % pages.length];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Column(
        children: [
          Image.asset(
            imageUrl,
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            imageLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Các trang mẫu


class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late ApiService apiService;
  List<Attendance> attendances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio(), baseUrl: "http://10.0.2.2:8080");
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await apiService.getAttendances();
      setState(() {
        attendances = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching attendance data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Điểm danh", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : attendances.isEmpty
          ? const Center(
        child: Text(
          "Không có dữ liệu điểm danh.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          final a = attendances[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: a.status == "present"
                      ? Colors.green.shade100
                      : a.status == "absent"
                      ? Colors.red.shade100
                      : Colors.orange.shade100,
                  radius: 28,
                  child: Icon(
                    a.status == "present"
                        ? Icons.check_circle
                        : a.status == "absent"
                        ? Icons.cancel
                        : Icons.access_time,
                    size: 32,
                    color: a.status == "present"
                        ? Colors.green
                        : a.status == "absent"
                        ? Colors.red
                        : Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📅 Ngày: ${DateFormat('dd/MM/yyyy').format(a.date)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "🟢 Trạng thái: ${_translateStatus(a.status)}",
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'present':
        return 'Có mặt';
      case 'absent':
        return 'Vắng mặt';
      default:
        return 'Không có phép';
    }
  }
}





// MessagesPage
class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late ApiService apiService;
  List<Message> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchMessages();
  }

  void fetchMessages() async {
    try {
      List<Message> data = await apiService.getMessage();
      setState(() {
        messages = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void confirmMessage(Message message) async {
    try {
      final updatedMessage = message.copyWith(status: "Đã xác nhận");
      await apiService.sendMessage(updatedMessage);
      fetchMessages(); // Refresh lại danh sách
    } catch (e) {
      print("Lỗi khi xác nhận tin nhắn: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi khi gửi xác nhận!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lời nhắn")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : messages.isEmpty
            ? const Center(child: Text("Không có lời nhắn nào."))
            : ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            Message message = messages[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.createdAt.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        message.status,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (message.imagePath != null &&
                      message.imagePath!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.network(
                        message.imagePath!.startsWith("http")
                            ? message.imagePath!
                            : "http://10.0.2.2:8080${message.imagePath!}",
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    message.status == "Đã xác nhận"
                        ? "Tin nhắn đã xác nhận"
                        : "Tin nhắn chưa xác nhận",
                    style: const TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  if (message.status == "Chưa xác nhận")
                    Align(
                      alignment: Alignment.centerRight,

                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



class ClassDiaryPage extends StatelessWidget {
  const ClassDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gọi API để lấy danh sách nhật ký lớp
    return FutureBuilder<List<ClassDiary>>(
      future: _fetchClassDiaries(), // Hàm gọi API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có dữ liệu nhật ký lớp'));
        } else {
          // Hiển thị tất cả dữ liệu nhật ký lớp
          return Scaffold(
            appBar: AppBar(
              title: const Text("Nhật ký lớp"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: snapshot.data!.map((diaryData) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "📅 Nhật ký lớp ngày: ${diaryData.date}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "🎯 Hoạt động chung:",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(diaryData.activities),

                            const SizedBox(height: 16),
                            Text(
                              "😊 Tâm trạng của cả lớp:",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(diaryData.mood),

                            const SizedBox(height: 16),
                            Text(
                              "🩺 Sức khỏe chung:",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(diaryData.healthStatus),

                            const SizedBox(height: 16),
                            Text(
                              "📝 Ghi chú từ giáo viên:",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(diaryData.teacherNote),

                            const SizedBox(height: 16),
                            if (diaryData.imagePath != null)
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    diaryData.imagePath!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, size: 50),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(), // Duyệt qua tất cả các bản ghi và tạo widget cho mỗi bản ghi
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Hàm gọi API để lấy nhật ký lớp
  Future<List<ClassDiary>> _fetchClassDiaries() async {
    final dio = Dio();
    final apiService = ApiService(dio);
    try {
      return await apiService.getClassDiaries(); // Gọi API để lấy danh sách nhật ký lớp
    } catch (e) {
      throw Exception("Lỗi khi lấy dữ liệu nhật ký lớp: $e");
    }
  }
}



