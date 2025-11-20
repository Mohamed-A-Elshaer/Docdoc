import 'package:bloc/bloc.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:meta/meta.dart';

part 'signups_state.dart';

class SignupsCubit extends Cubit<SignupsState> {
  SignupsCubit(this.authRepo) : super(SignupsInitial());
  final AuthRepo authRepo;

  Future<void> signUpUser(String email,String password)async {
    emit(SignupsLoading());
    final result=await authRepo.signUpUser(email, password);
    result.fold(
        (failure)=> emit(SignupsFailure(message: failure.message)),
        (userEntity)=>emit(SignupsSuccess(userEntity: userEntity)));
  }
}
