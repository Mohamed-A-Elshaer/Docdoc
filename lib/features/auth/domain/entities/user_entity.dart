class UserEntity{
  UserEntity({required this.email,required this.uid,this.name,this.phone,this.birthdate});
  final String email;
  final String uid;
  final String? name;
  final String? phone;
  final String? birthdate;

    Map<String, dynamic> toMap() {
  return {
  'email': email,
  'uid': uid,
  'name': name,
  'phone': phone,
  'birthdate': birthdate,
  };
}
} 