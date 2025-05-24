import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t2305m_teacher/screen/cart/cart_screen.dart';
import 'package:t2305m_teacher/screen/home/home_screen.dart';
import 'package:t2305m_teacher/screen/profile/profile_screen.dart';
import 'package:t2305m_teacher/screen/search/search_screen.dart';
import 'package:t2305m_teacher/screen/home/ui/feature_products.dart';
import 'package:t2305m_teacher/models/students.dart';
import 'package:t2305m_teacher/models/attendance.dart';
import 'package:t2305m_teacher/api/api_service.dart';

import 'models/attendance.dart';

class RootPage extends StatefulWidget {
  final bool isAdmin;
  const RootPage({super.key, this.isAdmin = false});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> screens = [
    ProfileScreen(),
    SearchScreen(),
    HomeScreen(),
    CartScreen(),
  ];


  int _selectedIndex = 0;
  bool showAttendance = false;

  late ApiService apiService;
  List<Student> students = [];
  List<Attendance> attendances = [];
  bool isLoading = true;
  String? loadError;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
  }









  /* ---------------- API ---------------- */
  Future<void> fetchStudents() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });
    try {
      students = await apiService.getStudents();
      // In ra thông tin học sinh để kiểm tra



      for (var student in students) {
        print('ID: ${student.id}, Name: ${student.name}, Attendance Status312412414224: ${student.attendanceStatus}');
      }
    } catch (e) {
      loadError = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAttendance() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });
    try {
      attendances = await apiService.getAttendances();
      // In ra thông tin học sinh để kiểm tra
      for (var attendances in attendances) {
        print('Attendance Status1231212312: $attendances');
      }
    } catch (e) {
      loadError = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /* ---------------- UI helpers ---------------- */
  Icon _buildStatusIcon(AttendanceStatus? status) {
    switch (status) {
      case AttendanceStatus.present:
        return const Icon(Icons.check_circle, color: Colors.green);
      case AttendanceStatus.absent:
        return const Icon(Icons.cancel, color: Colors.red);
      case AttendanceStatus.excused:
        return const Icon(Icons.info, color: Colors.orange);
      case AttendanceStatus.unmarked:
        return const Icon(Icons.help_outline, color: Colors.grey);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  Color _statusColor(AttendanceStatus? status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.excused:
        return Colors.orange;
      case AttendanceStatus.unmarked:
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  String _statusText(AttendanceStatus? status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Có mặt';
      case AttendanceStatus.absent:
        return 'Vắng';
      case AttendanceStatus.excused:
        return 'Có phép';
      case AttendanceStatus.unmarked:
        return 'Chưa chấm';
      default:
        return 'Không rõ';
    }
  }

  /* ---------------- Attendance Screen ---------------- */
  Widget buildAttendanceScreen()  {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (loadError != null) {
      return Center(child: Text('Lỗi: $loadError'));
    }
    if (students.isEmpty) {
      return const Center(child: Text('Không có dữ liệu điểm danh'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bảng điểm danh')),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final s = students[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _statusColor(s.attendanceStatus),
              child: _buildStatusIcon(s.attendanceStatus),
            ),
            title: Text(s.name ?? 'Không tên'),
              subtitle: Text('Mã HS: ${s.id} | Trạng thái: ${_statusText(s.attendanceStatus)}'),

          );
        },
      ),
    );
  }


  /* ---------------- Navigation ---------------- */
  void changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
      showAttendance = false;
    });
  }

  void navigateToFeatureProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeatureProductsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showAttendance ? buildAttendanceScreen() : screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black54,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) async {
            if (index == 2) {
              await fetchStudents();
              setState(() {
                showAttendance = true;
              });
            } else if (index == 4) {
              navigateToFeatureProducts();
            } else {
              changeScreen(index);
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: AssetImage('assets/images/teacher.jpg'),
                radius: 15,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.addressBook),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF00C2CB), Color(0xFF0074B7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.check_circle, color: Colors.white),
              ),
              label: '',
            ),
            if (!widget.isAdmin)
              const BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: '',
              ),
            const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.ellipsisH),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}