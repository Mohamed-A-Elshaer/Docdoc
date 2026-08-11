import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_service.dart';

class SupabaseDatabaseService implements DatabaseService {
  static DateTime? _parseAppointmentDateTime(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    try {
      return DateTime.parse(raw);
    } catch (_) {}
    try {
      return DateFormat('EEEE, MMMM d, yyyy h:mm a').parse(raw);
    } catch (_) {}
    try {
      return DateFormat('yyyy-MM-dd HH:mm').parse(raw);
    } catch (_) {}
    return null;
  }

  @override
  Future<void> addUserDataToDatabase({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    // Use upsert so we can create or update the same record by uid
    await Supabase.instance.client.from(path).upsert(data, onConflict: 'uid');
  }

  @override
  Future<Map<String, dynamic>?> getUserData({
    required String path,
    required String uid,
  }) async {
    final response = await Supabase.instance.client
        .from(path)
        .select()
        .eq('uid', uid)
        .maybeSingle();
    if (response == null) {
      return null;
    }
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<void> addAppointment({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await Supabase.instance.client
        .from(path)
        .upsert(data, onConflict: 'api_appointment_id');
  }

  @override
  Future<Map<String, dynamic>?> getAppointmentData(
      {required String path, required String appointID}) async {
    final response = await Supabase.instance.client
        .from(path)
        .select()
        .eq('api_appointment_id', appointID)
        .maybeSingle();
    if (response == null) {
      return null;
    }
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<Map<String, dynamic>?> getEligibleReviewAppointment({
    required String appointmentsPath,
    required String ratingsPath,
    required String userUid,
    required int doctorId,
  }) async {
    final client = Supabase.instance.client;

    // Reuse shared transition logic (pending -> finished for overdue rows).
    // This keeps review flow as a fallback trigger even if login-time update missed.
    await markPastPendingAppointmentsAsFinishedForUser(
      path: appointmentsPath,
      userUid: userUid,
    );

    final response = await client
        .from(appointmentsPath)
        .select('id, user_uid, api_doctor_id, end_time, status')
        .eq('user_uid', userUid)
        .eq('api_doctor_id', doctorId);

    final rows = (response as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final finishedRows = rows.where((row) {
      final status = row['status']?.toString().trim().toLowerCase() ?? '';
      return status == 'finished';
    }).toList();
    if (finishedRows.isEmpty) return null;

    final appointmentIds = finishedRows
        .map((row) => row['id'])
        .map((id) => id is int ? id : int.tryParse(id.toString()))
        .whereType<int>()
        .toList();
    if (appointmentIds.isEmpty) return null;

    final ratingsResponse = await client
        .from(ratingsPath)
        .select('appointment_id')
        .inFilter('appointment_id', appointmentIds);

    final ratedAppointmentIds = (ratingsResponse as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((row) => row['appointment_id'])
        .map((id) => id is int ? id : int.tryParse(id.toString()))
        .whereType<int>()
        .toSet();

    Map<String, dynamic>? eligibleRow;
    DateTime? eligibleEndTime;
    for (final row in finishedRows) {
      final rowId = row['id'];
      final rowIdInt = rowId is int ? rowId : int.tryParse(rowId.toString());
      if (rowIdInt == null || ratedAppointmentIds.contains(rowIdInt)) continue;

      final endTime = _parseAppointmentDateTime(row['end_time']);
      if (eligibleRow == null) {
        eligibleRow = row;
        eligibleEndTime = endTime;
        continue;
      }
      if (endTime != null &&
          (eligibleEndTime == null || endTime.isAfter(eligibleEndTime))) {
        eligibleRow = row;
        eligibleEndTime = endTime;
      }
    }

    return eligibleRow;
  }

  @override
  Future<List<Map<String, dynamic>>> getAppointmentsByDoctorId({
    required String path,
    required int doctorId,
  }) async {
    final response = await Supabase.instance.client.from(path).select();
    final list = response as List;

    // Filter by doctor id in Dart to be robust against column type differences
    return list.map((e) => Map<String, dynamic>.from(e as Map)).where((row) {
      final raw = row['api_doctor_id'];
      if (raw == null) return false;
      final parsed = int.tryParse(raw.toString());
      return parsed == doctorId;
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getAppointmentsForUser({
    required String path,
    required String userUid,
  }) async {
    final response = await Supabase.instance.client
        .from(path)
        .select()
        .eq('user_uid', userUid)
        .order('start_time', ascending: false);

    final list = response as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> updateAppointmentById({
    required String path,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    await Supabase.instance.client.from(path).update(data).eq('id', id);
  }

  @override
  Future<void> markPastPendingAppointmentsAsFinishedForUser({
    required String path,
    required String userUid,
  }) async {
    final client = Supabase.instance.client;
    final response = await client
        .from(path)
        .select('id, end_time, status')
        .eq('user_uid', userUid);

    final rows = (response as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final now = DateTime.now();
    for (final row in rows) {
      final rowId = row['id'];
      final rowIdInt = rowId is int ? rowId : int.tryParse(rowId.toString());
      if (rowIdInt == null) continue;

      final status = row['status']?.toString().trim().toLowerCase() ?? '';
      if (status != 'pending') continue;

      final endTime = _parseAppointmentDateTime(row['end_time']);
      if (endTime == null) continue;

      if (!now.isBefore(endTime)) {
        await client
            .from(path)
            .update({'status': 'finished'}).eq('id', rowIdInt);
      }
    }
  }

  @override
  Future<Map<int, RatingModel>> getDoctorRatingAggregates({
    required String path,
  }) async {
    final response = await Supabase.instance.client
        .from(path)
        .select('api_doctor_id, rating, user_uid, reviews_count, created_at');

    final rows = (response as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final Map<int, List<Map<String, dynamic>>> byDoctor = {};
    for (final row in rows) {
      final id = row['api_doctor_id'];
      final doctorId = id is int ? id : int.tryParse(id.toString());
      if (doctorId == null) continue;
      byDoctor.putIfAbsent(doctorId, () => []).add(row);
    }

    final Map<int, RatingModel> result = {};
    for (final entry in byDoctor.entries) {
      final list = entry.value;
      double sum = 0;
      int userReviewCount = 0;
      DateTime? latestCreatedAt;
      int latestReviewsCount = 0;
      for (final r in list) {
        final s = r['rating'];
        final ratingVal =
            s is num ? s.toDouble() : double.tryParse(s.toString()) ?? 0;
        sum += ratingVal;
        final uid = r['user_uid'];
        final isSeed = uid == null;
        if (!isSeed) userReviewCount++;

        final createdAt = DateTime.tryParse(r['created_at']?.toString() ?? '');
        if (createdAt == null) continue;
        if (latestCreatedAt == null || createdAt.isAfter(latestCreatedAt)) {
          latestCreatedAt = createdAt;
          final rawCount = r['reviews_count'];
          latestReviewsCount = rawCount is int
              ? rawCount
              : int.tryParse(rawCount?.toString() ?? '') ?? 0;
        }
      }
      if (list.isEmpty) continue;
      final avg = sum / list.length;
      result[entry.key] = RatingModel.fromAggregate(
        average: avg,
        userReviewCount:
            latestCreatedAt == null ? userReviewCount : latestReviewsCount,
      );
    }
    return result;
  }

  @override
  Future<void> submitDoctorRating({
    required String path,
    required int doctorId,
    required String userUid,
    required int appointmentId,
    required int stars,
    required String reviewText,
    required double displayedSeedRating,
    required int displayedSeedReviewCount,
  }) async {
    final client = Supabase.instance.client;

    final existingForDoctor = await client
        .from(path)
        .select('id, user_uid, reviews_count, created_at')
        .eq('api_doctor_id', doctorId);

    final rows = (existingForDoctor as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final hasAnyRating = rows.isNotEmpty;

    final double seedRating = displayedSeedRating.clamp(1.0, 5.0).toDouble();
    final seedReviewsCount =
        displayedSeedReviewCount < 0 ? 0 : displayedSeedReviewCount;
    DateTime? latestCreatedAt;
    int latestReviewsCount = 0;
    for (final row in rows) {
      final createdAt = DateTime.tryParse(row['created_at']?.toString() ?? '');
      if (createdAt == null) continue;
      if (latestCreatedAt == null || createdAt.isAfter(latestCreatedAt)) {
        latestCreatedAt = createdAt;
        final raw = row['reviews_count'];
        latestReviewsCount =
            raw is int ? raw : int.tryParse(raw?.toString() ?? '') ?? 0;
      }
    }
    if (latestCreatedAt == null && rows.isNotEmpty) {
      final raw = rows.last['reviews_count'];
      latestReviewsCount =
          raw is int ? raw : int.tryParse(raw?.toString() ?? '') ?? 0;
    }
    final nextReviewsCount =
        (hasAnyRating ? latestReviewsCount : seedReviewsCount) + 1;
    final userRatingInt = stars.clamp(1, 5);

    final existingAppointmentRating = await client
        .from(path)
        .select('id')
        .eq('appointment_id', appointmentId)
        .maybeSingle();
    if (existingAppointmentRating != null) {
      throw Exception(
          'Feedback has already been submitted for this appointment.');
    }

    // First real rating for this doctor: seed row (user_uid null) + user row.
    if (!hasAnyRating) {
      await client.from(path).insert({
        'api_doctor_id': doctorId,
        'user_uid': null,
        'appointment_id': null,
        'rating': seedRating,
        'reviews_count': seedReviewsCount,
        'review': null,
        'is_edited': false,
      });
      await client.from(path).insert({
        'api_doctor_id': doctorId,
        'user_uid': userUid,
        'appointment_id': appointmentId,
        'rating': userRatingInt,
        'reviews_count': nextReviewsCount,
        'review': reviewText.isEmpty ? null : reviewText,
        'is_edited': false,
      });
      return;
    }

    await client.from(path).insert({
      'api_doctor_id': doctorId,
      'user_uid': userUid,
      'appointment_id': appointmentId,
      'rating': userRatingInt,
      'reviews_count': nextReviewsCount,
      'review': reviewText.isEmpty ? null : reviewText,
      'is_edited': false,
    });
  }
}
