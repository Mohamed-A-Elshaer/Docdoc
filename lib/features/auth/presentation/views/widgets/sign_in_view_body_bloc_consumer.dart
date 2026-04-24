import 'package:docdoc/features/auth/presentation/views/fill_your_profile_view.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/sign_in_view_body.dart';
import 'package:docdoc/features/home/presentation/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper_functions/build_error_bar.dart';
import '../../cubits/signin_cubits/signin_cubit.dart';

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocConsumer<SigninCubit,SigninState>(
          builder: (BuildContext context, state) {
            return const SignInViewBody();
          },
          listener: (BuildContext context, Object? state) {
            if (state is SigninSuccess) {
              final signedInUser = state.userEntity;
              final missingProfileData = signedInUser.name == null ||
                  signedInUser.phone == null ||
                  signedInUser.birthdate == null||signedInUser.gender == null;
              if (missingProfileData) {
                Navigator.pushReplacementNamed(
                  context,
                  FillYourProfileView.routeName,
                  arguments: signedInUser,
                );
                return;
              }
              Navigator.pushReplacementNamed(context, HomeView.routeName);
            }
            if (state is SigninFailure) {
              buildErrorBar(context, state.message);
            }
          },
        );
      }
    );
  }
}