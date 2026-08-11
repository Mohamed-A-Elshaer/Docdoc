import 'package:bloc/bloc.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'fill_your_profile_state.dart';

class FillYourProfileCubit extends Cubit<FillYourProfileState> {
  FillYourProfileCubit(this.authRepo) : super(FillYourProfileInitial());

  final AuthRepo authRepo;

  Future<void> submitProfile({
    required UserEntity user,
  }) async {
    emit(FillYourProfileLoading());

    final result = await authRepo.submitProfile(user: user);
    result.fold(
        (failure) => emit(FillYourProfileFailure(message: failure.message)),
        (userEntity) => emit(FillYourProfileSuccess()));
  }
}
