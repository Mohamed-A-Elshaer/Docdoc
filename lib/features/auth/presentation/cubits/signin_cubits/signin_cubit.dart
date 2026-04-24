import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repos/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());
  final AuthRepo authRepo;
 
  Future<void> signInUser(String email,String password,BuildContext context)async {
    emit(SigninLoading());
    final result=await authRepo.signInUser(email, password,context);
    result.fold(
        (failure)=> emit(SigninFailure(message: failure.message)),
        (userEntity)=>emit(SigninSuccess(userEntity: userEntity)));
  }
  Future<void> signInWithGoogle()async {
    emit(SigninLoading());
    final result=await authRepo.signInWithGoogle();
    result.fold(
        (failure)=> emit(SigninFailure(message: failure.message)),
        (userEntity)=>emit(SigninSuccess(userEntity: userEntity)));
  }
  Future<void> signInWithFacebook()async {
    emit(SigninLoading());
    final result=await authRepo.signInWithFacebook();
    result.fold(
        (failure)=> emit(SigninFailure(message: failure.message)),
        (userEntity)=>emit(SigninSuccess(userEntity: userEntity)));
  }
}
