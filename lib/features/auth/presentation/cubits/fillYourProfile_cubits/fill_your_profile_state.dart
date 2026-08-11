part of 'fill_your_profile_cubit.dart';

@immutable
sealed class FillYourProfileState {}

final class FillYourProfileInitial extends FillYourProfileState {}

final class FillYourProfileLoading extends FillYourProfileState {}

final class FillYourProfileSuccess extends FillYourProfileState {}

final class FillYourProfileFailure extends FillYourProfileState {
  FillYourProfileFailure({required this.message});
  final String message;
}
