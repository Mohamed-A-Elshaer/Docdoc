import 'package:dartz/dartz.dart';
import 'package:docdoc/core/errors/exceptions.dart';
import 'package:docdoc/core/errors/failures.dart';
import 'package:docdoc/core/services/supabase_auth_service.dart';
import 'package:docdoc/features/auth/data/models/user_model.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImp extends AuthRepo{
  final SupabaseAuthService supabaseAuthService;
  AuthRepoImp({required this.supabaseAuthService});
  @override
  Future<Either<Failures, UserEntity>> signUpUser(String email, String password) async{
 try {
   var user= await supabaseAuthService.signUpUser(email: email, password: password);
   return right(UserModel.fromSupabaseUser(user));
 } on CustomException catch (e) {
   print(e);
  return left(ServerFailures(e.message));
 } catch(e){
   print(e);
   return left(ServerFailures('An error occured. Please try again later.'));

 }
  }
  

}