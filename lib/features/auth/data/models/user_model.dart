import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity{
  UserModel({
    required super.email,
    required super.uid,
    super.name,
    super.phone,
    super.birthdate,
  });

  factory UserModel.fromSupabaseUser(User user){
    return UserModel(
        email: user.email??'',
        uid: user.id,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] as String?,
      phone: map['phone'] as String?,
      birthdate: map['birthdate'] as String?,
    );
  }
}