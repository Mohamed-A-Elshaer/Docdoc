import 'package:dartz/dartz.dart';
import 'package:docdoc/core/errors/failures.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepo{
  static final SupabaseClient supabase = Supabase.instance.client;

  Future<Either<Failures, UserEntity>> signUpUser(String email,String password);
  Future<Either<Failures, UserEntity>> signInUser(String email,String password,BuildContext context);
  Future<Either<Failures, UserEntity>> signInWithGoogle();
  Future<Either<Failures, UserEntity>> signInWithFacebook();
  Future addUserDataToDatabase({required UserEntity user});
  Future<Either<Failures, UserEntity>> submitProfile({required UserEntity user});
}