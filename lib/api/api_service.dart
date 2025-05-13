import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../models/announcements.dart';
import '../models/messages.dart';
import '../models/login_request.dart';
import '../models/study_comments.dart';
import '../models/study_results.dart';
import '../models/user.dart';
import '../models/schedule.dart';
import '../models/feedback.dart';
import '../models/tuition.dart';
import '../models/health.dart';
import '../models/images.dart';
import '../models/menu.dart';
import '../models/attendance.dart';
import '../models/leave_requests.dart';
import '../models/comment.dart';
import '../models/students.dart';
import '../models/class_diaries.dart';
import '../models/notification.dart';
import '../models/parents.dart';
import '../models/teachers.dart'; // ✅ Thêm dòng này

part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;



  @GET("/users")
  Future<List<User>> getUsers();

  @POST("/users/login")
  Future<User> loginUser(@Body() LoginRequest loginRequest);

  @GET("/schedules")
  Future<List<Schedule>> getSchedules();

  @GET("/messages")
  Future<List<Message>> getMessage();

  @POST("/messages")
  Future<void> sendMessage(@Body() Message message);

  @GET("/feedbacks")
  Future<List<FeedbackModel>> getFeedback();

  @POST("/feedbacks")
  Future<void> sendFeedback(@Body() Map<String, dynamic> feedbackData);

  @GET("/announcements")
  Future<List<Announcement>> getAnnouncements();

  @POST("/announcements")
  Future<void> createAnnouncement(@Body() Announcement announcement);

  @GET("/study_comments")
  Future<List<StudyComment>> getStudyComment();

  @GET("/study_results")
  Future<List<StudyResult>> getStudyResult();

  @GET("/tuitions")
  Future<List<Tuition>> getTuitions();

  @GET("/health")
  Future<List<Health>> getHealth();

  @GET("/images")
  Future<List<Images>> getImages();

  @GET("/menus")
  Future<List<Menu>> getMenus();

  @GET("/menus/by-date")
  Future<Menu?> getMenuByDate(@Query("date") String date);

  @GET("/attendance")
  Future<List<Attendance>> getAttendances();

  @GET("/attendance/{id}")
  Future<Attendance> getAttendanceById(@Path("id") int id);

  @POST("/attendance")
  Future<Attendance> createAttendance(@Body() Attendance attendance);

  @PUT("/attendance/{id}/status")
  Future<Attendance> updateAttendanceStatus(
      @Path("id") int id,
      @Query("status") String status,
      );

  @DELETE("/attendance/{id}")
  Future<void> deleteAttendance(@Path("id") int id);

  @GET("/leave_requests")
  Future<List<LeaveRequest>> getLeaveRequests();

  @GET("/leave_requests/{id}")
  Future<LeaveRequest> getLeaveRequestById(@Path("id") int id);

  @POST("/leave_requests")
  Future<LeaveRequest> createLeaveRequest(@Body() LeaveRequest leaveRequest);

  @PUT("/leave_requests/{id}/status")
  Future<LeaveRequest> updateLeaveRequestStatus(
      @Path("id") int id,
      @Query("status") String status,
      );

  @DELETE("/leave_requests/{id}")
  Future<void> deleteLeaveRequest(@Path("id") int id);

  @GET("/comments/announcement/{id}")
  Future<List<Comment>> getCommentsByAnnouncementId(@Path("id") int id);

  @POST("/comments")
  Future<Comment> createComment(@Body() Comment comment);

  @GET("/students")
  Future<List<Student>> getStudents();

  @GET("/class_diaries")
  Future<List<ClassDiary>> getClassDiaries();

  @GET("/class_diaries/{id}")
  Future<ClassDiary> getClassDiaryById(@Path("id") int id);

  @POST("/class_diaries")
  Future<ClassDiary> createClassDiary(@Body() ClassDiary classDiary);

  @GET("/notifications")
  Future<List<Notification>> getNotifications();

  @GET("/notifications/{id}")
  Future<Notification> getNotificationById(@Path("id") int id);

  @POST("/notifications")
  Future<Notification> createNotification(@Body() Notification notification);

  @PUT("/notifications/{id}")
  Future<Notification> updateNotification(@Path("id") int id, @Body() Notification notification);

  @DELETE("/notifications/{id}")
  Future<void> deleteNotification(@Path("id") int id);

  @GET("/parents")
  Future<List<Parent>> getParents();

  // 🔸 Các endpoint cho giáo viên
  @GET("/teachers")
  Future<List<Teacher>> getTeachers();

  @GET("/teachers/{id}")
  Future<Teacher> getTeacherById(@Path("id") int id);

  @POST("/teachers")
  Future<Teacher> createTeacher(@Body() Teacher teacher);

  @PUT("/teachers/{id}")
  Future<Teacher> updateTeacher(@Path("id") int id, @Body() Teacher teacher);

  @DELETE("/teachers/{id}")
  Future<void> deleteTeacher(@Path("id") int id);
}