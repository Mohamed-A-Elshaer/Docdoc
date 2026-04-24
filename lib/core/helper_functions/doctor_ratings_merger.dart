import 'dart:developer';

import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/core/helper_models/home_specialty_model.dart';
import 'package:docdoc/core/services/database_service.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/core/utils/backend_endpoint.dart';

/// Merges Supabase cumulative ratings into [DoctorModel]s from the REST API.
class DoctorRatingsMerger {
  DoctorRatingsMerger._();

  static Future<List<DoctorModel>> mergeIntoDoctors(
    List<DoctorModel> doctors,
  ) async {
    if (doctors.isEmpty) return doctors;
    try {
      final agg = await getIt<DatabaseService>().getDoctorRatingAggregates(
        path: BackendEndpoint.ratings,
      );
      return doctors.map((d) {
        final r = agg[d.id];
        if (r != null) {
          return d.copyWith(
            ratingModel: RatingModel(
              rate: r.rate,
              count: r.count,
            ),
          );
        }
        return d;
      }).toList();
    } catch (e, st) {
      log('DoctorRatingsMerger.mergeIntoDoctors: $e', stackTrace: st);
      return doctors;
    }
  }

  static Future<List<HomeSpecialtyModel>> mergeIntoHome(
    List<HomeSpecialtyModel> specialties,
  ) async {
    if (specialties.isEmpty) return specialties;
    final allDoctors = <DoctorModel>[];
    for (final s in specialties) {
      allDoctors.addAll(s.doctors);
    }
    final merged = await mergeIntoDoctors(allDoctors);
    final byId = {for (final d in merged) d.id: d};
    return specialties
        .map(
          (s) => HomeSpecialtyModel(
            id: s.id,
            name: s.name,
            doctors: s.doctors.map((d) => byId[d.id] ?? d).toList(),
          ),
        )
        .toList();
  }

  static Future<DoctorModel> mergeSingle(DoctorModel doctor) async {
    final list = await mergeIntoDoctors([doctor]);
    return list.first;
  }
}
