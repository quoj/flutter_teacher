import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../api/api_service.dart';
import '../../../model/category.dart';
import '../../../models/menu.dart';
import '../../../models/schedule.dart';
import '../../../service/category_service.dart';
import 'package:t2305m_teacher/models/user.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/// 1. BannerSlider: nhận thêm onQrTap
class BannerSlider extends StatelessWidget {
  final VoidCallback onQrTap;
  const BannerSlider({super.key, required this.onQrTap});

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
      padding: const EdgeInsets.all(8), // Giảm padding
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30, // Nhỏ hơn (mặc định là 30)
            backgroundImage: AssetImage('assets/images/teacher.jpg'),
          ),
          const SizedBox(width: 8), // Giảm khoảng cách
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Nguyễn Thị Hồng Anh",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // Nhỏ hơn
              ),
              Text(
                "Giáo viên phụ trách",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Lớp Mầm 1",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            iconSize: 20, // Nhỏ icon
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: onQrTap,
          ),
        ],
      ),
    );
  }

}

/// 2. QRScannerSheet widget
class QRScannerSheet extends StatefulWidget {
  final Function(String) onScanned;
  const QRScannerSheet({super.key, required this.onScanned});

  @override
  State<QRScannerSheet> createState() => _QRScannerSheetState();
}

class _QRScannerSheetState extends State<QRScannerSheet> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanned = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanned) {
        scanned = true;
        widget.onScanned(scanData.code ?? '');
        Navigator.of(context).maybePop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Quét mã QR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.blue,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 200,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text("Đưa mã QR vào khung để quét"),
        ],
      ),
    );
  }
}

/// 3. ProfileScreen hoàn chỉnh
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

  void _showQRScanner() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return QRScannerSheet(
          onScanned: (code) {
            // Xử lý code QR tại đây, ví dụ: show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('QR Đã quét: $code')),
            );
          },
        );
      },
    );
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
              BannerSlider(onQrTap: _showQRScanner), // truyền callback ở đây
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: BulletinWidget(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: ScheduleWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4. BulletinWidget giữ nguyên
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Thực đơn ngày",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuDetailScreen(menus: menus),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 10),
                  child: const Text(
                    "Chi tiết",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (menus.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
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
                                "📅 ${DateFormat('yyyy-MM-dd').format(menu.date)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text("🍳 Bữa sáng: ${menu.breakfast ?? 'Không có'}"),
                              const SizedBox(height: 8),
                              Text("🍛 Bữa trưa: ${menu.lunch ?? 'Không có'}"),
                              const SizedBox(height: 8),
                              Text("🍲 Bữa tối: ${menu.dinner ?? 'Không có'}"),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          else
            const Center(child: Text("Không có thực đơn nào")),
        ],
      ),
    );
  }
}

/// 5. MenuDetailScreen giữ nguyên
class MenuDetailScreen extends StatefulWidget {
  final List<Menu> menus;

  MenuDetailScreen({required this.menus});

  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late List<Menu> menus;
  late List<Menu> filteredMenus;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    menus = widget.menus;
    filteredMenus = menus.where((menu) {
      return DateFormat('yyyy-MM-dd').format(menu.date) == DateFormat('yyyy-MM-dd').format(selectedDate);
    }).toList();
  }

  void selectDay(DateTime day) {
    setState(() {
      selectedDate = day;
      filteredMenus = menus.where((menu) {
        return DateFormat('yyyy-MM-dd').format(menu.date) == DateFormat('yyyy-MM-dd').format(selectedDate);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
    List<DateTime> weekDates = List.generate(7, (index) {
      return selectedDate.subtract(Duration(days: selectedDate.weekday - 1)).add(Duration(days: index));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Thực đơn"),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = weekDates[index];
                return GestureDetector(
                  onTap: () => selectDay(day),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Text(
                          daysOfWeek[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: DateFormat('yyyy-MM-dd').format(day) == DateFormat('yyyy-MM-dd').format(selectedDate)
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM').format(day),
                          style: TextStyle(
                            fontSize: 14,
                            color: DateFormat('yyyy-MM-dd').format(day) == DateFormat('yyyy-MM-dd').format(selectedDate)
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMenus.length,
              itemBuilder: (context, index) {
                final menu = filteredMenus[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
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
                        "📅 ${DateFormat('yyyy-MM-dd').format(menu.date)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("🍳 Bữa sáng: ${menu.breakfast ?? 'Không có'}"),
                      SizedBox(height: 8),
                      Text("🍛 Bữa trưa: ${menu.lunch ?? 'Không có'}"),
                      SizedBox(height: 8),
                      Text("🍲 Bữa tối: ${menu.dinner ?? 'Không có'}"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 6. WeekScheduleWidget giữ nguyên
class WeekScheduleWidget extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  WeekScheduleWidget({required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            DateTime day = DateTime.now().add(Duration(days: index));
            return ListTile(
              title: Text(DateFormat('EEEE, yyyy-MM-dd').format(day)),
              onTap: () {
                onDateSelected(day);
              },
            );
          },
        ),
      ],
    );
  }
}

/// 7. ScheduleWidget giữ nguyên
class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late ApiService apiService;
  List<Schedule> schedulesToday = [];
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
      DateTime today = DateTime.now();
      List<Schedule> todaySchedules = allSchedules.where((schedule) {
        return schedule.startTime.year == today.year &&
            schedule.startTime.month == today.month &&
            schedule.startTime.day == today.day;
      }).toList();

      setState(() {
        schedulesToday = todaySchedules;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  "Hoạt động ngày",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : schedulesToday.isEmpty
                ? const Center(child: Text("Không có hoạt động nào hôm nay"))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: schedulesToday.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final schedule = schedulesToday[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📚 ${schedule.subjectId}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "🕐 ${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}