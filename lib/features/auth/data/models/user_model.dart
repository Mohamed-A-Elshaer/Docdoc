import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity{
  UserModel({required super.email,required super.uid});

  factory UserModel.fromSupabaseUser(User user){
    return UserModel(
        email: user.email??'',
        uid: user.id);
  }
}