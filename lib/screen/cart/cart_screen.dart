import 'package:flutter/material.dart';
import 'package:t2305m_teacher/api/api_service.dart';
import 'package:dio/dio.dart';
import '../../../models/announcements.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Announcement> announcements = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    setState(() => isLoading = true);
    try {
      ApiService apiService = ApiService(Dio());
      List<Announcement> data = await apiService.getAnnouncements();
      setState(() {
        announcements = data;
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
          : announcements.isEmpty
          ? const Center(child: Text('Không có ngoại khóa nào'))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: announcements.length,
        itemBuilder: (context, index) => _buildAnnouncementCard(announcements[index]),
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(announcement.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(announcement.content),
            const SizedBox(height: 5),
            Text('Tác giả: ${announcement.author}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 5),
            announcement.imagePath.isNotEmpty
                ? Image.network(
              announcement.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
