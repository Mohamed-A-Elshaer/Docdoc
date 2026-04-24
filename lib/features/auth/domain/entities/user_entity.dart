class UserEntity{
  UserEntity({required this.email,required this.uid,this.name,this.phone,this.birthdate,this.gender,this.apiUserId,this.isProfileCompleted});
  final String email;
  final String uid;
  final String? name;
  final String? phone;
  final String? birthdate;
  final String? gender;
  final bool? isProfileCompleted;
  final int? apiUserId;

    Map<String, dynamic> toMap() {
  return {
  'email': email,
  'uid': uid,
  'name': name,
  'phone': phone,
  'birthdate': birthdate,
  'gender': gender,
  'api_user_id':apiUserId,
  'is_profile_completed':isProfileCompleted,
  };
}
} 