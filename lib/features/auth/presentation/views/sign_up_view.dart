import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:docdoc/features/auth/presentation/cubits/signin_cubits/signin_cubit.dart';
import 'package:docdoc/features/auth/presentation/cubits/signup_cubits/signups_cubit.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/sign_up_view_body.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/sign_up_view_body_bloc_consumer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  static const routeName = 'signUp';

  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupsCubit(
            getIt<AuthRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => SigninCubit(
            getIt<AuthRepo>(),
          ),
        ),
      ],
      child: const SignUpViewBodyBlocConsumer(),
    );
  }


}

