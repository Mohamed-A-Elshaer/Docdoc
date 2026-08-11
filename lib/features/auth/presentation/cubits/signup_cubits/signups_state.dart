part of 'signups_cubit.dart';

@immutable
sealed class SignupsState {}

final class SignupsInitial extends SignupsState {}

final class SignupsLoading extends SignupsState {}

final class SignupsSuccess extends SignupsState {
  final UserEntity userEntity;
  SignupsSuccess({required this.userEntity});
}

final class SignupsFailure extends SignupsState {
  final String message;
  SignupsFailure({required this.message});
}
