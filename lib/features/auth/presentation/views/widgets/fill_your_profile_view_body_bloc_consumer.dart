import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/presentation/views/sign_in_view.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/fill_your_profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/helper_functions/build_error_bar.dart';
import '../../cubits/fillYourProfile_cubits/fill_your_profile_cubit.dart';

class FillYourProfileViewBodyBlocConsumer extends StatelessWidget {
  const FillYourProfileViewBodyBlocConsumer(
      {super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FillYourProfileCubit, FillYourProfileState>(
        listener: (context, state) {
          if (state is FillYourProfileSuccess) {
            buildErrorBar(context, 'Profile saved successfully. Please login to continue.');

            Navigator.of(context).pushNamedAndRemoveUntil(
              SignInView.routeName,
              (route) => false,
            );
          } else if (state is FillYourProfileFailure) {
            buildErrorBar(context, state.message);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
              inAsyncCall: state is FillYourProfileLoading ? true : false,
              child: FillYourProfileViewBody(user: userEntity)

          );
        }
    );
  }
}
