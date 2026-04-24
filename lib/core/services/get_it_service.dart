import 'package:docdoc/core/services/database_service.dart';
import 'package:docdoc/core/services/supabase_auth_service.dart';
import 'package:docdoc/core/services/supabase_database_Service.dart';
import 'package:docdoc/features/auth/data/repos/auth_repo_imp.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:docdoc/features/bookAppoint/data/repos/booking_repo_imp.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import 'package:get_it/get_it.dart';

final getIt=GetIt.instance;

void setupGetit(){
  getIt.registerSingleton<SupabaseAuthService>(SupabaseAuthService());
  getIt.registerSingleton<DatabaseService>(SupabaseDatabaseService());
  getIt.registerSingleton<AuthRepo>(
      AuthRepoImp(
          supabaseAuthService: getIt<SupabaseAuthService>(),
          databaseService: getIt<DatabaseService>()
      )
  );
  getIt.registerSingleton<BookingRepo>(
      BookingRepoImp(databaseService: getIt<DatabaseService>())
  );
}