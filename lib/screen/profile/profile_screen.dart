import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../api/api_service.dart';
import '../../../model/category.dart';
import '../../../models/menu.dart';
import '../../../models/schedule.dart';
import '../../../models/user.dart';
import '../../../service/category_service.dart';

/// 1. BannerSlider
class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Ảnh minh họa khác hoặc icon
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/teacher.jpg'), // đổi ảnh khác nếu có
          ),
          const SizedBox(width: 16),
          // Thay phần text thông tin thành slogan hoặc thông điệp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Giáo Viên Mầm Non",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}


/// 2. ProfileScreen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final categoryService = CategoryService();
    final fetchedCategories = await categoryService.getCategories();
    setState(() {
      categories = fetchedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BannerSlider(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const BulletinWidget(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const ScheduleWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3. BulletinWidget
class BulletinWidget extends StatefulWidget {
  const BulletinWidget({super.key});

  @override
  _BulletinWidgetState createState() => _BulletinWidgetState();
}

class _BulletinWidgetState extends State<BulletinWidget> {
  late ApiService apiService;
  List<Menu> menus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchMenus();
  }

  void fetchMenus() async {
    try {
      List<Menu> data = await apiService.getMenus();
      setState(() {
        menus = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching menus: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: 450,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Chỉ giữ lại tiêu đề "Thực đơn ngày", xóa phần "Chi tiết"
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                "Thực đơn ngày",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (menus.isNotEmpty)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  final String dayOfWeek = menu.dayOfWeek ?? 'Không rõ';

                  return Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$dayOfWeek",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text("🍳 Bữa Sáng: ${menu.breakfast ?? 'Không có'}"),
                        const SizedBox(height: 8),
                        Text("🍳 Bữa Sáng Phụ: ${menu.secondBreakfast ?? 'Không có'}"),
                        const SizedBox(height: 8),
                        Text("🍛 Bữa Trưa: ${menu.lunch ?? 'Không có'}"),
                        const SizedBox(height: 8),
                        Text("🍲 Bữa Chiều: ${menu.dinner ?? 'Không có'}"),
                        const SizedBox(height: 8),
                        Text("🍲 Bữa Chiều Phụ: ${menu.secondDinner ?? 'Không có'}"),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            const Center(child: Text("Không có thực đơn nào")),
        ],
      ),
    );
  }
}




/// 5. ScheduleWidget
class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late ApiService apiService;
  List<Schedule> schedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchSchedules();
  }

  void fetchSchedules() async {
    try {
      List<Schedule> allSchedules = await apiService.getSchedules();
      setState(() {
        schedules = allSchedules;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy lịch học: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Lịch học hôm nay",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (schedules.isEmpty)
            Center(
              child: Text(
                "Không có lịch học hôm nay",
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            )
          else
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: schedules.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 3,
                  shadowColor: Colors.deepOrangeAccent.withOpacity(0.2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Có thể xử lý sự kiện nhấn vào lịch học nếu muốn
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📚 ${schedule.subjectId}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 18, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                "${schedule.startTime} - ${schedule.endTime}",
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          if (schedule.teacherId != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.person, size: 18, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Giáo viên ID: ${schedule.teacherId}",
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}