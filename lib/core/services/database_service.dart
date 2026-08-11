import 'package:docdoc/core/helper_models/doctor_model.dart';

abstract class DatabaseService {
  Future<void> addUserDataToDatabase({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<Map<String, dynamic>?> getUserData({
    required String path,
    required String uid,
  });

  Future<void> addAppointment({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<Map<String, dynamic>?> getAppointmentData({
    required String path,
    required String appointID,
  });

  Future<Map<String, dynamic>?> getEligibleReviewAppointment({
    required String appointmentsPath,
    required String ratingsPath,
    required String userUid,
    required int doctorId,
  });

  /// Returns all appointments for a specific doctor (independent of user).
  Future<List<Map<String, dynamic>>> getAppointmentsByDoctorId({
    required String path,
    required int doctorId,
  });

  /// All appointment rows for the signed-in user (by [userUid] / `user_uid` column).
  Future<List<Map<String, dynamic>>> getAppointmentsForUser({
    required String path,
    required String userUid,
  });

  /// Partial update of an appointment row (e.g. status, times after reschedule).
  Future<void> updateAppointmentById({
    required String path,
    required int id,
    required Map<String, dynamic> data,
  });

  /// Marks all user appointments as `finished` when their end_time has passed.
  Future<void> markPastPendingAppointmentsAsFinishedForUser({
    required String path,
    required String userUid,
  });

  /// Cumulative average (all rows including optional seed) and display review count.
  Future<Map<int, RatingModel>> getDoctorRatingAggregates({
    required String path,
  });

  /// Inserts user rating; on first rating for [doctorId] also inserts the seed row using [displayedSeedRating].
  Future<void> submitDoctorRating({
    required String path,
    required int doctorId,
    required String userUid,
    required int appointmentId,
    required int stars,
    required String reviewText,
    required double displayedSeedRating,
    required int displayedSeedReviewCount,
  });
}
