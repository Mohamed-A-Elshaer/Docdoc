import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:docdoc/core/errors/exceptions.dart';
import 'package:docdoc/core/errors/failures.dart';
import 'package:docdoc/core/generated/backend_endpoint.dart';
import 'package:docdoc/core/services/database_service.dart';
import 'package:docdoc/core/services/supabase_auth_service.dart';
import 'package:docdoc/features/auth/data/models/user_model.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImp extends AuthRepo{
  final SupabaseAuthService supabaseAuthService;
  final DatabaseService databaseService;
  AuthRepoImp({required this.supabaseAuthService,required this.databaseService});
  @override
  Future<Either<Failures, UserEntity>> signUpUser(String email, String password) async{
    User? user;
 try {
    user= await supabaseAuthService.signUpUser(email: email, password: password);
   var userEntity=UserModel.fromSupabaseUser(user);
   await addUserDataToDatabase(user: userEntity);
   return right(userEntity);
 } on CustomException catch (e) {
   //print(e);
   if (user!=null) {
     await supabaseAuthService.deleteUser(userId: user.id);
   }  
  return left(ServerFailures(e.message));
 } catch(e){
   if (user!=null) {
     await supabaseAuthService.deleteUser(userId: user.id);
   }
   log('Exception in AuthRepoImp.signUpUser: ${e.toString()}');
   return left(ServerFailures('An error occured. Please try again later.'));

 }
  }

  @override
  Future<Either<Failures, UserEntity>> signInUser(String email, String password) async{
 try {
  var user= await supabaseAuthService.signInUser(email: email, password: password);
  final userData = await databaseService.getUserData(
      path: BackendEndpoint.addUserData,
      uid: user.id,
  );
  if (userData != null) {
    return right(UserModel.fromMap(userData));
  }
  return right(UserModel.fromSupabaseUser(user));
 } on CustomException catch (e) {
   //print(e);
  return left(ServerFailures(e.message));
 } catch(e){
   log('Exception in AuthRepoImp.signInUser: ${e.toString()}');
   return left(ServerFailures('An error occured. Please try again later.'));
 }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithGoogle() async{
     try {
       var user= await supabaseAuthService.signInWithGoogle();
      final userData = await databaseService.getUserData(
          path: BackendEndpoint.addUserData,
          uid: user.id,
      );
      if (userData != null) {
        return right(UserModel.fromMap(userData));
      }
      return right(UserModel.fromSupabaseUser(user));
     } catch(e){
       log('Exception in AuthRepoImp.signInWithGoogle: ${e.toString()}');
       return left(ServerFailures('An error occured. Please try again later.'));
     }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithFacebook() async {
    try {
      var user = await supabaseAuthService.signInWithFacebook();
      final userData = await databaseService.getUserData(
          path: BackendEndpoint.addUserData,
          uid: user.id,
      );
      if (userData != null) {
        return right(UserModel.fromMap(userData));
      }
      return right(UserModel.fromSupabaseUser(user));
    } catch (e) {
      log('Exception in AuthRepoImp.signInWithFacebook: ${e.toString()}');
      return left(ServerFailures('An error occured. Please try again later.'));
    }
  }

  @override
  Future addUserDataToDatabase({required UserEntity user}) async{
    await databaseService.addUserDataToDatabase(path: BackendEndpoint.addUserData, data: user.toMap());
  }

  @override
  Future<Either<Failures, UserEntity>> submitProfile({required UserEntity user}) async {
    try {
      await databaseService.addUserDataToDatabase(path: BackendEndpoint.addUserData, data: user.toMap());
      return right(user);
    } on CustomException catch (e) {
      return left(ServerFailures(e.message));
    } catch (e) {
      log('Exception in AuthRepoImp.submitProfile: ${e.toString()}');
      return left(ServerFailures('An error occured. Please try again later.'));
    }
  }

}