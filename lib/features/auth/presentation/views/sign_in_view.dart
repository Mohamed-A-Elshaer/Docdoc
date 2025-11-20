import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:docdoc/features/auth/presentation/cubits/signin_cubits/signin_cubit.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/sign_in_view_body.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/sign_in_view_body_bloc_consumer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(getIt.get<AuthRepo>()),
      child: const SignInViewBodyBlocConsumer(),
    );
  }


}

