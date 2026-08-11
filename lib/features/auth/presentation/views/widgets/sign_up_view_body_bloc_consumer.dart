import 'package:docdoc/features/auth/presentation/views/fill_your_profile_view.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/sign_up_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/helper_functions/build_error_bar.dart';
import '../../cubits/signup_cubits/signups_cubit.dart';

class SignUpViewBodyBlocConsumer extends StatelessWidget {
  const SignUpViewBodyBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<SignupsCubit, SignupsState>(
        listener: (context, state) {
          if (state is SignupsSuccess) {
            Navigator.of(context).pushReplacementNamed(
              FillYourProfileView.routeName,
              arguments: state.userEntity,
            );
          }
          if (state is SignupsFailure) {
            buildErrorBar(context, state.message);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
              inAsyncCall: state is SignupsLoading ? true : false,
              child: const SignUpViewBody());
        },
      );
    });
  }
}
